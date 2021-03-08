%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zeffiro_interface_figure_tool;
%zef.h_zeffiro = open('zeffiro_interface_figure_tool.fig');
%zef.o_h = findall(zef.h_zeffiro);
%zef.h_axes1 = findobj(zef.o_h,'Type','Axes');
%zef.h_axes1  = zef.h_axes1(1); 
%set(zef.h_zeffiro,'paperunits','inches');
%zef=rmfield(zef,'o_h');

set(findobj(zef.h_zeffiro.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro.Children,'-property','FontSize'),'FontSize',zef.font_size);
%set(findobj(zef.h_zeffiro.Children,'-property','FontUnits'),'FontUnits','normalized')

set(zef.h_zeffiro,'paperposition',[0 0 zef.snapshot_horizontal_resolution/200 zef.snapshot_vertical_resolution/200]);
set(zef.h_zeffiro,'papersize',[zef.snapshot_vertical_resolution/200 zef.snapshot_horizontal_resolution/200]);



% if evalin('base','zef.prism_layers');
%     if isfield(zef,'prisms')
%         zef.size_prisms = size(zef.prisms,1);
%     else
%         zef.size_prisms = 0;
%     end
% zef.h = evalin('base','zef.h_text_elements'); set(zef.h,'string',num2str(size(zef.tetra,1)+zef.size_prisms));
% else
% zef.h = evalin('base','zef.h_text_elements'); set(zef.h,'string',num2str(size(zef.tetra,1)));    
% end
% zef.h = evalin('base','zef.h_text_nodes'); set(zef.h,'string',num2str(size(zef.nodes,1)));
% 
% if evalin('base','zef.on_screen') == 0
%     set(zef.h_text_image,'string',[]);
% end
% if evalin('base','zef.on_screen') == 1
%     set(zef.h_text_image,'string','volume');
% end
% if evalin('base','zef.on_screen') == 2
%     set(zef.h_text_image,'string','surfaces');
% end
% if evalin('base','zef.inv_scale') == 1
%     set(zef.h_text_scale,'string','Logarithmic');
% end
% if evalin('base','zef.inv_scale') == 2
%     set(zef.h_text_scale,'string','Linear');
% end
% if evalin('base','zef.inv_scale') == 3
%     set(zef.h_text_scale,'string','Sqrt');
% end
% if evalin('base','zef.source_direction_mode') == 1
%     set(zef.h_text_field,'string','Cartesian');
% end
% if evalin('base','zef.source_direction_mode') == 2
%     set(zef.h_text_field,'string','Normal');
% end
% if evalin('base','zef.source_direction_mode') == 3
%     set(zef.h_text_field,'string','Basis');
% end
% if evalin('base','zef.reconstruction_type') == 1
%     set(zef.h_text_part,'string','Amplitude');
% end
% if evalin('base','zef.reconstruction_type') == 2
%     set(zef.h_text_part,'string','Normal');
% end
% if evalin('base','zef.reconstruction_type') == 3
%     set(zef.h_text_part,'string','Tangential');
% end
% if evalin('base','zef.reconstruction_type') == 4
%     set(zef.h_text_part,'string','Normal (+)');
% end
% if evalin('base','zef.reconstruction_type') == 5
%     set(zef.h_text_part,'string','Normal (-)');
% end
% if evalin('base','zef.reconstruction_type') == 6
%     set(zef.h_text_part,'string','Value');
% end
% if evalin('base','zef.reconstruction_type') == 7
%     set(zef.h_text_part,'string','Amplitude');
% end

if zef.clear_axes1
%cla(zef.h_axes1);
zef.h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'tag','Colorbar');
if not(isempty(zef.h_colorbar))
colorbar(zef.h_colorbar,'delete'); 
end
else
zef.clear_axes1 = 1;  
end


set(zef.h_zeffiro,'AutoResizeChildren','off');
zef.zeffiro_current_size = get(zef.h_zeffiro,'Position');
set(zef.h_zeffiro,'SizeChangedFcn','zef.zeffiro_current_size = zef_change_size_function(zef.h_zeffiro,zef.zeffiro_current_size);');


