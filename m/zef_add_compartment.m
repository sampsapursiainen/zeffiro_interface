zef.aux_field_1 = zef.h_compartment_table.Data;

zef_create_compartment(zef_compartment_tag);
zef_i = size(zef.aux_field_1,1) + 1;
zef_j = 1;

zef_init_fields_compartment_table;

zef_apply_parameter_profile;

zef_i = size(zef.aux_field_1,1);
zef_j = 1;

zef_init_fields_compartment_table_profile;

zef.h_compartment_table.Data = zef.aux_field_1;

zef = rmfield(zef,'aux_field_1');
clear zef_i;

zef_update;