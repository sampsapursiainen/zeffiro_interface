function [M,K,L,Q,Q_bar] = zef_nse_matrices(nodes,tetra,rho,mu)

r = 1;
h = 1;

K = [];
L =[];
Q = zef_volume_scalar_GF(nodes,tetra,h,ones(size(rho)));
Q_bar = zef_volume_scalar_GF(nodes,tetra,h,rho);
M = zef_volume_scalar_FF(nodes,tetra,rho);
L = zef_volume_scalar_GG(nodes,tetra,r,r,mu);

end