zef.aux_field = zef.h_compartment_table.Data;
zef_create_compartment(['c' num2str(length(zef.compartment_tags)+1)]);
zef_i = size(zef.aux_field,1) + 1;
zef.aux_field{zef_i,1} = evalin('base',['zef.' zef.compartment_tags{1} '_priority']);
zef.aux_field{zef_i,2} = evalin('base',['zef.' zef.compartment_tags{1} '_name']);
zef.aux_field{zef_i,3} = evalin('base',['zef.' zef.compartment_tags{1} '_on']);
zef.aux_field{zef_i,4} = evalin('base',['zef.' zef.compartment_tags{1} '_visible']);
zef.aux_field{zef_i,5} = evalin('base',['zef.' zef.compartment_tags{1} '_merge']);
zef.aux_field{zef_i,6} = evalin('base',['zef.' zef.compartment_tags{1} '_invert']);
zef.aux_field{zef_i,7} = zef.h_compartment_table.ColumnFormat{7}{1+evalin('base',['zef.' zef.compartment_tags{1} '_sources'])};
zef.aux_field{zef_i,8} = evalin('base',['zef.' zef.compartment_tags{1} '_sigma']);

zef.h_compartment_table.Data = zef.aux_field;

zef = rmfield(zef,'aux_field');
clear zef_i;

zef_update;