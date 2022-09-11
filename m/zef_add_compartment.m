function zef = zef_add_compartment(zef)

if nargin == 0
zef = evalin('base','zef');
end

zef.aux_field_1 = zef.h_compartment_table.Data;

zef = zef_create_compartment(zef,zef_compartment_tag(zef));
zef_i = size(zef.aux_field_1,1) + 1;
zef_j = 1;

zef_init_fields_compartment_table;
zef = zef_apply_parameter_profile(zef);

zef_i = size(zef.aux_field_1,1);
zef_j = 1;

zef_init_fields_compartment_table_profile;

zef.h_compartment_table.Data = zef.aux_field_1;

zef = rmfield(zef,'aux_field_1');
clear zef_i;

zef = zef_update(zef);

if nargout == 0
assignin('base','zef',zef);
end

end
