function M = zef_surface_scalar_FGn(nodes,tetra,g_i_ind,n_ind,scalar_field)

weighting = zef_barycentric_weighting('surface_FG');
M = zef_surface_scalar_Dn(nodes, tetra, g_i_ind, n_ind, scalar_field, weighting);

end