function zef = zef_nse_tool_init(zef)

if not(isfield(zef,'nse_field'))
zef.nse_field = struct;
end

if not(isfield(zef.nse_field,'use_gpu'))
zef.nse_field.use_gpu = 1;
end

if not(isfield(zef.nse_field,'arteriole_diameter'))
zef.nse_field.arteriole_diameter = 2e-5;
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
