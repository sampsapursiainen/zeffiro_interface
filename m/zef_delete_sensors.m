function zef_delete_sensors

    if not(evalin('base','zef.lock_sensor_names_on'))

table_data = evalin('base','zef.h_sensors_name_table.Data');
sensors_selected = evalin('base','zef.sensors_selected');

for i = 1 : length(sensors_selected)
    evalin('base',['zef.h_sensors_name_table.Data{' num2str(table_data{sensors_selected(i),1}) '} = NaN;'])
end

evalin('base','run(''zef_update_sensors_name_table'')');

    end

end
