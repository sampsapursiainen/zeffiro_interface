zef_create_dipolar_pair_update_struct;

if isfield(zef,'h_create_dipolar_pair_arrow')
delete(zef.h_create_dipolar_pair_arrow);
end

zef.aux_field = sqrt(zef.create_dipolar_pair_ori_x.^2 + zef.create_dipolar_pair_ori_y.^2 + zef.create_dipolar_pair_ori_z.^2);
zef.create_dipolar_pair_ori_x = zef.create_dipolar_pair_ori_x/zef.aux_field;
zef.create_dipolar_pair_ori_y = zef.create_dipolar_pair_ori_y/zef.aux_field;
zef.create_dipolar_pair_ori_z = zef.create_dipolar_pair_ori_z/zef.aux_field;

hold(zef.h_axes1,'on')
zef.h_create_dipolar_pair_arrow = quiver3(zef.h_axes1,zef.create_dipolar_pair_x,...
    zef.create_dipolar_pair_y ,...
   zef.create_dipolar_pair_z ,...
zef.create_dipolar_pair_ori_x,...
zef.create_dipolar_pair_ori_y,...
zef.create_dipolar_pair_ori_z,...
5*zef.create_dipolar_pair_length,...
'o','linewidth',3);

zef.aux_field = lines(7);
set(zef.h_create_dipolar_pair_arrow,'color',zef.aux_field(zef.create_dipolar_pair_color,:));

zef = rmfield(zef,'aux_field');