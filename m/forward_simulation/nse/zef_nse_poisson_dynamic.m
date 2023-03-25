function nse_field = zef_nse_poisson_dynamic(nse_field,nodes,tetra,domain_labels,mvd_length) 


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

h_waitbar = zef_waitbar(0,'NSE solver: pressure');

n_frames = nse_field.n_frames;

time_vec = [0:nse_field.time_step_length:nse_field.time_length]';

time_frame_ind = [1:ceil(length(time_vec)/n_frames):length(time_vec)];

nse_field.inv_time_1 = time_vec(time_frame_ind(1));
nse_field.inv_time_3 = time_vec(time_frame_ind(2)) - time_vec(time_frame_ind(1));

y = zef_nse_signal_pulse(time_vec,nse_field);
source_radius = nse_field.sphere_radius;

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

[v_1_nodes, v_1_tetra, nse_field.bp_vessel_node_ind] = zef_get_submesh(nodes, tetra, c_ind_1_domain);
v_1_nodes = mm_conversion*v_1_nodes;
[~, det] = zef_volume_barycentric(v_1_nodes,v_1_tetra);
volume = abs(det)/6;
volume_arteries = sum(volume(:));

[v_2_nodes, v_2_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, c_ind_2_domain);
v_2_nodes = mm_conversion*v_2_nodes;
[~, det] = zef_volume_barycentric(v_2_nodes,v_2_tetra);
volume = abs(det)/6;
volume_sum = sum(volume(:));
mvd_volume_mean = sum(mvd_length(c_ind_2_domain).*volume(:))./volume_sum;

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

beta = 8*pi*nse_field.mu*ml_min_conversion*nse_field.total_flow/((pi*(nse_field.arteriole_diameter/2)).^2*nse_field.pressure*hgmm_conversion*area_arteries*param_aux_integral_mean);

arteriole_length = nse_field.pressure_decay_in_arterioles*pi*(nse_field.arteriole_diameter/2).^2*arteriole_scale/beta;

K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ... 
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));
M_1 = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, beta.*param_aux);  
A = K_1 + M_1;

zef_waitbar(0.33,h_waitbar,'NSE solver: velocity');

nse_field.mu_vec = nse_field.mu*ones(size(v_1_tetra,1),1); 

nse_field.bv_vessels_1 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_2 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_3 = zeros(size(nse_field.bp_vessels));
nse_field.bv_vessels_b = zeros(size(nse_field.bp_vessels));

Q_1 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 1, nse_field.mu_vec.^(-1));
Q_2 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 2, nse_field.mu_vec.^(-1));
Q_3 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 3, nse_field.mu_vec.^(-1));

% g_1 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_x * nse_field.mu_vec.^(-1));
% g_2 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_y * nse_field.mu_vec.^(-1));
% g_3 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_z * nse_field.mu_vec.^(-1));

n_1 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 1, ones(size(tetra,1),1));
n_2 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 2, ones(size(tetra,1),1));
n_3 = zef_surface_scalar_vector_Fn(v_1_nodes, v_1_tetra, 3, ones(size(tetra,1),1));

n_norm = sqrt(n_1.^2 + n_2.^2 + n_3.^2);

n_i_nodes = length(i_node_ind); 
n_b_nodes = length(b_node_ind);

n_1 = n_1./n_norm;
n_2 = n_2./n_norm;
n_3 = n_3./n_norm;

N_1 = spdiags(n_1(b_node_ind),0,n_b_nodes,n_b_nodes);
N_2 = spdiags(n_2(b_node_ind),0,n_b_nodes,n_b_nodes);
N_3 = spdiags(n_3(b_node_ind),0,n_b_nodes,n_b_nodes);

%L = sparse(3*n_i_nodes+n_b_nodes,3*n_i_nodes+n_b_nodes,0);
L = sparse(3*n_i_nodes,3*n_i_nodes,0);
L([1:n_i_nodes], [1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);
L(n_i_nodes+[1:n_i_nodes], n_i_nodes+[1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);
L(2*n_i_nodes+[1:n_i_nodes], 2*n_i_nodes+[1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);
%L = nse_field.rho.*speye(size(L)) - nse_field.time_step_length.*L;
%L(3*n_i_nodes+[1:n_b_nodes], 3*n_i_nodes+[1:n_b_nodes]) = N_1*(K_1(b_node_ind, b_node_ind)*N_1) + N_2*(K_1(b_node_ind, b_node_ind)*N_2) + N_3*(K_1(b_node_ind, b_node_ind)*N_3);

%L(3*n_i_nodes+[1:n_b_nodes], [1:n_i_nodes]) = N_1*K_1(b_node_ind, i_node_ind);
%L([1:n_i_nodes], 3*n_i_nodes+[1:n_b_nodes]) = K_1(i_node_ind, b_node_ind)*N_1;

%L(3*n_i_nodes+[1:n_b_nodes], n_i_nodes + [1:n_i_nodes]) = N_2*K_1(b_node_ind, i_node_ind);
%L(n_i_nodes + [1:n_i_nodes], 3*n_i_nodes+[1:n_b_nodes]) = K_1(i_node_ind, b_node_ind)*N_2;

%L(3*n_i_nodes+[1:n_b_nodes], 2*n_i_nodes + [1:n_i_nodes]) = N_3*K_1(b_node_ind, i_node_ind);
%L(2*n_i_nodes + [1:n_i_nodes], 3*n_i_nodes+[1:n_b_nodes]) = K_1(i_node_ind, b_node_ind)*N_3;

%g = zeros(3*n_i_nodes + n_b_nodes,1);
% g = zeros(3*n_i_nodes,1);
% g([1:n_i_nodes]) = g_1(i_node_ind); 
% g(n_i_nodes + [1:n_i_nodes]) = g_2(i_node_ind);
% g(2*n_i_nodes + [1:n_i_nodes]) = g_3(i_node_ind);
%g(3*n_i_nodes + [1:n_b_nodes]) =  N_1*g_1(b_node_ind)+ N_2*g_2(b_node_ind) + N_3*g_3(b_node_ind);

p = zeros(size(K_1,1),1);

nse_field.bp_vessels = cell(0);
nse_field.bv_vessels_1 = cell(0);
nse_field.bv_vessels_2 = cell(0);
nse_field.bv_vessels_3 = cell(0);

h_waitbar = zef_waitbar(0,'NSE solver: compute');

p_1 = p;
p_2 = p;
y_1 = 0;
y_2 = 0;
u = zeros(size(L,1),1);
i_aux = 0;

for i = 1 : length(time_vec)
    
zef_waitbar(i/length(time_vec),h_waitbar,'NSE solver: compute');

if i == 1
    b = M_1 * (p_1  + source_vec * (y(i) - y_1));
else
    b = M_1 * (2*p_1 - p_2  + source_vec * (y(i) - 2*y_1 + y_2));
%else
%    b = M_1 * (3*p_1 + 3*p_2 - p_3  + source_vec * (y(i) - 3*y_1 - 3*y_2 + y_3));
end



if nse_field.use_gpu
DM = 1./diag(A); 
p = pcg_iteration_gpu(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
DM = spdiags(diag(A),0,size(A,1),size(A,1)); 
p = pcg_iteration(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end

%p_3 = p_2;
p_2 = p_1;
p_1 = p; 

%y_3 = y_2;
y_2 = y_1;
y_1 = y(i);

n_p_1 = Q_1*p;
n_p_2 = Q_2*p;
n_p_3 = Q_3*p;

%n_p = zeros(3*n_i_nodes + n_b_nodes,1);
n_p = zeros(3*n_i_nodes,1);
n_p([1:n_i_nodes]) = n_p_1(i_node_ind); 
n_p(n_i_nodes + [1:n_i_nodes]) = n_p_2(i_node_ind);
n_p(2*n_i_nodes + [1:n_i_nodes]) = n_p_3(i_node_ind);
%n_p(3*n_i_nodes + [1:n_b_nodes]) = N_1*n_p_1(b_node_ind)+ N_2*n_p_2(b_node_ind) + N_3*n_p_3(b_node_ind);

if nse_field.use_gpu
DM = 1./diag(L); 
aux_vec = pcg_iteration_gpu(L, n_p, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
else
DM = spdiags(diag(L), 0, size(L,1), size(L,1)); 
aux_vec = pcg_iteration(L, n_p, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
end

u = u + aux_vec;

if ismember(i,time_frame_ind)
    
i_aux = i_aux + 1;    
    
nse_field.bp_vessels{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_1{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_2{i_aux} = zeros(size(K_1,1),1);
nse_field.bv_vessels_3{i_aux} = zeros(size(K_1,1),1);

nse_field.bv_vessels_1{i_aux}(i_node_ind) = u([1:n_i_nodes]);
nse_field.bv_vessels_2{i_aux}(i_node_ind) = u(n_i_nodes+[1:n_i_nodes]);
nse_field.bv_vessels_3{i_aux}(i_node_ind) = u(2*n_i_nodes+[1:n_i_nodes]);
%nse_field.bv_vessels_b(b_node_ind) = aux_vec(3*n_i_nodes+[1:n_b_nodes]);

nse_field.bp_vessels{i_aux} = p/hgmm_conversion + p_hydrostatic/hgmm_conversion + nse_field.pressure;

end

end

close(h_waitbar)

end