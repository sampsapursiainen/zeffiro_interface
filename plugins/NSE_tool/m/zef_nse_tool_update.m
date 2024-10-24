function zef = zef_nse_tool_update(zef)

zef.nse_field.use_gpu = zef.nse_field.h_use_gpu.Value;
zef.nse_field.pcg_tol = zef.nse_field.h_pcg_tol.Value;
zef.nse_field.pcg_maxit = zef.nse_field.h_pcg_maxit.Value;
zef.nse_field.rho = zef.nse_field.h_rho.Value;
zef.nse_field.mu = zef.nse_field.h_mu.Value;

zef.nse_field.viscosity_model = zef.nse_field.h_viscosity_model.Value;
zef.nse_field.viscosity_exponent = zef.nse_field.h_viscosity_exponent.Value;
zef.nse_field.viscosity_delta = zef.nse_field.h_viscosity_delta.Value;

zef.nse_field.pressure_decay_in_arterioles = zef.nse_field.h_pressure_decay_in_arterioles.Value;

zef.nse_field.velocity_smoothing = zef.nse_field.h_velocity_smoothing.Value;

zef.nse_field.poisson_tolerance = zef.nse_field.h_poisson_tolerance.Value;

zef.nse_field.viscosity_smoothing = zef.nse_field.h_viscosity_smoothing.Value;

zef.nse_field.time_integration = zef.nse_field.h_time_integration.Value;

zef.nse_field.capillary_diameter = zef.nse_field.h_capillary_diameter.Value;

zef.nse_field.pressure = zef.nse_field.h_pressure.Value;

zef.nse_field.start_time = zef.nse_field.h_start_time.Value;

zef.nse_field.blood_conductivity = zef.nse_field.h_blood_conductivity.Value;

zef.nse_field.gravity_x = zef.nse_field.h_gravity_x.Value;
zef.nse_field.gravity_y = zef.nse_field.h_gravity_y.Value;
zef.nse_field.gravity_z = zef.nse_field.h_gravity_z.Value;

zef.nse_field.conductivity_model = zef.nse_field.h_conductivity_model.Value;
zef.nse_field.conductivity_exponent = zef.nse_field.h_conductivity_exponent.Value;

zef.nse_field.conductivity_statistic = zef.nse_field.h_conductivity_statistic.Value;

zef.nse_field.arteriole_diameter = zef.nse_field.h_arteriole_diameter.Value;
zef.nse_field.venule_diameter = zef.nse_field.h_venule_diameter.Value;

zef.nse_field.total_flow = zef.nse_field.h_total_flow.Value;
zef.nse_field.capillary_arteriole_total_area_ratio = zef.nse_field.h_capillary_arteriole_total_area_ratio.Value;

zef.nse_field.capillary_domain_ind = zef.nse_field.h_capillary_domain_ind.Value;
zef.nse_field.artery_domain_ind = zef.nse_field.h_artery_domain_ind.Value;

zef.nse_field.viscosity_relaxation_time = zef.nse_field.h_viscosity_relaxation_time.Value;
zef.nse_field.viscosity_transition = zef.nse_field.h_viscosity_transition.Value;

zef.nse_field.reconstruction_type = zef.nse_field.h_reconstruction_type.Value;
zef.nse_field.graph_type = zef.nse_field.h_graph_type.Value;
zef.nse_field.solver_type = zef.nse_field.h_solver_type.Value;

zef.nse_field.max_reconstruction_quantile = zef.nse_field.h_max_reconstruction_quantile.Value;
zef.nse_field.min_reconstruction_quantile = zef.nse_field.h_min_reconstruction_quantile.Value;

zef.nse_field.artery_diameter_change = zef.nse_field.h_artery_diameter_change.Value;

zef.nse_field.gravity_amplitude = zef.nse_field.h_gravity_amplitude.Value;
zef.nse_field.time_length = zef.nse_field.h_time_length.Value;
zef.nse_field.time_step_length = zef.nse_field.h_time_step_length.Value;
zef.nse_field.pulse_amplitude = zef.nse_field.h_pulse_amplitude.Value;
zef.nse_field.cycle_length = zef.nse_field.h_cycle_length.Value;
zef.nse_field.p_wave_start = zef.nse_field.h_p_wave_start.Value;
zef.nse_field.t_wave_start = zef.nse_field.h_t_wave_start.Value;
zef.nse_field.d_wave_start = zef.nse_field.h_d_wave_start.Value;
zef.nse_field.p_wave_length = zef.nse_field.h_p_wave_length.Value ;
zef.nse_field.t_wave_length = zef.nse_field.h_t_wave_length.Value;
zef.nse_field.d_wave_length = zef.nse_field.h_d_wave_length.Value;
zef.nse_field.p_wave_weight = zef.nse_field.h_p_wave_weight.Value;
zef.nse_field.t_wave_weight = zef.nse_field.h_t_wave_weight.Value;
zef.nse_field.d_wave_weight = zef.nse_field.h_d_wave_weight.Value;

zef.nse_field.sphere_radius = str2num(zef.nse_field.h_sphere_radius.Value);
zef.nse_field.sphere_x = str2num(zef.nse_field.h_sphere_x.Value);
zef.nse_field.sphere_y = str2num(zef.nse_field.h_sphere_y.Value);
zef.nse_field.sphere_z = str2num(zef.nse_field.h_sphere_z.Value);

zef.nse_field.roi_radius = str2num(zef.nse_field.h_roi_radius.Value);
zef.nse_field.roi_x = str2num(zef.nse_field.h_roi_x.Value);
zef.nse_field.roi_y = str2num(zef.nse_field.h_roi_y.Value);
zef.nse_field.roi_z = str2num(zef.nse_field.h_roi_z.Value);

zef.nse_field.n_frames = zef.nse_field.h_n_frames.Value;

zef.nse_field.neural_drive = zef.nse_field.h_neural_drive.Value;
zef.nse_field.nvc_flow_based_elimination = zef.nse_field.h_nvc_flow_based_elimination.Value;
zef.nse_field.nvc_signal_decay_rate = zef.nse_field.h_nvc_signal_decay_rate.Value;
zef.nse_field.nvc_mollification = zef.nse_field.h_nvc_mollification.Value;
zef.nse_field.relative_blood_oxygenation = zef.nse_field.h_relative_blood_oxygenation.Value;
zef.nse_field.oxygen_consumption_rate = zef.nse_field.h_oxygen_consumption_rate.Value;

end

