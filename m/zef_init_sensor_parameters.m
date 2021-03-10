
zef.aux_data_1 = cell(0);
if isequal(evalin('base',['zef.'  zef.current_tag '_type']),zef.h_sensors_table.ColumnFormat{3}{1})
zef.aux_data_2 = {{'X-coordinate','points','1'},{'Y-coordinate','points','2'},{'Z-coordinate','points','3'}};
else
zef.aux_data_2 = {{'Points','points'},{'Directions','directions'}};
end
zef_i = evalin('base','zef.current_sensor_name');

for zef_j = 1 : length(zef.aux_data_2)
zef.aux_data_1{zef_j,1} = zef.aux_data_2{zef_j}{1};
zef.aux_data_1{zef_j,2} = evalin('base',['zef.' zef.current_tag '_' zef.aux_data_2{zef_j}{2} '(' num2str(zef_i) ',' zef.aux_data_2{zef_j}{3} ')']);
end

zef.h_parameters_table.Data = zef.aux_data_1;

zef = rmfield(zef,{'aux_data_1','aux_data_2'});
clear zef_i zef_j;