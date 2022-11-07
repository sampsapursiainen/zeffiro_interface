
nse_field = load("torus.mat");

nse_field.d_t = 2.2e-05;
nse_field.pulse_length = 0.06;
nse_field.carrier_cycles_per_pluse_cycle = 0;
nse_field.t_data = 0:nse_field.d_t:nse_field.pulse_length;
nse_field.carrier_mode = 'complex';
nse_field.pcg_tol = 1e-5;
nse_field.pcg_maxit = 1000;

nodes =  nse_field.nodes;
tetra = nse_field.tetra;

nse_field.rho = ones(size(tetra,1),1);
nse_field.mu = ones(size(tetra,1),1); 


[~,~,surface_node_ind] = zef_surface_mesh(tetra, nodes);
surface_node_ind = unique(tetra(surface_node_ind,:));

[pulse_window, d_pulse_window] = bh_window(nse_field.t_data, nse_field.pulse_length, nse_field.carrier_cycles_per_pluse_cycle, nse_field.carrier_mode);

f_aux = zeros(size(nodes,1),1);
interior_node_ind = setdiff(1:size(nodes,1),surface_node_ind);

f_aux(interior_node_ind(1)) = 1;




p = zeros(size(nodes,1),1);
u_1 = zeros(size(nodes,1),1);
u_2 = zeros(size(nodes,1),1);
u_3 = zeros(size(nodes,1),1);


[M,L,Q_1,Q_2,Q_3,F] = zef_nse_matrices(nodes,tetra,nse_field.rho,nse_field.mu);

M(surface_node_ind,1:size(nodes,1)) = 0;
M(1:size(nodes,1),surface_node_ind) = 0;
M(surface_node_ind,surface_node_ind) = speye(size(surface_node_ind,1));

Q_1(surface_node_ind,1:size(nodes,1)) = 0;
Q_1(1:size(nodes,1),surface_node_ind) = 0;
Q_1(surface_node_ind,surface_node_ind) = speye(size(surface_node_ind,1));

Q_2(surface_node_ind,1:size(nodes,1)) = 0;
Q_2(1:size(nodes,1),surface_node_ind) = 0;
Q_2(surface_node_ind,surface_node_ind) = speye(size(surface_node_ind,1));

Q_3(surface_node_ind,1:size(nodes,1)) = 0;
Q_3(1:size(nodes,1),surface_node_ind) = 0;
Q_3(surface_node_ind,surface_node_ind) = speye(size(surface_node_ind,1));


L(surface_node_ind,1:size(nodes,1)) = 0;
L(1:size(nodes,1),surface_node_ind) = 0;


% B = spalloc(size(nodes,1),size(nodes,1),0);
% B(surface_node_ind,surface_node_ind) = 0;

f_1 = F*f_aux; 
f_2 = zeros(size(f_1));
f_3 = zeros(size(f_1));
aux_vec_init_1 = zeros(size(u_1));
aux_vec_init_2 = zeros(size(u_2));
aux_vec_init_3 = zeros(size(u_3));
DM = spdiags(full(sum(M,2)),0,size(nodes,1),size(nodes,1));


for t_ind = 1: length(nse_field.t_data)

[Cuu_1, Cuu_2, Cuu_3] = zef_volume_scalar_uFG(nodes, tetra, 1, u_1, u_2, u_3, u_1);
[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 2, u_1, u_2, u_3, u_2);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 3, u_1, u_2, u_3, u_3);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;


aux_vec_1 =  f_1*pulse_window(t_ind) - Cuu_1 - L + Q_1*p ;
[aux_vec_init_1] = pcg_iteration(M,aux_vec_1,nse_field.pcg_tol,nse_field.pcg_maxit,DM,aux_vec_init_1);



aux_vec_2 =  f_2 - Cuu_2 - L + Q_2*p ;
[aux_vec_init_2] = pcg_iteration(M,aux_vec_2,nse_field.pcg_tol,nse_field.pcg_maxit,DM,aux_vec_init_2);


aux_vec_3 =  f_3 - Cuu_3 - L + Q_3*p ;
[aux_vec_init_3] = pcg_iteration(M,aux_vec_3,nse_field.pcg_tol,nse_field.pcg_maxit,DM,aux_vec_init_3);

u1(:,:,t_ind) = u_1 + nse_field.d_t*aux_vec_init_1;

u2(:,:,t_ind) = u_2 + nse_field.d_t*aux_vec_init_2;
u3(:,:,t_ind) = u_3 + nse_field.d_t*aux_vec_init_3;

end
figure(1)
pdeplot3D(nodes',tetra')