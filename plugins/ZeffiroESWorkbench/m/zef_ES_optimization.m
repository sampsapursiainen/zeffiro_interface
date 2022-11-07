function zef = zef_ES_optimization(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_ES_optimization_window', 1/3, 1);

if nargout == 0
    assignin('base','zef',zef)
end

end