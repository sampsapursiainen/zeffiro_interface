%Copyright © 2018, Sampsa Pursiainen
function [source_interpolation_ind] = source_interpolation(void)

brain_ind = evalin('base','zef.brain_ind');
source_positions = evalin('base','zef.source_positions');
nodes = evalin('base','zef.nodes');
tetra = evalin('base','zef.tetra');

if evalin('base','zef.location_unit_current') == 2 
source_positions = 10*source_positions;
end

if evalin('base','zef.location_unit_current') == 3
zef.source_positions = 1000*source_positions;
end

rand_perm_aux = [];
if evalin('base','zef.n_sources') < size(source_positions,1)
rand_perm_aux = randperm(size(source_positions,1));
rand_perm_aux = rand_perm_aux(1:evalin('base','zef.n_sources'));
source_positions = source_positions(rand_perm_aux,:);
end

[center_points I center_points_ind] = unique(tetra(brain_ind,:));
source_interpolation_ind{1} = zeros(length(center_points),1);
source_interpolation_aux = source_interpolation_ind{1};
center_points = nodes(center_points,:)';

source_positions = source_positions';
ones_vec = ones(size(source_positions,2),1);

size_center_points = size(center_points,2); 

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;
for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_positions(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1
h = waitbar(i/size_center_points,['Interpolation 1.']);    
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Interpolation 1. Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_ind{1} = (gather(source_interpolation_aux));

if not(isempty(rand_perm_aux))
source_interpolation_ind{1} = rand_perm_aux(source_interpolation_ind{1});
end
source_interpolation_ind{1} = reshape(source_interpolation_ind{1}(center_points_ind), length(brain_ind), 4); 

waitbar(1,h,['Interpolation 1. Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);

close(h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
for k = 1 : 18   
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
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
        var_3 = 'zef.w_visible';
        color_str = evalin('base','zef.w_color');
    case 15
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
        var_3 = 'zef.g_visible';
        color_str = evalin('base','zef.g_color');
    case 16
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
        var_3 = 'zef.c_visible';
        color_str = evalin('base','zef.c_color');
     case 17
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
        var_3 = 'zef.sk_visible';
        color_str = evalin('base','zef.sk_color');
     case 18
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
if k == 14 && evalin('base','zef.wm_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 15 && evalin('base','zef.g_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 16 && evalin('base','zef.c_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 17 && evalin('base','zef.sk_sources');
    aux_brain_ind = [aux_brain_ind i];
end
if k == 18 && evalin('base','zef.sc_sources');
    aux_brain_ind = [aux_brain_ind i];
end

end
end

source_positions_aux = source_positions;

for ab_ind = 1 : length(aux_brain_ind)

aux_point_ind = unique(gather(source_interpolation_ind{1}));
source_positions = source_positions_aux(:,aux_point_ind);
ones_vec = ones(size(source_positions,2),1);

s_ind_1{ab_ind} = aux_point_ind;

center_points = evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']);
center_points = center_points';

source_interpolation_ind{2}{ab_ind} = zeros(length(center_points),1);
source_interpolation_aux = source_interpolation_ind{2}{ab_ind};

size_center_points = size(center_points,2); 

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;

for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_positions(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1
h = waitbar(i/size_center_points,['Interp. 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '.']);    
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Interp. 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '. Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_ind{2}{ab_ind} = (s_ind_1{ab_ind}(gather(source_interpolation_aux)));

if not(isempty(rand_perm_aux))
source_interpolation_ind{2}{ab_ind} = rand_perm_aux(source_interpolation_ind{2});
end
triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}']);
source_interpolation_ind{2}{ab_ind} = source_interpolation_ind{2}{ab_ind}(triangles); 


waitbar(1,h,['Interp. 2: ' num2str(ab_ind) '/' num2str(length(aux_brain_ind)) '. Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);

close(h)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source_direction_mode = evalin('base','zef.source_direction_mode');

%if source_direction_mode == 2
    
source_interpolation_ind{3} = zeros(length(source_positions),1);
source_interpolation_aux = source_interpolation_ind{3};

aux_p = [];
aux_t = [];

for ab_ind = 1 : length(aux_brain_ind)

aux_t = [aux_t ; size(aux_p,1) + evalin('base',['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
aux_p = [aux_p ; evalin('base',['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];

end

center_points = (1/3)*(aux_p(aux_t(:,1),:) + aux_p(aux_t(:,2),:) + aux_p(aux_t(:,3),:));
center_points = center_points';


size_center_points = size(center_points,2); 
size_source_positions = size(source_positions,2); 
ones_vec = ones(size(center_points,2),1);

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_positions = gpuArray(source_positions);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));
i_ind = 0;

tic;

for i = 1 : par_num : size_source_positions

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_source_positions)];
aux_vec = source_positions(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((center_points(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1
h = waitbar(i/size_source_positions,['Interp. 3:']);    
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_source_positions,h,['Interp. 3: Ready approx. ' datestr(datevec(now+(size_source_positions/i - 1)*time_val/86400)) '.']);
end
end

source_interpolation_ind{3} = (gather(source_interpolation_aux));

% if not(isempty(rand_perm_aux))
% source_interpolation_ind{2} = rand_perm_aux(source_interpolation_ind{2});
% end
% triangles = evalin('base',['zef.reuna_t{' int2str(aux_brain_ind) '}']);
% source_interpolation_ind{2} = source_interpolation_ind{2}(triangles); 

waitbar(1,h,['Interp. 3: Ready approx. ' datestr(datevec(now+(size_source_positions/i - 1)*time_val/86400)) '.']);

close(h)

end
