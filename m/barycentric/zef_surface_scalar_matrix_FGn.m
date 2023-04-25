function M = zef_surface_scalar_matrix_FGn(nodes,tetra,g_i_ind,n_ind,scalar_field)
%
% zef_surface_scalar_matrix_FGn
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
% - g_i_ind
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

weighting = zef_barycentric_weighting('surface_FG');
M = zef_surface_scalar_matrix_Dn(nodes, tetra, g_i_ind, n_ind, scalar_field, weighting);

end
