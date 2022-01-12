%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if isempty(zef.plugin_cell)
zef.plugin_cell = readcell([zef.program_path '/profile/' zef.profile_name '/zeffiro_plugins.ini'],'filetype','text','delimiter',',');
end
for zef_i = 1 : size(zef.plugin_cell,1)
zef.h_menu = findobj(zef.h_zeffiro_window_main,'Tag',zef.plugin_cell{zef_i,2});
zef.h_menu = uimenu(zef.h_menu,'label',zef.plugin_cell{zef_i,1},'callback',[zef.plugin_cell{zef_i,3} '; zef_update;'] );
end
clear zef_i;
zef = rmfield(zef,'h_menu');

