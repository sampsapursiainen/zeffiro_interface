function nse_field = zef_nse_poisson(nse_field,nodes,tetra,domain_labels,mvd_length) 

%Output: 
%nse_field.bf_capillaries
%nse_field.bp_vessels
%nse_field.bf_capillary_node_ind
%nse_field.bp_vessel_node_ind

%Input:
%nse_field.artery_domain_ind
%nse_field.capillary_domain_ind
%nse_field.total_flow
%nse_field.gravity_x
%nse_field.gravity_y
%nse_field.gravity_z
%nse_field.rho
%nse_field.mu
%nse_field.pressure

c_ind_1_domain = find(ismember(domain_labels,nse_field.artery_domain_ind));
c_ind_2_domain = find(ismember(domain_labels,nse_field.capillary_domain_ind));

hgmm_conversion = 101325/760;
mm_conversion = 0.001;
ml_min_conversion = 1E-6/60;
capillary_fraction = nse_field.capillary_arteriole_total_area_ratio;
arteriole_fraction = (1-nse_field.capillary_arteriole_total_area_ratio)/2;
venule_fraction = (1-nse_field.capillary_arteriole_total_area_ratio)/2;
arteriole_scale = 1./( arteriole_fraction*nse_field.arteriole_diameter.^2./(arteriole_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.arteriole_diameter.^2./(arteriole_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.arteriole_diameter.^2./(arteriole_fraction.*nse_field.venule_diameter.^2));
capillary_scale = 1./( arteriole_fraction*nse_field.capillary_diameter.^2./(capillary_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.capillary_diameter.^2./(capillary_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.capillary_diameter.^2./(capillary_fraction.*nse_field.venule_diameter.^2));
venule_scale = 1./( arteriole_fraction*nse_field.venule_diameter.^2./(venule_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.venule_diameter.^2./(venule_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.venule_diameter.^2./(venule_fraction.*nse_field.venule_diameter.^2));

mvd_length = 1E6.*mvd_length(:,1);

diffusion_coefficient = hgmm_conversion.*nse_field.pressure*((pi/4).*nse_field.arteriole_diameter.^2)/(8*pi*nse_field.mu);

%diffusion_coefficient*240e6
%keyboard

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;

[v_2_nodes, v_2_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, c_ind_2_domain);
v_2_nodes = mm_conversion*v_2_nodes;
[~, det] = zef_volume_barycentric(v_2_nodes,v_2_tetra);
volume = abs(det)/6;
volume_sum = sum(volume(:));
mvd_volume_mean = sum(mvd_length(c_ind_2_domain).*volume(:))./volume_sum;

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(v_1_tetra);
[t_ind_2, f_ind_2] = zef_find_adjacent_tetra(tetra, c_ind_1_domain(t_ind), f_ind);
[b_vec,det] = zef_volume_barycentric(v_1_nodes,v_1_tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(b_vec.^2,2));

param_aux = zeros(length(c_ind_1_domain),1);
param_aux(t_ind) = mvd_length(t_ind_2); 
param_aux_integral_mean = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra, param_aux);
param_aux_integral_mean = sum(param_aux_integral_mean);
I = find(param_aux(t_ind));
area_arteries = sum(area(I));
param_aux_integral_mean = param_aux_integral_mean/area_arteries;

beta = (8*pi*nse_field.mu*ml_min_conversion*nse_field.total_flow)./((pi*(nse_field.arteriole_diameter/2).^2).^2.*nse_field.pressure_decay_in_arterioles.*nse_field.pressure.*hgmm_conversion.*param_aux_integral_mean.^2.*arteriole_scale*area_arteries);

K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));

M = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, beta.*param_aux);

F_1 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,1,ones(size(v_1_tetra,1),1));
F_2 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,2,ones(size(v_1_tetra,1),1));
F_3 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,3,ones(size(v_1_tetra,1),1));

f_1 = nse_field.gravity_x*ones(size(v_1_nodes,1),1);
f_2 = nse_field.gravity_y*ones(size(v_1_nodes,1),1);
f_3 = nse_field.gravity_z*ones(size(v_1_nodes,1),1);

f = (nse_field.rho)*(F_1*f_1 + F_2*f_2 + F_3*f_3);

w_1 = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra, beta*param_aux);

nu = hgmm_conversion*nse_field.pressure*sum(w_1);

A = [ -K_1 + M w_1; w_1' sum(w_1) ];
b = [ f; nu ];

if nse_field.use_gpu
DM = 1./diag(A); 
p = pcg_iteration_gpu(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
DM = spdiags(diag(A),0,size(A,1),size(A,1)); 
p = pcg_iteration(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end
    
p_overline = p(end);
p = p(1:end-1);
nse_field.bp_vessels = (p + p_overline);

nse_field.bp_vessels = nse_field.bp_vessels/hgmm_conversion;
nse_field.bp_vessels = zef_nse_threshold_distribution(nse_field.bp_vessels,nse_field.min_pressure_quantile,nse_field.max_pressure_quantile); 
  
 
bp_vessels_aux = zeros(size(nodes,1),1);
bp_vessels_aux(nse_field.bp_vessel_node_ind) = nse_field.bp_vessels;

 
K_2 = zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 1, 1, mvd_length(c_ind_2_domain)) + ... 
     zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 2, 2, mvd_length(c_ind_2_domain)) + ... 
     zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 3, 3, mvd_length(c_ind_2_domain));


w_2 = zef_volume_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));
w_3 = zef_surface_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

g = sum(w_2);
 
bf_vessels_to_capillaries = bp_vessels_aux(nse_field.bf_capillary_node_ind);
u = ml_min_conversion*nse_field.total_flow*bf_vessels_to_capillaries./sum(bf_vessels_to_capillaries.*w_3);

s_vec = ones(size(K_2,1),1);
s_vec(find(u)) = 0; 
S = zef_volume_scalar_diagonal_matrix_FF(v_2_nodes, v_2_tetra, mvd_length(c_ind_2_domain));
%S = spdiags(s_vec,0,size(K_2,1),size(K_2,1));

a = min((1/mvd_volume_mean)*diag(K_2)./diag(S))

K_2 = (diffusion_coefficient/mvd_volume_mean)*K_2 + (venule_scale*diffusion_coefficient/mvd_volume_mean)*S;

%u = [ bf_vessels_to_capillaries; ml_min_conversion*nse_field.total_flow.*sum(w_2) ];
%K_2 = [ -nse_field.diffusion_parameter*K_2 w_2; w_2' g ];
 
 if nse_field.use_gpu
 DM = 1./diag(K_2); 
 nse_field.bf_capillaries = pcg_iteration_gpu(K_2,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
 else
 DM = spdiags(diag(K_2),0,size(K_2,1),size(K_2,1)); 
 nse_field.bf_capillaries  = pcg_iteration(K_2,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
 end
 
 %nse_field.bf_capillaries = nse_field.bf_capillaries(1:end-1) + nse_field.bf_capillaries(end);
 nse_field.bf_capillaries = zef_nse_threshold_distribution(nse_field.bf_capillaries,nse_field.min_flow_quantile,nse_field.max_flow_quantile); 
 %nse_field.bf_capillaries = ml_min_conversion*nse_field.total_flow*nse_field.bf_capillaries./sum(nse_field.bf_capillaries.*w_2);

%microcirculation_volume_bg = (pi/4).*mvd_volume_mean*volume_sum.*(arteriole_scale*nse_field.arteriole_diameter.^2+capillary_scale*nse_field.capillary_diameter.^2+venule_scale*nse_field.venule_diameter.^2)
%microcirculation_volume_bf = (pi/4).*sum(nse_field.bf_capillaries.*w_2)
  
 
end