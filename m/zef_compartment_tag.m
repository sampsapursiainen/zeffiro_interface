function compartment_tag = zef_compartment_tag

<<<<<<< HEAD
ismember_tag = 1; 
compartment_counter = 0; 

while ismember_tag
    
    compartment_counter = compartment_counter + 1; 
    compartment_tag = ['c' num2str(compartment_counter)];
    ismember_tag = ismember(compartment_tag,evalin('base','zef.compartment_tags'));
    
end

end
=======
ismember_tag = 1;
compartment_counter = 0;

while ismember_tag

    compartment_counter = compartment_counter + 1;
    compartment_tag = ['c' num2str(compartment_counter)];
    ismember_tag = ismember(compartment_tag,evalin('base','zef.compartment_tags'));

end

end
>>>>>>> a1aaa2aee8fce3911755df54709788623e2de0aa
