
zef.aux_data_1 = cell(0);
zef.aux_data_2 = evalin('base',['zef.' zef.current_tag '_transform_name']);

for zef_i = 1 : length(zef.aux_data_2)
zef.aux_data_1{zef_i,1} = zef_i;
zef.aux_data_1{zef_i,2} = zef.aux_data_2{zef_i};
end

zef.h_transform_table.Data = zef.aux_data_1;

zef = rmfield(zef,{'aux_data_1','aux_data_2'});
clear zef_i;
