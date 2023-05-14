function zef = zef_exp_app_launch(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_exp_app_start',1/4,1);

if nargout == 0
    assignin('base','zef',zef)
end

end
