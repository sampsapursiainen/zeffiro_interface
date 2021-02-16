zef_ES_optimization_init;

zef_data = zef_ES_optimization_app; 

zef.h_ES_current_threshold                        = zef_data.h_ES_current_threshold;
zef.h_ES_maximum_current                          = zef_data.h_ES_maximum_current;
%zef.h_ES_find_parameters_button                   = zef_data.h_ES_find_parameters_button;
zef.h_ES_plot_type                                = zef_data.h_ES_plot_type;
zef.h_ES_plot_data                                = zef_data.h_ES_plot_data;
zef.h_ES_update_reconstruction                    = zef_data.h_ES_update_reconstruction;
zef.h_ES_search_type                              = zef_data.h_ES_search_type;
zef.h_ES_optimizer_tolerance                      = zef_data.h_ES_optimizer_tolerance;
zef.h_ES_optimizer_tolerance_max                  = zef_data.h_ES_optimizer_tolerance_max;
zef.h_ES_regularization_parameter                 = zef_data.h_ES_regularization_parameter;
zef.h_ES_regularization_parameter_max             = zef_data.h_ES_regularization_parameter_max;
%zef.h_ES_current_pattern_mode                     = zef_data.h_ES_current_pattern_mode;
zef.h_ES_cortex_thickness                         = zef_data.h_ES_cortex_thickness;
zef.h_ES_relative_source_amplitude                = zef_data.h_ES_relative_source_amplitude;
zef.h_ES_source_density                           = zef_data.h_ES_source_density;
zef.h_ES_current_threshold_checkbox               = zef_data.h_ES_current_threshold_checkbox;
zef.h_ES_find_currents_button                     = zef_data.h_ES_find_currents_button;
zef.h_ES_clear_plot_data                          = zef_data.h_ES_clear_plot_data;
zef.h_ES_inv_colormap                             = zef_data.h_ES_inv_colormap;

clear zef_data;

%Edit Field (Text)
zef.h_ES_current_threshold.ValueChangedFcn                          = 'zef_ES_optimization_update;';
zef.h_ES_relative_source_amplitude.ValueChangedFcn                  = 'zef_ES_optimization_update;';
zef.h_ES_optimizer_tolerance.ValueChangedFcn                        = 'zef_ES_optimization_update;';
zef.h_ES_optimizer_tolerance_max.ValueChangedFcn                    = 'zef_ES_optimization_update;';
zef.h_ES_regularization_parameter.ValueChangedFcn                   = 'zef_ES_optimization_update;';
zef.h_ES_regularization_parameter_max.ValueChangedFcn               = 'zef_ES_optimization_update;';
zef.h_ES_cortex_thickness.ValueChangedFcn                           = 'zef_ES_optimization_update;';
zef.h_ES_maximum_current.ValueChangedFcn                            = 'zef_ES_optimization_update;';
zef.h_ES_source_density.ValueChangedFcn                             = 'zef_ES_optimization_update;';

%Button
zef.h_ES_clear_plot_data.ButtonPushedFcn                            = 'zef_ES_clear_plot_data';
zef.h_ES_plot_data.ButtonPushedFcn                                  = 'zef_ES_plot_data;';
zef.h_ES_update_reconstruction.ButtonPushedFcn                      = 'zef_ES_update_reconstruction;';
zef.h_ES_find_currents_button.ButtonPushedFcn                       = 'zef_ES_find_currents';

%CheckBox
zef.h_ES_current_threshold_checkbox.ValueChangedFcn                 = 'zef_ES_optimization_update;';

%Drop Down
zef.h_ES_plot_type.ValueChangedFcn                                  = 'zef_ES_optimization_update;';
zef.h_ES_search_type.ValueChangedFcn                                = 'zef_ES_optimization_update;';
zef.h_ES_inv_colormap.ValueChangedFcn                               = 'zef_ES_optimization_update;';

zef.h_ES_plot_type.ItemsData                                        = [1:length(zef.h_ES_plot_type.Items)];
zef.h_ES_plot_type.Value                                            = zef.ES_plot_type;
zef.h_ES_search_type.ItemsData                                      = [1:length(zef.h_ES_search_type.Items)];
zef.h_ES_search_type.Value                                          = zef.ES_search_type;
zef.h_ES_inv_colormap.ItemsData                                     = [1:length(zef.h_ES_inv_colormap.Items)];
zef.h_ES_inv_colormap.Value                                         = zef.ES_inv_colormap;

zef.h_ES_current_threshold.Value                                    = num2str(zef.ES_current_threshold);
zef.h_ES_relative_source_amplitude.Value                            = num2str(zef.ES_relative_source_amplitude);
zef.h_ES_optimizer_tolerance.Value                                  = num2str(zef.ES_optimizer_tolerance);
zef.h_ES_optimizer_tolerance_max.Value                              = num2str(zef.ES_optimizer_tolerance_max);
zef.h_ES_regularization_parameter.Value                             = num2str(zef.ES_regularization_parameter);
zef.h_ES_regularization_parameter_max.Value                         = num2str(zef.ES_regularization_parameter_max);
zef.h_ES_cortex_thickness.Value                                     = num2str(zef.ES_cortex_thickness);
zef.h_ES_maximum_current.Value                                      = num2str(zef.ES_maximum_current);
zef.h_ES_source_density.Value                                       = num2str(zef.ES_source_density);