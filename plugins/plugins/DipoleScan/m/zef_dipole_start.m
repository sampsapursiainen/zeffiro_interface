function zef = zef_dipole_start(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_dipole_window',1/4,1);

if nargout == 0
    assignin('base','zef',zef)
end

end
