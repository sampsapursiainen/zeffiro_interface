
zef.aux_data_1 = cell(0);
zef.aux_data_2 = evalin('base',['zef.' zef.current_tag '_name_list']);
zef.aux_data_3 = evalin('base',['zef.' zef.current_tag '_points']);

for zef_i = 1 : size(zef.aux_data_3,1)
zef.aux_data_1{zef_i,1} = zef_i;
if isempty(zef.aux_data_2)
zef.aux_data_1{zef_i,2} = num2str(zef_i);
else
zef.aux_data_1{zef_i,2} = zef.aux_data_2{zef_i};
end
zef.aux_data_1{zef_i,3} = 1;
end

zef.h_sensors_name_table.Data = zef.aux_data_1;

zef = rmfield(zef,{'aux_data_1','aux_data_2','aux_data_3'});
clear zef_i;