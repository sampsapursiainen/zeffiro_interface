function nse_field = zef_nse_poisson_dynamic(nse_field,nodes,tetra,domain_labels,mvd_length) 

h_waitbar = zef_waitbar(0,'NSE solver: pressure');

if not(isfield(nse_field,'nse_type'))
nse_field.nse_type = 1;
end

if nse_field.time_integration == 1
    n_q_steps = 1; 
elseif nse_field.time_integration == 2
    n_q_steps = 2;
elseif nse_field.time_integration == 3
    n_q_steps = 4;
end

n_frames = nse_field.n_frames;
time_vec = [0:nse_field.time_step_length:nse_field.time_length]';
n_time = length(time_vec);
start_ind = find(time_vec>nse_field.start_time,1,'first');
time_frame_ind = [start_ind:ceil((n_time-start_ind)/n_frames):n_time];
nse_field.inv_time_1 = time_vec(time_frame_ind(1));
nse_field.inv_time_3 = time_vec(time_frame_ind(2)) - time_vec(time_frame_ind(1));
y = zef_nse_signal_pulse(time_vec,nse_field);
source_radius = nse_field.sphere_radius;
c_ind_1_domain = find(ismember(domain_labels,nse_field.artery_domain_ind));
if nse_field.microcirculation_model
c_ind_2_domain = find(ismember(domain_labels,nse_field.capillary_domain_ind));
end

delta_t = nse_field.time_step_length/2;
hgmm_conversion = 101325/760;
mm_conversion = 0.001;
mvd_length = 1E6.*mvd_length(:,1);
ml_min_conversion = 1e-6/60;
pressure_reference = nse_field.pressure*hgmm_conversion;
capillary_fraction = nse_field.capillary_arteriole_total_area_ratio;
arteriole_fraction = (1-nse_field.capillary_arteriole_total_area_ratio)/2;
venule_fraction = (1-nse_field.capillary_arteriole_total_area_ratio)/2;
arteriole_scale = 1./( arteriole_fraction*nse_field.arteriole_diameter.^2./(arteriole_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.arteriole_diameter.^2./(arteriole_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.arteriole_diameter.^2./(arteriole_fraction.*nse_field.venule_diameter.^2));
capillary_scale = 1./( arteriole_fraction*nse_field.capillary_diameter.^2./(capillary_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.capillary_diameter.^2./(capillary_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.capillary_diameter.^2./(capillary_fraction.*nse_field.venule_diameter.^2));
venule_scale = 1./( arteriole_fraction*nse_field.venule_diameter.^2./(venule_fraction*nse_field.arteriole_diameter.^2) + capillary_fraction*nse_field.venule_diameter.^2./(venule_fraction*nse_field.capillary_diameter.^2) + venule_fraction.*nse_field.venule_diameter.^2./(venule_fraction.*nse_field.venule_diameter.^2));

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;
[~, det] = zef_volume_barycentric(v_1_nodes,v_1_tetra);
volume = abs(det)/6;
volume_arteries = sum(volume(:));

n_nodes = size(v_1_nodes,1);
b_node_ind = zef_surface_mesh(v_1_tetra); 
b_node_ind = unique(b_node_ind);
i_node_ind = [1:n_nodes]';
i_node_ind = setdiff(i_node_ind,b_node_ind);

source_node_ind = [];
for i  = 1 : length(nse_field.sphere_radius)
source_node_ind_aux = find(sqrt(sum((v_1_nodes(b_node_ind,:) - mm_conversion*ones(length(b_node_ind),1)*[nse_field.sphere_x(i) nse_field.sphere_y(i) nse_field.sphere_z(i)]).^2,2)) <= mm_conversion*source_radius(i));
source_node_ind = [source_node_ind ; source_node_ind_aux];
end
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
w_1 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, ones(size(v_1_tetra,1),1));
w_1 = w_1(i_node_ind);

zef_waitbar(0.33,h_waitbar,'NSE solver: velocity');

Q_1 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 1, ones(size(v_1_tetra,1),1));
Q_2 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 2, ones(size(v_1_tetra,1),1));
Q_3 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 3, ones(size(v_1_tetra,1),1));

c_vec = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra);

Q_1_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_1;
Q_2_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_2;
Q_3_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_3;

Q_1_v2 = Q_1_v1(:,i_node_ind);
Q_2_v2 = Q_2_v1(:,i_node_ind);
Q_3_v2 = Q_3_v1(:,i_node_ind);

Q_1_v1 = Q_1_v1(i_node_ind,i_node_ind);
Q_2_v1 = Q_2_v1(i_node_ind,i_node_ind);
Q_3_v1 = Q_3_v1(i_node_ind,i_node_ind);

Q_1 = Q_1(i_node_ind,:);
Q_2 = Q_2(i_node_ind,:);
Q_3 = Q_3(i_node_ind,:);

I_mu = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, ones(size(v_1_tetra,1),1));
I_u = I_mu(i_node_ind,i_node_ind);
S_mu = I_mu + nse_field.viscosity_smoothing.^2*K_1;
S_u = I_u + nse_field.velocity_smoothing.^2*K_1(i_node_ind,i_node_ind);

% F = zef_surface_scalar_matrix_FGn(v_1_nodes,v_1_tetra,1,1,ones(size(v_1_tetra,1),1));
% F = F + zef_surface_scalar_matrix_FGn(v_1_nodes,v_1_tetra,2,2,ones(size(v_1_tetra,1),1));
% F = F + zef_surface_scalar_matrix_FGn(v_1_nodes,v_1_tetra,3,3,ones(size(v_1_tetra,1),1));
% F = F(i_node_ind, i_node_ind);

C = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, nse_field.rho*ones(size(v_1_tetra,1),1));
C = C(i_node_ind,i_node_ind);

L = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,1,ones(size(v_1_tetra,1),1));
L = L + zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,2,ones(size(v_1_tetra,1),1));
L = L + zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,3,3,ones(size(v_1_tetra,1),1));
L = L(i_node_ind, i_node_ind);

% L_11 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,1,ones(size(v_1_tetra,1),1));
% L_22 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,2,ones(size(v_1_tetra,1),1));
% L_33 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,3,3,ones(size(v_1_tetra,1),1));
% L_12 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,2,ones(size(v_1_tetra,1),1));
% L_13 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,3,ones(size(v_1_tetra,1),1));
% L_23 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,3,ones(size(v_1_tetra,1),1));

% L_11 = L_11(i_node_ind, i_node_ind);
% L_22 = L_22(i_node_ind, i_node_ind);
% L_33 = L_33(i_node_ind, i_node_ind);
% L_12 = L_12(i_node_ind, i_node_ind);
% L_13 = L_13(i_node_ind, i_node_ind);
% L_23 = L_23(i_node_ind, i_node_ind);

c_vec = c_vec(i_node_ind);

p = zeros(size(K_1,1),1);

nse_field.bp_vessels = cell(0);
nse_field.bv_vessels_1 = cell(0);
nse_field.bv_vessels_2 = cell(0);
nse_field.bv_vessels_3 = cell(0);
nse_field.mu_vessels = cell(0);
nse_field.bf_capillaries = cell(0);

if nse_field.microcirculation_model
     
beta = 8*pi*nse_field.mu*ml_min_conversion*nse_field.total_flow/((pi*(nse_field.arteriole_diameter/2)).^2*nse_field.pressure*hgmm_conversion*area_arteries*param_aux_integral_mean);
arteriole_length = nse_field.pressure_decay_in_arterioles*pi*(nse_field.arteriole_diameter/2).^2*arteriole_scale/beta;

[v_2_nodes, v_2_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, c_ind_2_domain);
v_2_nodes = mm_conversion*v_2_nodes;
[~, det] = zef_volume_barycentric(v_2_nodes,v_2_tetra);
volume = abs(det)/6;
volume_sum = sum(volume(:));
mvd_volume_mean = sum(mvd_length(c_ind_2_domain).*volume(:))./volume_sum;
diffusion_coefficient = hgmm_conversion.*nse_field.pressure*((pi/4).*nse_field.arteriole_diameter.^2)/(8*pi*nse_field.mu);
bp_vessels_aux = zeros(size(nodes,1),1);

K_2 = zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 1, 1, mvd_length(c_ind_2_domain)) + ... 
     zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 2, 2, mvd_length(c_ind_2_domain)) + ... 
     zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 3, 3, mvd_length(c_ind_2_domain));

C_2 = zef_volume_scalar_matrix_FF(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));
M_2 = zef_volume_scalar_matrix_FF(v_2_nodes, v_2_tetra, mvd_length(c_ind_2_domain)); 
eps_var = ((4*pi).^(1/3).*3.^(2/3).*diffusion_coefficient.*nse_field.pressure_decay_in_arterioles./(mvd_volume_mean.*arteriole_length.*max(volume).^(1/3)));
K_2 = (diffusion_coefficient/mvd_volume_mean)*K_2 + eps_var*M_2;
K_2 = delta_t*K_2 + C_2;
w_2 = zef_surface_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

end

h_waitbar = zef_waitbar(0,'NSE solver: compute' );

u_1 = zeros(length(i_node_ind),1);
u_2 = zeros(length(i_node_ind),1);
u_3 = zeros(length(i_node_ind),1);
if nse_field.microcirculation_model
mc_vec = zeros(size(v_2_nodes,1),1);
end
p_1 = p;
p_2 = p;
y_1 = 0;
y_2 = 0;
i_aux = 0;

if nse_field.use_gpu
   
    p = gpuArray(p);  
    u_1 = gpuArray(u_1);
    u_2 = gpuArray(u_2);
    u_3 = gpuArray(u_3);
    u_1 = gpuArray(u_1);
    if nse_field.microcirculation_model
    mc_vec = gpuArray(mc_vec);
    bp_vessels_aux = gpuArray(bp_vessels_aux); 
    K_2 = gpuArray(K_2);
    C_2 = gpuArray(C_2);
    w_1 = gpuArray(w_1);
    w_2 = gpuArray(w_2);
    end
    S_u = gpuArray(S_u);
    S_mu = gpuArray(S_mu);
    I_mu = gpuArray(I_mu); 
    I_u = gpuArray(I_u);
    D_1 = gpuArray(D_1);
    M_1 = gpuArray(M_1);
    K_1 = gpuArray(K_1);
    Q_1 = gpuArray(Q_1);
    Q_2 = gpuArray(Q_2);
    Q_3 = gpuArray(Q_3);
    Q_1_v1 = gpuArray(Q_1_v1);
    Q_2_v1 = gpuArray(Q_2_v1);
    Q_3_v1 = gpuArray(Q_3_v1);
    Q_1_v2 = gpuArray(Q_1_v2);
    Q_2_v2 = gpuArray(Q_2_v2);
    Q_3_v2 = gpuArray(Q_3_v2);
    L = gpuArray(L);
    C = gpuArray(C);
    %L_11 = gpuArray(L_11);
    %L_22 = gpuArray(L_22);
    %L_33 = gpuArray(L_33);
    %L_12 = gpuArray(L_12);
    %L_13 = gpuArray(L_13);
    %L_23 = gpuArray(L_23);
    y = gpuArray(y);
    c_vec = gpuArray(c_vec);
    source_vec = gpuArray(source_vec);
    y_1 = gpuArray(y_1);
    y_2 = gpuArray(y_2);
    i_aux = gpuArray(i_aux);
    i_node_ind = gpuArray(i_node_ind);
    mu_vec = gpuArray(mu_vec);
    delta_t = gpuArray(delta_t);
    pressure_reference = gpuArray(pressure_reference);
     
end

if nse_field.use_gpu
DM_C = gpuArray(1./full(diag(C))); 
DM_S_u = gpuArray(1./(full(diag(S_u))));
DM_S_mu = gpuArray(1./(full(diag(S_mu))));
if nse_field.microcirculation_model
DM_K_2 = gpuArray(1./(full(diag(K_2))));
end
else
DM_C = spdiags(diag(C), 0, size(C,1), size(C,1));
DM_S_u = spdiags(diag(S_u), 0, size(S_u,1), size(S_u,1));
DM_S_mu = spdiags(diag(S_mu), 0, size(S_mu,1), size(S_mu,1));
if nse_field.microcirculation_model
DM_K_2 = spdiags(diag(K_2), 0, size(K_2,1), size(K_2,1));
end
end

KDMD = @(x) zef_KDMD(x,K_1,M_1,D_1,nse_field.use_gpu);

for i = 1 : n_time

zef_waitbar(i/n_time,h_waitbar,['NSE solver: compute, total flow (ml/min): ' sprintf('%0.3g',sum(sqrt(u_1.^2 + u_2.^2 + u_3.^2).*w_1)/(3*ml_min_conversion)) ', maximum pressure (Hgmm): ' sprintf('%0.3g',max(p + pressure_reference + p_hydrostatic)/hgmm_conversion)]);
 
y_0 = y(i);

for quadrature_step_ind = 1 : n_q_steps

if nse_field.nse_type == 2

    if nse_field.velocity_smoothing > 0
if nse_field.use_gpu  
v_1 = pcg_iteration_gpu(S_u,I_u*u_1,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
v_2 = pcg_iteration_gpu(S_u,I_u*u_2,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
v_3 = pcg_iteration_gpu(S_u,I_u*u_3,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
else 
v_1 = pcg_iteration(S_u,I_u*u_1,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
v_2 = pcg_iteration(S_u,I_u*u_2,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
v_3 = pcg_iteration(S_u,I_u*u_3,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_u);
end
    end

end
        
q_1_u_1 = Q_1_v1*u_1; 
q_1_u_2 = Q_1_v1*u_2;
q_1_u_3 = Q_1_v1*u_3;

q_2_u_1 = Q_2_v1*u_1; 
q_2_u_2 = Q_2_v1*u_2;
q_2_u_3 = Q_2_v1*u_3;

q_3_u_1 = Q_3_v1*u_1;
q_3_u_2 = Q_3_v1*u_2;
q_3_u_3 = Q_3_v1*u_3;


if quadrature_step_ind == 1
if i == 1
    b = D_1 * (M_1 * (D_1 * (p_1  + source_vec * (y_0 - 2*y_1))));
else
    b = D_1 * (M_1 * (D_1 * (2*p_1 - p_2  + source_vec * (y_0 - 2*y_1 + y_2))));
end

g_mu_1 = Q_1_v1*mu_vec(i_node_ind);
g_mu_2 = Q_2_v1*mu_vec(i_node_ind);
g_mu_3 = Q_3_v1*mu_vec(i_node_ind);

% g_u_g_mu_1 = q_1_u_1.*g_mu_1 + q_2_u_1.*g_mu_2 + q_3_u_1.*g_mu_3; 
% g_u_g_mu_2 = q_1_u_2.*g_mu_1 + q_2_u_2.*g_mu_2 + q_3_u_2.*g_mu_3; 
% g_u_g_mu_3 = q_1_u_3.*g_mu_1 + q_2_u_3.*g_mu_2 + q_3_u_3.*g_mu_3;

g_u_T_g_mu_1 = q_1_u_1.*g_mu_1 + q_1_u_2.*g_mu_2 + q_1_u_3.*g_mu_3; 
g_u_T_g_mu_2 = q_2_u_1.*g_mu_1 + q_2_u_2.*g_mu_2 + q_2_u_3.*g_mu_3; 
g_u_T_g_mu_3 = q_3_u_1.*g_mu_1 + q_3_u_2.*g_mu_2 + q_3_u_3.*g_mu_3;

friction_vec = 2*Q_1'*g_u_T_g_mu_1 + 2*Q_2'*g_u_T_g_mu_2 + 2*Q_3'*g_u_T_g_mu_3;

b(i_node_ind) = b(i_node_ind) + friction_vec(i_node_ind);

end

if nse_field.nse_type == 2
    
u_gu_vec_1 = q_1_u_1.*v_1 + q_2_u_1.*v_2 + q_3_u_1.*v_3;
u_gu_vec_2 = q_1_u_2.*v_1 + q_2_u_2.*v_2 + q_3_u_2.*v_3;
u_gu_vec_3 = q_1_u_3.*v_1 + q_2_u_3.*v_2 + q_3_u_3.*v_3;

if quadrature_step_ind == 1
    
tr_vec = Q_1'*u_gu_vec_1 + Q_2'*u_gu_vec_2 + Q_3'*u_gu_vec_3;

b(i_node_ind) = b(i_node_ind) - nse_field.rho.*tr_vec(i_node_ind);

end

end

if quadrature_step_ind == 1
if nse_field.use_gpu
b = gpuArray(b);  
DM_K = gpuArray(1./(full(diag(K_1)) + full(diag(D_1)).*full(diag(M_1)).*full(diag(D_1)))); 
p = pcg_iteration_gpu(KDMD,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM_K);
else
DM_K = spdiags(diag(K_1) + diag(D_1).*diag(M_1).*diag(D_1),0,size(K_1,1),size(K_1,1)); 
p = pcg_iteration(KDMD,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM_K);
end

p_2 = p_1;
p_1 = p; 
y_2 = y_1;
y_1 = y_0;

end

if quadrature_step_ind == 1
n_p_1_0 = - Q_1*p;
n_p_2_0 = - Q_2*p;
n_p_3_0 = - Q_3*p;
end

n_p_1 = n_p_1_0;
n_p_2 = n_p_2_0;
n_p_3 = n_p_3_0;

if nse_field.nse_type == 2
    
n_p_1 = n_p_1 - nse_field.rho.*(u_gu_vec_1.*c_vec);
n_p_2 = n_p_2 - nse_field.rho.*(u_gu_vec_2.*c_vec);
n_p_3 = n_p_3 - nse_field.rho.*(u_gu_vec_3.*c_vec);

end

%n_p_1 = n_p_1 - mu_vec(i_node_ind).*(2*L_11*u_1 + L_22*u_1 + L_33*u_1 + L_12*u_2 + L_13*u_3);
%n_p_2 = n_p_2 - mu_vec(i_node_ind).*(L_12*u_1 + L_11*u_2 + 2*L_22*u_2 + L_33*u_2 + L_23*u_3);
%n_p_3 = n_p_3 - mu_vec(i_node_ind).*(L_13*u_1 + L_23*u_2 + L_11*u_3 + L_22*u_3 + 2*L_33*u_3);

sqrt_mu = sqrt(mu_vec(i_node_ind));
n_p_1 = n_p_1 - sqrt_mu.*(L*(sqrt_mu.*u_1));% + g_u_g_mu_1.*c_vec + g_u_T_g_mu_1.*c_vec;
n_p_2 = n_p_2 - sqrt_mu.*(L*(sqrt_mu.*u_2));% + g_u_g_mu_2.*c_vec + g_u_T_g_mu_2.*c_vec;
n_p_3 = n_p_3 - sqrt_mu.*(L*(sqrt_mu.*u_3));% + g_u_g_mu_3.*c_vec + g_u_T_g_mu_3.*c_vec;

if nse_field.use_gpu
n_p_1 = gpuArray(n_p_1);
n_p_2 = gpuArray(n_p_2);
n_p_3 = gpuArray(n_p_3);
aux_vec_1 = pcg_iteration_gpu(C, n_p_1, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
aux_vec_2 = pcg_iteration_gpu(C, n_p_2, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
aux_vec_3 = pcg_iteration_gpu(C, n_p_3, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
else
aux_vec_1 = pcg_iteration(C, n_p_1, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
aux_vec_2 = pcg_iteration(C, n_p_2, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
aux_vec_3 = pcg_iteration(C, n_p_3, nse_field.pcg_tol, nse_field.pcg_maxit, DM_C);
end

if quadrature_step_ind == 1
if nse_field.microcirculation_model
    
bp_vessels_aux(nse_field.bp_vessel_node_ind) =  p + pressure_reference;
bf_vessels_to_capillaries = bp_vessels_aux(nse_field.bf_capillary_node_ind);
I_boundary = find(bf_vessels_to_capillaries);
total_flow_estimate= sum(sqrt(u_1.^2 + u_2.^2 + u_3.^2).*w_1)/3;
r = total_flow_estimate*bf_vessels_to_capillaries./sum(pressure_reference.*w_2(I_boundary));

if nse_field.use_gpu
mc_vec = pcg_iteration_gpu(K_2, C_2*mc_vec + delta_t*r, nse_field.pcg_tol, nse_field.pcg_maxit, DM_K_2);
else
mc_vec = pcg_iteration(K_2, C_2*mc_vec + delta_t*r, nse_field.pcg_tol, nse_field.pcg_maxit, DM_K_2);
end


end
end

if quadrature_step_ind == 1
if ismember(nse_field.time_integration,[1])
u_1 = u_1 + delta_t.*aux_vec_1; 
u_2 = u_2 + delta_t.*aux_vec_2; 
u_3 = u_3 + delta_t.*aux_vec_3; 
elseif ismember(nse_field.time_integration,[2]) 
u_stage_1_1 = u_1;
u_stage_1_2 = u_2;
u_stage_1_3 = u_3;
slope_field_stage_1_1 = aux_vec_1;
slope_field_stage_1_2 = aux_vec_2;
slope_field_stage_1_3 = aux_vec_3;
u_1 = u_1 + delta_t.*slope_field_stage_1_1; 
u_2 = u_2 + delta_t.*slope_field_stage_1_2; 
u_3 = u_3 + delta_t.*slope_field_stage_1_3; 
elseif ismember(nse_field.time_integration,[3])
u_stage_1_1 = u_1; 
u_stage_1_2 = u_2; 
u_stage_1_3 = u_3; 
slope_field_stage_1_1 = aux_vec_1;
slope_field_stage_1_2 = aux_vec_2;
slope_field_stage_1_3 = aux_vec_3;
u_1 = u_1 + 0.5*delta_t.*slope_field_stage_1_1; 
u_2 = u_2 + 0.5*delta_t.*slope_field_stage_1_2; 
u_3 = u_3 + 0.5*delta_t.*slope_field_stage_1_3; 
end
elseif quadrature_step_ind == 2
if ismember(nse_field.time_integration,[2])
slope_field_stage_2_1 = aux_vec_1;
slope_field_stage_2_2 = aux_vec_2;
slope_field_stage_2_3 = aux_vec_3;
u_1 = u_stage_1_1 + 0.5*delta_t.*(slope_field_stage_1_1 + slope_field_stage_2_1);   
u_2 = u_stage_1_2 + 0.5*delta_t.*(slope_field_stage_1_2 + slope_field_stage_2_2);   
u_3 = u_stage_1_3 + 0.5*delta_t.*(slope_field_stage_1_3 + slope_field_stage_2_3);
elseif ismember(nse_field.time_integration,[3])
slope_field_stage_2_1 = aux_vec_1;
slope_field_stage_2_2 = aux_vec_2;
slope_field_stage_2_3 = aux_vec_3;
u_1 = u_stage_1_1 + 0.5*delta_t.*slope_field_stage_2_1; 
u_2 = u_stage_1_2 + 0.5*delta_t.*slope_field_stage_2_2; 
u_3 = u_stage_1_3 + 0.5*delta_t.*slope_field_stage_2_3; 
end
elseif quadrature_step_ind == 3
if ismember(nse_field.time_integration,[3])
slope_field_stage_3_1 = aux_vec_1;
slope_field_stage_3_2 = aux_vec_2;
slope_field_stage_3_3 = aux_vec_3;
u_1 = u_stage_1_1 + delta_t.*slope_field_stage_3_1; 
u_2 = u_stage_1_2 + delta_t.*slope_field_stage_3_2; 
u_3 = u_stage_1_3 + delta_t.*slope_field_stage_3_3; 
end
elseif quadrature_step_ind == 4
if ismember(nse_field.time_integration,[3])
slope_field_stage_4_1 = aux_vec_1;
slope_field_stage_4_2 = aux_vec_2;
slope_field_stage_4_3 = aux_vec_3;
u_1 = u_stage_1_1 + (1/6)*delta_t.*(slope_field_stage_1_1 + 2*slope_field_stage_2_1 + 2*slope_field_stage_3_1 + slope_field_stage_4_1); 
u_2 = u_stage_1_2 + (1/6)*delta_t.*(slope_field_stage_1_2 + 2*slope_field_stage_2_2 + 2*slope_field_stage_3_2 + slope_field_stage_4_2); 
u_3 = u_stage_1_3 + (1/6)*delta_t.*(slope_field_stage_1_3 + 2*slope_field_stage_2_3 + 2*slope_field_stage_3_3 + slope_field_stage_4_3); 
end
end
end

if nse_field.viscosity_model == 2
   
trace_strain_rate = abs(Q_1_v2*u_1) + abs(Q_2_v2*u_2) + abs(Q_3_v2*u_3); 
mu_vec = nse_field.mu*trace_strain_rate.^(nse_field.viscosity_exponent-1);

elseif nse_field.viscosity_model == 3

trace_strain_rate = abs(Q_1_v2*u_1) + abs(Q_2_v2*u_2) + abs(Q_3_v2*u_3); 
mu_vec = nse_field.mu + nse_field.viscosity_delta.*(1 + (nse_field.viscosity_relaxation_time*trace_strain_rate).^nse_field.viscosity_transition).^((nse_field.viscosity_exponent-1)./nse_field.viscosity_transition);

end

if ismember(nse_field.viscosity_model,[2 3])
    
if nse_field.viscosity_smoothing > 0
if nse_field.use_gpu  
mu_vec = pcg_iteration_gpu(S_mu,I_mu*mu_vec,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_mu);
else 
mu_vec = pcg_iteration(S_mu,I_mu*mu_vec,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_mu);
end
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
nse_field.bv_vessels_1{i_aux}(i_node_ind) = gather(u_1);
nse_field.bv_vessels_2{i_aux}(i_node_ind) = gather(u_2);
nse_field.bv_vessels_3{i_aux}(i_node_ind) = gather(u_3);
nse_field.bp_vessels{i_aux} = gather(p)/hgmm_conversion + gather(p_hydrostatic)/hgmm_conversion + gather(pressure_reference)/hgmm_conversion;
nse_field.mu_vessels{i_aux} = gather(mu_vec);
if nse_field.microcirculation_model 
nse_field.bf_capillaries{i_aux} = gather(mc_vec);
end

end
end

close(h_waitbar)

end