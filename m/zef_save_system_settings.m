writecell(zef.h_system_settings_table.Data,[zef.program_path '/profile/zeffiro_interface.ini'],'FileType','text');
for zef_i = 1 : size(zef.h_system_settings_table.Data,1)
evalin('base',['zef.' zef.h_system_settings_table.Data{zef_i,3} '= zef.h_system_settings_table.Data{zef_i,2};']);
end
