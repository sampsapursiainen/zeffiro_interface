function M = zef_volume_scalar_matrix_GG(nodes,tetra,g_i_ind,g_j_ind,scalar_field)
%
% zef_volume_scalar_matrix_GG
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
% - g_j_ind
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

weighting = zef_barycentric_weighting('GG');
M = zef_volume_scalar_matrix_DD(nodes,tetra,g_i_ind,g_j_ind,scalar_field,weighting);

end
