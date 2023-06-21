function zef = zef_DBS_strip_struct_start(zef)

if nargin == 0
zef = evalin('base','zef');
end    

zef = zef_tool_start(zef,'zef_DBS_strip_struct_open',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end



end