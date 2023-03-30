function nse_field = zef_nse_poisson_dynamic(nse_field,nodes,tetra,domain_labels,mvd_length) 

h_waitbar = zef_waitbar(0,'NSE solver: pressure');

if not(isfield(nse_field,'nse_type'))
nse_field.nse_type = 1;
end

n_frames = nse_field.n_frames;

time_vec = [0:nse_field.time_step_length:nse_field.time_length]';

time_frame_ind = [1:ceil(length(time_vec)/n_frames):length(time_vec)];

nse_field.inv_time_1 = time_vec(time_frame_ind(1));
nse_field.inv_time_3 = time_vec(time_frame_ind(2)) - time_vec(time_frame_ind(1));

y = zef_nse_signal_pulse(time_vec,nse_field);
source_radius = nse_field.sphere_radius;

c_ind_1_domain = find(ismember(domain_labels,nse_field.artery_domain_ind));
%c_ind_2_domain = find(ismember(domain_labels,nse_field.capillary_domain_ind));

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

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;
[~, det] = zef_volume_barycentric(v_1_nodes,v_1_tetra);
volume = abs(det)/6;
volume_arteries = sum(volume(:));

b_node_ind = zef_surface_mesh(v_1_tetra); 
b_node_ind = unique(b_node_ind);
i_node_ind = [1:size(v_1_nodes,1)]';
i_node_ind = setdiff(i_node_ind,b_node_ind);

source_node_ind = find(sqrt(sum((v_1_nodes(b_node_ind,:) - mm_conversion*ones(length(b_node_ind),1)*[nse_field.sphere_x nse_field.sphere_y nse_field.sphere_z]).^2,2)) <= mm_conversion*source_radius);
source_vec = zeros(size(v_1_nodes,1),1);
source_vec(b_node_ind(source_node_ind)) = 1;

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
param_aux_integral_mean = param_aux_integral_mean/area_arteries;

gravity_amplitude = nse_field.gravity_amplitude;
gravity_x = nse_field.gravity_x;
gravity_y = nse_field.gravity_y;
gravity_z = nse_field.gravity_z;

gravity_x = gravity_amplitude*gravity_x/sqrt(gravity_x.^2 + gravity_y.^2 + gravity_z.^2);
gravity_y = gravity_amplitude*gravity_y/sqrt(gravity_x.^2 + gravity_y.^2 + gravity_z.^2);
gravity_z = gravity_amplitude*gravity_z/sqrt(gravity_x.^2 + gravity_y.^2 + gravity_z.^2);

gravity_vec = gravity_x.*v_1_nodes(:,1) + gravity_y.*v_1_nodes(:,2) + gravity_z.*v_1_nodes(:,3);
gravity_vec = gravity_vec - min(gravity_vec);
p_hydrostatic = nse_field.rho*gravity_vec;

nu_0 = ((1+nse_field.artery_diameter_change.^2).*area_arteries*pi*(nse_field.arteriole_diameter.^2/4)*nse_field.pressure.*hgmm_conversion)./(8*pi*nse_field.mu.*nse_field.artery_diameter_change.^2*volume_arteries);
mu_vec = nse_field.mu.*ones(size(v_1_nodes,1),1); 

K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));
M_1 = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, param_aux.^2./(nse_field.time_step_length.^2.*nu_0.^2.*param_aux_integral_mean.^2));
D_1 = spdiags(sqrt(mu_vec),0,size(M_1,1),size(M_1,2));

S = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, ones(size(v_1_tetra,1),1));
S = spdiags(1./full(sum(S,2)),0,size(v_1_nodes,1),size(v_1_nodes,1))*S;

KDMD = @(x) zef_KDMD(x,K_1,M_1,D_1,nse_field.use_gpu); 

zef_waitbar(0.33,h_waitbar,'NSE solver: velocity');

nse_field.bv_vessels_1 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_2 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_3 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_b = zeros(size(nse_field.bp_vessels));

Q_1 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 1, ones(size(v_1_tetra,1),1));
Q_2 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 2, ones(size(v_1_tetra,1),1));
Q_3 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 3, ones(size(v_1_tetra,1),1));

v_vec = zef_volume_scalar_vector(v_1_nodes, v_1_tetra, ones(size(v_1_tetra,1),1),1);
c_vec = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra);

n_1 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 1, ones(size(tetra,1),1));
n_2 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 2, ones(size(tetra,1),1));
n_3 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 3, ones(size(tetra,1),1));

n_norm = sqrt(n_1.^2 + n_2.^2 + n_3.^2);

n_i_nodes = length(i_node_ind); 
n_b_nodes = length(b_node_ind);
i_nodes_aux = 1:n_i_nodes;

n_1 = n_1./n_norm;
n_2 = n_2./n_norm;
n_3 = n_3./n_norm;

[~, ~, ~, b_coord, b_volume] = zef_volume_scalar_matrix_uFG(v_1_nodes, v_1_tetra, 1, zeros(length(i_node_ind),1), zeros(length(i_node_ind),1), zeros(length(i_node_ind),1), zeros(length(i_node_ind),1), nse_field.rho, i_node_ind);

C_aux = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, nse_field.rho*ones(size(v_1_tetra,1),1));
C_aux = C_aux(i_node_ind,i_node_ind);

C = sparse(3*n_i_nodes,3*n_i_nodes,0);

C(i_nodes_aux,i_nodes_aux) = C_aux;
C(n_i_nodes + [i_nodes_aux],n_i_nodes + [i_nodes_aux]) = C_aux;
C(2*n_i_nodes + [i_nodes_aux],2*n_i_nodes + [i_nodes_aux]) = C_aux;

L = sparse(3*n_i_nodes,3*n_i_nodes,0);

L_11 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,1,nse_field.mu);
L_22 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,2,nse_field.mu);
L_33 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,3,3,nse_field.mu);
L_12 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,2,nse_field.mu);
L_13 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,3,nse_field.mu);
L_23 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,3,nse_field.mu);

L_11 = L_11(i_node_ind, i_node_ind);
L_22 = L_22(i_node_ind, i_node_ind);
L_33 = L_33(i_node_ind, i_node_ind);
L_12 = L_12(i_node_ind, i_node_ind);
L_13 = L_13(i_node_ind, i_node_ind);
L_23 = L_23(i_node_ind, i_node_ind);

L([i_nodes_aux], [i_nodes_aux]) = 2*L_11 + L_22 + L_33;
L(n_i_nodes+[i_nodes_aux], n_i_nodes+[i_nodes_aux]) = L_11 + 2*L_22 + L_33;
L(2*n_i_nodes+[i_nodes_aux], 2*n_i_nodes+[i_nodes_aux]) = L_11 + L_22 + 2*L_33;

L([i_nodes_aux], n_i_nodes+[i_nodes_aux]) = L_12;
L(n_i_nodes+[i_nodes_aux],[i_nodes_aux]) = L_12';

L([i_nodes_aux], 2*n_i_nodes+[i_nodes_aux]) = L_13;
L(2*n_i_nodes+[i_nodes_aux],[i_nodes_aux]) = L_13';

L(n_i_nodes + [i_nodes_aux], 2*n_i_nodes+[i_nodes_aux]) = L_23;
L(2*n_i_nodes+[i_nodes_aux], n_i_nodes + [i_nodes_aux]) = L_23';

p = zeros(size(K_1,1),1);

nse_field.bp_vessels = cell(0);
nse_field.bv_vessels_1 = cell(0);
nse_field.bv_vessels_2 = cell(0);
nse_field.bv_vessels_3 = cell(0);
nse_field.mu_vessels = cell(0);

h_waitbar = zef_waitbar(0,'NSE solver: compute');

p_1 = p;
p_2 = p;
y_1 = 0;
y_2 = 0;
u = zeros(size(L,1),1);
i_aux = 0;

for i = 1 : length(time_vec)
    
zef_waitbar(i/length(time_vec),h_waitbar,'NSE solver: compute');

for quadrature_step_ind = 1 : 2

mu_aux = mu_vec(i_node_ind);

if i == 1
    b = D_1 * (M_1 * (D_1 * (p_1  + source_vec * (y(i) - 2*y_1))));
else
    b = D_1 * (M_1 * (D_1 * (2*p_1 - p_2  + source_vec * (y(i) - 2*y_1 + y_2))));
end

u_aux_1 = (L([i_nodes_aux],:)*u);
u_aux_2 = (L(n_i_nodes+[i_nodes_aux],:)*u);
u_aux_3 = (L(2*n_i_nodes+[i_nodes_aux],:)*u);

b(i_node_ind) = b(i_node_ind) - mu_aux.*(Q_1(i_node_ind,i_node_ind)'*u_aux_1) - u_aux_1.*(Q_1(i_node_ind,i_node_ind)'*mu_vec(i_node_ind)) - mu_aux.*(Q_2(i_node_ind,i_node_ind)'*u_aux_2) - u_aux_2.*(Q_2(i_node_ind,i_node_ind)'*mu_vec(i_node_ind)) - mu_aux.*(Q_3(i_node_ind,i_node_ind)'*u_aux_3) - u_aux_3.*(Q_3(i_node_ind,i_node_ind)'*mu_aux);

if nse_field.nse_type == 2
        
q_1_u_1 = (Q_1(i_node_ind,i_node_ind)*u([i_nodes_aux]))./v_vec(i_node_ind); 
q_1_u_2 = (Q_1(i_node_ind,i_node_ind)*u(n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);
q_1_u_3 = (Q_1(i_node_ind,i_node_ind)*u(2*n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);

q_2_u_1 = (Q_2(i_node_ind,i_node_ind)*u([i_nodes_aux]))./v_vec(i_node_ind); 
q_2_u_2 = (Q_2(i_node_ind,i_node_ind)*u(n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);
q_2_u_3 = (Q_2(i_node_ind,i_node_ind)*u(2*n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);

q_3_u_1 = (Q_3(i_node_ind,i_node_ind)*u([i_nodes_aux]))./v_vec(i_node_ind); 
q_3_u_2 = (Q_3(i_node_ind,i_node_ind)*u(n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);
q_3_u_3 = (Q_3(i_node_ind,i_node_ind)*u(2*n_i_nodes + [i_nodes_aux]))./v_vec(i_node_ind);

tr_vec = q_1_u_1.*q_1_u_1 + q_2_u_1.*q_1_u_2 + q_3_u_1.*q_1_u_3 + ... 
q_1_u_2.*q_2_u_1 + q_2_u_2.*q_2_u_2 + q_3_u_2.*q_2_u_3 + ...
q_1_u_3.*q_3_u_1 + q_2_u_3.*q_3_u_2 + q_3_u_3.*q_3_u_3 ;

tr_vec = tr_vec.*c_vec(i_node_ind);

b(i_node_ind) = b(i_node_ind) - tr_vec;

end

if nse_field.use_gpu
DM = 1./(diag(K_1) + diag(D_1).*diag(M_1).*diag(D_1)); 
p = pcg_iteration_gpu(KDMD,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
DM = spdiags(diag(K_1) + diag(D_1).*diag(M_1).*diag(D_1),0,size(K_1,1),size(K_1,1)); 
p = pcg_iteration(KDMD,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end

p_2 = p_1;
p_1 = p; 

y_2 = y_1;
y_1 = y(i);

n_p = zeros(3*n_i_nodes,1);

n_p([i_nodes_aux]) = Q_1(i_node_ind,:)*p;
n_p(n_i_nodes + [i_nodes_aux]) = Q_2(i_node_ind,:)*p;
n_p(2*n_i_nodes + [i_nodes_aux]) = Q_3(i_node_ind,:)*p;

if nse_field.nse_type == 2

u_gu_vec_1 = q_1_u_1.*u([i_nodes_aux]) + q_2_u_1.*u(n_i_nodes + [i_nodes_aux]) + q_3_u_1.*u(2*n_i_nodes + [i_nodes_aux]) ;
u_gu_vec_2 = q_1_u_2.*u([i_nodes_aux]) + q_2_u_2.*u(n_i_nodes + [i_nodes_aux]) + q_3_u_2.*u(2*n_i_nodes + [i_nodes_aux]) ;
u_gu_vec_3 = q_1_u_3.*u([i_nodes_aux]) + q_2_u_3.*u(n_i_nodes + [i_nodes_aux]) + q_3_u_3.*u(2*n_i_nodes + [i_nodes_aux]);
    
n_p([i_nodes_aux]) = n_p([i_nodes_aux]) - u_gu_vec_1.*c_vec(i_node_ind);
n_p(n_i_nodes + [i_nodes_aux]) = n_p(n_i_nodes + [i_nodes_aux]) - u_gu_vec_2.*c_vec(i_node_ind);
n_p(2*n_i_nodes + [i_nodes_aux]) = n_p(2*n_i_nodes + [i_nodes_aux]) - u_gu_vec_3.*c_vec(i_node_ind);

end

n_p([i_nodes_aux]) = n_p([i_nodes_aux]) - mu_aux.*u_aux_1;
n_p(n_i_nodes + [i_nodes_aux]) = n_p(n_i_nodes + [i_nodes_aux])  - mu_aux.*u_aux_2;
n_p(2*n_i_nodes + [i_nodes_aux]) = n_p(2*n_i_nodes + [i_nodes_aux]) - mu_aux.*u_aux_3;

if nse_field.use_gpu
DM = 1./diag(C); 
aux_vec = pcg_iteration_gpu(C, n_p, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
else
DM = spdiags(diag(C), 0, size(C,1), size(C,1)); 
aux_vec = pcg_iteration(C, n_p, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
end

if quadrature_step_ind == 1
slope_field_stage_1 = aux_vec;
u_stage_1 = u;
u = u + nse_field.time_step_length.*slope_field_stage_1; 
elseif quadrature_step_ind == 2
slope_field_stage_2 = aux_vec;
u = u_stage_1 + nse_field.time_step_length.*0.5.*(slope_field_stage_1 + slope_field_stage_2);   
end

end

if nse_field.viscosity_model == 2
   
trace_strain_rate = abs(Q_1(:,i_node_ind)*u([i_nodes_aux]))./v_vec + abs(Q_2(:,i_node_ind)*u(n_i_nodes+[i_nodes_aux]))./v_vec + abs(Q_3(:,i_node_ind)*u(2*n_i_nodes+[i_nodes_aux]))./v_vec; 
mu_vec = nse_field.mu*trace_strain_rate.^(nse_field.viscosity_exponent-1);
%mu_vec(i_node_ind) = mu_vec_aux(i_node_ind);
%mu_vec(b_node_ind) = nse_field.mu;

for ell = 1 : nse_field.viscosity_n_smoothing
    mu_vec = S*mu_vec;
end

D_1 = spdiags(sqrt(mu_vec),0,size(M_1,1),size(M_1,2));
KDMD = @(x) zef_KDMD(x,K_1,M_1,D_1,nse_field.use_gpu);

elseif nse_field.viscosity_model == 3

trace_strain_rate = abs(Q_1(:,i_node_ind)*u([i_nodes_aux]))./v_vec + abs(Q_2(:,i_node_ind)*u(n_i_nodes+[i_nodes_aux]))./v_vec + abs(Q_3(:,i_node_ind)*u(2*n_i_nodes+[i_nodes_aux]))./v_vec; 
mu_vec = nse_field.mu + nse_field.viscosity_delta.*(1 + (nse_field.viscosity_relaxation_time*trace_strain_rate).^nse_field.viscosity_transition).^((nse_field.viscosity_exponent-1)./nse_field.viscosity_transition);
%mu_vec(i_node_ind) = mu_vec_aux(i_node_ind);
%mu_vec(b_node_ind) = nse_field.mu;

for ell = 1 : nse_field.viscosity_n_smoothing
    mu_vec = S*mu_vec;
end

D_1 = spdiags(sqrt(mu_vec),0,size(M_1,1),size(M_1,2));
KDMD = @(x) zef_KDMD(x,K_1,M_1,D_1,nse_field.use_gpu);
 
end

if ismember(i,time_frame_ind)
    
i_aux = i_aux + 1;    
    
nse_field.bp_vessels{i_aux} = zeros(size(K_1,1),1);
nse_field.mu_vessels{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_1{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_2{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_3{i_aux} = zeros(size(K_1,1),1);

nse_field.bv_vessels_1{i_aux}(i_node_ind) = u([i_nodes_aux]);
nse_field.bv_vessels_2{i_aux}(i_node_ind) = u(n_i_nodes+[i_nodes_aux]);
nse_field.bv_vessels_3{i_aux}(i_node_ind) = u(2*n_i_nodes+[i_nodes_aux]);

nse_field.bp_vessels{i_aux} = p/hgmm_conversion + 2*p_hydrostatic/hgmm_conversion + nse_field.pressure;
nse_field.mu_vessels{i_aux} = mu_vec;

end
end

close(h_waitbar)

end