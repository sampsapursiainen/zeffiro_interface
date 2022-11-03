
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
nse_field.mu = 1; 


[surface_triangles, surface_nodes, tetra_ind] = zef_surface_mesh(tetra, nodes);
[pulse_window, d_pulse_window] = bh_window(nse_field.t_data, nse_field.pulse_length, nse_field.carrier_cycles_per_pluse_cycle, nse_field.carrier_mode);
f_aux = pulse_window.'*surface_triangles(:,3).' + d_pulse_window.'*surface_triangles(:,3).';

p = zeros(size(nodes,1),1);
u_1 = zeros(size(nodes,1),1);
u_2 = zeros(size(nodes,1),1);
u_3 = zeros(size(nodes,1),1);


[M,L,Q_1,Q_2,Q_3,F] = zef_nse_matrices(nodes,tetra,nse_field.rho,nse_field.mu);

[Cuu_1, Cuu_2, Cuu_3] = zef_volume_scalar_uFG(nodes, tetra, 1, u_1, u_2, u_3, u_1);
[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 2, u_1, u_2, u_3, u_2);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 3, u_1, u_2, u_3, u_3);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

aux_vec_init = zeros(size(u_1));

for i = 1:3
aux_vec =  Cuu_1;

[aux_vec_init] = pcg_iteration(M,aux_vec,pcg_tol,pcg_maxit,M,aux_vec_init);
end


figure(1)
pdeplot3D(nodes',tetra')