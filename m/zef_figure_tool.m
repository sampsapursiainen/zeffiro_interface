%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zeffiro_interface_figure_tool;

set(findobj(zef.h_zeffiro.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_zeffiro,'paperposition',[0 0 zef.snapshot_horizontal_resolution/200 zef.snapshot_vertical_resolution/200]);
set(zef.h_zeffiro,'papersize',[zef.snapshot_vertical_resolution/200 zef.snapshot_horizontal_resolution/200]);

if zef.clear_axes1
zef.h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'tag','Colorbar');
if not(isempty(zef.h_colorbar))
colorbar(zef.h_colorbar,'delete'); 
end
else
zef.clear_axes1 = 1;  
end

set(zef.h_zeffiro,'AutoResizeChildren','off');
zef.zeffiro_current_size = get(zef.h_zeffiro,'Position');
set(zef.h_zeffiro,'SizeChangedFcn','zef.zeffiro_current_size = zef_change_size_function(zef.h_zeffiro,zef.zeffiro_current_size,[],{''Colorbar''});');


