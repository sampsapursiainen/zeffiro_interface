function zef = zef_strip_tool_add(zef)

zef.strip_tool.strip_current_id = zef.strip_tool.strip_current_id + 1; 

zef.strip_tool.current_strip = length(zef.([zef.current_sensors '_strip_cell']))+1;

zef = zef_strip_tool_init(zef);
zef = zef_strip_tool_update(zef);

end