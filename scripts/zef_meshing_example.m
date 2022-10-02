function zef_meshing_example


% Set mesh resolution
project_struct.mesh_resolution = 4.5;
project_struct.n_sources = 1000;
project_struct.source_direction_mode = 1;
project_struct.mesh_smoothing_on = 1;
project_struct.refinement_on = 1;
project_struct.use_gpu = 1;
project_struct.forward_simulation_selected = 1;
project_struct.refinement_surface_compartments = [10 -1 1 18 17];
project_struct.refinement_surface_on = 1;

% Create finite element mesh
project_struct = zef_create_finite_element_mesh(project_struct);



end