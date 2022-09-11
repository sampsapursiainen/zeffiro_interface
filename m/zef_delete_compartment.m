function zef = zef_delete_compartment(zef)

if nargin == 0
zef = evalin('base','zef');
end

table_data = eval('zef.h_compartment_table.Data');
compartments_selected =  eval('zef.compartments_selected');

for i = 1 : length(compartments_selected)
    if not(table_data{compartments_selected(i),2})
    eval(['zef.h_compartment_table.Data{' num2str(table_data{compartments_selected(i),1}) '} = NaN;'])
    end
end

zef = zef_update(zef);

if nargout == 0
    assignin('base','zef',zef);
end

end
