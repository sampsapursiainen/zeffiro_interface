

%%
project_struct = zef_KalmanDemo_open_and_create_measurement();
%%
project_struct = zef_KalmanDemo_runKalman(project_struct);
%%
project_struct = zef_KalmanDemo_visualize(project_struct);
%%
project_struct = zef_KalmanDemo_save(project_struct);
%%


function project_struct = zef_KalmanDemo_runKalman(project_struct)
% How to use kalman without GUI
% kalman settings
project_struct.inv_snr = 26;
project_struct.inv_sampling_frequency = 5000;
project_struct.inv_low_cut_frequency = 0;
project_struct.inv_high_cut_frequency = 0;
project_struct.number_of_frames = 118;
project_struct.inv_time_1 = 0.115;
project_struct.inv_time_2 = 0;
project_struct.inv_time_3 = 0.0002;
project_struct.normalize_data = 1;
project_struct.inv_evolution_prior = -34;
% 1 kalman, 2 enkf, 3 kalman sl, 4 kalman spatial sl
project_struct.filter_type = 1;
% 1 none, 2 RTS
project_struct.kf_smoothing = 1;

% run the inverse method
[project_struct] = zef_KF(project_struct);

end

function project_struct = zef_KalmanDemo_save(project_struct)
% Save project
zef_save(project_struct,'example_project.mat','data/');
zef_close_all(project_struct);
end

function project_struct = zef_KalmanDemo_open_and_create_measurement()
    % Create project
%project_struct = zeffiro_interface('start_mode','nodisplay','import_to_existing_project','scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');
project_struct = zeffiro_interface('start_mode','nodisplay','open_project', 'data/example_projects/multicompartment_head_project.mat');
% Set mesh resolution
project_struct.mesh_resolution = 4.5;
project_struct.n_sources = 2000;
project_struct.source_direction_mode = 1;
project_struct.mesh_smoothing_on = 1;
project_struct.refinement_on = 1;
project_struct.forward_simulation_selected = 1;
%project_struct.refinement_surface_compartments = [ -1    22    21    10    11    12    13    14     1];
project_struct.refinement_surface_on = 1;


% Create finite element mesh
project_struct = zef_create_finite_element_mesh(project_struct);

project_struct.n_sources = 2000;
project_struct.source_direction_mode = 1;


project_struct = zef_eeg_lead_field(project_struct);

% create a measurement
load('data/SEP_synth_source_data.mat', 'SEP_synth_source_data');
project_struct.synth_source_data = SEP_synth_source_data;

% zef_generate_time_sequence()
project_struct.fss_bg_noise = -46;
project_struct = find_synthetic_source(project_struct);
project_struct = zef_update_fss(project_struct);
[project_struct.time_sequence, project_struct.time_variable] = zef_generate_time_sequence(project_struct);
project_struct = zef_update_fss(project_struct);

% h_create_synth_data
project_struct = zef_update_fss(project_struct);
[project_struct.measurements] = zef_find_source(project_struct);
end

function project_struct = zef_KalmanDemo_visualize(project_struct)
zef.h_zeffiro.Visible = 'on';
zef.use_display = 1;

project_struct.use_display = 1;
project_struct.visualization_type = 3;
zef = project_struct;
zef_visualize_surfaces;


end



