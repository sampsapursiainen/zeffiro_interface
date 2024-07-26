function zef = zef_strip_tool_open(zef)

if not(isfield(zef,'strip_tool'))
zef.strip_tool = struct; 
zef.strip_tool.strip_current_id = 1; 
end

zef = zef_strip_tool_window(zef);
zef = zef_strip_tool_init(zef); 
zef = zef_strip_tool_update(zef); 

end
