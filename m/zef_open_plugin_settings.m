zef_data = zef_plugin_settings;
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end

set(zef.h_plugin_settings_table,'CellSelectionCallback',@zef_plugin_settings_table_selection);
if isempty(zef.plugin_cell)
zef.plugin_cell = readcell([zef.program_path '/profile/' zef.profile_name '/zeffiro_plugins.ini'],'FileType','text','Delimiter',',');
end
zef.h_plugin_settings_table.Data = zef.plugin_cell;

zef.h_plugin_settings_save.ButtonPushedFcn = 'zef_save_plugin_settings;';
zef.h_plugin_settings_apply.ButtonPushedFcn = 'zef_save_plugin_settings;zef_plugin;';
set(zef.h_plugin_settings_table,'columnformat',{'char','char','char',{'number','string'}})

set(zef.h_plugin_settings_update_from_profile,'ButtonPushedFcn','zef.h_plugin_settings_table.Data=readcell([zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_plugins.ini''],''FileType'',''text'',''Delimiter'','','');zef.plugin_cell=zef.h_plugin_settings_table.Data;');

set(zef.h_menu_plugin_settings_table_add,'MenuSelectedFcn','zef.h_plugin_settings_table.Data{end+1,1} = []; zef.h_plugin_settings_table.Data = [zef.h_plugin_settings_table.Data(1:zef.plugin_settings_selected(1),:) ; zef.h_plugin_settings_table.Data(end,:) ; zef.h_plugin_settings_table.Data(zef.plugin_settings_selected(1)+1:end-1,:)];');
set(zef.h_menu_plugin_settings_table_delete,'MenuSelectedFcn','zef.h_plugin_settings_table.Data = zef.h_plugin_settings_table.Data(find(not(ismember([1:size(zef.h_plugin_settings_table.Data,1)],zef.plugin_settings_selected))),:);');

set(findobj(zef.h_plugin_settings.Children,'-property','FontSize'),'FontSize',zef.font_size);
set(zef.h_plugin_settings,'AutoResizeChildren','off');
zef.plugin_settings_current_size = get(zef.h_plugin_settings,'Position');
zef.plugin_settings_relative_size = zef_get_relative_size(zef.h_plugin_settings);
set(zef.h_plugin_settings,'SizeChangedFcn','zef.plugin_settings_current_size = zef_change_size_function(zef.h_plugin_settings,zef.plugin_settings_current_size,zef.plugin_settings_relative_size);');

zef.h_plugin_settings.Name = 'ZEFFIRO Interface: Plugin settings';
