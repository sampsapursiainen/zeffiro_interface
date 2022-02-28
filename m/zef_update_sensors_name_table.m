zef.aux_field_1 = zef.h_sensors_name_table.Data;
zef.aux_field_2 = [];
zef.aux_field_3 = [];

for zef_i = 1 : size(zef.aux_field_1,1)

    if not(isnan(zef.aux_field_1{zef_i,1}))
    zef.aux_field_2 = [zef.aux_field_2 zef_i];
    zef.aux_field_3 = [zef.aux_field_3 zef.aux_field_1{zef_i,1}];
    end

end

[~, zef.aux_field_3] = sort(zef.aux_field_3);
zef.aux_field_2 = zef.aux_field_2(zef.aux_field_3);

zef.aux_field_1 = zef.aux_field_1(zef.aux_field_2,:);

zef.h_sensors_name_table.Data = zef.aux_field_1;

evalin('base',['zef.' zef.current_sensors '_name_list = cell(0);'])
evalin('base',['zef.' zef.current_sensors '_visible_list = [];'])

for zef_i = 1 : size(zef.aux_field_1,1)

    evalin('base',['zef.' zef.current_sensors '_name_list{' num2str(zef_i) '} = ''' zef.aux_field_1{zef_i,2} ''';']);
    evalin('base',['zef.' zef.current_sensors '_visible_list = [' 'zef.' zef.current_sensors '_visible_list ;' num2str(zef.aux_field_1{zef_i,3}) '];']);

end
    if not(isempty(evalin('base',['zef.' zef.current_sensors '_points'])))
      evalin('base',['zef.' zef.current_sensors '_points = ' 'zef.' zef.current_sensors '_points([' num2str(zef.aux_field_2) '],:);']);
    end
    if not(isempty(evalin('base',['zef.' zef.current_sensors '_directions'])))
    evalin('base',['zef.' zef.current_sensors '_directions = ' 'zef.' zef.current_sensors '_directions([' num2str(zef.aux_field_2) '],:);']);
    end

    for zef_i = 1 : size(zef.parameter_profile,1)
     if isequal(zef.parameter_profile{zef_i,8},'Sensors') && isequal(zef.parameter_profile{zef_i,6},'On') && isequal(zef.parameter_profile{zef_i,7},'On')
     evalin('base',['zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2}  '=zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} '([' num2str(zef.aux_field_2) '],:);']);
     end
    end

zef = rmfield(zef,{'aux_field_1','aux_field_2','aux_field_3'});
clear zef_i;

if not(isempty(find(evalin('base',['zef.' zef.current_sensors '_visible_list']))))
if not( evalin('base',['zef.' zef.current_sensors '_visible']))
    evalin('base',['zef.' zef.current_sensors '_visible = 1;'])
zef.h_sensors_table.Data = [];
end
end

zef_update