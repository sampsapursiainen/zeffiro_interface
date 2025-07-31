function zef = zef_delete_compartment(zef,compartments_selected)

if nargin < 2
    compartments_selected = [];
end

if nargin == 0
    zef = evalin('base','zef');
end

table_data = zef.h_compartment_table.Data;

if isempty(compartments_selected)
compartments_selected =  zef.compartments_selected;
end

for i = 1 : length(compartments_selected)
    if not(table_data{compartments_selected(i),2})
       zef.h_compartment_table.Data{compartments_selected(i),1} = NaN;
    end
end

zef = zef_update(zef);

if nargout == 0
    assignin('base','zef',zef);
end

end
