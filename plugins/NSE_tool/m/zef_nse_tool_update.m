function zef = zef_nse_tool_update(zef)

zef.nse_field.use_gpu = zef.nse_field.h_use_gpu.Value;
zef.nse_field.pcg_tol = zef.nse_field.h_pcg_tol.Value;
zef.nse_field.pcg_maxit = zef.nse_field.h_pcg_maxit.Value;
zef.nse_field.rho = zef.nse_field.h_rho.Value;
zef.nse_field.mu = zef.nse_field.h_mu.Value;

zef.nse_field.diffusion_parameter = zef.nse_field.h_diffusion_parameter.Value;
zef.nse_field.max_pressure_quantile = zef.nse_field.h_max_pressure_quantile.Value;
zef.nse_field.min_pressure_quantile = zef.nse_field.h_min_pressure_quantile.Value;
zef.nse_field.max_flow_quantile = zef.nse_field.h_max_flow_quantile.Value;
zef.nse_field.min_flow_quantile = zef.nse_field.h_min_flow_quantile.Value;

zef.nse_field.pressure = zef.nse_field.h_pressure.Value; 

zef.nse_field.blood_conductivity = zef.nse_field.h_blood_conductivity.Value; 

zef.nse_field.gravity_x = zef.nse_field.h_gravity_x.Value; 
zef.nse_field.gravity_y = zef.nse_field.h_gravity_y.Value; 
zef.nse_field.gravity_z = zef.nse_field.h_gravity_z.Value;

zef.nse_field.conductivity_model = zef.nse_field.h_conductivity_model.Value;
zef.nse_field.conductivity_exponent = zef.nse_field.h_conductivity_exponent.Value;


zef.nse_field.vessel_resistance = zef.nse_field.h_vessel_resistance.Value;

zef.nse_field.total_flow = zef.nse_field.h_total_flow.Value; 
zef.nse_field.pulse_frequency = zef.nse_field.h_pulse_frequency.Value; 

zef.nse_field.capillary_domain_ind = zef.nse_field.h_capillary_domain_ind.Value; 
zef.nse_field.artery_domain_ind = zef.nse_field.h_artery_domain_ind.Value; 

zef.nse_field.reconstruction_type = zef.nse_field.h_reconstruction_type.Value; 
zef.nse_field.solver_type = zef.nse_field.h_solver_type.Value; 


end

