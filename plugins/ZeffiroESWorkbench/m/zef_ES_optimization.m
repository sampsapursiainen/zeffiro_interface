zef_ES_optimization_init;
zef_data = zef_ES_optimization_app;
%% zef_data
zef.h_ES_workbench                        = zef_data.h_ES_workbench;
zef.h_ES_current_threshold                = zef_data.h_ES_current_threshold;
zef.h_ES_scoredose                        = zef_data.h_ES_scoredose;
zef.h_ES_maximum_current                  = zef_data.h_ES_maximum_current;
zef.h_ES_plot_type                        = zef_data.h_ES_plot_type;
zef.h_ES_plot_data                        = zef_data.h_ES_plot_data;
zef.h_ES_update_reconstruction            = zef_data.h_ES_update_reconstruction;
zef.h_ES_search_type                      = zef_data.h_ES_search_type;
zef.h_ES_search_method                    = zef_data.h_ES_search_method;
zef.h_ES_optimizer_tolerance              = zef_data.h_ES_optimizer_tolerance;
zef.h_ES_optimizer_tolerance_max          = zef_data.h_ES_optimizer_tolerance_max;
zef.h_ES_regularization_parameter         = zef_data.h_ES_regularization_parameter;
zef.h_ES_regularization_parameter_max     = zef_data.h_ES_regularization_parameter_max;
zef.h_ES_cortex_thickness                 = zef_data.h_ES_cortex_thickness;
zef.h_ES_relative_source_amplitude        = zef_data.h_ES_relative_source_amplitude;
zef.h_ES_source_density                   = zef_data.h_ES_source_density;
zef.h_ES_current_threshold_checkbox       = zef_data.h_ES_current_threshold_checkbox;
zef.h_ES_solvermaximumcurrent_checkbox    = zef_data.h_ES_solvermaximumcurrent_checkbox;
zef.h_ES_scoredose_checkbox               = zef_data.h_ES_scoredose_checkbox;
zef.h_ES_find_currents_button             = zef_data.h_ES_find_currents_button;
zef.h_ES_clear_plot_data                  = zef_data.h_ES_clear_plot_data;
zef.h_ES_inv_colormap                     = zef_data.h_ES_inv_colormap;
zef.h_ES_step_size                        = zef_data.h_ES_step_size;
zef.h_ES_scoredose                        = zef_data.h_ES_scoredose;
zef.h_ES_relativeweightnnz                = zef_data.h_ES_relativeweightnnz;
zef.h_ES_effectivennz                     = zef_data.h_ES_effectivennz;
zef.h_ES_solvermaximumcurrent             = zef_data.h_ES_solvermaximumcurrent;
zef.h_ES_objfun                           = zef_data.h_ES_objfun;
zef.h_ES_separationangle                  = zef_data.h_ES_separationangle;

zef.h_ES_4x1_button                       = zef_data.h_ES_4x1_button;
zef.h_ES_lattice_zoom                     = zef_data.h_ES_lattice_zoom;

clear zef_data;
%% Edit Field
zef.h_ES_current_threshold.ValueChangedFcn               = 'zef_ES_optimization_update;';
zef.h_ES_relative_source_amplitude.ValueChangedFcn       = 'zef_ES_optimization_update;';
zef.h_ES_optimizer_tolerance.ValueChangedFcn             = 'zef_ES_optimization_update;';
zef.h_ES_optimizer_tolerance_max.ValueChangedFcn         = 'zef_ES_optimization_update;';
zef.h_ES_regularization_parameter.ValueChangedFcn        = 'zef_ES_optimization_update;';
zef.h_ES_regularization_parameter_max.ValueChangedFcn    = 'zef_ES_optimization_update;';
zef.h_ES_cortex_thickness.ValueChangedFcn                = 'zef_ES_optimization_update;';
zef.h_ES_maximum_current.ValueChangedFcn                 = 'zef_ES_optimization_update;';
zef.h_ES_source_density.ValueChangedFcn                  = 'zef_ES_optimization_update;';
zef.h_ES_step_size.ValueChangedFcn                       = 'zef_ES_optimization_update;';
zef.h_ES_scoredose.ValueChangedFcn                       = 'zef_ES_optimization_update;';
zef.h_ES_relativeweightnnz.ValueChangedFcn               = 'zef_ES_optimization_update;';
zef.h_ES_effectivennz.ValueChangedFcn                    = 'zef_ES_optimization_update;';
zef.h_ES_solvermaximumcurrent.ValueChangedFcn            = 'zef_ES_optimization_update;';
zef.h_ES_separationangle.ValueChangedFcn                 = 'zef_ES_optimization_update;';
%% Button
zef.h_ES_clear_plot_data.ButtonPushedFcn                 = 'zef.ES_update_plot_data = 0; zef_ES_update_plot_data;';
zef.h_ES_plot_data.ButtonPushedFcn                       = 'zef.ES_update_plot_data = 1; zef_ES_update_plot_data;';
zef.h_ES_update_reconstruction.ButtonPushedFcn           = 'zef_ES_update_reconstruction;';
zef.h_ES_find_currents_button.ButtonPushedFcn            = 'zef_ES_find_currents;';
zef.h_ES_4x1_button.ButtonPushedFcn                      = 'zef_ES_4x1_fun';
%% CheckBox
zef.h_ES_current_threshold_checkbox.ValueChangedFcn      = 'zef_ES_optimization_update;';
zef.h_ES_scoredose_checkbox.ValueChangedFcn              = 'zef_ES_optimization_update;';
zef.h_ES_solvermaximumcurrent_checkbox.ValueChangedFcn   = 'zef_ES_optimization_update;';
%% Drop Down
zef.h_ES_plot_type.ValueChangedFcn                       = 'zef_ES_optimization_update;';
zef.h_ES_plot_type.ItemsData                             = 1:length(zef.h_ES_plot_type.Items);
zef.h_ES_plot_type.Value                                 = zef.ES_plot_type;

zef.h_ES_objfun.ValueChangedFcn                          = 'zef_ES_optimization_update;';
zef.h_ES_objfun.ItemsData                                = 1:length(zef.h_ES_objfun.Items);
zef.h_ES_objfun.Value                                    = zef.ES_objfun;

zef.h_ES_search_type.ValueChangedFcn                     = 'zef_ES_optimization_update;';
zef.h_ES_search_type.ItemsData                           = 1:length(zef.h_ES_objfun.Items);
zef.h_ES_search_type.Value                               = zef.ES_search_type;

zef.h_ES_search_method.ValueChangedFcn                   = 'zef_ES_optimization_update;';
zef.h_ES_search_method.ItemsData                         = 1:length(zef.h_ES_search_method.Items);
zef.h_ES_search_method.Value                             = zef.ES_search_method;

zef.h_ES_inv_colormap.ValueChangedFcn                    = 'zef_ES_optimization_update;';
zef.h_ES_inv_colormap.ItemsData                          = 1:length(zef.h_ES_inv_colormap.Items);
zef.h_ES_inv_colormap.Value                              = zef.ES_inv_colormap;
%% Slider
zef.h_ES_lattice_zoom.ValueChangedFcn                    = 'zef_ES_optimization_update;';

zef.h_ES_step_size.Value                                 = zef.ES_step_size;
zef.h_ES_scoredose.Value                                 = zef.ES_scoredose;
zef.h_ES_relativeweightnnz.Value                         = zef.ES_relativeweightnnz;
zef.h_ES_current_threshold.Value                         = zef.ES_current_threshold;
zef.h_ES_relative_source_amplitude.Value                 = zef.ES_relative_source_amplitude;
zef.h_ES_optimizer_tolerance.Value                       = zef.ES_optimizer_tolerance;
zef.h_ES_optimizer_tolerance_max.Value                   = zef.ES_optimizer_tolerance_max;
zef.h_ES_regularization_parameter.Value                  = zef.ES_regularization_parameter;
zef.h_ES_regularization_parameter_max.Value              = zef.ES_regularization_parameter_max;
zef.h_ES_cortex_thickness.Value                          = zef.ES_cortex_thickness;
zef.h_ES_maximum_current.Value                           = zef.ES_maximum_current;
zef.h_ES_source_density.Value                            = zef.ES_source_density;
zef.h_ES_separationangle.Value                           = zef.ES_separationangle;
zef.h_ES_lattice_zoom.Value                              = zef.ES_lattice_zoom;
%% Autoresize
set(zef.h_ES_workbench,'AutoResizeChildren','off');
zef.h_ES_workbench_current_size = get(zef.h_ES_workbench,'Position');
set(zef.h_ES_workbench,'SizeChangedFcn', 'zef.h_ES_workbench_current_size = zef_change_size_function(zef.h_ES_workbench, zef.h_ES_workbench_current_size);');