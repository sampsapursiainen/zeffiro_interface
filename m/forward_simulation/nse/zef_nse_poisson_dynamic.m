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

hgmm_conversion = 101325/760;
mm_conversion = 0.001;
mvd_length = 1E6.*mvd_length(:,1);

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

zef_waitbar(0.33,h_waitbar,'NSE solver: velocity');

Q_1 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 1, ones(size(v_1_tetra,1),1));
Q_2 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 2, ones(size(v_1_tetra,1),1));
Q_3 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 3, ones(size(v_1_tetra,1),1));

c_vec = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra);

Q_1_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_1;
Q_2_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_2;
Q_3_v1 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_3;

Q_1_v1 = Q_1_v1(i_node_ind,i_node_ind);
Q_2_v1 = Q_2_v1(i_node_ind,i_node_ind);
Q_3_v1 = Q_3_v1(i_node_ind,i_node_ind);

Q_1_v2 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_1;
Q_2_v2 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_2;
Q_3_v2 = spdiags(1./c_vec,0,size(v_1_nodes,1),size(v_1_nodes,1))*Q_3;

Q_1_v2 = Q_1_v2(:,i_node_ind);
Q_2_v2 = Q_2_v2(:,i_node_ind);
Q_3_v2 = Q_3_v2(:,i_node_ind);

Q_1 = Q_1(i_node_ind,:);
Q_2 = Q_2(i_node_ind,:);
Q_3 = Q_3(i_node_ind,:);

I_mu = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, ones(size(v_1_tetra,1),1));
I_u = I_mu(i_node_ind,i_node_ind);
S_mu = I_mu + nse_field.viscosity_smoothing.^2*K_1;
S_u = I_u + nse_field.velocity_smoothing.^2*K_1(i_node_ind,i_node_ind);

C = zef_volume_scalar_matrix_FF(v_1_nodes, v_1_tetra, nse_field.rho*ones(size(v_1_tetra,1),1));
C = C(i_node_ind,i_node_ind);

L_11 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,1,1,ones(size(v_1_tetra,1),1));
L_22 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,2,2,ones(size(v_1_tetra,1),1));
L_33 = zef_volume_scalar_matrix_GG(v_1_nodes,v_1_tetra,3,3,ones(size(v_1_tetra,1),1));
L_11 = L_11(i_node_ind, i_node_ind);
L_22 = L_22(i_node_ind, i_node_ind);
L_33 = L_33(i_node_ind, i_node_ind);
L = L_11 + L_22 + L_33; 

p = zeros(size(K_1,1),1);

nse_field.bp_vessels = cell(0);
nse_field.bv_vessels_1 = cell(0);
nse_field.bv_vessels_2 = cell(0);
nse_field.bv_vessels_3 = cell(0);
nse_field.mu_vessels = cell(0);

h_waitbar = zef_waitbar(0,'NSE solver: compute' );

c_vec = c_vec(i_node_ind);

u_1 = zeros(size(L,1),1);
u_2 = zeros(size(L,1),1);
u_3 = zeros(size(L,1),1);
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
    y = gpuArray(y);
    c_vec = gpuArray(c_vec);
    source_vec = gpuArray(source_vec);
    y_1 = gpuArray(y_1);
    y_2 = gpuArray(y_2);
    i_aux = gpuArray(i_aux);
    i_node_ind = gpuArray(i_node_ind);
    mu_vec = gpuArray(mu_vec);
     
end

if nse_field.use_gpu
DM_C = gpuArray(1./full(diag(C))); 
DM_S_u = gpuArray(1./(full(diag(S_u))));
DM_S_mu = gpuArray(1./(full(diag(S_mu))));
else
DM_C = spdiags(diag(C), 0, size(C,1), size(C,1));
DM_S_u = spdiags(diag(S_u), 0, size(S_u,1), size(S_u,1));
DM_S_mu = spdiags(diag(S_mu), 0, size(S_mu,1), size(S_mu,1));
end

KDMD = @(x) zef_KDMD(x,K_1,M_1,D_1,nse_field.use_gpu);

for i = 1 : length(time_vec)
    
zef_waitbar(i/length(time_vec),h_waitbar,['NSE solver: compute, velocity norm: ' sprintf('%0.3g',sqrt(sum(u_1.^2)+sum(u_2.^2)+sum(u_3.^2)))]);

L_u_1 = L*u_1;
L_u_2 = L*u_2;
L_u_3 = L*u_3;

for quadrature_step_ind = 1 : 1

if nse_field.nse_type == 2

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

if i == 1
    b = D_1 * (M_1 * (D_1 * (p_1  + source_vec * (y(i) - 2*y_1))));
else
    b = D_1 * (M_1 * (D_1 * (2*p_1 - p_2  + source_vec * (y(i) - 2*y_1 + y_2))));
end

friction_vec =  L_u_1.*(Q_1_v1*mu_vec(i_node_ind))  + L_u_2.*(Q_2_v1*mu_vec(i_node_ind)) + L_u_3.*(Q_3_v1*mu_vec(i_node_ind));

b(i_node_ind) = b(i_node_ind) + friction_vec;

if nse_field.nse_type == 2
        
q_1_u_1 = Q_1_v1*u_1; 
q_1_u_2 = Q_1_v1*u_2;
q_1_u_3 = Q_1_v1*u_3;

q_2_u_1 = Q_2_v1*u_1; 
q_2_u_2 = Q_2_v1*u_2;
q_2_u_3 = Q_2_v1*u_3;

q_3_u_1 = Q_3_v1*u_1;
q_3_u_2 = Q_3_v1*u_2;
q_3_u_3 = Q_3_v1*u_3;

Q_1_v1_1 = Q_1_v1*v_1; 
Q_1_v1_2 = Q_1_v1*v_2;
Q_1_v1_3 = Q_1_v1*v_3;

q_2_v_1 = Q_2_v1*v_1;
q_2_v_2 = Q_2_v1*v_2;
q_2_v_3 = Q_2_v1*v_3;

q_3_v_1 = Q_3_v1*v_1;
q_3_v_2 = Q_3_v1*v_2;
q_3_v_3 = Q_3_v1*v_3;

tr_vec = Q_1_v1_1.*q_1_u_1 + q_2_v_1.*q_1_u_2 + q_3_v_1.*q_1_u_3 + ... 
Q_1_v1_2.*q_2_u_1 + q_2_v_2.*q_2_u_2 + q_3_v_2.*q_2_u_3 + ...
Q_1_v1_3.*q_3_u_1 + q_2_v_3.*q_3_u_2 + q_3_v_3.*q_3_u_3 ;

%   norm(tr_vec)

b(i_node_ind) = b(i_node_ind) + nse_field.rho.*tr_vec.*c_vec;

end

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
y_1 = y(i);

n_p_1 = - Q_1*p;
n_p_2 = - Q_2*p;
n_p_3 = - Q_3*p;

if nse_field.nse_type == 2

u_gu_vec_1 = q_1_u_1.*v_1 + q_2_u_1.*v_2 + q_3_u_1.*v_3;
u_gu_vec_2 = q_1_u_2.*v_1 + q_2_u_2.*v_2 + q_3_u_2.*v_3;
u_gu_vec_3 = q_1_u_3.*v_1 + q_2_u_3.*v_2 + q_3_u_3.*v_3;
    
n_p_1 = n_p_1 - nse_field.rho.*u_gu_vec_1.*c_vec;
n_p_2 = n_p_2 - nse_field.rho.*u_gu_vec_2.*c_vec;
n_p_3 = n_p_3 - nse_field.rho.*u_gu_vec_3.*c_vec;

end

n_p_1 = n_p_1 - mu_vec(i_node_ind).*(L_u_1);
n_p_2 = n_p_2 - mu_vec(i_node_ind).*(L_u_2);
n_p_3 = n_p_3 - mu_vec(i_node_ind).*(L_u_3);

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
slope_field_stage_1_1 = aux_vec_1;
slope_field_stage_1_2 = aux_vec_2;
slope_field_stage_1_3 = aux_vec_3;
u_stage_1_1 = u_1;
u_stage_1_2 = u_2;
u_stage_1_3 = u_3;
u_1 = u_1 + nse_field.time_step_length.*slope_field_stage_1_1; 
u_2 = u_2 + nse_field.time_step_length.*slope_field_stage_1_2; 
u_3 = u_3 + nse_field.time_step_length.*slope_field_stage_1_3; 
elseif quadrature_step_ind == 2
slope_field_stage_2_1 = aux_vec_1;
slope_field_stage_2_2 = aux_vec_2;
slope_field_stage_2_3 = aux_vec_3;
u_1 = u_stage_1_1 + nse_field.time_step_length.*0.5.*(slope_field_stage_1_1 + slope_field_stage_2_1);   
u_2 = u_stage_1_2 + nse_field.time_step_length.*0.5.*(slope_field_stage_1_2 + slope_field_stage_2_2);   
u_3 = u_stage_1_3 + nse_field.time_step_length.*0.5.*(slope_field_stage_1_3 + slope_field_stage_2_3);   
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
    
if nse_field.use_gpu  
mu_vec = pcg_iteration_gpu(S_mu,I_mu*mu_vec,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_mu);
else 
mu_vec = pcg_iteration(S_mu,I_mu*mu_vec,nse_field.pcg_tol,nse_field.pcg_maxit,DM_S_mu);
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
nse_field.bp_vessels{i_aux} = gather(p/hgmm_conversion) + gather(p_hydrostatic/hgmm_conversion) + gather(nse_field.pressure);
nse_field.mu_vessels{i_aux} = gather(mu_vec);

end
end

close(h_waitbar)

end