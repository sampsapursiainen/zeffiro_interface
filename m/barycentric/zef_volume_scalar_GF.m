function M = zef_volume_scalar_GF(nodes,tetra,scalar_field,g_i_ind)

weighting = 1/6;
M = zef_volume_scalar_D(nodes,tetra,scalar_field,weighting,g_i_ind);

end