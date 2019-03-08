%Copyright © 2018, Sampsa Pursiainen
function [sensors,reuna_p,reuna_t] = process_meshes(void);

i = 0;
sensors = [];
reuna_p = cell(0);
reuna_t = cell(0);

for k = 1 : 18

switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_scaling';   
        var_8 = 'zef.d1_points';
        var_9 = 'zef.d1_triangles';
    case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_scaling'; 
        var_8 = 'zef.d2_points';
        var_9 = 'zef.d2_triangles';
    case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_scaling';  
        var_8 = 'zef.d3_points';
        var_9 = 'zef.d3_triangles';
    case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_scaling';
        var_8 = 'zef.d4_points';
        var_9 = 'zef.d4_triangles';   
            case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_scaling';   
        var_8 = 'zef.d5_points';
        var_9 = 'zef.d5_triangles';
    case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_scaling'; 
        var_8 = 'zef.d6_points';
        var_9 = 'zef.d6_triangles';
    case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_scaling';  
        var_8 = 'zef.d7_points';
        var_9 = 'zef.d7_triangles';
    case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_scaling';
        var_8 = 'zef.d8_points';
        var_9 = 'zef.d8_triangles';     
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_scaling';   
        var_8 = 'zef.d9_points';
        var_9 = 'zef.d9_triangles';
    case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_scaling'; 
        var_8 = 'zef.d10_points';
        var_9 = 'zef.d10_triangles';
    case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_scaling';  
        var_8 = 'zef.d11_points';
        var_9 = 'zef.d11_triangles';
    case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_scaling';
        var_8 = 'zef.d12_points';
        var_9 = 'zef.d12_triangles'; 
    case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_scaling';
        var_8 = 'zef.d13_points';
        var_9 = 'zef.d13_triangles'; 
    case 14
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_scaling';  
        var_8 = 'zef.w_points';
        var_9 = 'zef.w_triangles';
    case 15
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_scaling';
        var_8 = 'zef.g_points';
        var_9 = 'zef.g_triangles';
    case 16
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_scaling';
        var_8 = 'zef.c_points';
        var_9 = 'zef.c_triangles';
     case 17
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_scaling';
        var_8 = 'zef.sk_points';
        var_9 = 'zef.sk_triangles';
     case 18
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_scaling';     
        var_8 = 'zef.sc_points';
        var_9 = 'zef.sc_triangles';
     end

on_val = evalin('base',var_0);      
scaling_val = evalin('base',var_1);    
translation_vec = [0 0 0];     
theta_angle_vec = [0 0 0];   

if on_val
i = i + 1;
reuna_p{i} = evalin('base',var_8);
reuna_t{i} = evalin('base',var_9);
mean_vec = repmat(mean(reuna_p{i}),size(reuna_p{i},1),1);   
if scaling_val ~= 1  
reuna_p{i} = scaling_val*reuna_p{i};
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
end
end 
for j = 1 : 3
if translation_vec(j) ~= 0
reuna_p{i}(:,j) = reuna_p{i}(:,j) + translation_vec(j);
end
end
end
end

s_points = evalin('base','zef.s_points');
if ismember(evalin('base','zef.imaging_method'),[2 3]) 
s_directions = evalin('base','zef.s_directions(:,1:3)');
s_directions_g = [];
if size(evalin('base','zef.s_directions'),2) == 6
s_directions_g = evalin('base','zef.s_directions(:,4:6)');
end
else 
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
end

