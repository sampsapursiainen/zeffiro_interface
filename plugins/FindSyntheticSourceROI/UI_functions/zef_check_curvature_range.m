function zef =  zef_check_curvature_range(zef)

editBox = zef.h_synth_source_ROI_curvature;

value = str2double(editBox.String);

if isnan(value) 
    value = 0; 
elseif value < -1 
    value = -1;
    warning('Curvature value was set to -1. Must be between -1 and 1.')
elseif value > 1
    value = 1;
    warning('Curvature value was set to 1. Must be between -1 and 1.')
end

set(editBox, 'String', num2str(value));

end