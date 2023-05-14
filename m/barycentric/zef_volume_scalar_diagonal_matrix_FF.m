function M = zef_volume_scalar_diagonal_matrix_FF(nodes, tetra, scalar_field)
%
% zef_volume_scalar_diagonal_matrix_FF
%
% TODO: Sampsa should document this.
%
% Inputs:
%
% - nodes
%
%   TODO: explanation.
%
% - tetra
%
%   TODO: explanation.
%
% - scalar_field
%
%   TODO: explanation.
%
% Outputs:
%
% - M
%
%   TODO: explanation.
%

if nargin < 3
    scalar_field = ones(size(tetra,1),1);
end

weighting = zef_barycentric_weighting('FF');
M = zef_volume_scalar_diagonal_matrix(nodes, tetra, scalar_field, weighting);

end
