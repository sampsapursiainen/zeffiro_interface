if not(isfield(zef,'h_create_dipolar_pair_x'))
zef.create_dipolar_pair_x = 0;
end

if not(isfield(zef,'h_create_dipolar_pair_y'))
zef.create_dipolar_pair_y = 0;
end

if not(isfield(zef,'h_create_dipolar_pair_z'))
zef.create_dipolar_pair_z = 0;
end

if not(isfield(zef,'h_create_dipolar_pair_ori_x'))
zef.create_dipolar_pair_ori_x = 1;
end

if not(isfield(zef,'h_create_dipolar_pair_ori_y'))
zef.create_dipolar_pair_ori_y = 0;
end

if not(isfield(zef,'h_create_dipolar_pair_ori_z'))
zef.create_dipolar_pair_ori_z = 0;
end

if not(isfield(zef,'h_create_dipolar_pair_strength'))
zef.create_dipolar_pair_strength = 10;
end

if not(isfield(zef,'h_create_dipolar_pair_separation'))
zef.create_dipolar_pair_separation = 2;
end

if not(isfield(zef,'h_create_dipolar_pair_impedance'))
zef.create_dipolar_pair_impedance = 1E3;
end

if not(isfield(zef,'h_create_dipolar_pair_color'))
zef.create_dipolar_pair_color = 1;
end

if not(isfield(zef,'h_create_dipolar_pair_length'))
zef.create_dipolar_pair_length = 3;
end

if not(isfield(zef,'h_create_dipolar_pair_tag'))
zef.create_dipolar_pair_tag = 'Dipole ';
end

zef_create_dipolar_pair_update_table
