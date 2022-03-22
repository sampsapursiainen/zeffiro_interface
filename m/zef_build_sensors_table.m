    for zef_i = 1 : length(zef.sensor_tags)
    zef.aux_field_1{zef_i,1} = zef_i;
    zef.aux_field_1{zef_i,2} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_name']);
    zef.aux_field_1{zef_i,3} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_imaging_method_name']);
    zef.aux_field_1{zef_i,4} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_on']);
    zef.aux_field_1{zef_i,5} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_visible']);
    zef.aux_field_1{zef_i,6} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_points))']);
    zef.aux_field_1{zef_i,7} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_directions))']);
   end
 zef.h_sensors_table.Data = zef.aux_field_1;
