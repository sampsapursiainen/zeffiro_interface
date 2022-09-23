function M = zef_volume_scalar_D(nodes, tetra, scalar_field, weighting, g_i_ind)

N = size(nodes,1);
K = size(tetra,1);

if nargin < 4
weighting = 1;    
end

if nargin < 3
scalar_field = ones(size(tetra,1),1);
end

if length(weighting)==1
weight_param = weighting([1 1]);
else
weight_param = weighting;
end

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

M = spalloc(N,N,0);

for i = 1 : 4
[g_i] = zef_volume_barycentric(nodes,tetra,i,det);
    for j = i : 4
        
        if i == j
        entry_vec = volume*weight_param(1);
        else
        entry_vec = volume*weight_param(2);
        end
        M_part =  sparse(tetra(:,i),tetra(:,j),scalar_field.*g_i(:,g_i_ind).*entry_vec,N,N);       
        if i == j
        M = M + M_part;
        else
        M = M + M_part;
        M = M + M_part';
        end
        
    end
end

end