function zef = zef_DBS_attach_electrodes(zef)

eval(['zef.' zef.current_sensors '_points=zef.strip_struct.electrode_data;']);
eval(['zef.' zef.current_sensors '_electrode_outer_radius=zef.strip_struct.electrode_data(:,4);']);
eval(['zef.' zef.current_sensors '_electrode_inner_radius=zef.strip_struct.electrode_data(:,5);']);
eval(['zef.' zef.current_sensors '_electrode_impedance=zef.strip_struct.electrode_data(:,6);']);
zef.sensors_visual_size = zef.strip_struct.electrode_radius/2;
end

