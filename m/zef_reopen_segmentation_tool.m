set(zef.h_zeffiro_window_main,'DeleteFcn','');
close(zef.h_zeffiro_window_main);
zef_segmentation_tool;
zef_update;

set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.clear_axes1 = 0;


