function zef = zef_nse_tool_window(zef)

zef_data = zef_nse_tool_app;

zef = zef_nse_tool_init(zef);

zef.nse_field.h_nse_tool = zef_data.h_nse_tool;
zef.nse_field.h_nse_tool.Name = 'ZEFFIRO Interface: NSE tool';
zef.nse_field.h_start = zef_data.h_start;
zef.nse_field.h_plot_pulse = zef_data.h_plot_pulse;
zef.nse_field.h_plot_pulse_data = zef_data.h_plot_pulse_data;
zef.nse_field.h_parse_reconstruction = zef_data.h_parse_reconstruction;
zef.nse_field.h_number_of_frames = zef_data.h_number_of_frames;
zef.nse_field.h_number_of_frames.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_use_gpu = zef_data.h_use_gpu;
zef.nse_field.h_use_gpu.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_time_length = zef_data.h_time_length;
zef.nse_field.h_time_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_cycle_length = zef_data.h_cycle_length;
zef.nse_field.h_cycle_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pulse_mode = zef_data.h_pulse_mode;
zef.nse_field.h_pulse_mode.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pcg_tol = zef_data.h_pcg_tol;
zef.nse_field.h_pcg_tol.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';
zef.nse_field.h_pcg_maxit = zef_data.h_pcg_maxit;
zef.nse_field.h_pcg_maxit.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_systolic_pressure = zef_data.h_systolic_pressure;
zef.nse_field.h_systolic_pressure.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_diastolic_pressure = zef_data.h_diastolic_pressure;
zef.nse_field.h_diastolic_pressure.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_artery_diameter = zef_data.h_artery_diameter;
zef.nse_field.h_artery_diameter.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_density = zef_data.h_density;
zef.nse_field.h_density.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_viscosity = zef_data.h_viscosity;
zef.nse_field.h_viscosity.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_p_wave_start = zef_data.h_p_wave_start;
zef.nse_field.h_p_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_p_wave_length = zef_data.h_p_wave_length;
zef.nse_field.h_p_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_p_wave_weight = zef_data.h_p_wave_weight;
zef.nse_field.h_p_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_t_wave_start = zef_data.h_t_wave_start;
zef.nse_field.h_t_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_t_wave_length = zef_data.h_t_wave_length;
zef.nse_field.h_t_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_t_wave_weight = zef_data.h_t_wave_weight;
zef.nse_field.h_t_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_d_wave_start = zef_data.h_d_wave_start;
zef.nse_field.h_d_wave_start.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_d_wave_length = zef_data.h_d_wave_length;
zef.nse_field.h_d_wave_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_d_wave_weight = zef_data.h_d_wave_weight;
zef.nse_field.h_d_wave_weight.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_nse_reconstruction_type = zef_data.h_nse_reconstruction_type;
zef.nse_field.h_nse_reconstruction_type.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_time_step_length = zef_data.h_time_step_length;
zef.nse_field.h_time_step_length.ValueChangedFcn = 'zef = zef_nse_tool_update(zef);';

zef.nse_field.h_number_of_frames.Value = zef.nse_field.number_of_frames; 
zef.nse_field.h_use_gpu.Value = zef.nse_field.use_gpu;
zef.nse_field.h_time_length.Value = zef.nse_field.time_length;
zef.nse_field.h_cycle_length.Value = zef.nse_field.cycle_length;

zef.nse_field.h_pcg_tol.Value = zef.nse_field.pcg_tol;
zef.nse_field.h_pcg_maxit.Value = zef.nse_field.pcg_maxit;
zef.nse_field.h_time_step_length.Value = zef.nse_field.time_step_length;

zef.nse_field.h_density.Value = zef.nse_field.density;
zef.nse_field.h_viscosity.Value = zef.nse_field.viscosity;

zef.nse_field.h_artery_diameter.Value = zef.nse_field.artery_diameter;
zef.nse_field.h_p_wave_start.Value = zef.nse_field.p_wave_start;
zef.nse_field.h_p_wave_length.Value = zef.nse_field.p_wave_length;
zef.nse_field.h_p_wave_weight.Value = zef.nse_field.p_wave_weight;
zef.nse_field.h_t_wave_start.Value = zef.nse_field.t_wave_start;
zef.nse_field.h_t_wave_length.Value = zef.nse_field.t_wave_length;
zef.nse_field.h_t_wave_weight.Value = zef.nse_field.t_wave_weight;
zef.nse_field.h_d_wave_start.Value = zef.nse_field.d_wave_start;
zef.nse_field.h_d_wave_length.Value = zef.nse_field.d_wave_length;
zef.nse_field.h_d_wave_weight.Value = zef.nse_field.d_wave_weight;

zef.nse_field.h_systolic_pressure.Value = zef.nse_field.systolic_pressure;
zef.nse_field.h_diastolic_pressure.Value = zef.nse_field.diastolic_pressure;


zef.nse_field.h_pulse_mode.Items = {'Blackman-Harris'};
zef.nse_field.h_pulse_mode.ItemsData = [1 : length(zef.nse_field.h_pulse_mode.Items)];
zef.nse_field.h_pulse_mode.Value = zef.nse_field.pulse_mode;

zef.nse_field.h_nse_reconstruction_type.Items = {'Velocity','Pressure'};
zef.nse_field.h_nse_reconstruction_type.ItemsData = [1 : length(zef.nse_field.h_nse_reconstruction_type.Items)];
zef.nse_field.h_nse_reconstruction_type.Value = zef.nse_field.nse_reconstruction_type;

zef.nse_field.h_start.ButtonPushedFcn = 'zef = zef_nse_iteration(zef);';
zef.nse_field.h_plot_pulse.ButtonPushedFcn = 'zef_nse_plot_pulse(zef,zef.nse_field);';
zef.nse_field.h_plot_pulse_data.ButtonPushedFcn = 'zef_nse_plot_pulse(zef,zef.nse_field,''full_data'');';
zef.nse_field.h_parse_reconstruction.ButtonPushedFcn = '[zef.reconstruction, zef.reconstruction_information] = zef_nse_reconstruction(zef.nse_field,zef.h_nse_reconstruction_type.Items{zef.nse_reconstruction_type});';

end

