function M = zef_volume_scalar_matrix_D(nodes, tetra, g_i_ind, scalar_field, weighting)

N = size(nodes,1);

if nargin < 5
weighting = 1;    
end

if nargin < 4
scalar_field = ones(size(tetra,1),1);
end

weight_param = weighting;

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

M = spalloc(N,N,0);

entry_vec = volume*weight_param;

    for i = 1 : 4

    [g_i] = zef_volume_barycentric(nodes,tetra,i);
    
        for j = 1 : 4       

        M_part = sparse(tetra(:,j),tetra(:,i),scalar_field.*g_i(:,g_i_ind).*entry_vec,N,N);       
        M = M + M_part;
        
        end 
        
    end
    
end