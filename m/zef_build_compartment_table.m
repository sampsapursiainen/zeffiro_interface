zef.aux_field_1 = cell(0);

zef_i = 0;

for zef_j = length(zef.compartment_tags) : -1 : 1

zef_i = zef_i + 1;

zef_init_fields_compartment_table;

zef_n = 0;
for zef_k =  1  : size(zef.parameter_profile,1)
     if isequal(zef.parameter_profile{zef_k,8},'Segmentation') && isequal(zef.parameter_profile{zef_k,6},'On') && isequal(zef.parameter_profile{zef_k,7},'On')
  zef_n = zef_n + 1;
     zef.h_compartment_table.ColumnName{zef_n+zef.compartment_table_size} = zef.parameter_profile{zef_k,1};
         if isequal(zef.parameter_profile{zef_k,3},'Scalar')
        zef.aux_field_1{zef_i,zef_n+zef.compartment_table_size} = num2str(evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2}]));
         elseif isequal(zef.parameter_profile{zef_k,3},'String')
  zef.aux_field_1{zef_i,zef_n + zef.compartment_table_size} = (evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2}]));
   end
    end
end

end

zef.h_compartment_table.Data = zef.aux_field_1;
zef = rmfield(zef,'aux_field_1');
zef_update;

