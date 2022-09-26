function M = zef_volume_scalar_FF(nodes, tetra, scalar_field)

weighting = zef_barycentric_weighting('FF');
M = zef_volume_scalar(nodes, tetra, scalar_field, weighting); 

end
