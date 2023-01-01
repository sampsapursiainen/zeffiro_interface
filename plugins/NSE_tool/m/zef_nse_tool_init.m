function zef = zef_nse_tool_init(zef)

if not(isfield(zef,'nse_field'))
    zef.nse_field = struct;
end

if not(isfield(zef.nse_field,'number_of_frames'))
zef.nse_field.number_of_frames = 20;
end

if not(isfield(zef.nse_field,'use_gpu'))
zef.nse_field.use_gpu = 1;
end

if not(isfield(zef.nse_field,'time_length'))
zef.nse_field.time_length = 1;
end

if not(isfield(zef.nse_field,'cycle_length'))
zef.nse_field.cycle_length = 1;
end

if not(isfield(zef.nse_field,'systolic_pressure'))
zef.nse_field.systolic_pressure = 180;
end

if not(isfield(zef.nse_field,'diastolic_pressure'))
zef.nse_field.diastolic_pressure = 110;
end

if not(isfield(zef.nse_field,'density'))
zef.nse_field.density = 1043;
end

if not(isfield(zef.nse_field,'viscosity'))
zef.nse_field.viscosity = 3E-3;
end

if not(isfield(zef.nse_field,'artery_diameter'))
zef.nse_field.artery_diameter = 3.448;
end

if not(isfield(zef.nse_field,'p_wave_start'))
zef.nse_field.p_wave_start = 0;
end

if not(isfield(zef.nse_field,'p_wave_length'))
zef.nse_field.p_wave_length = 0.55;
end

if not(isfield(zef.nse_field,'p_wave_weight'))
zef.nse_field.p_wave_weight = 0.53;
end

if not(isfield(zef.nse_field,'t_wave_start'))
zef.nse_field.t_wave_start = 0.21;
end

if not(isfield(zef.nse_field,'t_wave_length'))
zef.nse_field.t_wave_length = 0.55;
end

if not(isfield(zef.nse_field,'t_wave_weight'))
zef.nse_field.t_wave_weight = 0.37;
end

if not(isfield(zef.nse_field,'d_wave_start'))
zef.nse_field.d_wave_start = 0.43;
end

if not(isfield(zef.nse_field,'d_wave_length'))
zef.nse_field.d_wave_length = 0.55;
end

if not(isfield(zef.nse_field,'d_wave_weight'))
zef.nse_field.d_wave_weight = 0.1;
end

if not(isfield(zef.nse_field,'pcg_tol'))
zef.nse_field.pcg_tol = 1e-5;
end

if not(isfield(zef.nse_field,'pcg_maxit'))
zef.nse_field.pcg_maxit = 10000;
end

if not(isfield(zef.nse_field,'time_step_length'))
zef.nse_field.time_step_length = 1;
end

if not(isfield(zef.nse_field,'pulse_mode'))
zef.nse_field.pulse_mode = 1;
end

if not(isfield(zef.nse_field,'nse_reconstruction_type'))
zef.nse_field.nse_reconstruction_type = 1;
end

end
