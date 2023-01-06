function M = zef_volume_scalar_matrix_FF(nodes, tetra, scalar_field)

if nargin < 3
    scalar_field = ones(size(tetra,1),1);
end

weighting = zef_barycentric_weighting('FF');
M = zef_volume_scalar_matrix(nodes, tetra, scalar_field, weighting); 

end
