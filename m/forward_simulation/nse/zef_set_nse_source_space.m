function zef = zef_set_nse_source_space(zef,nse_field)

zef.source_positions = nse_field.nodes(nse_field.i_node_ind,:);
zef.source_orientations = [];
zef = zef_source_interpolation(zef);
 
end