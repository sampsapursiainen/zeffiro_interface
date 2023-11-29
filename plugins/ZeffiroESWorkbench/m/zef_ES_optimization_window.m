function zef = zef_ES_optimization_window(zef)
zef_ES_optimization_init;
zef_data = zef_ES_optimization_app;
%% zef_data
% Figure
zef.h_ES_workbench              = zef_data.h_ES_workbench;

% DropDown
zef.h_ES_opt_solver             = zef_data.h_ES_opt_solver;
zef.h_ES_opt_method             = zef_data.h_ES_opt_method;
zef.h_ES_opt_algorithm          = zef_data.h_ES_opt_algorithm;

zef.h_ES_obj_fun                = zef_data.h_ES_obj_fun;
zef.h_ES_obj_fun_2              = zef_data.h_ES_obj_fun_2;
zef.h_ES_threshold_condition    = zef_data.h_ES_threshold_condition;

zef.h_ES_HPO_search_method      = zef_data.h_ES_HPO_search_method;

zef.h_ES_plot_type              = zef_data.h_ES_plot_type;
zef.h_ES_inv_colormap           = zef_data.h_ES_inv_colormap;

% Button
zef.h_ES_find_currents_button   = zef_data.h_ES_find_currents_button;
zef.h_ES_update_reconstruction  = zef_data.h_ES_update_reconstruction;
zef.h_ES_plot_data              = zef_data.h_ES_plot_data;

% Checkbox
zef.h_ES_fixed_active_electrodes= zef_data.h_ES_fixed_active_electrodes;
zef.h_ES_2D_electrode_map       = zef_data.h_ES_2D_electrode_map;

% Table
zef.h_ES_parameter_table        = zef_data.h_ES_parameter_table;

% Spinner
zef.h_ES_HPO_recursive_instances = zef_data.h_ES_HPO_recursive_instances;

% Labels
zef.h_ES_recursive_instances_label = zef_data.h_ES_recursive_instances_label;

% Context menu (Right-click)
zef.h_ES_plot_data_menu_item_1  = zef_data.h_ES_plot_data_menu_item_1;
zef.h_ES_plot_data_menu_item_2  = zef_data.h_ES_plot_data_menu_item_2;
zef.h_ES_plot_data_menu_item_3  = zef_data.h_ES_plot_data_menu_item_3;
zef.h_ES_plot_data_menu_item_4  = zef_data.h_ES_plot_data_menu_item_4;
zef.h_ES_plot_data_menu_item_5  = zef_data.h_ES_plot_data_menu_item_5;

clear zef_data;
%% Table
zef.h_ES_parameter_table.CellEditCallback        = 'zef_ES_optimization_update;';
%% Button
zef.h_ES_plot_data.ButtonPushedFcn               = 'zef_ES_plot_data;';
zef.h_ES_update_reconstruction.ButtonPushedFcn   = 'zef_ES_update_reconstruction; zef_plot_meshes;';
zef.h_ES_find_currents_button.ButtonPushedFcn    = 'question_aux = questdlg(''Confirm calculations?'',''ZI'',''Yes'',''No'', ''No''); switch question_aux; case ''Yes''; if     zef.h_ES_HPO_search_method.Value == 1; zef = zef_ES_find_currents(zef); elseif zef.h_ES_HPO_search_method.Value == 2; zef = zef_ES_find_currents_recursive(zef); end;; end;;';
%% Right-click
zef.h_ES_plot_data_menu_item_1.MenuSelectedFcn   = 'zef_ES_update_reconstruction; zef_plot_meshes; zef_ES_plot_current_pattern(zef);';
zef.h_ES_plot_data_menu_item_2.MenuSelectedFcn   = 'zef_ES_plot_barplot(zef);';
zef.h_ES_plot_data_menu_item_3.MenuSelectedFcn   = 'zef_ES_plot_error_chart(zef);';
zef.h_ES_plot_data_menu_item_4.MenuSelectedFcn   = 'zef_ES_optimizer_properties_show;';
zef.h_ES_plot_data_menu_item_5.MenuSelectedFcn   = 'zef_ES_plot_distance_curves;';
%% Checkboxes
zef.h_ES_fixed_active_electrodes.ValueChangedFcn = 'zef.ES_active_electrodes = zef_ES_fix_active_electrodes(zef);';
zef.ES_active_electrodes                         = zef_ES_fix_active_electrodes(zef);
%% Drop Down
zef.h_ES_opt_solver.Items                       = zef.ES_opt_solver_list;
zef.h_ES_opt_solver.ValueChangedFcn             = 'zef_ES_optimization_update;';
zef.h_ES_opt_solver.ItemsData                   = 1:length(zef.h_ES_opt_solver.Items);
zef.h_ES_opt_solver.Value                       = zef.ES_opt_solver;

zef.h_ES_opt_method.Items                       = zef.ES_opt_method_list;
zef.h_ES_opt_method.ValueChangedFcn             = 'zef_ES_optimization_update;';
zef.h_ES_opt_method.ItemsData                   = 1:length(zef.h_ES_opt_method.Items);
zef.h_ES_opt_method.Value                       = zef.ES_opt_method;

zef.h_ES_opt_algorithm.Items                    = zef.ES_opt_algorithm_list;
zef.h_ES_opt_algorithm.ValueChangedFcn          = 'zef_ES_optimization_update;';
zef.h_ES_opt_algorithm.ItemsData                = 1:length(zef.h_ES_opt_algorithm.Items);
zef.h_ES_opt_algorithm.Value                    = find(ismember(zef.h_ES_opt_algorithm.Items, zef.ES_opt_algorithm), 1);

vec = zef_ES_table;
zef.h_ES_obj_fun.Items                          = vec.Properties.VariableNames(find(~strcmp(vec.Properties.VariableDescriptions, 'none')));
zef.h_ES_obj_fun.ValueChangedFcn                = 'zef_ES_optimization_update;';
zef.h_ES_obj_fun.ItemsData                      = 1:length(zef.h_ES_obj_fun.Items);
zef.h_ES_obj_fun.Value                          = zef.ES_obj_fun;

zef.h_ES_obj_fun_2.Items                        = zef.h_ES_obj_fun.Items;
zef.h_ES_obj_fun_2.ValueChangedFcn              = 'zef_ES_optimization_update;';
zef.h_ES_obj_fun_2.ItemsData                    = 1:length(zef.h_ES_obj_fun_2.Items);
zef.h_ES_obj_fun_2.Value                        = zef.ES_obj_fun_2;

zef.h_ES_threshold_condition.Items              = {'Relative','Absolute'};
zef.h_ES_threshold_condition.ValueChangedFcn    = 'zef_ES_optimization_update;';
zef.h_ES_threshold_condition.ItemsData          = 1:length(zef.h_ES_threshold_condition.Items);
zef.h_ES_threshold_condition.Value              = zef.ES_threshold_condition;

zef.h_ES_HPO_search_method.Items                = zef.ES_HPO_search_method_list;
zef.h_ES_HPO_search_method.ValueChangedFcn      = 'if zef.h_ES_HPO_search_method.Value ~= 2; zef.h_ES_HPO_recursive_instances.Visible = ''off''; zef.h_ES_recursive_instances_label.Visible = ''off''; else; zef.h_ES_HPO_recursive_instances.Visible = ''on''; zef.h_ES_recursive_instances_label.Visible = ''on''; end;';
zef.h_ES_HPO_search_method.ItemsData            = 1:length(zef.h_ES_HPO_search_method.Items);
zef.h_ES_HPO_search_method.Value                = zef.ES_HPO_search_method;


zef.h_ES_plot_type.Items                        = {'Current pattern', 'Electrode potentials', 'Error Chart', 'Show properties', 'Plot distance curves'};
zef.h_ES_plot_type.ValueChangedFcn              = 'zef_ES_optimization_update;';
zef.h_ES_plot_type.ItemsData                    = 1:length(zef.h_ES_plot_type.Items);
zef.h_ES_plot_type.Value                        = zef.ES_plot_type;

zef.h_ES_inv_colormap.ValueChangedFcn           = 'zef_ES_optimization_update;';
zef.h_ES_inv_colormap.ItemsData                 = 1:length(zef.h_ES_inv_colormap.Items);
zef.h_ES_inv_colormap.Value                     = zef.ES_inv_colormap;

%% Spinner
zef.h_ES_HPO_recursive_instances.ValueChangedFcn = 'zef.ES_HPO_recursive_instances  = zef.h_ES_HPO_recursive_instances.Value;';

%%
if not(ismember(zef.ES_opt_solver, zef.h_ES_opt_solver.ItemsData))
    zef.h_ES_opt_solver.Value = 1;
else
    zef.h_ES_opt_solver.Value = zef.ES_opt_solver;
end
%% Autoresize
set(zef.h_ES_workbench,'AutoResizeChildren','off');
zef.h_ES_workbench_current_size  = get(zef.h_ES_workbench,'Position');

%not = setdiff(zef.h_ES_workbench.Children, findobj(zef.h_ES_workbench.Children,'-not',{'Type','uitoolbar','-or','Type','uipushtool','-or','Type','uimenu'}));

zef.h_ES_workbench_relative_size = zef_get_relative_size(zef.h_ES_workbench);
set(zef.h_ES_workbench,'SizeChangedFcn', 'zef.h_ES_workbench_current_size = zef_change_size_function(zef.h_ES_workbench, zef.h_ES_workbench_current_size, zef.h_ES_workbench_relative_size);');
%%
set(findobj(zef.h_ES_workbench.Children,'-property','FontUnits'), 'FontUnits', 'pixels');
set(findobj(zef.h_ES_workbench.Children,'-property','FontSize'),  'FontSize', 14);

zef_ES_init_parameter_table;
zef_ES_optimization_update;

if nargout == 0
    assignin('base','zef',zef);
end
end