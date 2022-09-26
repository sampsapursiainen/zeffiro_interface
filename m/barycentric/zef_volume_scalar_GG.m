function M = zef_volume_scalar_GG(nodes,tetra,g_i_ind,g_j_ind,scalar_field)

weighting = zef_barycentric_weighting('GG');
M = zef_volume_scalar_DD(nodes,tetra,g_i_ind,g_j_ind,scalar_field,weighting);

end