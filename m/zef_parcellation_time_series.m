%Copyright © 2018, Sampsa Pursiainen
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
min_rec = 10*log10(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = 10*log10(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
max_rec = sqrt(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
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
min_rec = 10*log10(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = 10*log10(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
max_rec = sqrt(max(max_rec/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end   
end 
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
for k = 1 : 27
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
        var_3 = 'zef.d1_visible';
    color_str = evalin('base','zef.d1_color');
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
        var_3 = 'zef.d2_visible';
        color_str = evalin('base','zef.d2_color');
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
        var_3 = 'zef.d3_visible';
        color_str = evalin('base','zef.d3_color');
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
        var_3 = 'zef.d4_visible';
        color_str = evalin('base','zef.d4_color');
     case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
        var_3 = 'zef.d5_visible';
    color_str = evalin('base','zef.d5_color');
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';   
        var_2 = 'zef.d6_priority';
        var_3 = 'zef.d6_visible';
        color_str = evalin('base','zef.d6_color');
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';   
        var_2 = 'zef.d7_priority';
        var_3 = 'zef.d7_visible';
        color_str = evalin('base','zef.d7_color');
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';   
        var_2 = 'zef.d8_priority';
        var_3 = 'zef.d8_visible';
        color_str = evalin('base','zef.d8_color');
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';   
        var_2 = 'zef.d9_priority';
        var_3 = 'zef.d9_visible';
        color_str = evalin('base','zef.d9_color');
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';   
        var_2 = 'zef.d10_priority';
        var_3 = 'zef.d10_visible';
        color_str = evalin('base','zef.d10_color');
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';   
        var_2 = 'zef.d11_priority';
        var_3 = 'zef.d11_visible';
        color_str = evalin('base','zef.d11_color');
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';   
        var_2 = 'zef.d12_priority';
        var_3 = 'zef.d12_visible';
        color_str = evalin('base','zef.d12_color');
     case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';   
        var_2 = 'zef.d13_priority';
        var_3 = 'zef.d13_visible';
        color_str = evalin('base','zef.d13_color');
  case 14
        var_0 = 'zef.d14_on';
        var_1 = 'zef.d14_sigma';
        var_2 = 'zef.d14_priority';
        var_3 = 'zef.d14_visible';
    color_str = evalin('base','zef.d14_color');
  case 15
        var_0 = 'zef.d15_on';
        var_1 = 'zef.d15_sigma';   
        var_2 = 'zef.d15_priority';
        var_3 = 'zef.d15_visible';
        color_str = evalin('base','zef.d15_color');
     case 16
        var_0 = 'zef.d16_on';
        var_1 = 'zef.d16_sigma';   
        var_2 = 'zef.d16_priority';
        var_3 = 'zef.d16_visible';
        color_str = evalin('base','zef.d16_color');
     case 17
        var_0 = 'zef.d17_on';
        var_1 = 'zef.d17_sigma';   
        var_2 = 'zef.d17_priority';
        var_3 = 'zef.d17_visible';
        color_str = evalin('base','zef.d17_color');
    case 18
        var_0 = 'zef.d18_on';
        var_1 = 'zef.d18_sigma';   
        var_2 = 'zef.d18_priority';
        var_3 = 'zef.d18_visible';
        color_str = evalin('base','zef.d18_color');
     case 19
        var_0 = 'zef.d19_on';
        var_1 = 'zef.d19_sigma';   
        var_2 = 'zef.d19_priority';
        var_3 = 'zef.d19_visible';
        color_str = evalin('base','zef.d19_color');
     case 20
        var_0 = 'zef.d20_on';
        var_1 = 'zef.d20_sigma';   
        var_2 = 'zef.d20_priority';
        var_3 = 'zef.d20_visible';
        color_str = evalin('base','zef.d20_color');
     case 21
        var_0 = 'zef.d21_on';
        var_1 = 'zef.d21_sigma';   
        var_2 = 'zef.d21_priority';
        var_3 = 'zef.d21_visible';
        color_str = evalin('base','zef.d21_color');
     case 22
        var_0 = 'zef.d22_on';
        var_1 = 'zef.d22_sigma';   
        var_2 = 'zef.d22_priority';
        var_3 = 'zef.d22_visible';
        color_str = evalin('base','zef.d22_color');
    case 23
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 24
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 25
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 26
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 27
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
        var_3 = 'zef.sc_visible';
        color_str = evalin('base','zef.sc_color');
     end
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
if k == 19 && evalin('base','zef.d10_sources');
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


sensors = evalin('base','zef.sensors');
reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');  


f_ind = frame_start;
f_ind_aux = 1;
tic;
h_waitbar = waitbar(0,['Step ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']); 


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

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 10*log10(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end
end

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

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = 10*log10(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction/max_abs_reconstruction,1/evalin('base','zef.inv_dynamic_range')));    
end
end

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
close(h_waitbar);

end



