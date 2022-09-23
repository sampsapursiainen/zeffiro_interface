function M = zef_volume_scalar_F(nodes,tetra,scalar_field)

weighting = [1/6];
M = zef_volume_scalar(nodes, tetra, scalar_field, weighting); 

end