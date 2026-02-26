function zef = zef_start_source_tree_tool(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_open_source_tree',1/2,1);

if nargout == 0
    assignin('base','zef',zef)
end

end
