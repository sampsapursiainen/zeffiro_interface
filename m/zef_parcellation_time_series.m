%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [time_series] = zef_parcellation_time_series(void)

void = [];

length_reconstruction_cell = 1;

number_of_frames = evalin('base','zef.number_of_frames');
surface_triangles = evalin('base','zef.surface_triangles');
nodes = evalin('base','zef.nodes');

s_i_ind = evalin('base','zef.source_interpolation_ind{2}');
s_i_ind_2 =  evalin('base','zef.source_interpolation_ind{1}');

selected_list = evalin('base','zef.parcellation_selected');
p_i_ind = evalin('base','zef.parcellation_interp_ind');
time_series = zeros(length(selected_list), number_of_frames);

h_waitbar = waitbar(0,['Time series.']);

max_abs_reconstruction = 0;
min_rec = Inf;
max_rec = -Inf;
if iscell(evalin('base','zef.reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.reconstruction'));
frame_start = evalin('base','zef.frame_start');
frame_stop = evalin('base','zef.frame_stop');
frame_step = evalin('base','zef.frame_step');
if frame_start == 0
frame_start = 1;
end
if frame_stop == 0
frame_stop = length_reconstruction_cell;
end
frame_start = max(frame_start,1);
frame_start = min(length_reconstruction_cell,frame_start);
frame_stop = max(frame_stop,1);
frame_stop = min(length_reconstruction_cell,frame_stop);
number_of_frames = length([frame_start : frame_step : frame_stop]);
for f_ind = frame_start : frame_step : frame_stop;
reconstruction = single(evalin('base',['zef.reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;
reconstruction = evalin('base','zef.reconstruction');
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end

cb_done = 0;
i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
compartment_tags = evalin('base','zef.compartment_tags');
for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_sources'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);

on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
    aux_brain_ind = [aux_brain_ind i];
end

end
end

sensors = evalin('base','zef.sensors');
reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');

f_ind = frame_start;
f_ind_aux = 1;
tic;
waitbar(0,h_waitbar,['Step ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);

i = 0;

aux_brain_visible_ind = [];

for k = 1 : length(compartment_tags)

        on_val = evalin('base',['zef.' compartment_tags{k} '_on']);
        visible_val = evalin('base',['zef.' compartment_tags{k} '_sources'])>0;
        color_str =  evalin('base',['zef.' compartment_tags{k} '_color']);

if on_val
i = i + 1;
if visible_val

if ismember(i, aux_brain_ind)
aux_brain_visible_ind = [aux_brain_visible_ind i];
ab_ind = find(aux_brain_ind==i);

if iscell(evalin('base','zef.reconstruction'))
reconstruction = single(evalin('base',['zef.reconstruction{' int2str(frame_start) '}']));
else
reconstruction = evalin('base','zef.reconstruction');
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(evalin('base','zef.reconstruction_type'),[1 7])
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6 7])
reconstruction = sum(reconstruction(s_i_ind{ab_ind}),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind{ab_ind}),2)/3;
rec_y = sum(rec_y(s_i_ind{ab_ind}),2)/3;
rec_z = sum(rec_z(s_i_ind{ab_ind}),2)/3;
n_vec_aux = cross(reuna_p{i}(reuna_t{i}(:,2),:)' - reuna_p{i}(reuna_t{i}(:,1),:)',...
reuna_p{i}(reuna_t{i}(:,3),:)' - reuna_p{i}(reuna_t{i}(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - rec_x.*abs(n_vec_aux(:,1))).^2 + (rec_y - rec_y.*abs(n_vec_aux(:,2))).^2 + (rec_z - rec_z.*abs(n_vec_aux(:,3))).^2);
end

if evalin('base','zef.reconstruction_type') == 4
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if evalin('base','zef.reconstruction_type') == 5
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5 7])
reconstruction = smooth_field(reuna_t{i}, reconstruction, size(reuna_p{i}(:,1),1),3);
end

reconstruction = (max(reconstruction/max_abs_reconstruction,0));

p_counter = 0;
for p_ind = selected_list
p_counter = p_counter + 1;
  if not(isempty(reconstruction(p_i_ind{p_ind}{2}{ab_ind})))
 if evalin('base','zef.parcellation_type') == 1
time_series(p_counter,f_ind_aux) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),1);
elseif evalin('base','zef.parcellation_type') == 2
time_series(p_counter,f_ind_aux) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
  elseif evalin('base','zef.parcellation_type') == 3
time_series(p_counter,f_ind_aux) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 4
time_series(p_counter,f_ind_aux) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 5;
time_series(p_counter,f_ind_aux) = mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
 end
  end
end

end
end
end
end

for f_ind = frame_start + frame_step : frame_step : frame_stop

pause(0.01);
stop_movie = evalin('base','zef.stop_movie');
if stop_movie
    if get(evalin('base','zef.h_pause_movie'),'value') == 1
    waitfor(evalin('base','zef.h_pause_movie'),'value');
    else
return;
    end
end
f_ind_aux = f_ind_aux + 1;
time_val = toc;
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Step ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '. Ready: ' datestr(datevec(now+((number_of_frames)/(f_ind_aux-1) - 1)*time_val/86400)) '.']);

for i = intersect(aux_brain_ind,aux_brain_visible_ind)
ab_ind = find(aux_brain_ind == i);
reconstruction = single(evalin('base',['zef.reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(evalin('base','zef.reconstruction_type'),[1 7])
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6 7])
reconstruction = sum(reconstruction(s_i_ind{ab_ind}),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind{ab_ind}),2)/3;
rec_y = sum(rec_y(s_i_ind{ab_ind}),2)/3;
rec_z = sum(rec_z(s_i_ind{ab_ind}),2)/3;
n_vec_aux = cross(reuna_p{i}(reuna_t{i}(:,2),:)' - reuna_p{i}(reuna_t{i}(:,1),:)',...
 reuna_p{i}(reuna_t{i}(:,3),:)' - reuna_p{i}(reuna_t{i}(:,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - rec_x.*abs(n_vec_aux(:,1))).^2 + (rec_y - rec_y.*abs(n_vec_aux(:,2))).^2 + (rec_z - rec_z.*abs(n_vec_aux(:,3))).^2);
end

if evalin('base','zef.reconstruction_type') == 4
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
end

if evalin('base','zef.reconstruction_type') == 5
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5 7])
reconstruction = smooth_field(reuna_t{i}, reconstruction, size(reuna_p{i}(:,1),1),3);
end

reconstruction = (max(reconstruction/max_abs_reconstruction,0));

p_counter = 0;
for p_ind = selected_list
  p_counter = p_counter + 1;
  if not(isempty(reconstruction(p_i_ind{p_ind}{2}{ab_ind})))
 if evalin('base','zef.parcellation_type') == 1
time_series(p_counter,f_ind_aux) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),1);
    elseif evalin('base','zef.parcellation_type') == 2
time_series(p_counter,f_ind_aux) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
  elseif evalin('base','zef.parcellation_type') == 3
time_series(p_counter,f_ind_aux) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 4
time_series(p_counter,f_ind_aux) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 5
time_series(p_counter,f_ind_aux) =mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
 end
  end
end

end

end

waitbar(1,h_waitbar,['Step ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);

time_series(find(isnan(time_series))) = 0;
time_series = time_series.^2;
close(h_waitbar);

end

