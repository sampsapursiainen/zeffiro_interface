function M = zef_volume_scalar_matrix_CC(nodes, tetra, scalar_field)

K = size(tetra,1);

if nargin < 3
scalar_field = ones(size(tetra,1),1);
end

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

aux_vec = scalar_field.*volume;

M = spdiags(aux_vec,0,K,K);

end