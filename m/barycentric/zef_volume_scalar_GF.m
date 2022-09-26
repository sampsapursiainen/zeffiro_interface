function M = zef_volume_scalar_GF(nodes,tetra,g_i_ind,scalar_field)

weighting = zef_barycentric_weighting('GF');
M = zef_volume_scalar_D(nodes, tetra, g_i_ind, scalar_field, weighting);

end