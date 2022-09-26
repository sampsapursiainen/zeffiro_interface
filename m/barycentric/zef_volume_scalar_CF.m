function M = zef_volume_scalar_F(nodes,tetra,scalar_field)

weighting = zef_barycentric_weighting('CF');
M = zef_volume_scalar(nodes, tetra, scalar_field, weighting); 

end