function zef = sl1_map_estimation(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_init_sl1',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end

end