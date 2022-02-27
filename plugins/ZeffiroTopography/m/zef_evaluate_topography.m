%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z] = zef_evaluate_topography(void)

h = waitbar(0,['Topography.']);

sampling_freq = evalin('base','zef.top_sampling_frequency');
high_pass = evalin('base','zef.top_low_cut_frequency');
low_pass = evalin('base','zef.top_high_cut_frequency');
number_of_frames = evalin('base','zef.top_number_of_frames');
time_step = evalin('base','zef.top_time_3');
triangles = evalin('base','zef.reuna_t{end}');
triangle_points = evalin('base','zef.reuna_p{end}');
sensor_points = evalin('base','zef.sensors(:,1:3)');

if number_of_frames > 1
z = cell(number_of_frames,1);
else
number_of_frames = 1;
end

tic;
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if iscell(evalin('base','zef.measurements'));
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.top_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max(sqrt(sum(abs(f).^2)));
%std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
%std_lhood = std_lhood^2;
end;
f = f/data_norm;

filter_order = 3;
if size(f,2) > 1 && low_pass > 0
[lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));
f = filter(lp_f_1,lp_f_2,f')';
end
if size(f,2) > 1 && high_pass > 0
[hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');
f = filter(hp_f_1,hp_f_2,f')';
end

if size(f,2) > 1
if evalin('base','zef.top_time_2') >=0 0 && evalin('base','zef.top_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.top_time_1') <= size(f,2);
f = f(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.top_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.top_time_3'))) : min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.top_time_1') + evalin('base','zef.top_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.top_time_3'))));
end
end
if size(f,2) > 1
t = [1:size(f,2)];
%gaussian_window = blackmanharris(length(t))';
%f = f.*gaussian_window;
f = mean(f,2);
end

waitbar(f_ind/number_of_frames,h,['Topography. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

z_aux = zeros(size(triangle_points,1),1);
for sensor_ind = 1 : size(sensor_points,1)
dist_vec = sqrt(sum((triangle_points-sensor_points(sensor_ind*ones(size(triangle_points,1),1),:)).^2,2));
dist_vec = dist_vec/min(dist_vec);
z_aux = z_aux + f(sensor_ind)./(evalin('base','zef.top_regularization_parameter')+(dist_vec));
end

if number_of_frames > 1
    z{f_ind} = z_aux;
else
    z = z_aux;
end

end

if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;
aux_norm_vec = max(abs(z{f_ind}),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
z{f_ind} = z{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = abs(z);
z = z./max(aux_norm_vec);
end;

close(h);

end
