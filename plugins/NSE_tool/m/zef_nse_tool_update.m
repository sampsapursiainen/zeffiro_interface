function zef = zef_nse_tool_update(zef)

zef.nse_field.number_of_frames = zef.nse_field.h_number_of_frames.Value;
zef.nse_field.use_gpu = zef.nse_field.h_use_gpu.Value;
zef.nse_field.time_length = zef.nse_field.h_time_length.Value;
zef.nse_field.cycle_length = zef.nse_field.h_cycle_length.Value;

zef.nse_field.pcg_tol = zef.nse_field.h_pcg_tol.Value;
zef.nse_field.pcg_maxit = zef.nse_field.h_pcg_maxit.Value;
zef.nse_field.time_step_length = zef.nse_field.h_time_step_length.Value;
zef.nse_field.pulse_mode = zef.nse_field.h_pulse_mode.Value; 

zef.nse_field.density = zef.nse_field.h_density.Value;
zef.nse_field.viscosity = zef.nse_field.h_viscosity.Value;

zef.nse_field.systolic_pressure = zef.nse_field.h_systolic_pressure.Value; 
zef.nse_field.diastolic_pressure = zef.nse_field.h_diastolic_pressure.Value; 
zef.nse_field.artery_diameter = zef.nse_field.h_artery_diameter.Value; 

zef.nse_field.p_wave_start = zef.nse_field.h_p_wave_start.Value; 
zef.nse_field.p_wave_length = zef.nse_field.h_p_wave_length.Value; 
zef.nse_field.p_wave_weight = zef.nse_field.h_p_wave_weight.Value; 

zef.nse_field.t_wave_start = zef.nse_field.h_t_wave_start.Value; 
zef.nse_field.t_wave_length = zef.nse_field.h_t_wave_length.Value; 
zef.nse_field.t_wave_weight = zef.nse_field.h_t_wave_weight.Value; 

zef.nse_field.d_wave_start = zef.nse_field.h_d_wave_start.Value; 
zef.nse_field.d_wave_length = zef.nse_field.h_d_wave_length.Value; 
zef.nse_field.d_wave_weight = zef.nse_field.h_d_wave_weight.Value; 

zef.nse_field.nse_reconstruction_type = zef.nse_field.h_nse_reconstruction_type.Value; 

end
