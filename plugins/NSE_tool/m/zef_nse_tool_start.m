function zef = zef_nse_tool_start(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_nse_tool_window',2/3,1);

if nargout == 0
    assignin('base','zef',zef)
end

end
