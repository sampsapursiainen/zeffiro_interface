if isvalid(zef.h_zeffiro_menu)
    set(zef.h_zeffiro_menu,'DeleteFcn','');

    
end

zef.current_log_file = zef.h_zeffiro_menu.ZefCurrentLogFile;
zef.zeffiro_task_id = zef.h_zeffiro_menu.ZefTaskId;
zef.zeffiro_restart_time = zef.h_zeffiro_menu.ZefRestartTime;
    delete(zef.h_zeffiro_menu);

zef_menu_tool;

zef = zef_update(zef);

set(findobj(zef.h_zeffiro_menu.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_menu.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.clear_axes1 = 0;


