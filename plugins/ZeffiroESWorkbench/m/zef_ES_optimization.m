function zef_ES_optimization(zef)

if nargin == 0
    zef = evalin('base','zef');
end

org_val         = zef.font_size;
zef.font_size   = 14;
zef             = zef_tool_start(zef, 'zef_ES_optimization_window', 1/5, 1);
zef.font_size   = org_val;

if nargout == 0
    assignin('base','zef',zef);
end

end