function M = zef_surface_scalar_matrix_FG(nodes,tetra,g_i_ind,scalar_field)
%
% zef_surface_scalar_matrix_FG
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
M = zef_surface_scalar_matrix_D(nodes, tetra, g_i_ind, scalar_field, weighting);

end
