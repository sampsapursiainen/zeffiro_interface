function zef_delete_sensor_sets

table_data = evalin('base','zef.h_sensors_table.Data');
sensor_sets_selected = evalin('base','zef.sensor_sets_selected');

for i = 1 : length(sensor_sets_selected)
    if not(table_data{sensor_sets_selected(i),4})
    evalin('base',['zef.h_sensors_table.Data{' num2str(table_data{sensor_sets_selected(i),1}) '} = NaN;'])
    end
end

evalin('base','run(''zef_update'')');

end
