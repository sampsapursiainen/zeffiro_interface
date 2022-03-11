warning('off');
zef.gravity_field_type = 3;
zef_delete_original_field;
zef_process_meshes;
[zef.L,  zef.bg_data, zef.source_positions, zef.source_directions] = lead_field_gravity(zef.nodes,zef.tetra,zef.rho,zef.sensors,zef.active_compartment_ind);
warning('on');
