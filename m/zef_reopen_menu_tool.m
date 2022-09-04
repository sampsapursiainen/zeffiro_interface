if isvalid(zef.h_zeffiro_menu)
    set(zef.h_zeffiro_menu,'DeleteFcn','');
delete(zef.h_zeffiro_menu);
end
zef_menu_tool
zef = zef_update(zef);

set(findobj(zef.h_zeffiro_menu.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_menu.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.clear_axes1 = 0;


