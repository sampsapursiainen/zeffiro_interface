zef_add_compartment;
evalin('base',['zef.' zef.compartment_tags{1} '_name = ''Box'';']);
evalin('base',['zef.' zef.compartment_tags{1} '_sources = -1;']);
evalin('base',['zef.' zef.compartment_tags{1} '_visible = 0;']);
zef.compartment_tags = [zef.compartment_tags(2:end) zef.compartment_tags(1)];
zef_build_compartment_table;
