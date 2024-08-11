function zef = zef_strip_tool_update(zef)

struct_aux = zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip};

struct_aux.tip_point = [str2num(zef.strip_tool.h_tip_point_1.String) ; ...
    str2num(zef.strip_tool.h_tip_point_2.String) ; ...
    str2num(zef.strip_tool.h_tip_point_3.String) ];

struct_aux.encapsulation_shift = [str2num(zef.strip_tool.h_encapsulation_shift_1.String) ; ...
    str2num(zef.strip_tool.h_encapsulation_shift_2.String) ; ...
    str2num(zef.strip_tool.h_encapsulation_shift_3.String) ];

struct_aux.orientation_axis{1} = [str2num(zef.strip_tool.h_orientation_axis_1.String) ; ...
    str2num(zef.strip_tool.h_orientation_axis_2.String) ; ...
    str2num(zef.strip_tool.h_orientation_axis_3.String) ];

struct_aux.orientation_axis{2} = [str2num(zef.strip_tool.h_encapsulation_orientation_axis_1.String) ; ...
    str2num(zef.strip_tool.h_encapsulation_orientation_axis_2.String) ; ...
    str2num(zef.strip_tool.h_encapsulation_orientation_axis_3.String) ];

struct_aux.strip_model = zef.strip_tool.h_strip_model.Value;
struct_aux.strip_impedance = str2num(zef.strip_tool.h_strip_impedance.String);
struct_aux.strip_conductivity = str2num(zef.strip_tool.h_strip_conductivity.String);
struct_aux.encapsulation_conductivity = str2num(zef.strip_tool.h_encapsulation_conductivity.String);
struct_aux.encapsulation_on = zef.strip_tool.h_encapsulation_on.Value;
struct_aux.strip_angle = str2num(zef.strip_tool.h_strip_angle.String);
struct_aux.strip_tag = zef.strip_tool.h_strip_tag.String;

struct_aux.strip_length = str2num(zef.strip_tool.h_strip_length.String);
struct_aux.encapsulation_length = str2num(zef.strip_tool.h_encapsulation_length.String);
struct_aux.encapsulation_thickness = str2num(zef.strip_tool.h_encapsulation_thickness.String);
struct_aux.strip_n_sectors = str2num(zef.strip_tool.h_strip_n_sectors.String);

if not(isfield(struct_aux,'strip_status'))
struct_aux.strip_status = 'Tentative';
end

zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip} = struct_aux;

cell_aux = zef.([zef.current_sensors '_strip_cell']);

zef.strip_tool.h_strip_list.String = cell(0);

for i = 1 : length(cell_aux)

if isequal(cell_aux{i}.strip_status,'Tentative')
color_str_aux_1 = 'orange';
elseif isequal(cell_aux{i}.strip_status,'Embedded')
    color_str_aux_1 = 'green';
end

if isequal(cell_aux{i}.encapsulation_on, 1)
    color_str_aux_2 = 'red';
    str_aux = 'On';
else
    color_str_aux_2 = 'black';
    str_aux = 'Off';
end

string_aux = ['<HTML><BODY>' 'ID: ' num2str(cell_aux{i}.strip_id) ', Tag: ' cell_aux{i}.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{cell_aux{i}.strip_model} ', Status: <SPAN style="color:' color_str_aux_1 '">' cell_aux{i}.strip_status '</SPAN>' ', Encapsulation: <SPAN style="color:' color_str_aux_2 '">' str_aux '</SPAN> </BODY></HTML>']; 
zef.strip_tool.h_strip_list.String{i} = string_aux;

end

%zef.strip_tool.h_strip_compartment_list.String = cell(0);

% for i = 1 : length(zef.compartment_tags)-1
% 
% zef.strip_tool.h_strip_compartment_list.String{i} = zef.([zef.compartment_tags{i} '_name']);
% 
% end

end