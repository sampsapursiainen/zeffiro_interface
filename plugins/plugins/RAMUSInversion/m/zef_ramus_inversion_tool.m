function zef = zef_ramus_inversion_tool(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_ramus_window',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end

end
