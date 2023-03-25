function zef = zef_nse_tool_init(zef)

if not(isfield(zef,'nse_field'))
zef.nse_field = struct;
end

if not(isfield(zef,'inv_time_1'))
zef.nse_field.inv_time_1 = 0;
end

if not(isfield(zef,'inv_time_2'))
zef.nse_field.inv_time_2 = 0;
end 
 
if not(isfield(zef,'inv_time_3'))
zef.nse_field.inv_time_3 = 0;
end

if not(isfield(zef.nse_field,'use_gpu'))
zef.nse_field.use_gpu = 1;
end

if not(isfield(zef.nse_field,'n_frames'))
zef.nse_field.n_frames = 1;
end


if not(isfield(zef.nse_field,'gravity_amplitude'))
zef.nse_field.gravity_amplitude = -9.81;
end

if not(isfield(zef.nse_field,'time_length'))
zef.nse_field.time_length = 1;
end

if not(isfield(zef.nse_field,'time_step_length'))
zef.nse_field.time_step_length = 0.1;
end

if not(isfield(zef.nse_field,'pulse_amplitude'))
zef.nse_field.pulse_amplitude = 50;
end


if not(isfield(zef.nse_field,'sphere_radius'))
zef.nse_field.sphere_radius = 30;
end

if not(isfield(zef.nse_field,'sphere_x'))
zef.nse_field.sphere_x = 0;
end

if not(isfield(zef.nse_field,'sphere_y'))
zef.nse_field.sphere_y = 0;
end

if not(isfield(zef.nse_field,'sphere_z'))
zef.nse_field.sphere_z = 0;
end

if not(isfield(zef.nse_field,'cycle_length'))
zef.nse_field.cycle_length = 1;
end

if not(isfield(zef.nse_field,'p_wave_start'))
zef.nse_field.p_wave_start = 0.05;
end

if not(isfield(zef.nse_field,'t_wave_start'))
zef.nse_field.t_wave_start = 0.2;
end

if not(isfield(zef.nse_field,'d_wave_start'))
zef.nse_field.d_wave_start = 0.35;
end

if not(isfield(zef.nse_field,'p_wave_length'))
zef.nse_field.p_wave_length = 0.5;
end

if not(isfield(zef.nse_field,'t_wave_length'))
zef.nse_field.t_wave_length = 0.5;
end

if not(isfield(zef.nse_field,'d_wave_length'))
zef.nse_field.d_wave_length = 0.5;
end

if not(isfield(zef.nse_field,'p_wave_weight'))
zef.nse_field.p_wave_weight = 0.5;
end

if not(isfield(zef.nse_field,'t_wave_weight'))
zef.nse_field.t_wave_weight = 0.2;
end

if not(isfield(zef.nse_field,'d_wave_weight'))
zef.nse_field.d_wave_weight = 0.05;
end

if not(isfield(zef.nse_field,'capillary_diameter'))
zef.nse_field.capillary_diameter = 7e-6;
end

if not(isfield(zef.nse_field,'venule_diameter'))
zef.nse_field.venule_diameter = 2e-5;
end

if not(isfield(zef.nse_field,'pressure_decay_in_arterioles'))
zef.nse_field.pressure_decay_in_arterioles = 0.70;
end

if not(isfield(zef.nse_field,'blood_conductivity'))
zef.nse_field.blood_conductivity = 1.59;
end

if not(isfield(zef.nse_field,'capillary_arteriole_total_area_ratio'))
zef.nse_field.capillary_arteriole_total_area_ratio = 2;
end

if not(isfield(zef.nse_field,'total_flow'))
zef.nse_field.total_flow = 1;
end

if not(isfield(zef.nse_field,'conductivity_model'))
zef.nse_field.conductivity_model = 1;
end

if not(isfield(zef.nse_field,'conductivity_exponent'))
zef.nse_field.conductivity_exponent = 2;
end

if not(isfield(zef.nse_field,'pressure'))
zef.nse_field.pressure = 110;
end

if not(isfield(zef.nse_field,'rho'))
zef.nse_field.rho = 1043;
end

if not(isfield(zef.nse_field,'capillary_domain_ind'))
zef.nse_field.capillary_domain_ind = 1;
end

if not(isfield(zef.nse_field,'artery_domain_ind'))
zef.nse_field.artery_domain_ind = 1;
end

if not(isfield(zef.nse_field,'mu'))
zef.nse_field.mu = 3E-3;
end

if not(isfield(zef.nse_field,'pcg_tol'))
zef.nse_field.pcg_tol = 1e-05;
end

if not(isfield(zef.nse_field,'pcg_maxit'))
zef.nse_field.pcg_maxit = 10000;
end

if not(isfield(zef.nse_field,'reconstruction_type'))
zef.nse_field.reconstruction_type = 1;
end

if not(isfield(zef.nse_field,'solver_type'))
zef.nse_field.solver_type = 1;
end

if not(isfield(zef.nse_field,'gravity_x'))
zef.nse_field.gravity_x = 0;
end

if not(isfield(zef.nse_field,'gravity_y'))
zef.nse_field.gravity_y = 0;
end

if not(isfield(zef.nse_field,'gravity_z'))
zef.nse_field.gravity_z = 9.81;
end


end
