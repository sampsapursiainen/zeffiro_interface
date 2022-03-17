zef.plugin_cell = zef.h_plugin_settings_table.Data;
writecell(zef.plugin_cell,[zef.program_path '/profile/' zef.profile_name '/zeffiro_plugins.ini'],'FileType','text');
for zef_i = 1 : size(zef.h_plugin_settings_table.Data,1)
evalin('base',['zef.' zef.h_plugin_settings_table.Data{zef_i,3} '= zef.h_plugin_settings_table.Data{zef_i,2};']);
end
