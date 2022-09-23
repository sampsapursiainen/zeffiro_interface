function M = zef_volume_scalar_FF(nodes, tetra, scalar_field)

weighting = [1/10,1/20];
M = zef_volume_scalar(nodes, tetra, scalar_field, weighting); 

end
