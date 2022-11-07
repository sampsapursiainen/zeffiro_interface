function [M,L,Q_1,Q_2,Q_3,F] = zef_nse_matrices(nodes,tetra,rho,mu)

M = zef_volume_scalar_FF(nodes,tetra,rho);

L = zef_volume_scalar_GG(nodes,tetra,1,1,mu);
L = L + zef_volume_scalar_GG(nodes,tetra,2,2,mu);
L = L + zef_volume_scalar_GG(nodes,tetra,3,3,mu);

Q_1 = zef_volume_scalar_FG(nodes,tetra,1,ones(size(rho)));
Q_2 = zef_volume_scalar_FG(nodes,tetra,2,ones(size(rho)));
Q_3 = zef_volume_scalar_FG(nodes,tetra,3,ones(size(rho)));

F = zef_volume_scalar_FF(nodes,tetra);

end