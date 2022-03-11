function s_points = zef_cem_electrode(s_points)

current_sensors = evalin('base','zef.current_sensors');
s_points = [s_points(:,1:3) evalin('base',['zef.' current_sensors '_electrode_outer_radius(:)']) evalin('base',['zef.' current_sensors '_electrode_inner_radius(:)']) evalin('base',['zef.' current_sensors '_electrode_impedance(:)'])];

end
