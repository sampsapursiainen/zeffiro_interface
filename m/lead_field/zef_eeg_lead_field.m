function zef = zef_eeg_lead_field(zef)

if nargin == 0
zef = evalin('base','zef');
end

warning('off');
zef.lead_field_type = 1;
zef.imaging_method = 1;
zef_delete_original_field;
zef = zef_process_meshes(zef);
zef.sensors_attached_volume = zef_attach_sensors_volume(zef,zef.sensors);
zef = zef_lead_field_matrix(zef);
[zef.L,zef.source_positions,zef.source_directions] = zef_lead_field_filter(zef.L,zef.source_positions,zef.source_directions,zef.lead_field_filter_quantile);
if zef.source_interpolation_on
    zef = zef_source_interpolation(zef);
end
warning('on');

if nargout == 0
assignin('base','zef',zef);
end

end