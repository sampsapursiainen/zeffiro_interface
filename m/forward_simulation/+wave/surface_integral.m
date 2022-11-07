function [integ_vec] = surface_integral(u_data, du_dt_data, p_1_data, p_2_data, p_3_data, t_data, t_shift, source_points, orbit_nodes, orbit_triangles)

n_triangles = size(orbit_triangles(:,1), 1);
n_nodes = size(orbit_nodes(:,1), 1);
n_source_points = size(source_points,1);

t_c_points = (1/3)*[orbit_nodes(orbit_triangles(:,1), :) + orbit_nodes(orbit_triangles(:,2), :) + orbit_nodes(orbit_triangles(:,3), :)]; 
s_vec = zeros(n_triangles, n_source_points); 
t_integ_vec = zeros(n_triangles, n_source_points); 
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
source_vec = source_vec./s_vec(:,i*[1 1 1]);
scaling_vec_2(:,i) = sum(source_vec.*n_vec_aux,2);

end

d_t_2 = t_data(2) - t_data(1); 
ret_time = floor((s_vec-t_shift)/d_t_2);

u_data = (1/3)*(u_data(orbit_triangles(:,1),:)+u_data(orbit_triangles(:,2),:)+u_data(orbit_triangles(:,3),:));
du_dt_data = (1/3)*(du_dt_data(orbit_triangles(:,1),:)+du_dt_data(orbit_triangles(:,2),:)+du_dt_data(orbit_triangles(:,3),:));
du_dn_data = p_1_data.*n_vec_aux(:,ones(1,size(p_1_data,2))) + p_2_data.*n_vec_aux(:,2*ones(1,size(p_2_data,2))) + p_3_data.*n_vec_aux(:,3*ones(1,size(p_3_data,2)));

integ_vec = (zeros(n_source_points, 2*length(t_data)));
ind_aux_1 =  [1:n_source_points];
ind_aux_1 = ind_aux_1(ones(n_triangles,1),:);
for t_ind = 1 : size(u_data,2)
t_ind
aux_vec_1 =  -ala_vec(:).*u_data(:, t_ind);
aux_vec_1 = scaling_vec_2.*aux_vec_1(:,ones(1,n_source_points))./(s_vec.^2);
aux_vec_2 =  -ala_vec(:).*du_dt_data(:, t_ind);
aux_vec_2 = scaling_vec_2.*aux_vec_2(:,ones(1,n_source_points))./(s_vec);
aux_vec_3 =  -ala_vec(:).*du_dn_data(:, t_ind);
aux_vec_3 = aux_vec_3(:,ones(1,n_source_points))./(s_vec);
aux_vec = accumarray([ ind_aux_1(:), ret_time(:)+t_ind], aux_vec_1(:)+aux_vec_2(:)+aux_vec_3(:), size(integ_vec));
integ_vec = integ_vec + aux_vec;
end
integ_vec = integ_vec/(4*pi);

integ_vec = integ_vec(:,1:length(t_data));
