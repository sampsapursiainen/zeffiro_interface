%Copyright © 2018, Sampsa Pursiainen
function [z] = ias_iteration(void)

[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}')); 

beta = evalin('base','zef.inv_beta');
theta0 = evalin('base','zef.inv_theta0');
eta = beta - 1.5;
kappa = beta + 1.5;
std_lhood = evalin('base','zef.inv_likelihood_std');
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
time_step = evalin('base','zef.inv_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');


if source_direction_mode == 1
s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end
if source_direction_mode == 2
s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end



if source_direction_mode == 2
source_directions = source_directions(s_ind_1,:);
end

s_ind_1 = s_ind_1(:);

L = evalin('base','zef.L');
if evalin('base','zef.use_gpu') == 1
L = gpuArray(L);
end
L = L(:,s_ind_1);
L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));
if evalin('base','zef.use_gpu') == 1
S_mat = gpuArray(S_mat);
end



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
f = evalin('base',['zef.measurements{' int2str(evalin('base','zef.inv_data_segment')) '}']);
else
f = evalin('base','zef.measurements');
end

data_norm = 1;
if evalin('base','zef.normalize_data')==1;
data_norm = max(abs(f(:)).^2); 
std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==2;
data_norm = max((sum(abs(f).^2)));
std_lhood = std_lhood^2;
elseif evalin('base','zef.normalize_data')==3;
data_norm = sum((sum(abs(f).^2)))/size(f,2);
std_lhood = std_lhood^2;
end;
f = f/data_norm;

if source_direction_mode == 1
z_aux = zeros(size(L,2),1); 
end
if source_direction_mode == 2
z_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1); 
theta = theta0*ones(length(z_vec),1);

if size(f,2) > 1  
if evalin('base','zef.inv_time_2') >=0 0 && evalin('base','zef.inv_time_1') >= 0 & 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size(f,2);
f = f(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))) : min(size(f,2), 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))));
end
end
if size(f,2) > 1
t = [1:size(f,2)];
gaussian_window_param = 20;
gaussian_window = exp(-((t-(length(t)/2)).^2./(2*(length(t)/gaussian_window_param)^2)))/(sqrt(2*pi)*(length(t)/gaussian_window_param))*length(t);
gaussian_window = gaussian_window(ones(size(f,1),1),:);
fft_f = fft(f.*gaussian_window,[],2);
clear gaussian_window;
f = fft_f.*conj(fft_f)/size(f,2);
clear fft_f;
f = f(:,1:floor(size(f,2)/2));
low_pass_ind = 1 + floor((low_pass/(sampling_freq/2))*size(f,2));
high_pass_ind = 1 + floor((high_pass/(sampling_freq/2))*size(f,2));
low_pass_ind = min(low_pass_ind, size(f,2));
high_pass_ind = min(high_pass_ind, size(f,2));
if high_pass > 0; 
   high_pass_ind = max(2,high_pass_ind);
else
   high_pass_ind = max(1,high_pass_ind);
end
low_pass_ind = max(high_pass_ind,low_pass_ind);
f = sum(f(:,high_pass_ind:low_pass_ind),2)/(low_pass_ind - high_pass_ind + 1);
end
if f_ind == 1
h = waitbar(0,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_ias_map_iter = evalin('base','zef.inv_n_map_iterations');

if evalin('base','zef.use_gpu') == 1
f = gpuArray(f);
end


for i = 1 : n_ias_map_iter
if f_ind > 1;    
waitbar(i/n_ias_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready approx: ' date_str '.' ]);
else
waitbar(i/n_ias_map_iter,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);   
end;
m_max = sqrt(size(L,2));
u = zeros(length(z_vec),1);
z_vec = zeros(length(z_vec),1);
d_sqrt = sqrt(theta);
if evalin('base','zef.use_gpu') == 1
d_sqrt = gpuArray(d_sqrt);
end
L = L_aux.*repmat(d_sqrt',size(L,1),1); 
z_vec = d_sqrt.*(L'*((L*L' + S_mat)\f));

if evalin('base','zef.use_gpu') == 1
z_vec = gather(z_vec);
end
if evalin('base','zef.inv_hyperprior') == 1;
theta = theta0*(eta + sqrt((1/(2*theta0))*z_vec.^2 + eta^2)); 
else
theta = (theta0+0.5*z_vec.^2)./kappa;
end;
end;

if source_direction_mode == 2
z_vec = [z_vec.*source_directions(:,1) z_vec.*source_directions(:,2)  z_vec.*source_directions(:,3)]';
z_vec = z_vec(:);
end

if source_direction_mode == 1
z_aux(s_ind_1) = z_vec;
end
if source_direction_mode == 2
z_aux(s_ind_2) = z_vec;
end

if number_of_frames > 1;
z{f_ind} = z_aux;
else
z = z_aux;
end;
end;
if number_of_frames > 1;
aux_norm_vec = 0;
for f_ind = 1 : number_of_frames;
aux_norm_vec = max(sqrt(sum(reshape(z{f_ind}, 3, length(z{f_ind})/3).^2)),aux_norm_vec);
end;
for f_ind = 1 : number_of_frames;
z{f_ind} = z{f_ind}./max(aux_norm_vec);
end;
else
aux_norm_vec = sqrt(sum(reshape(z, 3, length(z)/3).^2)); 
z = z./max(aux_norm_vec);
end;
close(h);
