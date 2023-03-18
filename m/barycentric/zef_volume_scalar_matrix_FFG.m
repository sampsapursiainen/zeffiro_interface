function M = zef_volume_scalar_matrix_FFG(nodes, tetra, g_i_ind, scalar_field)

weighting = zef_barycentric_weighting('FF');
M = zef_volume_scalar_matrix_D(nodes, tetra, g_i_ind, scalar_field, weighting); 

end

