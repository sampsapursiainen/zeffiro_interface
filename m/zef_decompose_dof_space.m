%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [decomposition_ind,decomposition_count,dof_positions,decomposition_ind_first] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,varargin)

if not(isempty(varargin))
source_ind = varargin{1};
if length(varargin) > 1
n_sources = varargin{2};
else
    n_sources = evalin('base','zef.n_sources');
end
if length(varargin) > 2
dof_decomposition_type = varargin{3};
else
dof_decomposition_type = evalin('base','zef.dof_decomposition_type');
end
else
source_ind = brain_ind;
n_sources = evalin('base','zef.n_sources');
dof_decomposition_type = evalin('base','zef.dof_decomposition_type');
end

if isempty(source_ind)
source_ind = brain_ind;
end

if evalin('caller','exist(''h'')')
    if isvalid(evalin('caller','h'))
h = evalin('caller','h');
    end
end


center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
source_points = center_points(source_ind,:)';
center_points = center_points(brain_ind,:);

if dof_decomposition_type == 1

center_points = center_points';    
    
dof_positions = (nodes(tetrahedra(source_ind,1),:) + nodes(tetrahedra(source_ind,2),:) + nodes(tetrahedra(source_ind,3),:)+ nodes(tetrahedra(source_ind,4),:))/4;

size_center_points = size(center_points,2); 
size_source_points = size(center_points,2); 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

waitbar(1/size_center_points,h,['Source decomposition.']); 

source_interpolation_aux = zeros(size_center_points,1);
ones_vec = ones(size(source_points,2),1);

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_points = gpuArray(source_points);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

i_ind = 0;
tic
for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_points(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1 
waitbar(i/size_center_points,h,['Source decomposition.']); 
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Source decomposition. Ready: ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_aux = gather(source_interpolation_aux);
decomposition_ind = source_interpolation_aux;
[aux_vec, i_a, i_c] = unique(source_interpolation_aux);
decomposition_count = accumarray(i_c,1);
decomposition_pointe = i_a;

elseif dof_decomposition_type == 2
    
min_x = min(center_points(:,1));
max_x = max(center_points(:,1));
min_y = min(center_points(:,2));
max_y = max(center_points(:,2));
min_z = min(center_points(:,3));
max_z = max(center_points(:,3));

lattice_constant = n_sources.^(1/3)/((max_x - min_x)*(max_y - min_y)*(max_z - min_z))^(1/3); 
lattice_res_x = floor(lattice_constant*(max_x - min_x));
lattice_res_y = floor(lattice_constant*(max_y - min_y));
lattice_res_z = floor(lattice_constant*(max_z - min_z));

l_d_x = (max_x - min_x)/(lattice_res_x + 1);
l_d_y = (max_y - min_y)/(lattice_res_y + 1);
l_d_z = (max_z - min_z)/(lattice_res_z + 1);

min_x = min_x + l_d_x;
max_x = max_x - l_d_x;
min_y = min_y + l_d_y;
max_y = max_y - l_d_y;
min_z = min_z + l_d_z;
max_z = max_z - l_d_z;

[X_lattice, Y_lattice, Z_lattice] = meshgrid(linspace(min_x,max_x,lattice_res_x),linspace(min_y,max_y,lattice_res_y),linspace(min_z,max_z,lattice_res_z));


lattice_ind_aux = [max(1,ceil(lattice_res_x*(center_points(:,1)-min(center_points(:,1)))./(max(center_points(:,1))-min(center_points(:,1))))) ... 
max(1,ceil(lattice_res_y*(center_points(:,2)-min(center_points(:,2)))./(max(center_points(:,2))-min(center_points(:,2)))))...
max(1,ceil(lattice_res_z*(center_points(:,3)-min(center_points(:,3)))./(max(center_points(:,3))-min(center_points(:,3)))))];
    
lattice_ind_aux = (lattice_ind_aux(:,3)-1)*lattice_res_x*lattice_res_y + (lattice_ind_aux(:,1)-1)*lattice_res_y + lattice_ind_aux(:,2);

dof_positions = [X_lattice(:) Y_lattice(:) Z_lattice(:)];
decomposition_ind = lattice_ind_aux;
[aux_vec, i_a, i_c] = unique(decomposition_ind);
aux_ind_2 = zeros(size(dof_positions,1),1);
aux_ind_2(aux_vec) = [1 : length(aux_vec)];
decomposition_ind = aux_ind_2(decomposition_ind);
dof_positions = dof_positions(aux_vec,:);
decomposition_count = accumarray(i_c,1);
decomposition_ind_first = i_a;

elseif dof_decomposition_type == 3    
    
 decomposition_ind = [1:length(brain_ind)]';
 decomposition_count = ones(size(decomposition_ind));
 dof_positions = center_points;
 decomposition_ind_first = [1:length(brain_ind)]';

end
end



