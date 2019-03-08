zef.h_zeffiro = open('zeffiro_interface_figure_tool.fig');
zef.o_h = findall(zef.h_zeffiro);
zef.h_axes1 = zef.o_h(34);
zef=rmfield(zef,'o_h');

color_label('s');
color_label('w');
color_label('g');
color_label('c');
color_label('sk');
color_label('sc');
color_label('d1');
color_label('d2');
color_label('d3');
color_label('d4');
color_label('d5');
color_label('d6');
color_label('d7');
color_label('d8');
color_label('d9');
color_label('d10');
color_label('d11');
color_label('d12');
color_label('d13');

if evalin('base','zef.prism_layers');
    if isfield(zef,'prisms')
        zef.size_prisms = size(zef.prisms,1);
    else
        zef.size_prisms = 0;
    end
zef.h = evalin('base','zef.h_text_elements'); set(zef.h,'string',num2str(size(zef.tetra,1)+zef.size_prisms));
else
zef.h = evalin('base','zef.h_text_elements'); set(zef.h,'string',num2str(size(zef.tetra,1)));    
end
zef.h = evalin('base','zef.h_text_nodes'); set(zef.h,'string',num2str(size(zef.nodes,1)));

if evalin('base','zef.on_screen') == 0
    set(zef.h_text_image,'string',[]);
end
if evalin('base','zef.on_screen') == 1
    set(zef.h_text_image,'string','volume');
end
if evalin('base','zef.on_screen') == 2
    set(zef.h_text_image,'string','surfaces');
end
if evalin('base','zef.inv_scale') == 1
    set(zef.h_text_scale,'string','Logarithmic');
end
if evalin('base','zef.inv_scale') == 2
    set(zef.h_text_scale,'string','Linear');
end
if evalin('base','zef.inv_scale') == 3
    set(zef.h_text_scale,'string','Sqrt');
end
if evalin('base','zef.source_direction_mode') == 1
    set(zef.h_text_field,'string','Cartesian');
end
if evalin('base','zef.source_direction_mode') == 2
    set(zef.h_text_field,'string','Normal');
end
if evalin('base','zef.source_direction_mode') == 3
    set(zef.h_text_field,'string','Basis');
end
if evalin('base','zef.reconstruction_type') == 1
    set(zef.h_text_part,'string','Amplitude');
end
if evalin('base','zef.reconstruction_type') == 2
    set(zef.h_text_part,'string','Normal');
end
if evalin('base','zef.reconstruction_type') == 3
    set(zef.h_text_part,'string','Tangential');
end
if evalin('base','zef.reconstruction_type') == 4
    set(zef.h_text_part,'string','Normal (+)');
end
if evalin('base','zef.reconstruction_type') == 5
    set(zef.h_text_part,'string','Normal (-)');
end
if evalin('base','zef.reconstruction_type') == 6
    set(zef.h_text_part,'string','Value');
end
if evalin('base','zef.reconstruction_type') == 7
    set(zef.h_text_part,'string','Amplitude');
end

if zef.clear_axes1
%cla(zef.h_axes1);
zef.h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'tag','Colorbar');
if not(isempty(zef.h_colorbar))
colorbar(zef.h_colorbar,'delete'); 
end
else
zef.clear_axes1 = 1;  
end


