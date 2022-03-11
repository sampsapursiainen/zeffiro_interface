function zef_plugin_settings_table_selection(hObject,eventdata,handles)

plugin_settings_selected = eventdata.Indices(:,1);
plugin_settings_selected = unique(plugin_settings_selected);
plugin_settings_selected = plugin_settings_selected(:)';
evalin('base',['zef.plugin_settings_selected =[' num2str(plugin_settings_selected) '];']);

end
