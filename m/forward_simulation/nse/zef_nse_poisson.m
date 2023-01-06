function nse_field = zef_nse_poisson(nse_field) 

%Output: 
%nse_field.bf_capillaries
%nse_field.bp_vessels
%nse_field.bf_capillary_node_ind
%nse_field.bp_vessel_node_ind

%Input:
%nse_field.nodes
%nse_field.tetra 
%nse_field.c_ind_1
%nse_field.c_ind_2
%nse_field.f_param
%nse_field.f_val
%nse_field.g_vec
%nse_field.rho
%nse_field.p_0 

aux_ind = setdiff([1:size(nse_field.tetra,1)]',nse_field.c_ind_1);

p_0_aux = accumarray(nse_field.tetra(aux_ind,1),nse_field.p_ref(aux_ind),[size(nse_field.nodes,1) 1]);
p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,2),nse_field.p_ref(aux_ind),[size(nse_field.nodes,1) 1]);
p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,3),nse_field.p_ref(aux_ind),[size(nse_field.nodes,1) 1]);
p_0_aux = p_0_aux + accumarray(nse_field.tetra(aux_ind,4),nse_field.p_ref(aux_ind),[size(nse_field.nodes,1) 1]);

p_0_aux_count =  accumarray(nse_field.tetra(aux_ind,1),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,2),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,3),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);
p_0_aux_count =  p_0_aux_count + accumarray(nse_field.tetra(aux_ind,4),ones(length(aux_ind),1),[size(nse_field.nodes,1) 1]);

nse_field.p_0 = p_0_aux./p_0_aux_count; 

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nse_field.nodes, nse_field.tetra, nse_field.c_ind_1);

K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));

M = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, nse_field.f_param(nse_field.c_ind_1));

F_1 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,1,nse_field.rho*ones(size(v_1_tetra,1),1));
F_2 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,2,nse_field.rho*ones(size(v_1_tetra,1),1));
F_3 = zef_surface_scalar_matrix_FFn(v_1_nodes,v_1_tetra,3,nse_field.rho*ones(size(v_1_tetra,1),1));

g_1 = nse_field.g_vec(1)*ones(size(v_1_nodes,1),1);
g_2 = nse_field.g_vec(2)*ones(size(v_1_nodes,1),1);
g_3 = nse_field.g_vec(3)*ones(size(v_1_nodes,1),1);

g = F_1*g_1 + F_2*g_2 + F_3*g_3;

w_1 = zef_surface_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.f_param(nse_field.c_ind_1));

nse_field.p_0 = nse_field.p_0(nse_field.bp_vessel_node_ind);

A = [ -K_1+M -w_1; -w_1' size(v_1_nodes,1) ];
b = [ -nse_field.p_0.*w_1 + g; -nse_field.f_val-sum(nse_field.p_0.*w_1) ];

p = A\b;

if nse_field.use_gpu
DM = 1./diag(A); 
p = pcg_iteration_gpu(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
DM = spdiags(diag(A),0,size(A,1),size(A,1)); 
p = pcg_iteration(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end
    
c = p(end);
p = p(1:end-1);
nse_field.bp_vessels = p - nse_field.p_0 - c;
bp_vessels_aux = zeros(size(nse_field.nodes,1),1);
bp_vessels_aux(nse_field.bp_vessel_node_ind) = nse_field.bp_vessels;

[v_2_nodes, v_2_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nse_field.nodes, nse_field.tetra, nse_field.c_ind_2);

K_2 = zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 1, 1, nse_field.f_param(size(v_2_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 2, 2, nse_field.f_param(size(v_2_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 3, 3, nse_field.f_param(size(v_2_tetra,1),1));

w_2 = zef_surface_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

bf_vessels_to_capillaries = bp_vessels_aux(nse_field.bf_capillary_node_ind);

nse_field.bf_capillaries = K_2\bf_vessels_to_capillaries; 

nse_field.bf_capillaries = (nse_field.f_val./sum(nse_field.bf_capillaries.*w_2))*nse_field.bf_capillaries;

end