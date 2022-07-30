
if not(isfield(zef,'ES_separation_angle'))
    zef.ES_separation_angle = 45;
end
if not(isfield(zef,'ES_effective_nnz'))
    zef.ES_effective_nnz = 8;
end
if not(isfield(zef,'ES_obj_fun'))
    zef.ES_obj_fun = 2;
end
if not(isfield(zef,'ES_obj_fun_2'))
    zef.ES_obj_fun_2 = 4;
end
if not(isfield(zef,'ES_solver_package'))
    zef.ES_solver_package = 'sdpt3';
end
if not(isfield(zef,'ES_solver_tolerance'))
    zef.ES_solver_tolerance = '1E-12';
end
if not(isfield(zef,'ES_total_max_current'))
    zef.ES_total_max_current = 0.004;
end
if not(isfield(zef,'ES_relative_weight_nnz'))
    zef.ES_relative_weight_nnz = 100;
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
if not(isfield(zef,'ES_beta'))
    zef.ES_beta = 10;
end
if not(isfield(zef,'ES_beta_min'))
    zef.ES_beta_min = 1E-5;
end
if not(isfield(zef,'ES_alpha'))
    zef.ES_alpha = 1E-5;
end
if not(isfield(zef,'ES_alpha_max'))
    zef.ES_alpha_max = 10;
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
if not(isfield(zef,'ES_max_current_channel'))
    zef.ES_max_current_channel = 0.002;
end
if not(isfield(zef,'ES_cortex_thickness'))
    zef.ES_cortex_thickness = 4;
end
if not(isfield(zef,'ES_relative_source_amplitude'))
    zef.ES_relative_source_amplitude = 100; % 100%
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
if not(isfield(zef,'ES_score_dose'))
    zef.ES_score_dose = 24;
end
if not(isfield(zef,'ES_update_plot_data'))
    zef.ES_update_plot_data = 0;
end
if not(isfield(zef,'ES_acceptable_threshold'))
    zef.ES_acceptable_threshold = 95;
end
if not(isfield(zef,'ES_boundary_color_limit'))
    zef.ES_boundary_color_limit = 0.0025;
end
if not(isfield(zef,'ES_roi_range'))
    zef.ES_roi_range = 15;
end
