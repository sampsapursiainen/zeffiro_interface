function zef = zef_find_synthetic_source_ROI(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_tool_start(zef,'zef_find_synthetic_source_ROI_window',1/4,0);

if nargout == 0
    assignin('base','zef',zef)
end

end
