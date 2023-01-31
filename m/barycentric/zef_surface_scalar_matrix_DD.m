function M = zef_surface_scalar_matrix_DD(nodes, tetra, g_i_ind, g_j_ind, scalar_field, weighting)

N = size(nodes,1);
K = size(tetra,1);

if nargin < 6
weighting = 1;    
end

if nargin < 5
scalar_field = ones(size(tetra,1),1);
end

if length(weighting)==1
weight_param = weighting([1 1]);
else
weight_param = weighting;
end

[b_vec,det] = zef_volume_barycentric(nodes,tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(b_vec.^2,2));

M = spalloc(N,N,0);

for i = 1 : 4
        [g_i] = zef_volume_barycentric(nodes,tetra,i,det);
        
    for j = i : 4
        [g_j] = zef_volume_barycentric(nodes,tetra,j,det);
        
        if i == j
        entry_vec = area*weight_param(1);
        else
        entry_vec = area*weight_param(2);
        end
        M_part =  sparse(tetra(:,i),tetra(:,j),scalar_field.*g_i(:,g_i_ind).*g_j(:,g_j_ind).*entry_vec,N,N);
        
        if i == j
        M = M + M_part;
        else
        M = M + M_part;
        M = M + M_part';
        end
        
    end
end
end