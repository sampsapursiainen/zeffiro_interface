function M = zef_surface_scalar_FF(nodes,tetra,scalar_field)

weighting = zef_barycentric_weighting('surface_FF');
M = zef_surface_scalar(nodes, tetra, scalar_field, weighting);

end