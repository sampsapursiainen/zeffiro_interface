addpath('./m');

%project_file_name = 'Inverted_project10.mat';%'P20-N20_synthetic_1accuracy-1mmresolution_200.mat';
load(project_file_name);
zef = zef_data;
clear zef_data;

zef.n_sources = 100000;

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

zef_data = zef;
zef_data.fieldnames = fieldnames(zef);
zef_data = rmfield(zef_data,zef_data.fieldnames(find(startsWith(zef_data.fieldnames, 'h_'))));
%zef_data = rmfield(zef_data,{'fieldnames','h'});
save([file_name],'zef_data','-v7.3');
clear zef_data;

exit;
