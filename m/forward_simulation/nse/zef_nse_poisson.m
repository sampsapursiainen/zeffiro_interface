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

nse_field.bp_vessels = cell(0);
nse_field.bv_vessels_1 = cell(0);
nse_field.bv_vessels_2 = cell(0);
nse_field.bv_vessels_3 = cell(0);
nse_field.mu_vessels = cell(0);
nse_field.bf_capillaries = cell(0);

h_waitbar = zef_waitbar(0,3,'NSE solver: pressure');

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
pulse_amplitude = nse_field.pulse_amplitude.*hgmm_conversion;
%time_vec = [0:nse_field.time_step_length:nse_field.time_length];
%p_aux = zef_nse_signal_pulse(time_vec,nse_field);

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

 source_radius = nse_field.sphere_radius;
 source_node_ind = [];
 for i  = 1 : length(nse_field.sphere_radius)
     source_node_ind_aux = find(sqrt(sum((v_1_nodes(b_node_ind,:) - mm_conversion*ones(length(b_node_ind),1)*[nse_field.sphere_x(i) nse_field.sphere_y(i) nse_field.sphere_z(i)]).^2,2)) <= mm_conversion*source_radius(i));
     source_node_ind = [source_node_ind ; source_node_ind_aux];
 end
 source_vec = zeros(size(v_1_nodes,1),1);
 source_vec(b_node_ind(source_node_ind)) = 1;

 %p_aux = p_aux/max(p_aux); 
 %p_aux = pulse_amplitude*p_aux;
 
K_1 = zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 1, 1, ones(size(v_1_tetra,1),1)) + ...
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 2, 2, ones(size(v_1_tetra,1),1)) + ...
    zef_volume_scalar_matrix_GG(v_1_nodes, v_1_tetra, 3, 3, ones(size(v_1_tetra,1),1));
M_1 = zef_surface_scalar_matrix_FF(v_1_nodes, v_1_tetra, beta.*param_aux);
A = K_1 + M_1;
% b =  M_1 * (p_hydrostatic);
% if nse_field.use_gpu
%     DM = 1./diag(A);
%     p_hydrostatic = pcg_iteration_gpu(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
% else
%     DM = spdiags(diag(A),0,size(A,1),size(A,1));
%     p_hydrostatic = pcg_iteration(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
% end

%p = zeros(size(source_vec));
p = source_vec;
p_old = zeros(size(p));
iter_ind = 0;
conv_val = Inf;
nse_field.conv_vec = [];
while conv_val > nse_field.poisson_tolerance
iter_ind = iter_ind + 1;
%p_integral = zeros(size(source_vec));
%for i = 1 : length(time_vec)
%b = M_1*(p_aux(i)*source_vec + p);
b = M_1*p;
if nse_field.use_gpu
    DM = 1./diag(A);
    p = pcg_iteration_gpu(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
else
    DM = spdiags(diag(A),0,size(A,1),size(A,1));
    p = pcg_iteration(A,b,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
end
%if and(time_vec(i) >= nse_field.start_time, time_vec(i)<=nse_field.time_length)
%p_integral = p_integral + nse_field.time_step_length*p;
%p_integral = max(p_integral,p);
%end
%zef_waitbar(i/length(time_vec),h_waitbar,'NSE solver: pressure');
conv_val = norm(p - p_old)./norm(p_old);
p_old = p;
nse_field.conv_vec = [nse_field.conv_vec conv_val];
end

%p = p_integral/(nse_field.time_length - nse_field.start_time);
%p = p_integral;
p = abs(p); 
p = p/max(p); 
p = pulse_amplitude*p;

nse_field.bp_vessels{1} = p  + p_hydrostatic + (max(p_hydrostatic) - min(p_hydrostatic))/2 + nse_field.pressure.*hgmm_conversion ;

zef_waitbar(1,3,h_waitbar,'NSE solver: velocity');

mu_vec = nse_field.mu*ones(size(v_1_tetra,1),1);

nse_field.bv_vessels_1{1} = zeros(size(nse_field.bp_vessels{1}));
nse_field.bv_vessels_2{1} = zeros(size(nse_field.bp_vessels{1}));
nse_field.bv_vessels_3{1} = zeros(size(nse_field.bp_vessels{1}));
%nse_field.bv_vessels_b = zeros(size(nse_field.bp_vessels{1}));

Q_1 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 1, mu_vec.^(-1));
Q_2 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 2, mu_vec.^(-1));
Q_3 = zef_volume_scalar_matrix_FG(v_1_nodes,v_1_tetra, 3, mu_vec.^(-1));

g_1 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_x * mu_vec.^(-1));
g_2 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_y * mu_vec.^(-1));
g_3 = zef_volume_scalar_vector_F(v_1_nodes, v_1_tetra, nse_field.rho * nse_field.gravity_z * mu_vec.^(-1));

n_p_1 = Q_1*p;
n_p_2 = Q_2*p;
n_p_3 = Q_3*p;

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

L = sparse(3*n_i_nodes,3*n_i_nodes,0);
L([1:n_i_nodes], [1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);
L(n_i_nodes+[1:n_i_nodes], n_i_nodes+[1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);
L(2*n_i_nodes+[1:n_i_nodes], 2*n_i_nodes+[1:n_i_nodes]) = K_1(i_node_ind, i_node_ind);

g = zeros(3*n_i_nodes,1);
g([1:n_i_nodes]) = g_1(i_node_ind);
g(n_i_nodes + [1:n_i_nodes]) = g_2(i_node_ind);
g(2*n_i_nodes + [1:n_i_nodes]) = g_3(i_node_ind);

n_p = zeros(3*n_i_nodes,1);
n_p([1:n_i_nodes]) = n_p_1(i_node_ind);
n_p(n_i_nodes + [1:n_i_nodes]) = n_p_2(i_node_ind);
n_p(2*n_i_nodes + [1:n_i_nodes]) = n_p_3(i_node_ind);

if nse_field.use_gpu
    DM = 1./diag(L);
    aux_vec = pcg_iteration_gpu(L, n_p - g, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
else
    DM = spdiags(diag(L), 0, size(L,1), size(L,1));
    aux_vec = pcg_iteration(L, n_p - g, nse_field.pcg_tol, nse_field.pcg_maxit, DM);
end

nse_field.bv_vessels_1{1}(i_node_ind) = aux_vec([1:n_i_nodes]);
nse_field.bv_vessels_2{1}(i_node_ind) = aux_vec(n_i_nodes+[1:n_i_nodes]);
nse_field.bv_vessels_3{1}(i_node_ind) = aux_vec(2*n_i_nodes+[1:n_i_nodes]);

nse_field.bp_vessels{1} = nse_field.bp_vessels{1}/hgmm_conversion;

if nse_field.microcirculation_model

    zef_waitbar(2,3,h_waitbar,'NSE solver: concentration');

    bp_vessels_aux = zeros(size(nodes,1),1);
    bp_vessels_aux(nse_field.bp_vessel_node_ind) =  p;

    K_2 = zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 1, 1, mvd_length(c_ind_2_domain)) + ...
        zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 2, 2, mvd_length(c_ind_2_domain)) + ...
        zef_volume_scalar_matrix_GG(v_2_nodes, v_2_tetra, 3, 3, mvd_length(c_ind_2_domain));

    w_2 = zef_surface_scalar_vector_F(v_2_nodes, v_2_tetra, ones(size(v_2_tetra,1),1));

    bf_vessels_to_capillaries = bp_vessels_aux(nse_field.bf_capillary_node_ind);
    u = ml_min_conversion*nse_field.total_flow*bf_vessels_to_capillaries./sum(bf_vessels_to_capillaries.*w_2);

    M_2 = zef_volume_scalar_matrix_FF(v_2_nodes, v_2_tetra, mvd_length(c_ind_2_domain));

    K_2 = (diffusion_coefficient/mvd_volume_mean)*K_2 + ((4*pi).^(1/3).*3.^(2/3).*diffusion_coefficient.*nse_field.pressure_decay_in_arterioles./(mvd_volume_mean.*arteriole_length.*max(volume).^(1/3)))*M_2;

    if nse_field.use_gpu
        DM = 1./diag(K_2);
        nse_field.bf_capillaries{1} = pcg_iteration_gpu(K_2,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
    else
        DM = spdiags(diag(K_2),0,size(K_2,1),size(K_2,1));
        nse_field.bf_capillaries{1}  = pcg_iteration(K_2,u,nse_field.pcg_tol,nse_field.pcg_maxit,DM);
    end

    nse_field.bf_capillaries{1} = min(1,abs(nse_field.bf_capillaries{1}));

end

nse_field.bp_vessels{1} = abs(nse_field.bp_vessels{1});
nse_field.mu_vessels{1} = nse_field.mu*ones(size(nse_field.bp_vessels{1}));

zef_waitbar(3,3,h_waitbar,'NSE solver');

close(h_waitbar);

end
