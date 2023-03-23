function zef = zef_nse_tool_update(zef)

zef.nse_field.use_gpu = zef.nse_field.h_use_gpu.Value;
zef.nse_field.pcg_tol = zef.nse_field.h_pcg_tol.Value;
zef.nse_field.pcg_maxit = zef.nse_field.h_pcg_maxit.Value;
zef.nse_field.rho = zef.nse_field.h_rho.Value;
zef.nse_field.mu = zef.nse_field.h_mu.Value;

zef.nse_field.pressure_decay_in_arterioles = zef.nse_field.h_pressure_decay_in_arterioles.Value;

zef.nse_field.capillary_diameter = zef.nse_field.h_capillary_diameter.Value;

zef.nse_field.pressure = zef.nse_field.h_pressure.Value; 

zef.nse_field.blood_conductivity = zef.nse_field.h_blood_conductivity.Value; 

zef.nse_field.gravity_x = zef.nse_field.h_gravity_x.Value; 
zef.nse_field.gravity_y = zef.nse_field.h_gravity_y.Value; 
zef.nse_field.gravity_z = zef.nse_field.h_gravity_z.Value;

zef.nse_field.conductivity_model = zef.nse_field.h_conductivity_model.Value;
zef.nse_field.conductivity_exponent = zef.nse_field.h_conductivity_exponent.Value;


zef.nse_field.arteriole_diameter = zef.nse_field.h_arteriole_diameter.Value;
zef.nse_field.venule_diameter = zef.nse_field.h_venule_diameter.Value;


zef.nse_field.total_flow = zef.nse_field.h_total_flow.Value; 
zef.nse_field.capillary_arteriole_total_area_ratio = zef.nse_field.h_capillary_arteriole_total_area_ratio.Value; 

zef.nse_field.capillary_domain_ind = zef.nse_field.h_capillary_domain_ind.Value; 
zef.nse_field.artery_domain_ind = zef.nse_field.h_artery_domain_ind.Value; 

zef.nse_field.reconstruction_type = zef.nse_field.h_reconstruction_type.Value; 
zef.nse_field.solver_type = zef.nse_field.h_solver_type.Value; 

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


end

