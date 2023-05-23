function compartment_tag = zef_find_compartment(property_name,property_value)

compartment_tags = evalin('base','zef.compartment_tags');

compartment_tag = '';
compartment_found = 0;
compartment_counter = 0;

if ischar(property_value)
    property_value = ['''' property_value ''''];
else
    property_value = char(string(property_value));
end

while not(compartment_found) && compartment_counter < length(compartment_tags)

    if evalin('base',['isequal(zef.' compartment_tags{end-compartment_counter} '_' property_name ',' property_value ')'])
        compartment_tag = compartment_tags{end-compartment_counter};
        compartment_found = 1;
    end

    compartment_counter = compartment_counter + 1;

end

end
