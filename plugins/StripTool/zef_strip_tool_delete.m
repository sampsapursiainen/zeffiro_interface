function zef = zef_strip_tool_delete(zef)

struct_aux_1 = cell(0);
struct_aux_2 = zef.([zef.current_sensors '_strip_cell']);
I = setdiff(1:length(struct_aux_2),zef.strip_tool.current_strip);
if not(isempty(I))
struct_aux_1 = struct_aux_2{I};
else
    struct_aux_1 = cell(0);
end
zef.([zef.current_sensors '_strip_cell']) = struct_aux_1;

zef.strip_tool.current_strip = 1;
zef = zef_strip_tool_init(zef);
zef = zef_strip_tool_update(zef);

end