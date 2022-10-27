
p = zeros(size(nodes,1),1);
u_1 = zeros(size(nodes,1),1);
u_2 = zeros(size(nodes,1),1);
u_3 = zeros(size(nodes,1),1);

Cuu_1 = zef_volume_scalar_uFG(nodes, tetra, 1, u_1, u_1, b_coord, volume);
Cuu_2 = zef_volume_scalar_uFG(nodes, tetra, 2, u_1, u_1, b_coord, volume);
Cuu_3 = zef_volume_scalar_uFG(nodes, tetra, 1, u_1, u_1, b_coord, volume);

[Cuu_1, Cuu_2, Cuu_3] = zef_volume_scalar_uFG(nodes, tetra, 1, u_1, u_2, u_3, u_1, b_coord, volume);
[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 2, u_1, u_2, u_3, u_2, b_coord, volume);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

[Aux_1, Aux_2, Aux_3] = zef_volume_scalar_uFG(nodes, tetra, 3, u_1, u_2, u_3, u_3, b_coord, volume);
Cuu_1 = Cuu_1 + Aux_1;
Cuu_2 = Cuu_2 + Aux_2;
Cuu_3 = Cuu_3 + Aux_3;

aux_vec = f_1 - 

[aux_vec_init] = pcg_iteration(C,aux_vec,pcg_tol,pcg_maxit,M,aux_vec_init,gpu_extended_memory);