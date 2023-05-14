function zef = zef_start_dataBank(zef)

if nargin == 0
zef = evalin('base','zef');
end    

zef = zef_tool_start(zef,'zef_open_dataBank',1/2,1);

if nargout == 0
    assignin('base','zef',zef)
end

end