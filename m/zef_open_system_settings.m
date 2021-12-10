zef_data = zef_system_settings;
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end   

zef.ini_cell = readcell([zef.program_path '/zeffiro_interface.ini'],'FileType','text');
zef.h_system_settings_table.Data = zef.ini_cell;
for zef_i = 1 : size(zef.ini_cell,1)
evalin('base',['zef.h_system_settings_table.Data{zef_i,2} = zef.' zef.ini_cell{zef_i,3} ';']);
end
zef = rmfield(zef,'ini_cell');
zef.h_system_settings_save.ButtonPushedFcn = 'zef_save_system_settings;';
set(zef.h_compartment_table,'columnformat',{'char','char','char'})

set(findobj(zef.h_system_settings.Children,'-property','FontSize'),'FontSize',zef.font_size);
set(zef.h_system_settings,'AutoResizeChildren','off');
zef.system_settings_current_size = get(zef.h_system_settings,'Position');
zef.system_settings_relative_size = zef_get_relative_size(zef.h_system_settings);
set(zef.h_system_settings,'SizeChangedFcn','zef.system_settings_current_size = zef_change_size_function(zef.h_system_settings,zef.system_settings_current_size,zef.system_settings_relative_size);');

zef.h_system_settings.Name = 'ZEFFIRO Interface: System settings';