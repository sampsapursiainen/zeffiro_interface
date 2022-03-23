
zef.aux_data_1 = cell(0);
zef.aux_data_2 = evalin('base',['zef.' zef.current_sensors '_name_list']);
zef.aux_data_3 = evalin('base',['zef.' zef.current_sensors '_points']);
for zef_i = length(zef.aux_data_2) + 1 : size(zef.aux_data_3,1)
zef.aux_data_2{zef_i} = num2str(zef_i);
evalin('base',['zef.' zef.current_sensors '_name_list{' num2str(zef_i) '} =''' num2str(zef_i) ''';']);
end
if evalin('base',['zef.' zef.current_sensors '_visible'])
if isempty(find(evalin('base',['zef.' zef.current_sensors '_visible_list'])))
evalin('base',['zef.' zef.current_sensors '_visible_list = [ ones(size(zef.' zef.current_sensors '_points,1),1)];'])
end
if length(evalin('base',['zef.' zef.current_sensors '_visible_list'])) < size(zef.aux_data_3,1)
evalin('base',['zef.' zef.current_sensors '_visible_list = [' 'zef.' zef.current_sensors '_visible_list; ones(size(zef.' zef.current_sensors '_points,1)-size(zef.' zef.current_sensors '_visible_list,1),1)];'])
end
zef.aux_data_4 = evalin('base',['zef.' zef.current_sensors '_visible_list']);
else
zef.aux_data_4 = evalin('base',['zeros(size(zef.' zef.current_sensors '_points,1),1);']);
evalin('base',['zef.' zef.current_sensors '_visible_list = zeros(size(zef.' zef.current_sensors '_points,1),1);']);
end
if size(evalin('base',['zef.' zef.current_sensors '_color_table']),1) < size(zef.aux_data_3,1)
evalin('base',['zef.' zef.current_sensors '_color_table = [' 'zef.' zef.current_sensors '_color_table ; zef.' zef.current_sensors '_color(ones(size(zef.' zef.current_sensors '_points,1)-size(zef.' zef.current_sensors '_color_table,1),1),:)];'])
end
for zef_i = 1 : size(zef.aux_data_3,1)
zef.aux_data_1{zef_i,1} = zef_i;
zef.aux_data_1{zef_i,2} = zef.aux_data_2{zef_i};
if isempty(zef.aux_data_4)
zef.aux_data_1{zef_i,3} = 1;
else
zef.aux_data_1{zef_i,3} = zef.aux_data_4(zef_i);
end
end

zef.h_sensors_name_table.Data = zef.aux_data_1;

zef = rmfield(zef,{'aux_data_1','aux_data_2','aux_data_3','aux_data_4'});
clear zef_i;
