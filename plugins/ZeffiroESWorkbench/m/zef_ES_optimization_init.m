if not(isfield(zef,'ES_L2_reg_ratio_UL'))
    zef.ES_L2_reg_ratio_UL = 1E3;
end
if not(isfield(zef,'ES_L2_reg_ratio_LL'))
    zef.ES_L2_reg_ratio_LL = 1E-3;
end
if not(isfield(zef,'ES_separation_angle'))
    zef.ES_separation_angle = 45;
end
if not(isfield(zef,'ES_effectivennz'))
    zef.ES_effectivennz = 8;
end
if not(isfield(zef,'ES_objfun'))
    zef.ES_objfun = 3;
end
if not(isfield(zef,'ES_objfun_2'))
    zef.ES_objfun_2 = 4;
end
if not(isfield(zef,'ES_solvermaximumcurrent'))
    zef.ES_solvermaximumcurrent = 0.004;
end
if not(isfield(zef,'ES_relativeweightnnz'))
    zef.ES_relativeweightnnz = 100;
end
if not(isfield(zef,'ES_fixed_active_electrodes'))
    zef.ES_fixed_active_electrodes = 0;
end
if not(isfield(zef,'ES_plot_type'))
    zef.ES_plot_type = 1;
end
if not(isfield(zef,'ES_search_type'))
    zef.ES_search_type = 2;
end
if not(isfield(zef,'ES_search_method'))
    zef.ES_search_method = 1;
end
if not(isfield(zef,'ES_volumetric_current_density'))
    zef.ES_volumetric_current_density = [];
end
if not(isfield(zef,'ES_optimizer_tolerance'))
    zef.ES_optimizer_tolerance = 1E-06;
end
if not(isfield(zef,'ES_optimizer_tolerance_max'))
    zef.ES_optimizer_tolerance_max = 1E-2;
end
if not(isfield(zef,'ES_regularization_parameter'))
    zef.ES_regularization_parameter = 1e-6;
end
if not(isfield(zef,'ES_regularization_parameter_max'))
    zef.ES_regularization_parameter_max = 1e15;
end
if not(isfield(zef,'ES_active_electrodes'))
    zef.ES_active_electrodes = [];
end
if not(isfield(zef,'ES_positivity_constraint'))
    zef.ES_positivity_constraint = [];
end
if not(isfield(zef,'ES_negativity_constraint'))
    zef.ES_negativity_constraint = [];
end
if not(isfield(zef,'ES_maximum_current'))
    zef.ES_maximum_current = 0.002;
end
if not(isfield(zef,'ES_cortex_thickness'))
    zef.ES_cortex_thickness = 4;
end
if not(isfield(zef,'ES_relative_source_amplitude'))
    zef.ES_relative_source_amplitude = 1;
end
if not(isfield(zef,'ES_source_density'))
    zef.ES_source_density = 0.77;
end
if not(isfield(zef,'ES_inv_colormap'))
    zef.ES_inv_colormap = 2;
end
if not(isfield(zef,'ES_step_size'))
    zef.ES_step_size = 10;
end
if not(isfield(zef,'ES_scoredose'))
    zef.ES_scoredose = 8;
end
if not(isfield(zef,'ES_update_plot_data'))
    zef.ES_update_plot_data = 0;
end
if not(isfield(zef,'ES_delta_param'))
    zef.ES_delta_param = 0.1;
end
if not(isfield(zef,'ES_L1_iter'))
    zef.ES_L1_iter = 3;
end
if not(isfield(zef,'ES_acceptable_threshold'))
    zef.ES_acceptable_threshold = 95;
end
if not(isfield(zef,'ES_boundary_color_limit'))
    zef.ES_boundary_color_limit = 0.00025;
end
