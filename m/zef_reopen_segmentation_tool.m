set(zef.h_zeffiro_window_main,'DeleteFcn','');
close(zef.h_zeffiro_window_main);
zeffiro_interface_segmentation_tool;
zef_update;

set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.h_temp = findobj(zef.h_zeffiro_window_main,{'parent',zef.h_menu_forward_tools,'-or','parent',zef.h_menu_inverse_tools,'-or','parent',zef.h_menu_multi_tools});
zef.menu_accelerator_vec = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

for zef_k = 1 : length(zef.h_temp);
if zef_k <= length(zef.menu_accelerator_vec)
    set(zef.h_temp(zef_k),'accelerator',char(zef.menu_accelerator_vec(zef_k)));
end
end
zef_plugin;
zef.h_temp = findobj(zef.h_zeffiro_window_main,{'parent',zef.h_menu_forward_tools,'-or','parent',zef.h_menu_inverse_tools,'-or','parent',zef.h_menu_multi_tools},'accelerator','');
for zef_j = 1 : length(zef.h_temp);
if zef_j <= length(zef.menu_accelerator_vec)
    set(zef.h_temp(zef_j),'accelerator',char(zef.menu_accelerator_vec(zef_k+zef_j)));
end
end
clear zef_j zef_k
zef = rmfield(zef,'h_temp');
zef = rmfield(zef,'menu_accelerator_vec');
zef.clear_axes1 = 0;