function M = zef_surface_scalar_matrix_FF(nodes,tetra,scalar_field)
%
% zef_surface_scalar_matrix_FF
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

weighting = zef_barycentric_weighting('surface_FF');
M = zef_surface_scalar_matrix(nodes, tetra, scalar_field, weighting);

end
