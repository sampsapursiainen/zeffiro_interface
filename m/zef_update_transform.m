zef.aux_field_1 = zef.h_transform_table.Data;
zef.aux_field_2 = [];
zef.aux_field_3 = [];
zef.aux_field_4 = {'transform_name','scaling','x_correction','y_correction','z_correction','xy_rotation','yz_rotation','zx_rotation'};
zef.aux_field_5 = cell(0);

for zef_i = 1 : size(zef.aux_field_1,1)

    if not(isnan(zef.aux_field_1{zef_i,1}))
        zef.aux_field_2 = [zef.aux_field_2 zef.aux_field_1{zef_i,1}];
        zef.aux_field_3 = [zef.aux_field_3 zef_i];

    end

end

[~,zef.aux_field_2] = sort(zef.aux_field_2);
zef.aux_field_3 = zef.aux_field_3(zef.aux_field_2);

for zef_i = 1 : length(zef.aux_field_3)

zef.aux_field_5{zef_i} = zef.aux_field_1{zef.aux_field_3(zef_i),2};

end

for zef_i = 1 : length(zef.aux_field_4)

    if zef_i == 1
evalin('base',['zef.' zef.current_tag '_' zef.aux_field_4{zef_i} ' = cell(0);']);
for zef_j = 1 : length(zef.aux_field_5)
    ['zef.' zef.current_tag '_' zef.aux_field_4{zef_i} '{' num2str(zef_j) '} = ''' zef.aux_field_5{zef_j} ''';'];
evalin('base',['zef.' zef.current_tag '_' zef.aux_field_4{zef_i} '{' num2str(zef_j) '} = ''' zef.aux_field_5{zef_j} ''';']);
end
else
evalin('base',['zef.' zef.current_tag '_' zef.aux_field_4{zef_i} ' = zef.' zef.current_tag '_' zef.aux_field_4{zef_i} '([' num2str(zef.aux_field_3) ']);']);
    end
end

zef = rmfield(zef,{'aux_field_1','aux_field_2','aux_field_3','aux_field_4','aux_field_5'});
clear zef_i zef_j;

zef_init_transform;
