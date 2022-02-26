%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [void] = zef_plot_meshes(void);

void = [];
sensors_point_like = [];

loop_movie = 1;
length_reconstruction_cell = 1;
movie_fps = evalin('base','zef.movie_fps');
submesh_num = evalin('base','zef.submesh_num');
nodes = evalin('base','zef.nodes');

if ismember(evalin('base','zef.visualization_type'), [3,4])
s_i_ind = evalin('base','zef.source_interpolation_ind{2}');
s_i_ind_2 =  evalin('base','zef.source_interpolation_ind{1}');
end

if evalin('base','zef.use_parcellation')
selected_list = evalin('base','zef.parcellation_selected');
p_i_ind = evalin('base','zef.parcellation_interp_ind');
end

if ismember(evalin('base','zef.visualization_type'), [3])
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
for f_ind = frame_start : frame_step : frame_stop
reconstruction = single(evalin('base',['zef.reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec = 20*log10(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = 20*log10(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = sqrt(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;
reconstruction = evalin('base','zef.reconstruction');
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec = 20*log10(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = 20*log10(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = sqrt(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end
end
end

if ismember(evalin('base','zef.visualization_type'), [5])
max_abs_reconstruction = 0;
min_rec = Inf;
max_rec = -Inf;
if iscell(evalin('base','zef.top_reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.top_reconstruction'));
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
for f_ind = frame_start : frame_step : frame_stop
reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;
reconstruction = evalin('base','zef.top_reconstruction');
reconstruction = reconstruction(:);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
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
submesh_cell = cell(0);
for k = 1 : 27
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
        var_3 = 'zef.d1_visible';
        var_4 = 'zef.d1_submesh_ind';
    color_str = evalin('base','zef.d1_color');
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';
        var_2 = 'zef.d2_priority';
        var_3 = 'zef.d2_visible';
        var_4 = 'zef.d2_submesh_ind';
        color_str = evalin('base','zef.d2_color');
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';
        var_2 = 'zef.d3_priority';
        var_3 = 'zef.d3_visible';
        var_4 = 'zef.d3_submesh_ind';
        color_str = evalin('base','zef.d3_color');
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';
        var_2 = 'zef.d4_priority';
        var_3 = 'zef.d4_visible';
        var_4 = 'zef.d4_submesh_ind';
        color_str = evalin('base','zef.d4_color');
     case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
        var_3 = 'zef.d5_visible';
        var_4 = 'zef.d5_submesh_ind';
    color_str = evalin('base','zef.d5_color');
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';
        var_2 = 'zef.d6_priority';
        var_3 = 'zef.d6_visible';
        var_4 = 'zef.d6_submesh_ind';
        color_str = evalin('base','zef.d6_color');
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';
        var_2 = 'zef.d7_priority';
        var_3 = 'zef.d7_visible';
        var_4 = 'zef.d7_submesh_ind';
        color_str = evalin('base','zef.d7_color');
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';
        var_2 = 'zef.d8_priority';
        var_3 = 'zef.d8_visible';
        var_4 = 'zef.d8_submesh_ind';
        color_str = evalin('base','zef.d8_color');
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';
        var_2 = 'zef.d9_priority';
        var_3 = 'zef.d9_visible';
        var_4 = 'zef.d9_submesh_ind';
        color_str = evalin('base','zef.d9_color');
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';
        var_2 = 'zef.d10_priority';
        var_3 = 'zef.d10_visible';
        var_4 = 'zef.d10_submesh_ind';
        color_str = evalin('base','zef.d10_color');
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';
        var_2 = 'zef.d11_priority';
        var_3 = 'zef.d11_visible';
        var_4 = 'zef.d11_submesh_ind';
        color_str = evalin('base','zef.d11_color');
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';
        var_2 = 'zef.d12_priority';
        var_3 = 'zef.d12_visible';
        var_4 = 'zef.d12_submesh_ind';
        color_str = evalin('base','zef.d12_color');
     case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';
        var_2 = 'zef.d13_priority';
        var_3 = 'zef.d13_visible';
        var_4 = 'zef.d13_submesh_ind';
        color_str = evalin('base','zef.d13_color');
  case 14
        var_0 = 'zef.d14_on';
        var_1 = 'zef.d14_sigma';
        var_2 = 'zef.d14_priority';
        var_3 = 'zef.d14_visible';
        var_4 = 'zef.d14_submesh_ind';
    color_str = evalin('base','zef.d14_color');
  case 15
        var_0 = 'zef.d15_on';
        var_1 = 'zef.d15_sigma';
        var_2 = 'zef.d15_priority';
        var_3 = 'zef.d15_visible';
        var_4 = 'zef.d15_submesh_ind';
        color_str = evalin('base','zef.d15_color');
     case 16
        var_0 = 'zef.d16_on';
        var_1 = 'zef.d16_sigma';
        var_2 = 'zef.d16_priority';
        var_3 = 'zef.d16_visible';
        var_4 = 'zef.d16_submesh_ind';
        color_str = evalin('base','zef.d16_color');
     case 17
        var_0 = 'zef.d17_on';
        var_1 = 'zef.d17_sigma';
        var_2 = 'zef.d17_priority';
        var_3 = 'zef.d17_visible';
        var_4 = 'zef.d17_submesh_ind';
        color_str = evalin('base','zef.d17_color');
    case 18
        var_0 = 'zef.d18_on';
        var_1 = 'zef.d18_sigma';
        var_2 = 'zef.d18_priority';
        var_3 = 'zef.d18_visible';
        var_4 = 'zef.d18_submesh_ind';
        color_str = evalin('base','zef.d18_color');
     case 19
        var_0 = 'zef.d19_on';
        var_1 = 'zef.d19_sigma';
        var_2 = 'zef.d19_priority';
        var_3 = 'zef.d19_visible';
        var_4 = 'zef.d19_submesh_ind';
        color_str = evalin('base','zef.d19_color');
     case 20
        var_0 = 'zef.d20_on';
        var_1 = 'zef.d20_sigma';
        var_2 = 'zef.d20_priority';
        var_3 = 'zef.d20_visible';
        var_4 = 'zef.d20_submesh_ind';
        color_str = evalin('base','zef.d20_color');
     case 21
        var_0 = 'zef.d21_on';
        var_1 = 'zef.d21_sigma';
        var_2 = 'zef.d21_priority';
        var_3 = 'zef.d21_visible';
        var_4 = 'zef.d21_submesh_ind';
        color_str = evalin('base','zef.d21_color');
     case 22
        var_0 = 'zef.d22_on';
        var_1 = 'zef.d22_sigma';
        var_2 = 'zef.d22_priority';
        var_3 = 'zef.d22_visible';
        var_4 = 'zef.d22_submesh_ind';
        color_str = evalin('base','zef.d22_color');
    case 23
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        var_4 = 'zef.w_submesh_ind';
        color_str = evalin('base','zef.w_color');
    case 24
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        var_4 = 'zef.g_submesh_ind';
        color_str = evalin('base','zef.g_color');
    case 25
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        var_4 = 'zef.c_submesh_ind';
        color_str = evalin('base','zef.c_color');
     case 26
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        var_4 = 'zef.sk_submesh_ind';
        color_str = evalin('base','zef.sk_color');
     case 27
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        var_4 = 'zef.sc_submesh_ind';
        color_str = evalin('base','zef.sc_color');
     end
on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
submesh_ind = evalin('base',var_4);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = submesh_ind;
if k == 1 && evalin('base','zef.d1_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 2 && evalin('base','zef.d2_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 3 && evalin('base','zef.d3_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 4 && evalin('base','zef.d4_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 5 && evalin('base','zef.d5_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 6 && evalin('base','zef.d6_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 7 && evalin('base','zef.d7_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 8 && evalin('base','zef.d8_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 9 && evalin('base','zef.d9_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 10 && evalin('base','zef.d10_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 11 && evalin('base','zef.d11_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 12 && evalin('base','zef.d12_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 13 && evalin('base','zef.d13_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 14 && evalin('base','zef.d14_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 15 && evalin('base','zef.d15_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 16 && evalin('base','zef.d16_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 17 && evalin('base','zef.d17_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 18 && evalin('base','zef.d18_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 19 && evalin('base','zef.d19_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 20 && evalin('base','zef.d20_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 21 && evalin('base','zef.d21_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 22 && evalin('base','zef.d22_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 23 && evalin('base','zef.w_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 24 && evalin('base','zef.g_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 25 && evalin('base','zef.c_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 26 && evalin('base','zef.sk_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 27 && evalin('base','zef.sc_sources');
    aux_brain_ind = [aux_brain_ind i];
end
end
end

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'YDir','normal');
h_axes_text = findobj(evalin('base','zef.h_zeffiro'),'tag','image_details');
if not(isempty(h_axes_text))
delete(h_axes_text);
h_axes_text = [];
end
h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'tag','Colorbar');
if not(isempty(h_colorbar))
delete(h_colorbar(:));
end
hold on;
light('Position',[0 0 1],'Style','infinite');
light('Position',[0 0 -1],'Style','infinite');
sensors = evalin('base','zef.sensors');
aux_scale_val = 100/max(sqrt(sum((sensors(:,1:3) - repmat(mean(sensors(:,1:3)),size(sensors,1),1)).^2,2)));
[X_s, Y_s, Z_s] = sphere(50);
sphere_scale = 3.2*aux_scale_val;
X_s = sphere_scale*X_s;
Y_s = sphere_scale*Y_s;
Z_s = sphere_scale*Z_s;
reuna_p = evalin('base','zef.reuna_p');
reuna_p_inf = evalin('base','zef.reuna_p_inf');
reuna_t = evalin('base','zef.reuna_t');
if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
    for i = 1 : length(reuna_t)
        reuna_t{i} = uint32(reuna_t{i});
triangle_c{i} = (1/3)*(reuna_p{i}(reuna_t{i}(:,1),:) + reuna_p{i}(reuna_t{i}(:,2),:) + reuna_p{i}(reuna_t{i}(:,3),:));
    end
end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));
if submesh_num > 0
    for i = 1 : length(reuna_t)
    if submesh_num <= length(submesh_cell{i})
        if submesh_num == 1
        aux_ind_2{i} = [1:submesh_cell{i}(submesh_num)]';
        else
        aux_ind_2{i} = [submesh_cell{i}(submesh_num-1)+1:submesh_cell{i}(submesh_num)]';
    end
    end
    end
end

if evalin('base','zef.cp_on')
cp_a = evalin('base','zef.cp_a');
cp_b = evalin('base','zef.cp_b');
cp_c = evalin('base','zef.cp_c');
cp_d = evalin('base','zef.cp_d');
% if cp_a ~= 0 | cp_b ~=0
% light('Position',[-cp_a -cp_b -cp_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp_a cp_b cp_c],size(sensors,1),1),2) >= cp_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp_a cp_b cp_c],size(sensors,1),1),2) >= cp_d);
end
for i = 1 : length(reuna_t)
if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp_a cp_b cp_c],size(triangle_c{i},1),1),2) >= cp_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp_a cp_b cp_c],size(triangle_c{i},1),1),2) >= cp_d);
    end
end
end

if evalin('base','zef.cp2_on')
cp2_a = evalin('base','zef.cp2_a');
cp2_b = evalin('base','zef.cp2_b');
cp2_c = evalin('base','zef.cp2_c');
cp2_d = evalin('base','zef.cp2_d');
% if cp2_a ~= 0 | cp2_b ~=0
% light('Position',[-cp2_a -cp2_b -cp2_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp2_a cp2_b cp2_c],size(sensors,1),1),2) >= cp2_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp2_a cp2_b cp2_c],size(sensors,1),1),2) >= cp2_d);
end
for i = 1 : length(reuna_t)
    if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp2_a cp2_b cp2_c],size(triangle_c{i},1),1),2) >= cp2_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp2_a cp2_b cp2_c],size(triangle_c{i},1),1),2) >= cp2_d);
    end
end
end

if evalin('base','zef.cp3_on')
cp3_a = evalin('base','zef.cp3_a');
cp3_b = evalin('base','zef.cp3_b');
cp3_c = evalin('base','zef.cp3_c');
cp3_d = evalin('base','zef.cp3_d');
% if cp3_a ~= 0 | cp3_b ~=0
% light('Position',[-cp3_a -cp3_b -cp3_b],'Style','infinite');
% end
if not(isempty(aux_ind_1))
aux_ind_1 = intersect(aux_ind_1,find(sum(sensors(:,1:3).*repmat([cp3_a cp3_b cp3_c],size(sensors,1),1),2) >= cp3_d));
else
aux_ind_1 = find(sum(sensors(:,1:3).*repmat([cp3_a cp3_b cp3_c],size(sensors,1),1),2) >= cp3_d);
end
for i = 1 : length(reuna_t)
if not(isempty(aux_ind_2{i}))
aux_ind_2{i} = intersect(aux_ind_2{i},find(sum(triangle_c{i}.*repmat([cp3_a cp3_b cp3_c],size(triangle_c{i},1),1),2) >= cp3_d));
else
aux_ind_2{i} = find(sum(triangle_c{i}.*repmat([cp3_a cp3_b cp3_c],size(triangle_c{i},1),1),2) >= cp3_d);
end
end
end

if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
if evalin('base','zef.cp_mode') == 1
sensors = sensors(aux_ind_1,:);
elseif evalin('base','zef.cp_mode') == 2
aux_ind_1 = setdiff([1:size(sensors,1)]',aux_ind_1);
sensors = sensors(aux_ind_1,:);
end
for i = 1 : length(reuna_t)
if evalin('base','zef.cp_mode') == 1
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'),[3 4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind} = aux_is_3;
end
end
end;
end
elseif evalin('base','zef.cp_mode') == 2
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'),[3 4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind}= aux_is_3;
end
end
end
end
elseif evalin('base','zef.cp_mode') == 3
if ismember(i, aux_brain_ind)
aux_ind_2{i} = reuna_t{i};
else
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
end
elseif evalin('base','zef.cp_mode') == 4
if ismember(i, aux_brain_ind)
aux_ind_2{i} = reuna_t{i};
else
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
end
end
end
elseif submesh_num > 0
for i = 1 : length(reuna_t)
    if not(isempty(aux_ind_2{i}))
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'),[3 4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind} = aux_is_3;
end
end
end;
end
end
end
    end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));
triangle_c = cell(1,length(reuna_t));

if ismember(evalin('base','zef.imaging_method'), [1 4 5])  & size(sensors,2) == 6
    electrode_model = 2;
elseif ismember(evalin('base','zef.imaging_method'), [1 4 5])
    electrode_model = 1;
else
    electrode_model = 0;
end

if evalin('base','zef.attach_electrodes') & electrode_model == 1
sensors = zef_attach_sensors_volume(sensors,'geometry');
elseif evalin('base','zef.attach_electrodes') & electrode_model == 2
  sensors_aux = zef_attach_sensors_volume(sensors,'geometry');
  sensors_point_like_index = find(sensors_aux(:,4)==0);
  sensors_point_like = zeros(length(sensors_point_like_index),3);
for spl_ind = 1 : length(sensors_point_like_index)
if sensors_aux(sensors_point_like_index(spl_ind),2) == 0
sensors_point_like(spl_ind,:) = sensors(sensors_aux(sensors_point_like_index(spl_ind),1),1:3);
else
sensors_point_like(spl_ind,:) = reuna_p{end}(sensors_aux(sensors_point_like_index(spl_ind),2),:);
end
  end
sensors = sensors_aux;
sensors_patch_like_index = setdiff(1:size(sensors,1),sensors_point_like_index);
  sensors = sensors(sensors_patch_like_index,:);
else
    electrode_model = 1;
end

loop_count = 0;
while loop_movie && loop_count <= evalin('base','zef.loop_movie_count')
loop_count = loop_count + 1;

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'YDir','normal');
light('Position',[0 0 1],'Style','infinite');
light('Position',[0 0 -1],'Style','infinite');
hold on;

if evalin('base','zef.s_visible')
if electrode_model == 1 | not(ismember(evalin('base','zef.imaging_method'),[1,4,5]))
for i = 1 : size(sensors,1)
h = surf(sensors(i,1) + X_s, sensors(i,2) + Y_s, sensors(i,3) + Z_s);
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor','none');
set(h,'specularstrength',0.3);
set(h,'diffusestrength',0.7);
set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
elseif electrode_model == 2
 if not(isempty(sensors))
h = trisurf(sensors(:,2:4),reuna_p{end}(:,1),reuna_p{end}(:,2),reuna_p{end}(:,3));
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor',evalin('base','zef.s_color'));
set(h,'specularstrength',0.3);
set(h,'diffusestrength',0.7);
set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
set(h,'edgealpha',evalin('base','zef.layer_transparency'));
    end
if not(isempty(sensors_point_like))
for i = 1 : size(sensors_point_like,1)
h = surf(sensors_point_like(i,1) + X_s, sensors_point_like(i,2) + Y_s, sensors_point_like(i,3) + Z_s);
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor','none');
set(h,'specularstrength',0.3);
set(h,'diffusestrength',0.7);
set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
end

if ismember(evalin('base','zef.imaging_method'),[2 3])
sensors(:,4:6) = sensors(:,4:6)./repmat(sqrt(sum(sensors(:,4:6).^2,2)),1,3);
h=coneplot(sensors(:,1) + 4.5*sensors(:,4),sensors(:,2) + 4.5*sensors(:,5),sensors(:,3) + 4.5*sensors(:,6),8*sensors(:,4),8*sensors(:,5),8*sensors(:,6),0,'nointerp');
set(h,'facecolor',evalin('base','zef.s_color'));
set(h,'edgecolor','none');
set(h,'specularstrength',0.3);
set(h,'diffusestrength',0.7);
set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
if size(sensors,2) == 9
sensors(:,7:9) = sensors(:,7:9)./repmat(sqrt(sum(sensors(:,7:9).^2,2)),1,3);
h=coneplot(sensors(:,1) + 4.5*sensors(:,7),sensors(:,2) + 4.5*sensors(:,8),sensors(:,3) + 4.5*sensors(:,9),8*sensors(:,7),8*sensors(:,8),8*sensors(:,9),0,'nointerp');
set(h,'facecolor', 0.9*[1 1 1]);
set(h,'edgecolor','none');
set(h,'specularstrength',0.3);
set(h,'diffusestrength',0.7);
set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
end

if ismember(evalin('base','zef.visualization_type'),[3,4,5])

    if ismember(evalin('base','zef.visualization_type'),[3,5])
f_ind = frame_start;
    end

i = 0;

aux_brain_visible_ind = [];

for k = 1 : 27
switch k
    case 1
        on_val = evalin('base','zef.d1_on');
        visible_val = evalin('base','zef.d1_visible');
        color_str =  evalin('base','zef.d1_color');
    case 2
        on_val = evalin('base','zef.d2_on');
        visible_val = evalin('base','zef.d2_visible');
        color_str = evalin('base','zef.d2_color');
    case 3
        on_val = evalin('base','zef.d3_on');
        visible_val = evalin('base','zef.d3_visible');
        color_str = evalin('base','zef.d3_color');
    case 4
        on_val = evalin('base','zef.d4_on');
        visible_val = evalin('base','zef.d4_visible');
        color_str = evalin('base','zef.d4_color');
    case 5
        on_val = evalin('base','zef.d5_on');
        visible_val = evalin('base','zef.d5_visible');
        color_str =  evalin('base','zef.d5_color');
    case 6
        on_val = evalin('base','zef.d6_on');
        visible_val = evalin('base','zef.d6_visible');
        color_str = evalin('base','zef.d6_color');
    case 7
        on_val = evalin('base','zef.d7_on');
        visible_val = evalin('base','zef.d7_visible');
        color_str = evalin('base','zef.d7_color');
    case 8
        on_val = evalin('base','zef.d8_on');
        visible_val = evalin('base','zef.d8_visible');
        color_str = evalin('base','zef.d8_color');
    case 9
        on_val = evalin('base','zef.d9_on');
        visible_val = evalin('base','zef.d9_visible');
        color_str =  evalin('base','zef.d9_color');
    case 10
        on_val = evalin('base','zef.d10_on');
        visible_val = evalin('base','zef.d10_visible');
        color_str = evalin('base','zef.d10_color');
    case 11
        on_val = evalin('base','zef.d11_on');
        visible_val = evalin('base','zef.d11_visible');
        color_str = evalin('base','zef.d11_color');
    case 12
        on_val = evalin('base','zef.d12_on');
        visible_val = evalin('base','zef.d12_visible');
        color_str = evalin('base','zef.d12_color');
    case 13
        on_val = evalin('base','zef.d13_on');
        visible_val = evalin('base','zef.d13_visible');
        color_str = evalin('base','zef.d13_color');
    case 14
        on_val = evalin('base','zef.d14_on');
        visible_val = evalin('base','zef.d14_visible');
        color_str =  evalin('base','zef.d14_color');
    case 15
        on_val = evalin('base','zef.d15_on');
        visible_val = evalin('base','zef.d15_visible');
        color_str = evalin('base','zef.d15_color');
    case 16
        on_val = evalin('base','zef.d16_on');
        visible_val = evalin('base','zef.d16_visible');
        color_str = evalin('base','zef.d16_color');
    case 17
        on_val = evalin('base','zef.d17_on');
        visible_val = evalin('base','zef.d17_visible');
        color_str = evalin('base','zef.d17_color');
    case 18
        on_val = evalin('base','zef.d18_on');
        visible_val = evalin('base','zef.d18_visible');
        color_str =  evalin('base','zef.d18_color');
    case 19
        on_val = evalin('base','zef.d19_on');
        visible_val = evalin('base','zef.d19_visible');
        color_str = evalin('base','zef.d19_color');
    case 20
        on_val = evalin('base','zef.d20_on');
        visible_val = evalin('base','zef.d20_visible');
        color_str = evalin('base','zef.d20_color');
    case 21
        on_val = evalin('base','zef.d21_on');
        visible_val = evalin('base','zef.d21_visible');
        color_str = evalin('base','zef.d21_color');
    case 22
        on_val = evalin('base','zef.d22_on');
        visible_val = evalin('base','zef.d22_visible');
        color_str = evalin('base','zef.d22_color');
    case 23
        on_val = evalin('base','zef.w_on');
        visible_val = evalin('base','zef.w_visible');
        color_str = evalin('base','zef.w_color');
    case 24
        on_val = evalin('base','zef.g_on');
        visible_val = evalin('base','zef.g_visible');
        color_str = evalin('base','zef.g_color');
    case 25
        on_val = evalin('base','zef.c_on');
        visible_val = evalin('base','zef.c_visible');
        color_str = evalin('base','zef.c_color');
    case 26
        on_val = evalin('base','zef.sk_on');
        visible_val = evalin('base','zef.sk_visible');
        color_str = evalin('base','zef.sk_color');
    case 27
        on_val = evalin('base','zef.sc_on');
        visible_val = evalin('base','zef.sc_visible');
        color_str = evalin('base','zef.sc_color');
    end
if on_val
i = i + 1;
if visible_val
if ismember(i, aux_brain_ind) &&  (ismember(evalin('base','zef.visualization_type'), [3,4]))
    aux_brain_visible_ind = [aux_brain_visible_ind i];
ab_ind = find(aux_brain_ind==i);

%if i == aux_brain_visible_ind
%if  iscell(evalin('base','zef.reconstruction'))
%h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
%set(h_waitbar,'handlevisibility','off');
%end
%end

colormap_size = 32768;
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(evalin('base','zef.h_zeffiro'),'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

if ismember(evalin('base','zef.visualization_type'),[4])

if evalin('base','zef.use_parcellation')
reconstruction = ones(size(reuna_t{i},1),1);
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
reconstruction(p_i_ind{p_ind}{2}{ab_ind}) = p_ind+1;
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
end
min_rec = 1;
max_rec = size(evalin('base','zef.parcellation_colormap'),1);
elseif ismember(evalin('base','zef.visualization_type'),[3])

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

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end

if evalin('base','zef.use_parcellation')
reconstruction_aux = zeros(size(reconstruction));
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
    if evalin('base','zef.parcellation_type') == 1
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = reconstruction(p_i_ind{p_ind}{2}{ab_ind});
    elseif evalin('base','zef.parcellation_type') == 2
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 3
    reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
   elseif evalin('base','zef.parcellation_type') == 4
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 5
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
    end
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
reconstruction = reconstruction_aux;
end
end

if ismember(evalin('base','zef.visualization_type'),[3,4])

%**********************************************
if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
else
    h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
end
%**********************************************
set(h_surf_2{ab_ind},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
set(h_surf_2{ab_ind},'specularstrength',0.2);
set(h_surf_2{ab_ind},'specularexponent',0.8);
set(h_surf_2{ab_ind},'SpecularColorReflectance',0.8);
set(h_surf_2{ab_ind},'diffusestrength',1);
set(h_surf_2{ab_ind},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(reuna_t{i}(:,1)) = f_alpha_aux(reuna_t{i}(:,1)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,2)) = f_alpha_aux(reuna_t{i}(:,2)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,3)) = f_alpha_aux(reuna_t{i}(:,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{ab_ind},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{ab_ind},'FaceAlpha','interp');
set(h_surf_2{ab_ind},'AlphaDataMapping','none');
end

if ismember(i,aux_brain_ind) && cb_done == 0 && ismember(evalin('base','zef.visualization_type'),[3])
cb_done = 1;
h_colorbar = colorbar('EastOutside','Position',[0.92 0.647 0.01 0.29]);
h_axes_text = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
set(h_axes_text,'tag','image_details');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
axes(evalin('base','zef.h_axes1'));
end

end

lighting phong;

else

if ismember(evalin('base','zef.visualization_type'),[5]) && i == length(reuna_p)
%%%%%Topography reconstruction.

colormap_size = 32768;
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(evalin('base','zef.h_zeffiro'),'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

if iscell(evalin('base','zef.top_reconstruction'))
reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(frame_start) '}']));
else
reconstruction = evalin('base','zef.top_reconstruction');
end
reconstruction = reconstruction(:);

if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{i} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
else
h_surf_2{i} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
end
set(h_surf_2{i},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
set(h_surf_2{i},'specularstrength',0.2);
set(h_surf_2{i},'specularexponent',0.8);
set(h_surf_2{i},'SpecularColorReflectance',0.8);
set(h_surf_2{i},'diffusestrength',1);
set(h_surf_2{i},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux = r_alpha_aux;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{i},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{i},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{i},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{i},'FaceAlpha','interp');
set(h_surf_2{i},'AlphaDataMapping','none');
end

cb_done = 1;
h_colorbar = colorbar('EastOutside','Position',[0.92 0.647 0.01 0.29]);
h_axes_text = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
set(h_axes_text,'tag','image_details');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.top_time_1') + evalin('base','zef.top_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.top_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
axes(evalin('base','zef.h_axes1'));

lighting phong;

%%%% End of topography reconstruction

else
h_surf = trimesh(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'specularstrength',0.1);
set(h_surf,'diffusestrength',0.5);
set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
%if not(evalin('base','zef.visualization_type')==3);
lighting phong;
%end
end

end
end
end
end

evalin('base','zef_3D_plot_specs(zef.h_axes1);');
% if loop_count == 1
% view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
% axis('image');
% end
% camva(evalin('base','zef.cam_va'));
%
% if evalin('base','zef.axes_visible')
% set(evalin('base','zef.h_axes1'),'visible','on');
% set(evalin('base','zef.h_axes1'),'xGrid','on');
% set(evalin('base','zef.h_axes1'),'yGrid','on');
% set(evalin('base','zef.h_axes1'),'zGrid','on');
% else
% set(evalin('base','zef.h_axes1'),'visible','off');
% set(evalin('base','zef.h_axes1'),'xGrid','off');
% set(evalin('base','zef.h_axes1'),'yGrid','off');
% set(evalin('base','zef.h_axes1'),'zGrid','off');
% end
%drawnow;

if ismember(evalin('base','zef.visualization_type'),[3,5])

f_ind_aux = 1;
for f_ind = frame_start + frame_step : frame_step : frame_stop

pause(0.01);
stop_movie = evalin('base','zef.stop_movie');
%pause(0.01);
if stop_movie
    if get(evalin('base','zef.h_pause_movie'),'value') == 1
    waitfor(evalin('base','zef.h_pause_movie'),'value');
    else
return;
    end
end
f_ind_aux = f_ind_aux + 1;
%waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.'])

if ismember(evalin('base','zef.visualization_type'),[3])
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

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end

%delete(h_surf_2{ab_ind});

if evalin('base','zef.use_parcellation')
reconstruction_aux = zeros(size(reconstruction));
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
 if evalin('base','zef.parcellation_type') == 1
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = reconstruction(p_i_ind{p_ind}{2}{ab_ind});
    elseif evalin('base','zef.parcellation_type') == 2
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
  elseif evalin('base','zef.parcellation_type') == 3
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 4
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
elseif evalin('base','zef.parcellation_type') == 5
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
    end
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
reconstruction = reconstruction_aux;
end

axes(evalin('base','zef.h_axes1'));
%h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{ab_ind},'CData',reconstruction);

set(h_surf_2{ab_ind},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
set(h_surf_2{ab_ind},'specularstrength',0.2);
set(h_surf_2{ab_ind},'specularexponent',0.8);
set(h_surf_2{ab_ind},'SpecularColorReflectance',0.8);
set(h_surf_2{ab_ind},'diffusestrength',1);
set(h_surf_2{ab_ind},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(reuna_t{i}(:,1)) = f_alpha_aux(reuna_t{i}(:,1)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,2)) = f_alpha_aux(reuna_t{i}(:,2)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,3)) = f_alpha_aux(reuna_t{i}(:,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{ab_ind},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{ab_ind},'FaceAlpha','interp');
set(h_surf_2{ab_ind},'AlphaDataMapping','none');
end

end
elseif ismember(evalin('base','zef.visualization_type'),[5])
%Topography reconstruction.

reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);

axes(evalin('base','zef.h_axes1'));
%h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{i},'CData',reconstruction);

set(h_surf_2{i},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
set(h_surf_2{i},'specularstrength',0.2);
set(h_surf_2{i},'specularexponent',0.8);
set(h_surf_2{i},'SpecularColorReflectance',0.8);
set(h_surf_2{i},'diffusestrength',1);
set(h_surf_2{i},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux = r_alpha_aux;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{i},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{i},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{i},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{i},'FaceAlpha','interp');
set(h_surf_2{i},'AlphaDataMapping','none');
end

%End of topography reconstruction.
end

camorbit(frame_step*evalin('base','zef.orbit_1')/movie_fps,frame_step*evalin('base','zef.orbit_2')/movie_fps);
lighting phong;

%delete(h_text);
%delete(h_axes_text);
axes(h_axes_text);% = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
%set(h_axes_text,'tag','image_details');
if ismember(evalin('base','zef.visualization_type'),[3])
set(h_text,'string', ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
elseif ismember(evalin('base','zef.visualization_type'),[5])
set(h_text,'string', ['Time: ' num2str(evalin('base','zef.top_time_1') + evalin('base','zef.top_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.top_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
end

set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
drawnow limitrate;
end

end

else

i = 0;

for k = 1 : 27
switch k
    case 1
        on_val = evalin('base','zef.d1_on');
        visible_val = evalin('base','zef.d1_visible');
        color_str =  evalin('base','zef.d1_color');
    case 2
        on_val = evalin('base','zef.d2_on');
        visible_val = evalin('base','zef.d2_visible');
        color_str = evalin('base','zef.d2_color');
    case 3
        on_val = evalin('base','zef.d3_on');
        visible_val = evalin('base','zef.d3_visible');
        color_str = evalin('base','zef.d3_color');
    case 4
        on_val = evalin('base','zef.d4_on');
        visible_val = evalin('base','zef.d4_visible');
        color_str = evalin('base','zef.d4_color');
    case 5
        on_val = evalin('base','zef.d5_on');
        visible_val = evalin('base','zef.d5_visible');
        color_str =  evalin('base','zef.d5_color');
    case 6
        on_val = evalin('base','zef.d6_on');
        visible_val = evalin('base','zef.d6_visible');
        color_str = evalin('base','zef.d6_color');
    case 7
        on_val = evalin('base','zef.d7_on');
        visible_val = evalin('base','zef.d7_visible');
        color_str = evalin('base','zef.d7_color');
    case 8
        on_val = evalin('base','zef.d8_on');
        visible_val = evalin('base','zef.d8_visible');
        color_str = evalin('base','zef.d8_color');
    case 9
        on_val = evalin('base','zef.d9_on');
        visible_val = evalin('base','zef.d9_visible');
        color_str =  evalin('base','zef.d9_color');
    case 10
        on_val = evalin('base','zef.d10_on');
        visible_val = evalin('base','zef.d10_visible');
        color_str = evalin('base','zef.d10_color');
    case 11
        on_val = evalin('base','zef.d11_on');
        visible_val = evalin('base','zef.d11_visible');
        color_str = evalin('base','zef.d11_color');
    case 12
        on_val = evalin('base','zef.d12_on');
        visible_val = evalin('base','zef.d12_visible');
        color_str = evalin('base','zef.d12_color');
    case 13
        on_val = evalin('base','zef.d13_on');
        visible_val = evalin('base','zef.d13_visible');
        color_str = evalin('base','zef.d13_color');
    case 14
        on_val = evalin('base','zef.d14_on');
        visible_val = evalin('base','zef.d14_visible');
        color_str =  evalin('base','zef.d14_color');
    case 15
        on_val = evalin('base','zef.d15_on');
        visible_val = evalin('base','zef.d15_visible');
        color_str = evalin('base','zef.d15_color');
    case 16
        on_val = evalin('base','zef.d16_on');
        visible_val = evalin('base','zef.d16_visible');
        color_str = evalin('base','zef.d16_color');
    case 17
        on_val = evalin('base','zef.d17_on');
        visible_val = evalin('base','zef.d17_visible');
        color_str = evalin('base','zef.d17_color');
    case 18
        on_val = evalin('base','zef.d18_on');
        visible_val = evalin('base','zef.d18_visible');
        color_str =  evalin('base','zef.d18_color');
    case 19
        on_val = evalin('base','zef.d19_on');
        visible_val = evalin('base','zef.d19_visible');
        color_str = evalin('base','zef.d19_color');
    case 20
        on_val = evalin('base','zef.d20_on');
        visible_val = evalin('base','zef.d20_visible');
        color_str = evalin('base','zef.d20_color');
    case 21
        on_val = evalin('base','zef.d21_on');
        visible_val = evalin('base','zef.d21_visible');
        color_str = evalin('base','zef.d21_color');
    case 22
        on_val = evalin('base','zef.d22_on');
        visible_val = evalin('base','zef.d22_visible');
        color_str = evalin('base','zef.d22_color');
    case 23
        on_val = evalin('base','zef.w_on');
        visible_val = evalin('base','zef.w_visible');
        color_str = evalin('base','zef.w_color');
    case 24
        on_val = evalin('base','zef.g_on');
        visible_val = evalin('base','zef.g_visible');
        color_str = evalin('base','zef.g_color');
    case 25
        on_val = evalin('base','zef.c_on');
        visible_val = evalin('base','zef.c_visible');
        color_str = evalin('base','zef.c_color');
    case 26
        on_val = evalin('base','zef.sk_on');
        visible_val = evalin('base','zef.sk_visible');
        color_str = evalin('base','zef.sk_color');
    case 27
        on_val = evalin('base','zef.sc_on');
        visible_val = evalin('base','zef.sc_visible');
        color_str = evalin('base','zef.sc_color');
    end
if on_val
i = i + 1;
if visible_val
h_surf = trimesh(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'specularstrength',0.1);
set(h_surf,'diffusestrength',0.5);
set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
lighting phong;
end
end
end

evalin('base','zef_3D_plot_specs(zef.h_axes1);');

% view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
% axis('image');
% camva(evalin('base','zef.cam_va'));
% if evalin('base','zef.axes_visible')
% set(evalin('base','zef.h_axes1'),'visible','on');
% set(evalin('base','zef.h_axes1'),'xGrid','on');
% set(evalin('base','zef.h_axes1'),'yGrid','on');
% set(evalin('base','zef.h_axes1'),'zGrid','on');
% else
% set(evalin('base','zef.h_axes1'),'visible','off');
% set(evalin('base','zef.h_axes1'),'xGrid','off');
% set(evalin('base','zef.h_axes1'),'yGrid','off');
% set(evalin('base','zef.h_axes1'),'zGrid','off');
% end

end

if iscell(evalin('base','zef.reconstruction')) && evalin('base','zef.visualization_type') == 3
loop_movie = evalin('base','zef.loop_movie');
else
loop_movie = 0;
end
hold off;

end

rotate3d on;
%if evalin('base','zef.visualization_type')==3 & iscell(evalin('base','zef.reconstruction'))
%close(h_waitbar);
%end
