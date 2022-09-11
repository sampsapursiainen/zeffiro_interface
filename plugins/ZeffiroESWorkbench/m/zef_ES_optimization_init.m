zef.ES_search_method_list = {'L1L1 optimization','L1L2 optimization','Least squares optimization','Backpropagation','L2L2 optimization'};
zef.ES_search_type_list = {'Matlab','SDPT3 (CVX)','SeDuMi (CVX)','MOSEK','Gurobi'};
zef.ES_algorithm_list = {'interior-point','interior-point-legacy','dual-simplex','primal-simplex'};

if not(isfield(zef,'ES_absolute_tolerance'))
    zef.ES_absolute_tolerance = 1E-03;
end
if not(isfield(zef,'ES_relative_tolerance'))
    zef.ES_relative_tolerance = 1E-03;
end
if not(isfield(zef,'ES_simplex'))
    zef.ES_simplex = 'none';
end
if not(isfield(zef,'ES_algorithm'))
    zef.ES_algorithm = 'interior-point';
end
if not(isfield(zef,'ES_threshold_condition'))
    zef.ES_threshold_condition = 1;
end
if not(isfield(zef,'ES_display'))
    zef.ES_display = 'off';
end
if not(isfield(zef,'mosek_path'))
    zef.mosek_path = '';
end
if not(isfield(zef,'gurobi_path'))
    zef.gurobi_path = '';
end
if not(isfield(zef,'ES_separation_angle'))
    zef.ES_separation_angle = 45;
end
if not(isfield(zef,'ES_effective_nnz'))
    zef.ES_effective_nnz = 20;
end
if not(isfield(zef,'ES_obj_fun'))
    zef.ES_obj_fun = 2;
end
if not(isfield(zef,'ES_obj_fun_2'))
    zef.ES_obj_fun_2 = 4;
end
if not(isfield(zef,'ES_solver_tolerance'))
    zef.ES_solver_tolerance = 1E-6;
end
if not(isfield(zef,'ES_max_n_iterations'))
    zef.ES_max_n_iterations = 100000;
end
if not(isfield(zef,'ES_step_tolerance'))
    zef.ES_step_tolerance = 1E-6;
end
if not(isfield(zef,'ES_max_time'))
    zef.ES_max_time = 3600;
end
if not(isfield(zef,'ES_constraint_tolerance'))
    zef.ES_constraint_tolerance = 1E-6;
end
if not(isfield(zef,'ES_total_max_current'))
    zef.ES_total_max_current = 0.004;
end
if not(isfield(zef,'ES_relative_weight_nnz'))
    zef.ES_relative_weight_nnz = 1e-3;
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
    zef.ES_beta = 1;
end
if not(isfield(zef,'ES_beta_min'))
    zef.ES_beta_min = 1E-8;
end
if not(isfield(zef,'ES_alpha'))
    zef.ES_alpha = 1E-5;
end
if not(isfield(zef,'ES_alpha_max'))
    zef.ES_alpha_max = 0.1;
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
    zef.ES_source_density = 3.85;
end
if not(isfield(zef,'ES_inv_colormap'))
    zef.ES_inv_colormap = 2;
end
if not(isfield(zef,'ES_step_size'))
    zef.ES_step_size = 15;
end
if not(isfield(zef,'ES_score_dose'))
    zef.ES_score_dose = 20;
end
if not(isfield(zef,'ES_update_plot_data'))
    zef.ES_update_plot_data = 0;
end
if not(isfield(zef,'ES_acceptable_threshold'))
    zef.ES_acceptable_threshold = 0.80;
end
if not(isfield(zef,'ES_boundary_color_limit'))
    zef.ES_boundary_color_limit = 0.00025;
end
if not(isfield(zef,'ES_roi_range'))
    zef.ES_roi_range = 15;
end
