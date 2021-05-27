zef.aux_field_1 = cell(0);

zef_i = 0;

for zef_j = length(zef.compartment_tags) : -1 : 1
    
zef_i = zef_i + 1;
zef.aux_field_1{zef_i,1} = zef_i;
zef.aux_field_1{zef_i,2}  = evalin('base',['zef.' zef.compartment_tags{zef_j} '_name']);
zef.aux_field_1{zef_i,3}  = evalin('base',['zef.' zef.compartment_tags{zef_j} '_on']);
zef.aux_field_1{zef_i,4}  = evalin('base',['zef.' zef.compartment_tags{zef_j} '_visible']);
zef.aux_field_1{zef_i,5} = evalin('base',['zef.' zef.compartment_tags{zef_j} '_merge']);
zef.aux_field_1{zef_i,6} = evalin('base',['zef.' zef.compartment_tags{zef_j} '_invert']);
zef.aux_field_1{zef_i,7} = zef.h_compartment_table.ColumnFormat{7}{evalin('base',['zef.' zef.compartment_tags{zef_j} '_sources'])+1};
zef.aux_field_1{zef_i,8} = evalin('base',['zef.' zef.compartment_tags{zef_j} '_sigma']);

end

zef.h_compartment_table.Data = zef.aux_field_1;
zef = rmfield(zef,'aux_field_1');

zef_update;
          

       
       
       

          
           