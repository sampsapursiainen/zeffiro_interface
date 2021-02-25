%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [sensors,reuna_p,reuna_t,reuna_p_inf,reuna_submesh_ind] = process_meshes(varargin);

explode_param = 1;
if not(isempty(varargin))
  if not(isempty(varargin{1}))
explode_param = varargin{1}; 
    end
end

i = 0;
sensors = [];
reuna_p = cell(0);
reuna_t = cell(0);

for k = 1 : 27

switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_scaling'; 
        var_7 = 'zef.d1_points_inf';
        var_8 = 'zef.d1_points';
        var_9 = 'zef.d1_triangles';
        var_10 = 'zef.d1_submesh_ind';
    case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_scaling';
        var_7 = 'zef.d2_points_inf';
        var_8 = 'zef.d2_points';
        var_9 = 'zef.d2_triangles';
         var_10 = 'zef.d2_submesh_ind';
    case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_scaling';
        var_7 = 'zef.d3_points_inf';
        var_8 = 'zef.d3_points';
        var_9 = 'zef.d3_triangles';
         var_10 = 'zef.d3_submesh_ind';
    case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_scaling';
        var_7 = 'zef.d4_points_inf';
        var_8 = 'zef.d4_points';
        var_9 = 'zef.d4_triangles';   
         var_10 = 'zef.d4_submesh_ind';
    case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_scaling'; 
        var_7 = 'zef.d5_points_inf';
        var_8 = 'zef.d5_points';
        var_9 = 'zef.d5_triangles';
         var_10 = 'zef.d5_submesh_ind';
    case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_scaling'; 
        var_7 = 'zef.d6_points_inf';
        var_8 = 'zef.d6_points';
        var_9 = 'zef.d6_triangles';
         var_10 = 'zef.d6_submesh_ind';
    case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_scaling';
        var_7 = 'zef.d7_points_inf';
        var_8 = 'zef.d7_points';
        var_9 = 'zef.d7_triangles';
         var_10 = 'zef.d7_submesh_ind';
    case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_scaling';
        var_7 = 'zef.d8_points_inf';
        var_8 = 'zef.d8_points';
        var_9 = 'zef.d8_triangles'; 
         var_10 = 'zef.d8_submesh_ind';
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_scaling';  
        var_7 = 'zef.d9_points_inf';
        var_8 = 'zef.d9_points';
        var_9 = 'zef.d9_triangles';
         var_10 = 'zef.d9_submesh_ind';
    case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_scaling'; 
        var_7 = 'zef.d10_points_inf';
        var_8 = 'zef.d10_points';
        var_9 = 'zef.d10_triangles';
         var_10 = 'zef.d10_submesh_ind';
    case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_scaling';  
        var_7 = 'zef.d11_points_inf';
        var_8 = 'zef.d11_points';
        var_9 = 'zef.d11_triangles';
         var_10 = 'zef.d11_submesh_ind';
    case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_scaling';
        var_7 = 'zef.d12_points_inf';
        var_8 = 'zef.d12_points';
        var_9 = 'zef.d12_triangles'; 
         var_10 = 'zef.d12_submesh_ind';
    case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_scaling';
        var_7 = 'zef.d13_points_inf';
        var_8 = 'zef.d13_points';
        var_9 = 'zef.d13_triangles'; 
         var_10 = 'zef.d13_submesh_ind';
    case 14
        var_0 = 'zef.d14_on';
        var_1 = 'zef.d14_scaling'; 
        var_7 = 'zef.d14_points_inf';
        var_8 = 'zef.d14_points';
        var_9 = 'zef.d14_triangles';
         var_10 = 'zef.d14_submesh_ind';
    case 15
        var_0 = 'zef.d15_on';
        var_1 = 'zef.d15_scaling';
        var_7 = 'zef.d15_points_inf';
        var_8 = 'zef.d15_points';
        var_9 = 'zef.d15_triangles';
         var_10 = 'zef.d15_submesh_ind'; 
    case 16
        var_0 = 'zef.d16_on';
        var_1 = 'zef.d16_scaling'; 
        var_7 = 'zef.d16_points_inf';
        var_8 = 'zef.d16_points';
        var_9 = 'zef.d16_triangles';
         var_10 = 'zef.d16_submesh_ind';
    case 17
        var_0 = 'zef.d17_on';
        var_1 = 'zef.d17_scaling';
        var_7 = 'zef.d17_points_inf';
        var_8 = 'zef.d17_points';
        var_9 = 'zef.d17_triangles';
         var_10 = 'zef.d17_submesh_ind';
    case 18
        var_0 = 'zef.d18_on';
        var_1 = 'zef.d18_scaling';   
        var_7 = 'zef.d18_points_inf';
        var_8 = 'zef.d18_points';
        var_9 = 'zef.d18_triangles';
         var_10 = 'zef.d18_submesh_ind';
    case 19
        var_0 = 'zef.d19_on';
        var_1 = 'zef.d19_scaling'; 
        var_7 = 'zef.d19_points_inf';
        var_8 = 'zef.d19_points';
        var_9 = 'zef.d19_triangles';
         var_10 = 'zef.d19_submesh_ind';
    case 20
        var_0 = 'zef.d20_on';
        var_1 = 'zef.d20_scaling';  
        var_7 = 'zef.d20_points_inf';
        var_8 = 'zef.d20_points';
        var_9 = 'zef.d20_triangles';
         var_10 = 'zef.d20_submesh_ind';
    case 21
        var_0 = 'zef.d21_on';
        var_1 = 'zef.d21_scaling';
        var_7 = 'zef.d21_points_inf';
        var_8 = 'zef.d21_points';
        var_9 = 'zef.d21_triangles'; 
         var_10 = 'zef.d21_submesh_ind';
    case 22
        var_0 = 'zef.d22_on';
        var_1 = 'zef.d22_scaling';
        var_7 = 'zef.d22_points_inf';
        var_8 = 'zef.d22_points';
        var_9 = 'zef.d22_triangles';
         var_10 = 'zef.d22_submesh_ind';
    case 23
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_scaling';  
        var_7 = 'zef.w_points_inf';
        var_8 = 'zef.w_points';
        var_9 = 'zef.w_triangles';
         var_10 = 'zef.w_submesh_ind';
    case 24
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_scaling';
        var_7 = 'zef.g_points_inf';
        var_8 = 'zef.g_points';
        var_9 = 'zef.g_triangles';
         var_10 = 'zef.g_submesh_ind';
    case 25
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_scaling';
        var_7 = 'zef.c_points_inf';
        var_8 = 'zef.c_points';
        var_9 = 'zef.c_triangles';
         var_10 = 'zef.c_submesh_ind';
     case 26
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_scaling';
        var_7 = 'zef.sk_points_inf';
        var_8 = 'zef.sk_points';
        var_9 = 'zef.sk_triangles';
         var_10 = 'zef.sk_submesh_ind';
     case 27
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_scaling';  
        var_7 = 'zef.sc_points_inf';
        var_8 = 'zef.sc_points';
        var_9 = 'zef.sc_triangles';
         var_10 = 'zef.sc_submesh_ind';
     end

on_val = evalin('base',var_0);      
scaling_val = evalin('base',var_1);    
translation_vec = [0 0 0];     
theta_angle_vec = [0 0 0];   

if on_val
i = i + 1;
reuna_p_inf{i} = evalin('base',var_7);
reuna_p{i} = evalin('base',var_8);
reuna_t{i} = evalin('base',var_9);
reuna_submesh_ind{i} = evalin('base',var_10);
mean_vec = repmat(mean(reuna_p{i}),size(reuna_p{i},1),1);   
if scaling_val ~= 1  
reuna_p{i} = scaling_val*reuna_p{i};
reuna_p_inf{i} = scaling_val*reuna_p_inf{i};
end
for j = 1 : 3
switch j
    case 1
        axes_ind = [1 2];
    case 2
        axes_ind = [2 3];
    case 3
        axes_ind = [3 1];
end


if theta_angle_vec(j) ~= 0
theta_angle = theta_angle_vec(j)*pi/180;
R_mat = [cos(theta_angle) -sin(theta_angle); sin(theta_angle) cos(theta_angle)];
reuna_p{i}(:,axes_ind) = (reuna_p{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);
reuna_p_inf{i}(:,axes_ind) = (reuna_p_inf{i}(:,axes_ind)-mean_vec(:,axes_ind))*R_mat' + mean_vec(:,axes_ind);

end
end 
for j = 1 : 3
if translation_vec(j) ~= 0
reuna_p{i}(:,j) = reuna_p{i}(:,j) + translation_vec(j);
reuna_p_inf{i}(:,j) = reuna_p_inf{i}(:,j) + translation_vec(j);
end
end
if explode_param ~= 1
for s_ind = 1 : length(reuna_submesh_ind{i})
    if s_ind == 1 
        t_ind_1 = 1;
    else
        t_ind_1 = reuna_submesh_ind{i}(s_ind-1)+1;
    end
    t_ind_2 = reuna_submesh_ind{i}(s_ind);
    p_ind = unique(reuna_t{i}(t_ind_1:t_ind_2,:));
    mean_aux = mean(reuna_p{i}(p_ind,:));
            reuna_p{i}(p_ind,:) = reuna_p{i}(p_ind,:) + (explode_param-1)*repmat(mean_aux,length(p_ind),1);
    if not(isempty(reuna_p_inf{i})) 
 mean_aux = mean(reuna_p_inf{i}(p_ind,:));
        reuna_p_inf{i}(p_ind,:) = reuna_p_inf{i}(p_ind,:) + (explode_param-1)*repmat(mean_aux,length(p_ind),1);
    end
end
end
end
end

s_points = evalin('base','zef.s_points');
s_data_aux = [];
if ismember(evalin('base','zef.imaging_method'),[2 3]) 
s_directions = evalin('base','zef.s_directions(:,1:3)');
s_directions_g = [];
if size(evalin('base','zef.s_directions'),2) == 6
s_directions_g = evalin('base','zef.s_directions(:,4:6)');
end
else
if size(s_points,2)==6
s_data_aux = s_points(:,4:6);
s_points = s_points(:,1:3);
end
s_directions = [];
s_directions_g = [];
end
s_scaling = evalin('base','zef.s_scaling');
s_x_correction = evalin('base','zef.s_x_correction');
s_y_correction = evalin('base','zef.s_y_correction');
s_z_correction = evalin('base','zef.s_z_correction');
s_xy_rotation = evalin('base','zef.s_xy_rotation');
s_yz_rotation = evalin('base','zef.s_yz_rotation');
s_zx_rotation = evalin('base','zef.s_zx_rotation');
if isempty(s_directions)
sensors = [s_points];
else
if isempty(s_directions_g)
sensors = [s_points s_directions./repmat(sqrt(sum(s_directions.^2,2)),1,3)];    
else
sensors = [s_points s_directions./repmat(sqrt(sum(s_directions.^2,2)),1,3) s_directions_g./repmat(sqrt(sum(s_directions_g.^2,2)),1,3)];
end
end
scaling_val = s_scaling;    
translation_vec = [s_x_correction s_y_correction s_z_correction];     
theta_angle_vec = [s_xy_rotation s_yz_rotation s_zx_rotation]; 
if not(isempty(sensors))
mean_vec = repmat(mean(sensors(:,1:3)),size(sensors(:,1:3),1),1);    
if scaling_val ~= 1 
sensors(:,1:3) = s_scaling*sensors(:,1:3);
end
for j = 1 : 3
switch j
    case 1
        axes_ind_1 = [1 2];
        axes_ind_2 = [4 5];
        axes_ind_3 = [7 8];
    case 2
        axes_ind_1 = [2 3];
        axes_ind_2 = [5 6];
        axes_ind_3 = [8 9];
    case 3
        axes_ind_1 = [3 1];
        axes_ind_2 = [6 4];
        axes_ind_3 = [9 7];
end
if theta_angle_vec(j) ~= 0
theta_angle = theta_angle_vec(j)*pi/180;
R_mat = [cos(theta_angle) -sin(theta_angle); sin(theta_angle) cos(theta_angle)];
sensors(:,axes_ind_1) = (sensors(:,axes_ind_1) - mean_vec(:,axes_ind_1))*R_mat' + mean_vec(:,axes_ind_1);
if not(isempty(s_directions))
sensors(:,axes_ind_2) = sensors(:,axes_ind_2)*R_mat';
end
if not(isempty(s_directions_g))
sensors(:,axes_ind_3) = sensors(:,axes_ind_3)*R_mat';
end
end
end
for j = 1 : 3
if translation_vec(j) ~= 0
sensors(:,j) = sensors(:,j) + translation_vec(j);
end
sensors(:,j) = sensors(:,j)  +  (explode_param-1)*(sensors(:,j) - mean(sensors(:,j)));
end



if not(isempty(s_data_aux))
sensors = [sensors s_data_aux];
end
else
    sensors = [NaN NaN NaN];
end

