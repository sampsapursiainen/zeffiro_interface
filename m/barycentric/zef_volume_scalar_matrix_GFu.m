function M = zef_volume_scalar_matrix_GFu(nodes,tetra,g_i_ind,scalar_field)
%
% zef_volume_scalar_matrix_Gfu
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

weighting = zef_barycentric_weighting('FF');
M = zef_volume_scalar_matrix_D(nodes, tetra, g_i_ind, scalar_field, weighting);

end
