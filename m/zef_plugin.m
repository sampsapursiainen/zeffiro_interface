%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if isempty(zef.plugin_cell)
zef.plugin_cell = readcell([zef.program_path '/profile/' zef.profile_name '/zeffiro_plugins.ini'],'filetype','text','delimiter',',');
end
for zef_i = 1 : size(zef.plugin_cell,1)
zef.h_menu_1 = findobj(zef.h_zeffiro_menu,'Tag',zef.plugin_cell{zef_i,2});
zef.h_menu_2 = findobj(zef.h_menu_1.Children,'label',zef.plugin_cell{zef_i,1});
if not(isempty(zef.h_menu_2))
    set(zef.h_menu_2,'Callback',[zef.plugin_cell{zef_i,3} '; zef_update;']);
else
zef.h_menu_2 = uimenu(zef.h_menu_1,'label',zef.plugin_cell{zef_i,1},'callback',[zef.plugin_cell{zef_i,3} '; zef_update;'] );
end
end
clear zef_i;
zef = rmfield(zef,{'h_menu_1','h_menu_2'});
