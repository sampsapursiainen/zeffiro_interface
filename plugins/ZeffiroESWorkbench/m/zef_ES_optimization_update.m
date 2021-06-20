zef.ES_current_threshold                = get(zef.h_ES_current_threshold,'Value');
zef.ES_current_threshold_checkbox       = get(zef.h_ES_current_threshold_checkbox, 'Value');

zef.ES_optimizer_tolerance              = get(zef.h_ES_optimizer_tolerance,'Value');
zef.ES_optimizer_tolerance_max          = get(zef.h_ES_optimizer_tolerance_max,'Value');
zef.ES_regularization_parameter         = get(zef.h_ES_regularization_parameter,'Value');
zef.ES_regularization_parameter_max     = get(zef.h_ES_regularization_parameter_max,'Value');

zef.ES_cortex_thickness                 = get(zef.h_ES_cortex_thickness,'Value');
zef.ES_relative_source_amplitude        = get(zef.h_ES_relative_source_amplitude,'Value');
zef.ES_source_density                   = get(zef.h_ES_source_density,'Value');
zef.ES_maximum_current                  = get(zef.h_ES_maximum_current,'Value');

zef.ES_separationangle                  = get(zef.h_ES_separationangle,'Value');

zef.ES_search_type                      = get(zef.h_ES_search_type,'Value');
zef.ES_search_method                    = get(zef.h_ES_search_method,'Value');
zef.ES_lattice_zoom                     = get(zef.h_ES_lattice_zoom, 'Value');
[~, minIdx]                             = min(abs(zef.ES_lattice_zoom - zef.h_ES_lattice_zoom.MajorTicks(:)));
zef.h_ES_lattice_zoom.Value             = zef.h_ES_lattice_zoom.MajorTicks(minIdx); clear minIdx;
zef.ES_lattice_zoom                     = zef.h_ES_lattice_zoom.Value;
zef.ES_step_size                        = get(zef.h_ES_step_size,'Value');

zef.ES_inv_colormap                     = get(zef.h_ES_inv_colormap,'Value');
zef.ES_plot_type                        = get(zef.h_ES_plot_type,'Value');

zef.ES_objfun                           = get(zef.h_ES_objfun,'Value');

zef.ES_relativeweightnnz                = get(zef.h_ES_relativeweightnnz,'Value');
zef.ES_effectivennz                     = get(zef.h_ES_effectivennz,'Value');
zef.ES_scoredose                        = get(zef.h_ES_scoredose,'Value');
zef.ES_scoredose_checkbox               = get(zef.h_ES_scoredose_checkbox,'Value');
zef.ES_solvermaximumcurrent             = get(zef.h_ES_solvermaximumcurrent,'Value');
zef.ES_solvermaximumcurrent_checkbox    = get(zef.h_ES_solvermaximumcurrent_checkbox,'Value');



if evalin('base','zef.ES_search_type') == 2
    zef.h_ES_optimizer_tolerance_max.Enable = 'on';
    zef.h_ES_regularization_parameter_max.Enable = 'on';
    zef.h_ES_search_method.Enable = 'on';
    zef.h_ES_step_size.Enable = 'on';
    zef.h_ES_lattice_zoom.Enable = 'on';
else
    zef.h_ES_search_method.Enable = 'off';
    zef.h_ES_optimizer_tolerance_max.Enable = 'off';
    zef.h_ES_regularization_parameter_max.Enable = 'off';
    zef.h_ES_step_size.Enable = 'off';
    zef.h_ES_lattice_zoom.Enable = 'off';
end

if evalin('base','zef.ES_search_method') == 2 && evalin('base','zef.ES_search_type') ~= 1
    zef.h_ES_step_size.Enable = 'on';
else
    zef.h_ES_step_size.Enable = 'off';
end

if evalin('base','zef.h_ES_current_threshold_checkbox.Value')
    zef.h_ES_current_threshold.Enable = 'on';
else
    zef.h_ES_current_threshold.Enable = 'off';
end

if evalin('base','zef.h_ES_scoredose_checkbox.Value')
    zef.h_ES_scoredose.Enable = 'off';
else
    zef.h_ES_scoredose.Enable = 'on';
end
if evalin('base','zef.h_ES_solvermaximumcurrent_checkbox.Value')
    zef.h_ES_solvermaximumcurrent.Enable = 'off';
else
    zef.h_ES_solvermaximumcurrent.Enable = 'on';
end