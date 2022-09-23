function M = zef_volume_scalar_GG(nodes,tetra,scalar_field,g_i_ind,g_j_ind)

weighting = 1;
M = zef_volume_scalar_DD(nodes,tetra,scalar_field,weighting,g_i_ind,g_j_ind);

end