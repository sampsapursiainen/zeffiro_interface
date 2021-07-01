
zef_create_dipolar_pair_update_struct;

zef.aux_field = sqrt(zef.create_dipolar_pair_ori_x.^2 + zef.create_dipolar_pair_ori_y.^2 + zef.create_dipolar_pair_ori_z.^2);
zef.create_dipolar_pair_ori_x = zef.create_dipolar_pair_ori_x/zef.aux_field;
zef.create_dipolar_pair_ori_y = zef.create_dipolar_pair_ori_y/zef.aux_field;
zef.create_dipolar_pair_ori_z = zef.create_dipolar_pair_ori_z/zef.aux_field;

zef = rmfield(zef,'aux_field');

evalin('base',['zef.' zef.current_sensors '_points = [zef.' zef.current_sensors '_points; [' num2str(zef.create_dipolar_pair_x + zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_x/2) ' ' num2str(zef.create_dipolar_pair_y + zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_y/2) ' ' num2str(zef.create_dipolar_pair_z +  zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_z/2) ' 0 0 ' num2str(zef.create_dipolar_pair_impedance) ']];' ]);
evalin('base',['zef.' zef.current_sensors '_name_list{end+1} = [''' zef.create_dipolar_pair_tag ' 1''];' ]);
evalin('base',['zef.' zef.current_sensors '_points = [zef.' zef.current_sensors '_points; [' num2str(zef.create_dipolar_pair_x - zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_x/2) ' ' num2str(zef.create_dipolar_pair_y - zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_y/2) ' ' num2str(zef.create_dipolar_pair_z - zef.create_dipolar_pair_separation*zef.create_dipolar_pair_ori_z/2) ' 0 0 ' num2str(zef.create_dipolar_pair_impedance) ']];' ]);
evalin('base',['zef.' zef.current_sensors '_name_list{end+1} = [''' zef.create_dipolar_pair_tag ' 2''];' ]);

zef.current_pattern = (1E-6)*(zef.create_dipolar_pair_strength/zef.create_dipolar_pair_separation)*[zeros(size(evalin('base',['zef.' zef.current_sensors '_points']),1)-2,1) ; -1 ; 1];
zef_create_dipolar_pair_update_table;
zef_update;
