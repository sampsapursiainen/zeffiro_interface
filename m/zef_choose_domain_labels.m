function domain_labels = zef_choose_domain_labels(zef, label_array, use_labeling_priority)

if nargin < 3
    priority_mode = 1; 
end

submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_compartments = length(submesh_vec);
labeling_priority_vec = zeros(n_compartments,1);

priority_vec = flipud([1:n_compartments]');

if use_labeling_priority

counter_ind = 0;

for i = 1 : length(zef.reuna_p)
    for j = 1 : length(zef.reuna_submesh_ind{i})

        counter_ind = counter_ind + 1;
      labeling_priority_vec(counter_ind) = zef.([zef.compartment_tags{i} '_labeling_priority']);

    end
end

priority_vec = max(labeling_priority_vec) + priority_vec;
I = find(labeling_priority_vec==0);
labeling_priority_vec(I) = priority_vec(I);

else
labeling_priority_vec = priority_vec;
end

[priority_val priority_ind] = min(labeling_priority_vec(label_array),[],2);
priority_ind = sub2ind(size(label_array),[1:size(label_array,1)]',priority_ind);
[domain_labels] = label_array(priority_ind);

end
