function zef = zef_butterfly_plot(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_butterfly_plot_start',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end
