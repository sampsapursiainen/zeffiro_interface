function M = zef_surface_scalar_matrix_FFn(nodes,tetra,n_ind,scalar_field)
%
% zef_surface_scalar_matrix_FFn
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
% - n_ind
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
M = zef_surface_scalar_matrix_n(nodes, tetra, n_ind, scalar_field, weighting);

end
