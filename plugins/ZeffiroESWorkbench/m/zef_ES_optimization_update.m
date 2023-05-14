zef_ES_update_parameter_values;

zef.ES_opt_solver               = zef.h_ES_opt_solver.Value;
zef.ES_opt_method               = zef.h_ES_opt_method.Value;
zef.ES_opt_algorithm            = lower(zef.ES_opt_algorithm_list{zef.h_ES_opt_algorithm.Value});

zef.ES_obj_fun                  = zef.h_ES_obj_fun.Value;
zef.ES_obj_fun_2                = zef.h_ES_obj_fun_2.Value;
zef.ES_threshold_condition      = zef.h_ES_threshold_condition.Value;

zef.ES_HPO_search_method        = zef.h_ES_HPO_search_method.Value;

zef.ES_inv_colormap             = get(zef.h_ES_inv_colormap,'Value');
zef.ES_plot_type                = get(zef.h_ES_plot_type,'Value');

zef.ES_fixed_active_electrodes  = get(zef.h_ES_fixed_active_electrodes,'Value');

if not(ismember(zef.ES_opt_method, zef.h_ES_opt_method.ItemsData))
    zef.ES_opt_method = zef.h_ES_opt_method.ItemsData(1);
end

zef_ES_init_parameter_table;

zef.ES_opt_solver               = zef.h_ES_opt_solver.Value;
zef.ES_opt_method               = zef.h_ES_opt_method.Value;
zef.ES_opt_algorithm            = lower(zef.ES_opt_algorithm_list{zef.h_ES_opt_algorithm.Value});

zef.ES_obj_fun                  = zef.h_ES_obj_fun.Value;
zef.ES_obj_fun_2                = zef.h_ES_obj_fun_2.Value;
zef.ES_threshold_condition      = zef.h_ES_threshold_condition.Value;

zef.ES_HPO_search_method        = zef.h_ES_HPO_search_method.Value;

%zef.ES_solver_package          = zef.h_ES_opt_type.Items{ismember(zef.h_ES_opt_type.ItemsData,zef.ES_search_type)};

zef.ES_inv_colormap             = get(zef.h_ES_inv_colormap,'Value');
zef.ES_plot_type                = get(zef.h_ES_plot_type,'Value');

zef.ES_fixed_active_electrodes  = get(zef.h_ES_fixed_active_electrodes,'Value');

if not(ismember(zef.ES_opt_method, zef.h_ES_opt_method.ItemsData))
    zef.ES_opt_method = zef.h_ES_opt_method.ItemsData(1);
end