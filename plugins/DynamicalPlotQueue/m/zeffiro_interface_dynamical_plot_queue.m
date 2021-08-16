%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef_data=zeffiro_interface_dynamical_plot_queue_app;
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end   
set(zef.h_dynamical_plot_queue,'Name','ZEFFIRO Interface: Dynamical plot queue');
set(findobj(zef.h_dynamical_plot_queue.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_dynamical_plot_queue.Children,'-property','FontSize'),'FontSize',zef.font_size);
clear zef_i zef_data;

zef.h_dynamical_plot_queue_table.Data = zef.dynamical_plot_queue_table;

set(zef.h_dynamical_plot_queue_table,'columnformat',{'char','logical',{'static', 'dynamic'},'char'});
set(zef.h_dynamical_plot_queue_table,'CellEditCallback','zef.dynamical_plot_queue_table = zef.h_dynamical_plot_queue_table.Data;');
set(zef.h_dynamical_plot_queue_table,'CellSelectionCallback',@zef_dpq_selection);
set(zef.h_dynamical_plot_queue_menu_add,'MenuSelectedFcn','zef.h_dynamical_plot_queue_table.Data = zef_dpq_add;');
set(zef.h_dynamical_plot_queue_menu_delete,'MenuSelectedFcn','zef.h_dynamical_plot_queue_table.Data = zef_dpq_delete;');

set(zef.h_dynamical_plot_queue,'AutoResizeChildren','off');
zef.dynamical_plot_queue_current_size = get(zef.h_dynamical_plot_queue,'Position');
set(zef.h_dynamical_plot_queue,'SizeChangedFcn','zef.dynamical_plot_queue_current_size = zef_change_size_function(zef.h_dynamical_plot_queue,zef.zef_dynamical_plot_queue_current_size);');
