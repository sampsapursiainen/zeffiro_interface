zef.aux_field_1 = zef.h_parameters_table.Data;
zef.aux_field_2 = {'scaling','x_correction','y_correction','z_correction','xy_rotation','yz_rotation','zx_rotation'};

for zef_i = 1 : size(zef.aux_field_1,1)

   evalin('base',['zef.' zef.current_tag '_' zef.aux_field_2{zef_i} '(' num2str(zef.current_transform) ')=' num2str(zef.aux_field_1{zef_i,2}) ';']);

end

zef = rmfield(zef,{'aux_field_1','aux_field_2'});
clear zef_i;