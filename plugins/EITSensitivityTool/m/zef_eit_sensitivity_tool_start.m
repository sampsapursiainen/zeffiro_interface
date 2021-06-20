zef_data = zef_eit_sensitivity_tool;

zef.h_eit_sensitivity_tool = zef_data.UIFigure;
zef.h_eit_sensitivity_tool_activate = zef_data.h_eit_sensitivity_tool_activate;
zef.h_eit_sensitivity_tool_import = zef_data.h_eit_sensitivity_tool_import;
zef.h_eit_sensitivity_tool_file = zef_data.h_eit_sensitivity_tool_file;
zef.h_eit_sensitivity_tool_distribution = zef_data.h_eit_sensitivity_tool_distribution;
zef.h_eit_sensitivity_tool_substitute = zef_data.h_eit_sensitivity_tool_substitute;

zef.sigma_bypass = 0; 
set(zef.h_eit_sensitivity_tool_activate,'fontcolor',[0 0 0]); 
set(zef.h_eit_sensitivity_tool_activate,'text','Inactive');

set(zef.h_eit_sensitivity_tool_activate,'ButtonPushedFcn','if zef.sigma_bypass == 0; zef.sigma_bypass = 1; set(zef.h_eit_sensitivity_tool_activate,''fontcolor'',[1 0 0]); set(zef.h_eit_sensitivity_tool_activate,''text'',''Active''); else;  zef.sigma_bypass = 0; set(zef.h_eit_sensitivity_tool_activate,''fontcolor'',[0 0 0]); set(zef.h_eit_sensitivity_tool_activate,''text'',''Inactive'');end;');
set(zef.h_eit_sensitivity_tool_import,'ButtonPushedFcn','zef_eit_sensitivity_tool_import;');
set(zef.h_eit_sensitivity_tool_substitute,'ButtonPushedFcn','zef_eit_sensitivity_tool_substitute;');

set(findobj(zef.h_eit_sensitivity_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);
set(zef.h_eit_sensitivity_tool,'AutoResizeChildren','off');
zef.eit_sensitivity_tool_current_size  = get(zef.h_eit_sensitivity_tool,'Position');
set(zef.h_eit_sensitivity_tool,'SizeChangedFcn', 'zef.eit_sensitivity_tool_current_size = zef_change_size_function(zef.h_eit_sensitivity_tool,zef.eit_sensitivity_tool_current_size);');

zef.h_create_dipolar_pair.Name = 'ZEFFIRO Interface: EIT Sensitivity Tool';


clear zef_data;
