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

eval(['zef.' zef.current_sensors '_name_list = cell(0);'])
eval(['zef.' zef.current_sensors '_visible_list = [];'])

for zef_i = 1 : size(zef.aux_field_1,1)

    eval(['zef.' zef.current_sensors '_name_list{' num2str(zef_i) '} = ''' zef.aux_field_1{zef_i,2} ''';']);
    eval(['zef.' zef.current_sensors '_visible_list = [' 'zef.' zef.current_sensors '_visible_list ;' num2str(zef.aux_field_1{zef_i,3}) '];']);

end
if not(isempty(eval(['zef.' zef.current_sensors '_points'])))
    eval(['zef.' zef.current_sensors '_points = ' 'zef.' zef.current_sensors '_points([' num2str(zef.aux_field_2) '],:);']);
end

if isfield(zef,[zef.current_sensors '_functions'])
zef.([zef.current_sensors '_functions_aux']) = cell(1,size(zef.([zef.current_sensors '_points']),1));
zef.([zef.current_sensors '_functions_aux_ind']) = setdiff([1:size(zef.([zef.current_sensors '_functions']),1)],find(cellfun(@isempty, zef.([zef.current_sensors '_functions']))));
zef.([zef.current_sensors '_functions_aux'])(zef.([zef.current_sensors '_functions_aux_ind'])) = zef.([zef.current_sensors '_functions'])(zef.([zef.current_sensors '_functions_aux_ind']));
zef.([zef.current_sensors '_functions']) = zef.([zef.current_sensors '_functions_aux']);
zef = rmfield(zef,[zef.current_sensors '_functions_aux']);
zef = rmfield(zef,[zef.current_sensors '_functions_aux_ind']);
end

if not(isempty(eval(['zef.' zef.current_sensors '_points'])))
    eval(['zef.' zef.current_sensors '_points = ' 'zef.' zef.current_sensors '_points([' num2str(zef.aux_field_2) '],:);']);
end

if isfield(zef,[zef.current_sensors '_functions'])
if not(isempty(zef.([zef.current_sensors '_functions'])))
    zef.([zef.current_sensors '_functions']) = zef.([zef.current_sensors '_functions'])(zef.aux_field_2);
end
end

if not(isempty(eval(['zef.' zef.current_sensors '_directions'])))
    eval(['zef.' zef.current_sensors '_directions = ' 'zef.' zef.current_sensors '_directions([' num2str(zef.aux_field_2) '],:);']);
end

for zef_i = 1 : size(zef.parameter_profile,1)
    if isequal(zef.parameter_profile{zef_i,8},'Sensors') && isequal(zef.parameter_profile{zef_i,6},'On') && isequal(zef.parameter_profile{zef_i,7},'On')
        eval(['zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2}  '=zef.' zef.current_sensors '_' zef.parameter_profile{zef_i,2} '([' num2str(zef.aux_field_2) '],:);']);
    end
end

zef = rmfield(zef,{'aux_field_1','aux_field_2','aux_field_3'});
clear zef_i;

if not(isempty(find(eval(['zef.' zef.current_sensors '_visible_list']))))
    if not( eval(['zef.' zef.current_sensors '_visible']))
        eval(['zef.' zef.current_sensors '_visible = 1;'])
        zef.h_sensors_table.Data = [];
    end
end

zef = zef_update(zef);
