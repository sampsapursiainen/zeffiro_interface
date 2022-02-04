evalin('base',['zef.' zef.compartment_tags{zef_j}, '_on = ' num2str(double(zef.aux_field_1{zef_i,2})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_name = ''' zef.aux_field_1{zef_i,3} ''';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_visible = ' num2str(double(zef.aux_field_1{zef_i,4})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_merge = ' num2str(double(zef.aux_field_1{zef_i,7})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_invert = ' num2str(double(zef.aux_field_1{zef_i,8})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_sources = ' num2str(find(ismember(zef.h_compartment_table.ColumnFormat{9},zef.aux_field_1{zef_i,9}),1)-2) ';']);
