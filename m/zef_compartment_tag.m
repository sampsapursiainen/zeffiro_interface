function compartment_tag = zef_compartment_tag(zef)

ismember_tag = 1;
compartment_counter = 0;

while ismember_tag

    compartment_counter = compartment_counter + 1;
    compartment_tag = ['c' num2str(compartment_counter)];
    ismember_tag = ismember(compartment_tag,eval('zef.compartment_tags'));

end

end
