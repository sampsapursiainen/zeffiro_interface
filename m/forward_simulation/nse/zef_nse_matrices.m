function [nse_mat] = zef_nse_matrices(nodes,tetra,rho,mu)

nse_mat.M = zef_volume_scalar_matrix_FF(nodes,tetra,rho);

nse_mat.L_11 = zef_volume_scalar_matrix_GG(nodes,tetra,1,1,mu);
nse_mat.L_22 = zef_volume_scalar_matrix_GG(nodes,tetra,2,2,mu);
nse_mat.L_33 = zef_volume_scalar_matrix_GG(nodes,tetra,3,3,mu);
nse_mat.L_12 = zef_volume_scalar_matrix_GG(nodes,tetra,1,2,mu);
nse_mat.L_13 = zef_volume_scalar_matrix_GG(nodes,tetra,1,3,mu);
nse_mat.L_23 = zef_volume_scalar_matrix_GG(nodes,tetra,2,3,mu);

nse_mat.Q_1 = zef_volume_scalar_matrix_FG(nodes,tetra,1,ones(size(rho)));
nse_mat.Q_2 = zef_volume_scalar_matrix_FG(nodes,tetra,2,ones(size(rho)));
nse_mat.Q_3 = zef_volume_scalar_matrix_FG(nodes,tetra,3,ones(size(rho)));

nse_mat.F = zef_volume_scalar_matrix_FF(nodes,tetra,rho);

nse_mat.B1_1 = zef_surface_scalar_matrix_n(nodes,tetra,1);
nse_mat.B1_2 = zef_surface_scalar_matrix_n(nodes,tetra,2);
nse_mat.B1_3 = zef_surface_scalar_matrix_n(nodes,tetra,3);

nse_mat.B2 = zef_surface_scalar_matrix_Dn(nodes,tetra,1,1);
nse_mat.B2 = nse_mat.B2 + zef_surface_scalar_matrix_Dn(nodes,tetra,2,2);
nse_mat.B2 = nse_mat.B2 + zef_surface_scalar_matrix_Dn(nodes,tetra,3,3);

nse_mat.B3_11 = zef_surface_scalar_matrix_Dn(nodes,tetra,1,1);
nse_mat.B3_21 = zef_surface_scalar_matrix_Dn(nodes,tetra,2,1);
nse_mat.B3_31 = zef_surface_scalar_matrix_Dn(nodes,tetra,3,1);

nse_mat.B3_12 = zef_surface_scalar_matrix_Dn(nodes,tetra,1,2);
nse_mat.B3_22 = zef_surface_scalar_matrix_Dn(nodes,tetra,2,2);
nse_mat.B3_32 = zef_surface_scalar_matrix_Dn(nodes,tetra,3,2);

nse_mat.B3_13 = zef_surface_scalar_matrix_Dn(nodes,tetra,1,3);
nse_mat.B3_23 = zef_surface_scalar_matrix_Dn(nodes,tetra,2,3);
nse_mat.B3_33 = zef_surface_scalar_matrix_Dn(nodes,tetra,3,3);

[I,J,V] = find(nse_mat.M);

nse_mat.N = sparse(I,J,ones(size(V)));
diag_N = full(1./sum(nse_mat.N,2));
nse_mat.N = spdiags(diag_N,0,size(nse_mat.N,1),size(nse_mat.N,2))*nse_mat.N;

end