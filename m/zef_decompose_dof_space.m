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

center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
center_points = center_points(brain_ind,:);

if dof_decomposition_type == 1

dof_positions = (nodes(tetrahedra(source_ind,1),:) + nodes(tetrahedra(source_ind,2),:) + nodes(tetrahedra(source_ind,3),:)+ nodes(tetrahedra(source_ind,4),:))/4;

size_center_points = size(center_points,2);
size_source_points = size(center_points,2);

MdlKDT = KDTreeSearcher(dof_positions);
decomposition_ind  = knnsearch(MdlKDT,center_points);

[aux_vec, i_a, i_c] = unique(decomposition_ind);
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

lattice_ind_aux = [max(1,round(lattice_res_x*(center_points(:,1)-min(center_points(:,1)))./(max(center_points(:,1))-min(center_points(:,1))))) ...
max(1,round(lattice_res_y*(center_points(:,2)-min(center_points(:,2)))./(max(center_points(:,2))-min(center_points(:,2)))))...
max(1,round(lattice_res_z*(center_points(:,3)-min(center_points(:,3)))./(max(center_points(:,3))-min(center_points(:,3)))))];

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

