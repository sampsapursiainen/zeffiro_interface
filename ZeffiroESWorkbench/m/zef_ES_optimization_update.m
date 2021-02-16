zef.ES_current_threshold = str2num(get(zef.h_ES_current_threshold,'Value'));
zef.ES_maximum_current = str2num(get(zef.h_ES_maximum_current,'Value'));
zef.ES_optimizer_tolerance = str2num(get(zef.h_ES_optimizer_tolerance,'Value'));
zef.ES_optimizer_tolerance_max = str2num(get(zef.h_ES_optimizer_tolerance_max,'Value'));
zef.ES_regularization_parameter = str2num(get(zef.h_ES_regularization_parameter,'Value'));
zef.ES_regularization_parameter_max = str2num(get(zef.h_ES_regularization_parameter_max,'Value'));

zef.ES_cortex_thickness  = str2num(get(zef.h_ES_cortex_thickness,'Value'));
zef.ES_relative_source_amplitude  = str2num(get(zef.h_ES_relative_source_amplitude,'Value'));
zef.ES_source_density = str2num(get(zef.h_ES_source_density,'Value'));

zef.ES_plot_type = get(zef.h_ES_plot_type,'Value');
zef.ES_current_threshold_checkbox = get(zef.h_ES_current_threshold_checkbox, 'Value');
zef.ES_search_type = get(zef.h_ES_search_type,'Value');
zef.ES_inv_colormap = get(zef.h_ES_inv_colormap,'Value');

 if evalin('base','zef.ES_search_type') == 2 || evalin('base','zef.ES_search_type') == 3
     zef.h_ES_optimizer_tolerance_max.Enable = 'on';
     zef.h_ES_regularization_parameter_max.Enable = 'on';
else
     zef.h_ES_optimizer_tolerance_max.Enable = 'off';
     zef.h_ES_regularization_parameter_max.Enable = 'off';
end