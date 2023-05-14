function subcompartment_ind = zef_compartment_to_subcompartment(zef,compartment_ind)

if isempty(zef)
    zef = evalin('base','zef');
end

compartment_tags = eval('zef.compartment_tags');

subcompartment_ind = [];

compartment_counter = 0;
subcompartment_counter = 0;

for i = 1 : length(compartment_tags)

    on_val = eval(['zef.' compartment_tags{i}  '_on']);

    if on_val
        submesh_ind = eval(['zef.' compartment_tags{i} '_submesh_ind']);
        compartment_counter = compartment_counter + 1;
        if ismember(compartment_counter,compartment_ind)
            subcompartment_ind = [subcompartment_ind ; [subcompartment_counter(end) + 1 : subcompartment_counter(end) + length(submesh_ind)]'];
        end
        subcompartment_counter = subcompartment_counter + length(submesh_ind);
    end
end


end
