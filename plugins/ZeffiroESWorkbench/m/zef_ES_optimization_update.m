zef_ES_update_parameter_values;

zef.ES_search_type                      = get(zef.h_ES_search_type,'Value');
zef.ES_search_method                    = get(zef.h_ES_search_method,'Value');
zef.ES_inv_colormap                     = get(zef.h_ES_inv_colormap,'Value');
zef.ES_plot_type                        = get(zef.h_ES_plot_type,'Value');
zef.ES_objfun                           = get(zef.h_ES_objfun,'Value');
zef.ES_objfun_2                         = get(zef.h_ES_objfun_2,'Value');
zef.ES_fixed_active_electrodes          = get(zef.h_ES_fixed_active_electrodes,'Value');

zef_ES_init_parameter_table;
