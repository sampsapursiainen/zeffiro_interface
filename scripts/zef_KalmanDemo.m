function KalmanDemo()
% How to use kalman without GUI

% Create project
project_struct = zeffiro_interface('start_mode','nodisplay','import_to_new_project','scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');

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

% Create lead field matrix
project_struct = zef_eeg_lead_field(project_struct);

% Save project
project_struct = zef_save(project_struct,'example_project.mat','data/');

zef_close_all;

end