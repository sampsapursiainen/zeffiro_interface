function window_handle = zef_window_visible(zef,window_handle)

window_handle.Position(1) = zef.h_zeffiro_menu.Position(1)+zef.h_zeffiro_menu.Position(3)-window_handle.Position(3);
window_handle.Position(2) = zef.h_zeffiro_menu.Position(2)+zef.h_zeffiro_menu.Position(4)-window_handle.Position(4);
window_handle.Visible = 'on';
set(findobj(window_handle.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(window_handle.Children,'-property','FontSize'),'FontSize',zef.font_size);

end