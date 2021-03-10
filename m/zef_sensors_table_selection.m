function zef_sensors_table_selection(hObject,eventdata,handles)

sensors_selected = eventdata.Indices(1);
sensor_tags = evalin('base','zef.sensor_tags');

evalin('base', ['zef.current_sensors = ''' sensor_tags{sensors_selected} ''';']);
evalin('base', ['zef.current_tag = ''' sensor_tags{sensors_selected} ''';']);
evalin('base','run(''zef_init_transform'')');
evalin('base','run(''zef_init_sensors_name_table'')');

end