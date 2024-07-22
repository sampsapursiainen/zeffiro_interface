function zef = zef_strip_tool_update(zef)

struct_aux = zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip};

struct_aux.tip_point = [str2num(zef.strip_tool.h_tip_point_1.String) ; ...
    str2num(zef.strip_tool.h_tip_point_2.String) ; ...
    str2num(zef.strip_tool.h_tip_point_3.String) ];

struct_aux.orientation_axis = [str2num(zef.strip_tool.h_orientation_axis_1.String) ; ...
    str2num(zef.strip_tool.h_orientation_axis_2.String) ; ...
    str2num(zef.strip_tool.h_orientation_axis_3.String) ];

struct_aux.strip_model = zef.strip_tool.h_strip_model.Value;
struct_aux.strip_impedance = str2num(zef.strip_tool.h_strip_impedance.String);
struct_aux.strip_tag = zef.strip_tool.h_strip_tag.String;

if not(isfield(struct_aux,'strip_status'))
struct_aux.strip_status = 'Tentative';
end

zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip} = struct_aux;

cell_aux = zef.([zef.current_sensors '_strip_cell']);

zef.strip_tool.h_strip_list.String = cell(0);

for i = 1 : length(cell_aux)

string_aux = ['ID: ' num2str(cell_aux{i}.strip_id) ', Tag: ' cell_aux{i}.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{cell_aux{i}.strip_model} ', Status: ' cell_aux{i}.strip_status];
zef.strip_tool.h_strip_list.String{i} = string_aux;

end

end