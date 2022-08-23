%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_update_fig_details(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.aux_field = cell(0);
zef_j = 0;
if isfield(zef,[zef.current_sensors '_points'])
    if size(eval(['zef.' zef.current_sensors '_visible_list']),1)==size(eval(['zef.' zef.current_sensors '_points']),1)
for zef_i = 1 : size(eval(['zef.' zef.current_sensors '_points']),1)
if eval(['zef.' zef.current_sensors '_visible_list(' num2str(zef_i) ')'])
    zef_j = zef_j + 1;
    zef.aux_field{zef_j} = ['<HTML><BODY>' '&nbsp <SPAN bgcolor="rgb(' num2str(round(255*eval(['zef.' zef.current_sensors '_color_table(' num2str(zef_i) ',1)']))) ',' num2str(round(255*eval(['zef.' zef.current_sensors '_color_table(' num2str(zef_i) ',2)']))) ',' num2str(round(255*eval(['zef.' zef.current_sensors '_color_table(' num2str(zef_i) ',3)']))) ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp &nbsp ' eval(['zef.' zef.current_sensors '_name_list{' num2str(zef_i) '}']) '</BODY></HTML>'  ];
end
end
    end
end
set(zef.h_sensor_visible_color,'String',zef.aux_field);
zef.aux_field = cell(0);
zef_j = 0;
for zef_i = 1 : length(zef.compartment_tags)
    if eval(['zef.' zef.compartment_tags{zef_i} '_on']) && eval(['zef.' zef.compartment_tags{zef_i} '_visible'])
    zef_j = zef_j + 1;
        zef.aux_field{zef_j} = ['<HTML><BODY>' '&nbsp <SPAN bgcolor="rgb(' num2str(round(255*eval(['zef.' zef.compartment_tags{zef_i} '_color(1)']))) ',' num2str(round(255*eval(['zef.' zef.compartment_tags{zef_i} '_color(2)']))) ',' num2str(round(255*eval(['zef.' zef.compartment_tags{zef_i} '_color(3)']))) ')"> &nbsp &nbsp &nbsp </SPAN> &nbsp &nbsp ' eval(['zef.' zef.compartment_tags{zef_i} '_name']) '</BODY></HTML>'  ];
    end
end
set(zef.h_sensor_visible_color,'Min',1);
set(zef.h_sensor_visible_color,'Max',length(zef.aux_field));
set(zef.h_compartment_visible_color,'String',fliplr(zef.aux_field));

  zef.aux_field = {['Nodes: ' num2str(size(zef.nodes,1))],...
    ['Tetrahedra: ' num2str(size(zef.tetra,1))],...
    };

if eval('zef.on_screen') == 0
    zef.aux_field = [zef.aux_field, {'Visualization: '}];
end
if eval('zef.on_screen') == 1
    zef.aux_field = [zef.aux_field, {'Visualization: Volume'}];
end
if eval('zef.on_screen') == 2
   zef.aux_field = [zef.aux_field, {'Visualization: Surfaces'}];
end
if eval('zef.inv_scale') == 1
    zef.aux_field = [zef.aux_field, {'Scale: Logarithmic'}];
end
if eval('zef.inv_scale') == 2
      zef.aux_field = [zef.aux_field, {'Scale: Linear'}];
end
if eval('zef.inv_scale') == 3
    zef.aux_field = [zef.aux_field, {'Scale: Square root'}];
end
if eval('zef.source_direction_mode') == 1
        zef.aux_field = [zef.aux_field, {'Field basis: Cartesian'}];
end
if eval('zef.source_direction_mode') == 2
       zef.aux_field = [zef.aux_field, {'Field basis: Normal'}];
end
if eval('zef.source_direction_mode') == 3
       zef.aux_field = [zef.aux_field, {'Field basis: Mesh'}];
end
if eval('zef.reconstruction_type') == 1
       zef.aux_field = [zef.aux_field, {'Field: Amplitude'}];
end
if eval('zef.reconstruction_type') == 2
    zef.aux_field = [zef.aux_field, {'Field: Normal'}];
end
if eval('zef.reconstruction_type') == 3
   zef.aux_field = [zef.aux_field, {'Field: Tangential'}];
end
if eval('zef.reconstruction_type') == 4
     zef.aux_field = [zef.aux_field, {'Field: Normal (+)'}];
end
if eval('zef.reconstruction_type') == 5
   zef.aux_field = [zef.aux_field, {'Field: Normal (-)'}];
end
if eval('zef.reconstruction_type') == 6
    zef.aux_field = [zef.aux_field, {'Field: Value'}];
end
if eval('zef.reconstruction_type') == 7
     zef.aux_field = [zef.aux_field, {'Field: Amplitude smoothed'}];
end

set(zef.h_system_information, 'String',zef.aux_field);
zef = rmfield(zef,'aux_field');

clear zef_i;

if nargout == 0
assignin('base','zef',zef);
end
