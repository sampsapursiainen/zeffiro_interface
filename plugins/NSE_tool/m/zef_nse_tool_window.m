function zef = zef_nse_tool_window(zef)

zef_data = zef_nse_app;

zef = zef_nse_tool_init(zef);

zef.nse_field.reconstruction_type_list = cell(0); 

zef.nse_field.reconstruction_type_list{1} = [1 2 3 6 7 8 9 10 11 12 13 14];
zef.nse_field.reconstruction_type_list{2} = [4 5 15 16 17];

zef.nse_field.h_plot_sphere = zef_data.h_plot_sphere;
zef.nse_field.h_plot_roi = zef_data.h_plot_roi;
zef.nse_field.h_plot_graph = zef_data.h_plot_graph;
zef.nse_field.h_apply_roi = zef_data.h_apply_roi;
zef.nse_field.h_apply_source_coordinates = zef_data.h_apply_source_coordinates;
zef.nse_field.h_apply_dir_v = zef_data.h_apply_dir_v;

zef.nse_field.h_nse_tool = zef_data.h_nse_tool;
zef.nse_field.h_nse_tool.Name = 'ZEFFIRO Interface: NSE tool';
zef.nse_field.h_solve_system = zef_data.h_solve_system;
zef.nse_field.h_parse_reconstruction = zef_data.h_parse_reconstruction;
zef.nse_field.h_nse_sigma = zef_data.h_nse_sigma;
zef.nse_field.h_interpolate = zef_data.h_interpolate;
zef.nse_field.h_use_gpu = zef_data.h_use_gpu;
zef.nse_field.h_use_gpu.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pcg_tol = zef_data.h_pcg_tol;
zef.nse_field.h_pcg_tol.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pcg_maxit = zef_data.h_pcg_maxit;
zef.nse_field.h_pcg_maxit.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_gravity_x = zef_data.h_gravity_x;
zef.nse_field.h_gravity_x.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_gravity_y = zef_data.h_gravity_y;
zef.nse_field.h_gravity_y.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_gravity_z = zef_data.h_gravity_z;
zef.nse_field.h_gravity_z.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_total_flow = zef_data.h_total_flow;
zef.nse_field.h_total_flow.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_conductivity_statistic = zef_data.h_conductivity_statistic;
zef.nse_field.h_conductivity_statistic.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_start_time = zef_data.h_start_time;
zef.nse_field.h_start_time.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_velocity_smoothing = zef_data.h_velocity_smoothing;
zef.nse_field.h_velocity_smoothing.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_n_frames = zef_data.h_n_frames;
zef.nse_field.h_n_frames.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_poisson_tolerance = zef_data.h_poisson_tolerance;
zef.nse_field.h_poisson_tolerance.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_sphere_radius = zef_data.h_sphere_radius;
zef.nse_field.h_sphere_radius.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_sphere_x = zef_data.h_sphere_x;
zef.nse_field.h_sphere_x.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_sphere_y = zef_data.h_sphere_y;
zef.nse_field.h_sphere_y.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_sphere_z = zef_data.h_sphere_z;
zef.nse_field.h_sphere_z.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_roi_radius = zef_data.h_roi_radius;
zef.nse_field.h_roi_radius.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_roi_x = zef_data.h_roi_x;
zef.nse_field.h_roi_x.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_roi_y = zef_data.h_roi_y;
zef.nse_field.h_roi_y.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_roi_z = zef_data.h_roi_z;
zef.nse_field.h_roi_z.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_dir_v_x = zef_data.h_dir_v_x;
zef.nse_field.h_dir_v_x.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_dir_v_y = zef_data.h_dir_v_y;
zef.nse_field.h_dir_v_y.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_dir_v_z = zef_data.h_dir_v_z;
zef.nse_field.h_dir_v_z.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_neural_drive = zef_data.h_neural_drive;
zef.nse_field.h_neural_drive.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_nvc_flow_based_elimination = zef_data.h_nvc_flow_based_elimination;
zef.nse_field.h_nvc_flow_based_elimination.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_nvc_signal_decay_rate = zef_data.h_nvc_signal_decay_rate;
zef.nse_field.h_nvc_signal_decay_rate.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_nvc_mollification = zef_data.h_nvc_mollification;
zef.nse_field.h_nvc_mollification.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_relative_blood_oxygenation = zef_data.h_relative_blood_oxygenation;
zef.nse_field.h_relative_blood_oxygenation.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_oxygen_consumption_rate = zef_data.h_oxygen_consumption_rate;
zef.nse_field.h_oxygen_consumption_rate.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_gravity_amplitude = zef_data.h_gravity_amplitude;
zef.nse_field.h_gravity_amplitude.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_time_length = zef_data.h_time_length;
zef.nse_field.h_time_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_time_step_length = zef_data.h_time_step_length;
zef.nse_field.h_time_step_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pulse_amplitude = zef_data.h_pulse_amplitude;
zef.nse_field.h_pulse_amplitude.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_cycle_length = zef_data.h_cycle_length;
zef.nse_field.h_cycle_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_p_wave_start = zef_data.h_p_wave_start;
zef.nse_field.h_p_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_t_wave_start = zef_data.h_t_wave_start;
zef.nse_field.h_t_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_d_wave_start = zef_data.h_d_wave_start;
zef.nse_field.h_d_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_p_wave_length = zef_data.h_p_wave_length;
zef.nse_field.h_p_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_t_wave_length = zef_data.h_t_wave_length;
zef.nse_field.h_t_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_d_wave_length = zef_data.h_d_wave_length;
zef.nse_field.h_d_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_p_wave_weight = zef_data.h_p_wave_weight;
zef.nse_field.h_p_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_t_wave_weight = zef_data.h_t_wave_weight;
zef.nse_field.h_t_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_d_wave_weight = zef_data.h_d_wave_weight;
zef.nse_field.h_d_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_conductivity_model = zef_data.h_conductivity_model;
zef.nse_field.h_conductivity_model.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_conductivity_exponent = zef_data.h_conductivity_exponent;
zef.nse_field.h_conductivity_exponent.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pressure_decay_in_arterioles = zef_data.h_pressure_decay_in_arterioles;
zef.nse_field.h_pressure_decay_in_arterioles.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_capillary_diameter = zef_data.h_capillary_diameter;
zef.nse_field.h_capillary_diameter.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_capillary_arteriole_total_area_ratio= zef_data.h_capillary_arteriole_total_area_ratio;
zef.nse_field.h_capillary_arteriole_total_area_ratio.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_pressure = zef_data.h_pressure;
zef.nse_field.h_pressure.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_rho = zef_data.h_rho;
zef.nse_field.h_rho.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_relaxation_time = zef_data.h_viscosity_relaxation_time;
zef.nse_field.h_viscosity_relaxation_time.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_smoothing = zef_data.h_viscosity_smoothing;
zef.nse_field.h_viscosity_smoothing.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_transition = zef_data.h_viscosity_transition;
zef.nse_field.h_viscosity_transition.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_arteriole_diameter = zef_data.h_arteriole_diameter;
zef.nse_field.h_arteriole_diameter.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_artery_diameter_change = zef_data.h_artery_diameter_change;
zef.nse_field.h_artery_diameter_change.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_venule_diameter = zef_data.h_venule_diameter;
zef.nse_field.h_venule_diameter.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_mu = zef_data.h_mu;
zef.nse_field.h_mu.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_artery_domain_ind = zef_data.h_artery_domain_ind;
zef.nse_field.h_artery_domain_ind.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_capillary_domain_ind = zef_data.h_capillary_domain_ind;
zef.nse_field.h_capillary_domain_ind.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_reconstruction_type = zef_data.h_reconstruction_type;
zef.nse_field.h_reconstruction_type.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_model = zef_data.h_viscosity_model;
zef.nse_field.h_viscosity_model.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_graph_type = zef_data.h_graph_type;
zef.nse_field.h_graph_type.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_exponent = zef_data.h_viscosity_exponent;
zef.nse_field.h_viscosity_exponent.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_max_reconstruction_quantile = zef_data.h_max_reconstruction_quantile;
zef.nse_field.h_max_reconstruction_quantile.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_min_reconstruction_quantile = zef_data.h_min_reconstruction_quantile;
zef.nse_field.h_min_reconstruction_quantile.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity_delta = zef_data.h_viscosity_delta;
zef.nse_field.h_viscosity_delta.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_blood_conductivity = zef_data.h_blood_conductivity;
zef.nse_field.h_blood_conductivity.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_solver_type = zef_data.h_solver_type;
zef.nse_field.h_solver_type.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_time_integration = zef_data.h_time_integration;
zef.nse_field.h_time_integration.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_use_gpu.Value = zef.nse_field.use_gpu;

zef.nse_field.h_pcg_tol.Value = zef.nse_field.pcg_tol;
zef.nse_field.h_pcg_maxit.Value = zef.nse_field.pcg_maxit;

zef.nse_field.h_capillary_arteriole_total_area_ratio.Value = zef.nse_field.capillary_arteriole_total_area_ratio;
zef.nse_field.h_total_flow.Value = zef.nse_field.total_flow;

zef.nse_field.h_conductivity_statistic.Items = {'All','Mean', 'STD','Maximum','Minimum'};
zef.nse_field.h_conductivity_statistic.ItemsData = [1 : length(zef.nse_field.h_conductivity_statistic.Items)];
zef.nse_field.h_conductivity_statistic.Value = zef.nse_field.conductivity_statistic;

zef.nse_field.h_rho.Value = zef.nse_field.rho;
zef.nse_field.h_mu.Value = zef.nse_field.mu;
zef.nse_field.h_start_time.Value = zef.nse_field.start_time;

zef.nse_field.h_poisson_tolerance.Value = zef.nse_field.poisson_tolerance;

zef.nse_field.h_arteriole_diameter.Value = zef.nse_field.arteriole_diameter;
zef.nse_field.h_venule_diameter.Value = zef.nse_field.venule_diameter;

zef.nse_field.h_max_reconstruction_quantile.Value = zef.nse_field.max_reconstruction_quantile;
zef.nse_field.h_min_reconstruction_quantile.Value = zef.nse_field.min_reconstruction_quantile;

zef.nse_field.h_artery_diameter_change.Value = zef.nse_field.artery_diameter_change;

zef.nse_field.h_gravity_x.Value = zef.nse_field.gravity_x;
zef.nse_field.h_gravity_y.Value = zef.nse_field.gravity_y;
zef.nse_field.h_gravity_z.Value = zef.nse_field.gravity_z;

zef.nse_field.h_sphere_radius.Value = num2str(zef.nse_field.sphere_radius);
zef.nse_field.h_sphere_x.Value = num2str(zef.nse_field.sphere_x);
zef.nse_field.h_sphere_y.Value = num2str(zef.nse_field.sphere_y);
zef.nse_field.h_sphere_z.Value = num2str(zef.nse_field.sphere_z);

zef.nse_field.h_roi_radius.Value = num2str(zef.nse_field.roi_radius);
zef.nse_field.h_roi_x.Value = num2str(zef.nse_field.roi_x);
zef.nse_field.h_roi_y.Value = num2str(zef.nse_field.roi_y);
zef.nse_field.h_roi_z.Value = num2str(zef.nse_field.roi_z);


zef.nse_field.h_dir_v_x.Value = num2str(zef.nse_field.dir_v_x);
zef.nse_field.h_dir_v_y.Value = num2str(zef.nse_field.dir_v_y);
zef.nse_field.h_dir_v_z.Value = num2str(zef.nse_field.dir_v_z);

zef.nse_field.h_viscosity_smoothing.Value = zef.nse_field.viscosity_smoothing;

zef.nse_field.h_gravity_amplitude.Value = zef.nse_field.gravity_amplitude;
zef.nse_field.h_time_length.Value = zef.nse_field.time_length;
zef.nse_field.h_time_step_length.Value = zef.nse_field.time_step_length;
zef.nse_field.h_pulse_amplitude.Value = zef.nse_field.pulse_amplitude;
zef.nse_field.h_cycle_length.Value = zef.nse_field.cycle_length;
zef.nse_field.h_p_wave_start.Value = zef.nse_field.p_wave_start;
zef.nse_field.h_t_wave_start.Value = zef.nse_field.t_wave_start;
zef.nse_field.h_d_wave_start.Value = zef.nse_field.d_wave_start;
zef.nse_field.h_p_wave_length.Value = zef.nse_field.p_wave_length;
zef.nse_field.h_t_wave_length.Value = zef.nse_field.t_wave_length;
zef.nse_field.h_d_wave_length.Value = zef.nse_field.d_wave_length;
zef.nse_field.h_p_wave_weight.Value = zef.nse_field.p_wave_weight;
zef.nse_field.h_t_wave_weight.Value = zef.nse_field.t_wave_weight;
zef.nse_field.h_d_wave_weight.Value = zef.nse_field.d_wave_weight;

zef.nse_field.h_neural_drive.Value = zef.nse_field.neural_drive;
zef.nse_field.h_nvc_flow_based_elimination.Value = zef.nse_field.nvc_flow_based_elimination;
zef.nse_field.h_nvc_signal_decay_rate.Value = zef.nse_field.nvc_signal_decay_rate;
zef.nse_field.h_nvc_mollification.Value = zef.nse_field.nvc_mollification;
zef.nse_field.h_relative_blood_oxygenation.Value = zef.nse_field.relative_blood_oxygenation;
zef.nse_field.h_oxygen_consumption_rate.Value = zef.nse_field.oxygen_consumption_rate;

zef.nse_field.h_n_frames.Value = zef.nse_field.n_frames;

zef.nse_field.h_viscosity_relaxation_time.Value = zef.nse_field.viscosity_relaxation_time;
zef.nse_field.h_viscosity_transition.Value = zef.nse_field.viscosity_transition;

zef.nse_field.h_viscosity_exponent.Value = zef.nse_field.viscosity_exponent;
zef.nse_field.h_viscosity_delta.Value = zef.nse_field.viscosity_delta;

zef.nse_field.h_velocity_smoothing.Value = zef.nse_field.velocity_smoothing;

zef.nse_field.h_blood_conductivity.Value = zef.nse_field.blood_conductivity;
zef.nse_field.h_conductivity_exponent.Value = zef.nse_field.conductivity_exponent;
zef.nse_field.h_pressure_decay_in_arterioles.Value = zef.nse_field.pressure_decay_in_arterioles;
zef.nse_field.h_capillary_diameter.Value = zef.nse_field.capillary_diameter;
zef.nse_field.h_pressure.Value = zef.nse_field.pressure;

zef.nse_field.h_viscosity_model.Items = {'Constant','Power law','Carreau-Yasuda','Walburn-Schneck','Genaralized power law','Casson'};
zef.nse_field.h_viscosity_model.ItemsData = [1 : length(zef.nse_field.h_viscosity_model.Items)];
zef.nse_field.h_viscosity_model.Value = zef.nse_field.viscosity_model;

zef.nse_field.h_graph_type.Items = {'Pressure (full)','Pressure (epoch)','Pressure (full seperated)','Pressure (epoch forward separation)','Pressure (epoch backward separation)','Pressure histogram', 'Velocity (full)', 'Velocity (epoch)', 'Velocity (full seperated)','Velocity (epoch forward separation)','Velocity (epoch backward separation)','Velocity histogram', 'Viscosity (full)','Viscosity (epoch)' ,'Viscosity histogram','Perfusion (full)', 'Perfusion (epoch)', 'Perfusion histogram', 'Pulse function','Pulse histogram','Volumetric concentration','Oxy/Deoxy hemoglobin','Oxy/Deoxy hemoglobin peak radius'};
zef.nse_field.h_graph_type.ItemsData = [1 : length(zef.nse_field.h_graph_type.Items)];
zef.nse_field.h_graph_type.Value = zef.nse_field.graph_type;

zef.nse_field.h_conductivity_model.Items = {'Archie''s law','Hashin-Shtrikman upper bound','Hashin-Shtrikman lower bound'};
zef.nse_field.h_conductivity_model.ItemsData = [1 : length(zef.nse_field.h_conductivity_model.Items)];
zef.nse_field.h_conductivity_model.Value = zef.nse_field.conductivity_model;

zef.nse_field.h_reconstruction_type.Items = {'Pressure (Arteries)','Velocity (Arteries)','Viscosity (Arteries)','Concentration (Microcirculation)','Deoxygenized hemoglobin concentration (Microcirculation)', 'Mean pressure (Arteries)','Maximum pressure (Arteries)','STD pressure (Arteries)','Mean velocity (Arteries)','Maximum velocity (Arteries)','STD velocity (Arteries)','Mean viscosity (Arteries)','Maximum viscosity (Arteries)','STD viscosity (Arteries)','Mean concentration (Microcirculation)','Maximum concentration (Microcirculation)','STD concentration (Microcirculation)'};
zef.nse_field.h_reconstruction_type.ItemsData = [1 : length(zef.nse_field.h_reconstruction_type.Items)];
zef.nse_field.h_reconstruction_type.Value = zef.nse_field.reconstruction_type;

zef.nse_field.h_solver_type.Items = {'Poisson','Poisson & microcirculation','Poisson, microcirculation & haemodynamic response', 'Dynamic Stokes','Dynamic Stokes & microcirculation', 'Dynamic Navier-Stokes','Dynamic Navier-Stokes & microcirculation'};
zef.nse_field.h_solver_type.ItemsData = [1 : length(zef.nse_field.h_solver_type.Items)];
zef.nse_field.h_solver_type.Value = zef.nse_field.solver_type;

zef.nse_field.h_time_integration.Items = {'Euler','Trapezoid','Runge-Kutta'};
zef.nse_field.h_time_integration.ItemsData = [1 : length(zef.nse_field.h_time_integration.Items)];
zef.nse_field.h_time_integration.Value = zef.nse_field.time_integration;

zef.nse_field.h_solve_system.ButtonPushedFcn = 'zef_nse_run_solver';
zef.nse_field.h_parse_reconstruction.ButtonPushedFcn = 'zef.inv_time_1 = zef.nse_field.inv_time_1; zef.inv_time_2 = zef.nse_field.inv_time_2; zef.inv_time_3 = zef.nse_field.inv_time_3; [zef.reconstruction, zef.reconstruction_information] = zef_nse_reconstruction(zef.nse_field,zef.nse_field.h_reconstruction_type.Value);';
zef.nse_field.h_interpolate.ButtonPushedFcn = 'zef = zef_nse_interpolate(zef,zef.nse_field.h_reconstruction_type.Value);';
zef.nse_field.h_nse_sigma.ButtonPushedFcn = 'zef.nse_sigma = zef_nse_sigma(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.sigma,zef.source_interpolation_ind{1});';
zef.nse_field.h_plot_sphere.ButtonPushedFcn = 'zef_nse_plot_sphere;';
zef.nse_field.h_plot_roi.ButtonPushedFcn = 'zef_nse_plot_roi;';
zef.nse_field.h_apply_roi.ButtonPushedFcn = 'zef_nse_apply_roi';
zef.nse_field.h_apply_source_coordinates.ButtonPushedFcn = 'zef_nse_apply_source';
zef.nse_field.h_apply_dir_v.ButtonPushedFcn = 'zef_nse_dir_v_node;';

zef.nse_field.h_plot_graph.ButtonPushedFcn = 'zef_nse_plot_graph;';

zef.nse_field.h_artery_domain_ind.Items = cell(0);
for i = 1 : length(zef.compartment_tags)
    zef.nse_field.h_artery_domain_ind.Items{i} = eval(['zef.' zef.compartment_tags{i} '_name']);
end
zef.nse_field.h_artery_domain_ind.ItemsData = [1:length(zef.nse_field.h_artery_domain_ind.Items)];
zef.nse_field.h_artery_domain_ind.Multiselect = 'on';
zef.nse_field.h_artery_domain_ind.Value = zef.nse_field.artery_domain_ind;

zef.nse_field.h_capillary_domain_ind.Items = cell(0);
for i = 1 : length(zef.compartment_tags)
    zef.nse_field.h_capillary_domain_ind.Items{i} = eval(['zef.' zef.compartment_tags{i} '_name']);
end
zef.nse_field.h_capillary_domain_ind.ItemsData = [1:length(zef.nse_field.h_capillary_domain_ind.Items)];
zef.nse_field.h_capillary_domain_ind.Multiselect = 'on';
zef.nse_field.h_capillary_domain_ind.Value = zef.nse_field.capillary_domain_ind;

end
