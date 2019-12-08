%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef_data= zeffiro_interface_filter_tool;
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end   
set(zef.h_zef_filter_tool,'Name','ZEFFIRO Interface: Filter tool');
set(findobj(zef.h_zef_filter_tool.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zef_filter_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);
clear zef_i zef_data;

zef_init_filter_tool;

zef.h_filter_save_as.ButtonPushedFcn = 'zef_filter_save_as;';
zef.h_filter_load.ButtonPushedFcn = 'zef_filter_load;';
zef.h_filter_import_data.ButtonPushedFcn = 'zef_import_raw_data;';
zef.h_filter_plot_data.ButtonPushedFcn = 'zef_filter_raw_data; zef_filter_plot_data;';
zef.h_filter_export_data.ButtonPushedFcn = 'zef_filter_export_data;';
zef.h_add_filter.ButtonPushedFcn = 'zef_add_filter_item;';
zef.h_del_filter.ButtonPushedFcn = '[zef.yesno] = questdlg(''Delete selected filters?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_delete_filter_item; end;';
zef.h_move_up_filter.ButtonPushedFcn = 'zef_move_up_filter_item;';
zef.h_move_down_filter.ButtonPushedFcn = 'zef_move_down_filter_item;';
zef.h_filter_tag.ValueChangedFcn = 'zef.filter_tag = get(zef.h_filter_tag,''value'');';
zef.h_filter_pipeline_list.ValueChangedFcn = 'zef.filter_pipeline_selected = get(zef.h_filter_pipeline_list,''value'');zef_update_filter_tool;';
zef.h_filter_parameter_list.DisplayDataChangedFcn = 'zef.filter_pipeline{find(ismember(zef.filter_pipeline_list,zef.filter_pipeline_selected),1)}.parameters = zef.h_filter_parameter_list.Data;';
zef.h_filter_list.ValueChangedFcn = 'zef.filter_list_selected = get(zef.h_filter_list,''value'');';