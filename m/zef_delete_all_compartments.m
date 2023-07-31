function zef = zef_delete_all_compartments(zef)

if nargin == 0
    zef = evalin('base','zef');
end

if not(isempty(zef.h_compartment_table.Data))
    for zef_i = 1 : length(zef.h_compartment_table.Data(:,2))
        zef.h_compartment_table.Data{zef_i,2} = 0;
    end
    for zef_i = 1 : length(zef.h_sensors_table.Data(:,4))
        zef.h_sensors_table.Data{zef_i,4} = 0;
    end
    clear zef_i;
    zef.compartments_selected = [1 : length(zef.compartment_tags)];
    zef = zef_delete_compartment(zef);
    zef.compartments_selected = [];
    zef.sensor_sets_selected = [1 : length(zef.sensor_tags)];
    zef = zef_delete_sensor_sets(zef);
    zef.sensor_sets_selected = [];
end

if nargout == 0
    assignin('base','zef',zef);
end


end
