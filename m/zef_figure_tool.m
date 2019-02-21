zef.h_zeffiro = open('zeffiro_interface_figure_tool.fig');
zef.o_h = findall(zef.h_zeffiro);
zef.h_axes1 = zef.o_h(19);
zef=rmfield(zef,'o_h');

color_label('checkbox101','checkbox107','text1196');
color_label('checkbox201','checkbox207','text2196');
color_label('checkbox301','checkbox307','text3196');
color_label('checkbox401','checkbox407','text4196');
color_label('checkbox16','checkbox13','text195');
color_label('checkbox1','checkbox7','text196');
color_label('checkbox2','checkbox8','text197');
color_label('checkbox3','checkbox9','text198');
color_label('checkbox4','checkbox10','text199');
color_label('checkbox5','checkbox11','text200');

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

