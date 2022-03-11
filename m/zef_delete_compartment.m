function zef_delete_compartment

table_data = evalin('base','zef.h_compartment_table.Data');
compartments_selected =  evalin('base','zef.compartments_selected');

for i = 1 : length(compartments_selected)
    if not(table_data{compartments_selected(i),2})
    evalin('base',['zef.h_compartment_table.Data{' num2str(table_data{compartments_selected(i),1}) '} = NaN;'])
    end
end

evalin('base','run(''zef_update'')');

end
