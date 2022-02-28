warning('off');
zef.gravity_field_type = 1;
zef_delete_original_field;
zef_process_meshes;
[zef.L,  zef.bg_data, zef.source_positions, zef.source_directions] = lead_field_gravity_grad(zef.nodes,zef.tetra,zef.rho,zef.sensors,zef.active_compartment_ind);
warning('on');