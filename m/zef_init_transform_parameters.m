
zef.aux_data_1 = cell(0);
zef.aux_data_2 = {{'Scaling','scaling'},{'X-shift','x_correction'},{'Y-shift','y_correction'},{'Z-shift','z_correction'},{'Xy-rotation','xy_rotation'},{'Yz-rotation','yz_rotation'},{'Zx-rotation','zx_rotation'}};
zef_i = evalin('base','zef.current_transform');

for zef_j = 1 : length(zef.aux_data_2)
zef.aux_data_1{zef_j,1} = zef.aux_data_2{zef_j}{1};
zef.aux_data_1{zef_j,2} = evalin('base',['zef.' zef.current_tag '_' zef.aux_data_2{zef_j}{2} '(' num2str(zef_i) ')']);
end

zef.h_parameters_table.Data = zef.aux_data_1;

zef.current_parameters = 'transform';

zef = rmfield(zef,{'aux_data_1','aux_data_2'});
clear zef_i zef_j;
