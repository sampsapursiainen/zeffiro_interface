%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.aux_field = cell(0);
for zef_i = 1 : length(zef.compartment_tags)
    zef_j = length(zef.compartment_tags) - zef_i + 1;
    zef.aux_field{zef_j} = ['<HTML><BODY>' '&nbsp <SPAN bgcolor="rgb(' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(1)']))) ',' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(2)']))) ',' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(3)']))) ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp &nbsp ' evalin('base',['zef.' zef.compartment_tags{zef_i} '_name']) '</BODY></HTML>'  ];   
end
set(zef.h_compartment_color,'String',zef.aux_field);
zef.aux_field = cell(0);
zef_j = 0;
for zef_i = 1 : length(zef.compartment_tags)
    if evalin('base',['zef.' zef.compartment_tags{zef_i} '_on']) && evalin('base',['zef.' zef.compartment_tags{zef_i} '_visible'])
    zef_j = zef_j + 1;
        zef.aux_field{zef_j} = ['<HTML><BODY>' '&nbsp <SPAN bgcolor="rgb(' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(1)']))) ',' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(2)']))) ',' num2str(round(255*evalin('base',['zef.' zef.compartment_tags{zef_i} '_color(3)']))) ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp &nbsp ' evalin('base',['zef.' zef.compartment_tags{zef_i} '_name']) '</BODY></HTML>'  ];   
    end
end
set(zef.h_compartment_visible_color,'String',fliplr(zef.aux_field));

  zef.aux_field = {['Tetrahedra: ' num2str(size(zef.tetra,1))],...
    ['Nodes: ' num2str(size(zef.nodes,1))],...
    ['Tetrahedra: ' num2str(size(zef.tetra,1))],...
    };

if evalin('base','zef.on_screen') == 0
    zef.aux_field = [zef.aux_field, {'Visualization: '}];
end
if evalin('base','zef.on_screen') == 1
    zef.aux_field = [zef.aux_field, {'Visualization: Volume'}];
end
if evalin('base','zef.on_screen') == 2
   zef.aux_field = [zef.aux_field, {'Visualization: Surfaces'}];
end
if evalin('base','zef.inv_scale') == 1
    zef.aux_field = [zef.aux_field, {'Scale: Logarithmic'}];
end
if evalin('base','zef.inv_scale') == 2
      zef.aux_field = [zef.aux_field, {'Scale: Linear'}];
end
if evalin('base','zef.inv_scale') == 3
    zef.aux_field = [zef.aux_field, {'Scale: Square root'}];
end
if evalin('base','zef.source_direction_mode') == 1
        zef.aux_field = [zef.aux_field, {'Field basis: Cartesian'}];
end
if evalin('base','zef.source_direction_mode') == 2
       zef.aux_field = [zef.aux_field, {'Field basis: Normal'}];
end
if evalin('base','zef.source_direction_mode') == 3
       zef.aux_field = [zef.aux_field, {'Field basis: Mesh'}];
end
if evalin('base','zef.reconstruction_type') == 1
       zef.aux_field = [zef.aux_field, {'Field: Amplitude'}];
end
if evalin('base','zef.reconstruction_type') == 2
    zef.aux_field = [zef.aux_field, {'Field: Normal'}];
end
if evalin('base','zef.reconstruction_type') == 3
   zef.aux_field = [zef.aux_field, {'Field: Tangential'}];
end
if evalin('base','zef.reconstruction_type') == 4
     zef.aux_field = [zef.aux_field, {'Field: Normal (+)'}];
end
if evalin('base','zef.reconstruction_type') == 5
   zef.aux_field = [zef.aux_field, {'Field: Normal (-)'}];
end
if evalin('base','zef.reconstruction_type') == 6
    zef.aux_field = [zef.aux_field, {'Field: Value'}];
end
if evalin('base','zef.reconstruction_type') == 7
     zef.aux_field = [zef.aux_field, {'Field: Amplitude smoothed'}];
end

set(zef.h_system_information, 'String',zef.aux_field);
zef = rmfield(zef,'aux_field');
clear zef_i;