zef_ES_optimization_init;
zef_data = zef_ES_optimization_app;
%% zef_data
zef.h_ES_parameter_table                  = zef_data.h_ES_parameter_table;
zef.h_ES_workbench                        = zef_data.h_ES_workbench;
zef.h_ES_plot_type                        = zef_data.h_ES_plot_type;
zef.h_ES_plot_data                        = zef_data.h_ES_plot_data;
zef.h_ES_update_reconstruction            = zef_data.h_ES_update_reconstruction;
zef.h_ES_search_type                      = zef_data.h_ES_search_type;
zef.h_ES_search_method                    = zef_data.h_ES_search_method;
zef.h_ES_find_currents_button             = zef_data.h_ES_find_currents_button;
zef.h_ES_inv_colormap                     = zef_data.h_ES_inv_colormap;
zef.h_ES_objfun                           = zef_data.h_ES_objfun;
zef.h_ES_fixed_active_electrodes          = zef_data.h_ES_fixed_active_electrodes;
zef.h_ES_plot_data_menu_item_1 = zef_data.h_ES_plot_data_menu_item_1;
zef.h_ES_plot_data_menu_item_2 = zef_data.h_ES_plot_data_menu_item_2;
zef.h_ES_plot_data_menu_item_3 = zef_data.h_ES_plot_data_menu_item_3;
zef.h_ES_plot_data_menu_item_4 = zef_data.h_ES_plot_data_menu_item_4;

clear zef_data;
zef_ES_init_parameter_table;
zef.h_ES_plot_type.Items =  {'Current pattern',  'Electrode potentials',  'Error Chart', 'Show optimizer properties'};
zef.h_ES_search_method.Items = {'L1 optimization',  'L2 optimization',  '4x1'};

%% 
zef.h_ES_parameter_table.CellEditCallback                = 'zef_ES_optimization_update;';
%% Button
zef.h_ES_plot_data.ButtonPushedFcn                       = 'zef.ES_update_plot_data = 1; zef_ES_update_plot_data;';
zef.h_ES_update_reconstruction.ButtonPushedFcn           = 'zef_ES_update_reconstruction;';
zef.h_ES_find_currents_button.ButtonPushedFcn            = 'zef_ES_find_currents_button;';
%% Drop Down
zef.h_ES_plot_type.ValueChangedFcn                       = 'zef_ES_optimization_update;';
zef.h_ES_plot_type.ItemsData                             = 1:length(zef.h_ES_plot_type.Items);
zef.h_ES_plot_type.Value                                 = zef.ES_plot_type;

zef.h_ES_plot_data_menu_item_1.MenuSelectedFcn = 'zef.ES_plot_type = 1;';
zef.h_ES_plot_data_menu_item_2.MenuSelectedFcn = 'zef.ES_plot_type = 2;';
zef.h_ES_plot_data_menu_item_3.MenuSelectedFcn = 'zef.ES_plot_type = 3;';
zef.h_ES_plot_data_menu_item_4.MenuSelectedFcn = 'zef.ES_plot_type = 4;';

zef.h_ES_fixed_active_electrodes.Value = zef.ES_fixed_active_electrodes;
zef.ES_active_electrodes               = zef_ES_fix_active_electrodes;
zef.h_ES_fixed_active_electrodes.ValueChangedFcn = 'zef.ES_active_electrodes = zef_ES_fix_active_electrodes;';


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


set(findobj(zef.h_ES_workbench.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_ES_workbench.Children,'-property','FontSize'),'FontSize',zef.font_size);

%% Autoresize
set(zef.h_ES_workbench,'AutoResizeChildren','off');
zef.h_ES_workbench_current_size = get(zef.h_ES_workbench,'Position');
set(zef.h_ES_workbench,'SizeChangedFcn', 'zef.h_ES_workbench_current_size = zef_change_size_function(zef.h_ES_workbench, zef.h_ES_workbench_current_size);');
