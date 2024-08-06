function zef = zef_strip_tool_delete(zef)

struct_aux_1 = cell(0);
struct_aux_2 = zef.([zef.current_sensors '_strip_cell']);

strip_id = struct_aux_2{zef.strip_tool.current_strip}.strip_id;
domain_type = 'sensor_info';

if isfield(zef, zef.([zef.current_sensors '_get_functions']))
for i_ind = 1 : length(zef.([zef.current_sensors '_get_functions']))
    h_function_aux = zef.([zef.current_sensors '_get_functions']){i_ind}; 
    [~, sensor_info] = feval(h_function_aux, domain_type);
    if isequal(strip_id, sensor_info.strip_id)
    zef.([zef.current_sensors '_get_functions'])(i_ind) = cell(1);
    end
end
end

I = setdiff(1:length(struct_aux_2),zef.strip_tool.current_strip);
if not(isempty(I))
struct_aux_1 = struct_aux_2(I);
else
    struct_aux_1 = cell(0);
end
zef.([zef.current_sensors '_strip_cell']) = struct_aux_1;

zef.strip_tool.current_strip = 1;
zef.strip_tool.h_strip_list.Value = 1;

zef = zef_strip_tool_init(zef);
zef = zef_strip_tool_update(zef);

end