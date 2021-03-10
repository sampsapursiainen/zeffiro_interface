function zef_sensors_name_table_selection(hObject,eventdata,handles)

sensors_selected = eventdata.Indices(1);

evalin('base', ['zef.current_sensor_name = ' num2str(sensors_selected) ';']);
evalin('base','run(''zef_init_sensor_parameters'')');

end