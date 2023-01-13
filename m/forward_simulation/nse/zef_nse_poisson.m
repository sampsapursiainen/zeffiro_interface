function nse_field = zef_nse_poisson(nse_field,nodes,tetra,domain_labels,mvd_length,mvd_volume) 

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

% aux_ind = setdiff([1:size(nse_field.tetra,1)]',c_ind_1_domain);
% 
% p_0_aux = accumarray(nse_field.tetra(aux_ind,1),nse_field.pressure(aux_ind),[size(nse_field.nodes,1) 1]);
% p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,2),nse_field.pressure(aux_ind),[size(nse_field.nodes,1) 1]);
% p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,3),nse_field.pressure(aux_ind),[size(nse_field.nodes,1) 1]);
% p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,4),nse_field.pressure(aux_ind),[size(nse_field.nodes,1) 1]);
% 
% p_0_aux_count =  accumarray(nse_field.tetra(aux_ind,1),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
% p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,2),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
% p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,3),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
% p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,4),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
% 
% nse_field.p_0 = p_0_aux./p_0_aux_count; 

c_ind_1_domain = find(ismember(domain_labels,nse_field.artery_domain_ind));
c_ind_2_domain = find(ismember(domain_labels,nse_field.capillary_domain_ind));

hgmm_conversion = 101325/760;
mm_conversion = 0.001;
ml_min_conversion = 1E-6/60;
bpm_conversion = 1/60;
beta = sqrt(2*pi*bpm_conversion*nse_field.pulse_frequency*nse_field.rho/nse_field.mu);
mvd_length = mvd_length(:,1);
mvd_volume = mvd_volume(:,1);

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(v_1_tetra);
[t_ind_2, f_ind_2] = zef_find_adjacent_tetra(tetra, c_ind_1_domain(t_ind), f_ind);
[b_vec,det] = zef_volume_barycentric(v_1_nodes,v_1_tetra(t_ind,:),f_ind);
area = (abs(det)/2)./sqrt(sum(b_vec.^2,2));
param_aux = mvd_length(c_ind_1_domain);
param_aux(t_ind) = mvd_length(t_ind_2);
param_aux = param_aux./(nse_field.vessel_resistance.*max(mvd_length));
mvd_volume = mvd_volume/max(mvd_volume);

K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));

M = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, beta.*(param_aux));

F_1 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,1,ones(size(v_1_tetra,1),1));
F_2 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,2,ones(size(v_1_tetra,1),1));
F_3 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,3,ones(size(v_1_tetra,1),1));

f_1 = nse_field.gravity_x*ones(size(v_1_nodes,1),1);
f_2 = nse_field.gravity_y*ones(size(v_1_nodes,1),1);
f_3 = nse_field.gravity_z*ones(size(v_1_nodes,1),1);

f = (nse_field.rho)*(F_1*f_1 + F_2*f_2 + F_3*f_3);

w_1 = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra, beta*(param_aux));

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

[v_2_nodes, v_2_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, c_ind_2_domain);
v_2_nodes = mm_conversion*v_2_nodes;

K_2 = zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 1, 1,mvd_volume(size(v_2_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 2, 2, mvd_volume(size(v_2_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 3, 3, mvd_volume(size(v_2_tetra,1),1));

w_2 = zef_volume_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

w_3 = zef_surface_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

g = sum(w_2);

bf_vessels_to_capillaries = bp_vessels_aux(nse_field.bf_capillary_node_ind);
bf_vessels_to_capillaries = ml_min_conversion*nse_field.total_flow*bf_vessels_to_capillaries./sum(bf_vessels_to_capillaries.*w_3);

u = [ bf_vessels_to_capillaries; ml_min_conversion*nse_field.total_flow.*sum(w_2)];
S = [ -nse_field.diffusion_parameter*K_2 w_2; w_2' g ];

if nse_field.use_gpu
DM = 1./diag(S); 
nse_field.bf_capillaries  = pcg_iteration_gpu(S,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
DM = spdiags(diag(S),0,size(S,1),size(S,1)); 
nse_field.bf_capillaries  = pcg_iteration(S,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end

[~, det] = zef_volume_barycentric(v_2_nodes,v_2_tetra);
volume = abs(det)/6;

nse_field.bf_capillaries = nse_field.bf_capillaries(1:end-1) + nse_field.bf_capillaries(end);
nse_field.bf_capillaries = zef_nse_threshold_distribution(nse_field.bf_capillaries,nse_field.min_flow_quantile,nse_field.max_flow_quantile); 
nse_field.bf_capillaries = ml_min_conversion*nse_field.total_flow*nse_field.bf_capillaries./sum(nse_field.bf_capillaries.*w_2);

end