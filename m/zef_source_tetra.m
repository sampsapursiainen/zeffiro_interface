function [t_ind, coeff, f_ind] = zef_source_tetra(source_positions, tetra, nodes, K)

% Finds the index of a tetrahedron containing a source position for K
% tetrahedra nearest to that position.
% INPUT: 
%
% source_positions, Nx3 array (source positions)
%
% tetra, Mx4 array (tetrahedra)
%
% nodes, Lx3 array (nodes)
%
% OUTPUT:
% t_index, Nx1 array (indices of the tetrahedra found, if a container tetrahedron is not found, the index of the nearest one is given instead.)
%
% coeff, Nx3 array (coefficients of the source position as a linear combination of edges
% between vertex 1 and vertex 2, vertex 3, vertex 4, respectively.)
%
% f_ind, Nx1 array (1 if a container tetrahedron was found, 0 if the
% nearest point was used instead)
%
%K, positive integer (the number of nearest neighbors applied in the
%search.)

if nargin < 4
    K = 25;
end

h_waitbar = zef_waitbar(0, 'Finding nearest tetrahedra');

n_points = size(source_positions,1);
t_ind = zeros(n_points,1);
coeff = zeros(n_points,3);
f_ind = zeros(n_points,1);

v_1 = nodes(tetra(:,1),:);
v_2 = nodes(tetra(:,2),:);
v_3 = nodes(tetra(:,3),:);
v_4 = nodes(tetra(:,4),:);

t_c_p = 0.25 * (v_1 + v_2 + v_3 + v_4);

v_2 = v_2 - v_1;
v_3 = v_3 - v_1;
v_4 = v_4 - v_1; 

s_ind = knnsearch(t_c_p,source_positions,'K',K);

s_aux = source_positions(ones(K,1),:) - v_1(s_ind(1,:),:);

[x, y, z] = zef_3by3_solver(v_2(s_ind(1,:),:),v_3(s_ind(1,:),:),v_4(s_ind(1,:),:),s_aux);

aux_val = find(x>=0 & x<=1 & y>=0 & y<=1 & z>=0 & z<=1, 1, 'first');

if not(isempty(aux_val))
    t_ind(1) = s_ind(1,aux_val);
    f_ind(1) = 1;
else
t_ind(1) = s_ind(1,1);
end

if t_ind(1) > 0 
coeff(1,1) = x(aux_val);
coeff(1,2) = y(aux_val);
coeff(1,3) = z(aux_val);
end

if n_points == 1
    zef_waitbar(1, h_waitbar, 'Finding nearest tetrahedra');
end

for i = 2 : n_points

s_aux = source_positions(i*ones(K,1),:) - v_1(s_ind(i,:),:);

if mod(i,ceil(n_points/20))==0
zef_waitbar(i/n_points, h_waitbar, 'Finding nearest tetrahedra');
end

[x, y, z] = zef_3by3_solver(v_2(s_ind(i,:),:),v_3(s_ind(i,:),:),v_4(s_ind(i,:),:),s_aux);

aux_val = find(x>=0 & x<=1 & y>=0 & y<=1 & z>=0 & z<=1, 1,'first');

if not(isempty(aux_val))
    t_ind(i) = s_ind(i,aux_val);
    f_ind(i) = 1;
else
t_ind(i) = s_ind(i,1);
end

if t_ind(i) > 0 
coeff(i,1) = x(aux_val);
coeff(i,2) = y(aux_val);
coeff(i,3) = z(aux_val);
end

end

close(h_waitbar);

end
