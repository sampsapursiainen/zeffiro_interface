function M = zef_surface_scalar_matrix_FFn(nodes,tetra,n_ind,scalar_field)

weighting = zef_barycentric_weighting('surface_FF');
M = zef_surface_scalar_matrix_n(nodes, tetra, n_ind, scalar_field, weighting);

end