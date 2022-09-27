function KalmanDemo()
% How to use kalman without GUI

% Create project
project_struct = zeffiro_interface('start_mode','nodisplay','import_to_existing_project','scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');

% Set mesh resolution
project_struct.mesh_resolution = 3;

% Create finite element mesh
project_struct = zef_create_finite_element_mesh(project_struct);

% Save project
zef_save(project_struct,'example_project.mat','data/');
end