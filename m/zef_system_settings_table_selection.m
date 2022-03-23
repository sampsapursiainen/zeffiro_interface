function zef_system_settings_table_selection(hObject,eventdata,handles)

system_settings_selected = eventdata.Indices(:,1);
system_settings_selected = unique(system_settings_selected);
system_settings_selected = system_settings_selected(:)';
evalin('base',['zef.system_settings_selected =[' num2str(system_settings_selected) '];']);

end
