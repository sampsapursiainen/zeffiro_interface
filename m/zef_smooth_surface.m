function [smoothed_nodes] = zef_smooth_surface(nodes,triangles,smoothing_parameter,n_smoothing)

smoothing_param = smoothing_parameter;
smoothing_steps_surf = n_smoothing;
N = size(nodes,1);

if N > 0

A = sparse(N, N, 0);

for i = 1 : 3
for j = i+1 : 3
A_part = sparse(triangles(:,i),triangles(:,j),double(ones(size(triangles,1),1)),N,N);
if i == j
A = A + A_part;
else
A = A + A_part ;
A = A + A_part';
end
end
end

clear A_part;
K = unique(triangles(:));
A = spones(A);
sum_A = full(sum(A(K,K)))';

sum_A = sum_A(:,[1 1 1]);
taubin_lambda = 1;
taubin_mu = -1;

for iter_ind_aux_1 = 1 : smoothing_steps_surf
nodes_aux = A(K,K)*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_lambda*smoothing_param*nodes_aux;
nodes_aux = A(K,K)*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_mu*smoothing_param*nodes_aux;

end

smoothed_nodes = nodes;

else

    smoothed_nodes = [];

end

end
