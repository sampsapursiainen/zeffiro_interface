warning('off');
zef.lead_field_type = 1;
zef_delete_original_field;
zef_process_meshes;
zef_attach_sensors_volume(zef.sensors);
lead_field_matrix;
[zef.L,zef.source_positions,zef.source_directions] = zef_lead_field_filter(zef.L,zef.source_positions,zef.source_directions,zef.lead_field_filter_quantile);
warning('on');
