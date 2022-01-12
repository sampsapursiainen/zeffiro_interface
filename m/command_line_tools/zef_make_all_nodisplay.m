if zef.downsample_surfaces == 1; 
zef_downsample_surfaces; 
end; 
zef.source_interpolation_on = 1; 
zef_process_meshes; 
zef_create_fem_mesh;  
zef_postprocess_fem_mesh; 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
zef_process_meshes; 
zef_assign_data;
zef_attach_sensors_volume(zef.sensors);
lead_field_matrix;

