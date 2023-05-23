function [brain_ind, brain_compartments] = zef_find_active_compartment_ind(zef,domain_labels)

if nargin < 2
    domain_labels = zef.domain_labels;
end

aux_compartment_ind = zeros(length(zef.compartment_tags),1);
i = 0;

for k = 1 : length(zef.compartment_tags)

    var_0 = ['zef.'  zef.compartment_tags{k} '_on'];

    on_val = eval(var_0);

    if on_val
        i = i + 1;

        aux_compartment_ind(k) = i;

    end
end

brain_ind = [];
brain_compartments = [];
for k = 1 : length(zef.compartment_tags)
    if ismember(eval(['zef.' zef.compartment_tags{k} '_sources']),[1 2])
        if not(aux_compartment_ind(k)==0)
            brain_compartments(end+1) = aux_compartment_ind(k);
            [brain_ind]= [brain_ind ; find(domain_labels==aux_compartment_ind(k))];
        end
    end
end

if sum(aux_compartment_ind) == 0
    brain_ind = find(domain_labels);
end

end
