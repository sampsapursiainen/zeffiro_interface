function M = zef_surface_scalar_FFn(nodes,tetra,n_ind,scalar_field)

weighting = zef_barycentric_weighting('surface_FF');
M = zef_surface_scalar_n(nodes, tetra, n_ind, scalar_field, weighting);

end