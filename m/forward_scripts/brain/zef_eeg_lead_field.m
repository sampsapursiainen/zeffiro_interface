warning('off');
zef.lead_field_type = 1;
zef_delete_original_field;
zef_process_meshes;
zef.sensors = [zef.sensors(:,1:3) evalin('base',['zef.' zef.current_sensors '_electrode_outer_radius(:)']) evalin('base',['zef.' zef.current_sensors '_electrode_inner_radius(:)']) evalin('base',['zef.' zef.current_sensors '_electrode_impedance(:)'])];
zef_attach_sensors_volume(zef.sensors);
lead_field_matrix;
warning('on');