nodes_old = zef.nodes;
nodes = zef.nodes;
N = size(nodes,1);

taubin_lambda = 1;
taubin_mu = -1;
smoothing_param = 0.25;

 [zef.sensors_attached_volume] = zef_attach_sensors_volume(zef.sensors);
L = zef_electrode_struct;

if not(isempty(L))
C = [];
for electrode_ind = 1 : length(L)
 C_sparse = sparse(N, N, 0);
for i = 1 : 2
for j = i : 2
C_part = sparse(L(electrode_ind).edges(:,i),L(electrode_ind).edges(:,j),double(ones(size(L(electrode_ind).edges,1),1)),N,N);
if i == j
C_sparse = C_sparse + C_part;
else
C_sparse = C_sparse + C_part ;
C_sparse = C_sparse + C_part';
end
end
end
  C(electrode_ind).mat = full(C_sparse(L(electrode_ind).nodes,L(electrode_ind).nodes));
  C(electrode_ind).sum = sum(C(electrode_ind).mat)';
   C(electrode_ind).sum = C(electrode_ind).sum(:,[1 1 1]);
end
end

if not(isempty(L))
    for i = 1 : 100
for electrode_ind = 1 : length(L)
nodes_aux = C(electrode_ind).mat*nodes(L(electrode_ind).nodes,:);
nodes_aux = nodes_aux./C(electrode_ind).sum;
nodes_aux = nodes_aux - nodes(L(electrode_ind).nodes,:);
nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_lambda*smoothing_param*nodes_aux;
nodes_aux = C(electrode_ind).mat*nodes(L(electrode_ind).nodes,:);
nodes_aux = nodes_aux./C(electrode_ind).sum;
nodes_aux = nodes_aux - nodes(L(electrode_ind).nodes,:);
nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_mu*smoothing_param*nodes_aux;
end
    end
end

zef.nodes = nodes;