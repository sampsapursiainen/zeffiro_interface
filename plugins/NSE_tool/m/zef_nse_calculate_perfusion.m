function perfusion_estimate = zef_nse_calculate_perfusion(nse_field,nodes,tetra,domain_labels,mvd_length)

mm_conversion = 0.001;
ml_min_conversion = 1e-6/60;
hgmm_conversion = 101325/760;

mvd_length = 1E6.*mvd_length(:,1);

c_ind_1_domain = find(ismember(domain_labels,nse_field.artery_domain_ind));
[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;
[~, det] = zef_volume_barycentric(v_1_nodes,v_1_tetra);
volume = abs(det)/6;

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(v_1_tetra);
[t_ind_2, f_ind_2] = zef_find_adjacent_tetra(tetra, c_ind_1_domain(t_ind), f_ind);
[b_vec,det] = zef_volume_barycentric(v_1_nodes,v_1_tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(b_vec(:,1:3).^2,2));

param_aux = zeros(length(c_ind_1_domain),1);
param_aux(t_ind) = mvd_length(t_ind_2);
param_aux_integral_mean = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra, param_aux);
param_aux_integral_mean = sum(param_aux_integral_mean);
I = find(param_aux(t_ind));
area_arteries = sum(area(I));

param_aux_ones = zeros(size(param_aux));
param_aux_ones(t_ind) = 1;
w_3 = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra,param_aux_ones);
perfusion_estimate = zeros(size(nse_field.bv_vessels_1,2),1);

gravity_amplitude = nse_field.gravity_amplitude;
gravity_x = nse_field.gravity_x;
gravity_y = nse_field.gravity_y;
gravity_z = nse_field.gravity_z;

gravity_vec = gravity_x.*v_1_nodes(:,1) + gravity_y.*v_1_nodes(:,2) + gravity_z.*v_1_nodes(:,3);
gravity_vec = gravity_vec - min(gravity_vec);
p_hydrostatic = nse_field.rho*gravity_vec;

%n_1 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 1);
%n_2 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 2);
%n_3 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 3);

for i = 1 : size(nse_field.bv_vessels_1,2)

perfusion_estimate(i) = (sum((nse_field.bp_vessels{i}-p_hydrostatic/hgmm_conversion).*w_3)/sum(w_3))*nse_field.total_flow/nse_field.pressure;

end

end





