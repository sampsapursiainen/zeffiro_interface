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
zef.aux_field_1{zef_i,7} = zef.h_compartment_table.ColumnFormat{7}{evalin('base',['zef.' zef.compartment_tags{zef_j} '_sources'])+2};
zef.aux_field_1{zef_i,8} = evalin('base',['zef.' zef.compartment_tags{zef_j} '_sigma']);
zef_n = 0;
for zef_k =  1  : size(zef.parameter_profile,1)
     if isequal(zef.parameter_profile{zef_k,8},'Segmentation') && isequal(zef.parameter_profile{zef_k,6},'On') && isequal(zef.parameter_profile{zef_k,7},'On')
  zef_n = zef_n + 1; 
     zef.h_compartment_table.ColumnName{zef_n+7} = zef.parameter_profile{zef_k,1};
         if isequal(zef.parameter_profile{zef_k,3},'Scalar')
        zef.aux_field_1{zef_i,zef_n+7} = num2str(evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2}]));
         elseif isequal(zef.parameter_profile{zef_k,3},'String')
  zef.aux_field_1{zef_i,zef_n + 7} = (evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2}]));
   end
    end
end


end

zef.h_compartment_table.Data = zef.aux_field_1;
zef = rmfield(zef,'aux_field_1');
zef_update;

          

       
       
       

          
           