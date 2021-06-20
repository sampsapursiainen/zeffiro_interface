if zef.downsample_surfaces == 1; 
zef_downsample_surfaces; 
end; 
zef.source_interpolation_on = 1; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); 
[zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);
zef.tetra_aux = zef.tetra; 
[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); 
zef.n_sources_mod = 1; 
zef.source_ind = []; 
[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);
[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);
lead_field_matrix;

