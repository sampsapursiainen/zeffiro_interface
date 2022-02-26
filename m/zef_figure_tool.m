%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zeffiro_interface_figure_tool;

set(findobj(zef.h_zeffiro.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro.Children,'-property','FontSize'),'FontSize',zef.font_size);
set(findobj(zef.h_zeffiro.Children,'Tag','copyright_text'),'FontSize',0.5*zef.font_size);

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

if isfield(zef,'zeffiro_current_size')
if not(iscell(zef.zeffiro_current_size))
zef = rmfield(zef,'zeffiro_current_size');
end
end

set(zef.h_zeffiro,'Name',[get(zef.h_zeffiro,'Name') ' ' num2str(zef_fig_num)]);
set(zef.h_zeffiro,'AutoResizeChildren','off');
zef.zeffiro_current_size{zef_fig_num} = get(zef.h_zeffiro,'Position');
set(zef.h_zeffiro,'Tag',num2str(zef_fig_num));
set(zef.h_zeffiro,'SizeChangedFcn','zef_set_figure_current_size');
