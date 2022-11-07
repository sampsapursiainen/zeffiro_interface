%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [boundary_vec_1, boundary_vec_2, s_orbit] = boundary_source(fade_out_param, source_points, orbit_triangles, orbit_nodes)

n_triangles = size(orbit_triangles(:,1), 1);
n_nodes = size(orbit_nodes(:,1), 1);
n_source_points = size(source_points,1);

t_c_points = (1/3)*[orbit_nodes(orbit_triangles(:,1), :) + orbit_nodes(orbit_triangles(:,2), :) + orbit_nodes(orbit_triangles(:,3), :)]; 
s_vec = zeros(n_triangles, n_source_points); 
s_vec_2 = zeros(n_nodes, n_source_points); 
t_integ_vec = zeros(n_triangles, n_source_points); 
scaling_vec = zeros(n_triangles, n_source_points); 
scaling_vec_2 = zeros(n_triangles, n_source_points);

aux_vec_1 = orbit_nodes(orbit_triangles(:,2),:) - orbit_nodes(orbit_triangles(:,1),:); 
aux_vec_2 = orbit_nodes(orbit_triangles(:,3),:) - orbit_nodes(orbit_triangles(:,1),:); 
n_vec_aux = cross(aux_vec_1', aux_vec_2')';
ala_vec = sqrt(sum(n_vec_aux.^2,2))/2;
n_vec_aux = n_vec_aux./(2*ala_vec(:,[1 1 1]));
n_vec_aux = sign(repmat(sum(t_c_points.*n_vec_aux,2),1,3)).*n_vec_aux;

for i = 1 : n_source_points

source_vec  = t_c_points - source_points(i*ones(n_triangles,1), :);
s_vec(:, i) = sqrt(sum(source_vec.^2, 2)); 
s_vec_2(:, i) = sqrt(sum((orbit_nodes - source_points(i*ones(n_nodes,1), :)).^2, 2)); 
source_vec = source_vec./s_vec(:,i*[1 1 1]);
scaling_vec(:,i) = sum(source_vec.*n_vec_aux,2);
scaling_vec_2(:,i) = sum(source_vec.*n_vec_aux,2);
I_s_1 = find(scaling_vec(:,i) > 0); 
I_s_2 = find(scaling_vec(:,i) <= 0); 
scaling_vec(I_s_1,i) = exp(-fade_out_param*scaling_vec(I_s_1,i)./(1 - scaling_vec(I_s_1,i))).*scaling_vec(I_s_1,i);
scaling_vec(I_s_2,i) = 1;

end

boundary_vec_1 = zeros(n_nodes, n_source_points);
boundary_vec_2 = zeros(n_nodes, n_source_points);
%boundary_vec_3 = zeros(n_nodes, n_source_points);

aux_ind_2 = [1 : n_source_points]; 
aux_ind_2 = aux_ind_2(ones(n_triangles,1),:);
aux_vec_1 = -(1/3).*scaling_vec.*scaling_vec_2.*ala_vec(:,ones(n_source_points,1))./(s_vec.^2);
aux_vec_2 = -(1/3).*scaling_vec.*scaling_vec_2.*ala_vec(:,ones(n_source_points,1))./(s_vec);
%aux_vec_3 = -scaling_vec.*ala_vec(:,ones(n_source_points,1))./(s_vec);
%aux_vec_3 = ala_vec(:,ones(n_source_points,1));

for i = 1 : 3
aux_ind_1 = orbit_triangles(:,i); 
aux_ind_1 = aux_ind_1(:,ones(n_source_points,1));
boundary_vec_1  = boundary_vec_1 + accumarray([aux_ind_1(:) aux_ind_2(:)], aux_vec_1(:), [n_nodes, n_source_points]);
boundary_vec_2  = boundary_vec_2 + accumarray([aux_ind_1(:) aux_ind_2(:)], aux_vec_2(:), [n_nodes, n_source_points]);
%boundary_vec_3  = boundary_vec_3 + accumarray([aux_ind_1(:) aux_ind_2(:)], aux_vec_3(:), [n_nodes, n_source_points]);
end

s_orbit = s_vec_2;

boundary_vec_1 = 2*boundary_vec_1/(4*pi);
boundary_vec_2 = 2*boundary_vec_2/(4*pi);
