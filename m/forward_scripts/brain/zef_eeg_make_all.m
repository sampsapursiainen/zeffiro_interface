warning('off');
zef.lead_field_type = 1;
zef.source_interpolation_on = 1;
set(zef.h_source_interpolation_on,'value',1);
zef_create_finite_element_mesh;
zef_postprocess_finite_element_mesh;
zef.n_sources_mod = 1;
zef.source_ind = [];
zef_update_fig_details;
<<<<<<< HEAD
zef_process_meshes; 
=======
zef_process_meshes;
zef.sensors = [zef.sensors(:,1:3) evalin('base',['zef.' zef.current_sensors '_electrode_outer_radius(:)']) evalin('base',['zef.' zef.current_sensors '_electrode_inner_radius(:)']) evalin('base',['zef.' zef.current_sensors '_electrode_impedance(:)'])];
>>>>>>> 5b5c6faff4d84098629188095d4264ae682a8077
zef_attach_sensors_volume(zef.sensors);
lead_field_matrix;
warning('on');