function [domain_labels, subcompartment_labeling_priority_vec, compartment_labeling_priority_vec] = zef_choose_domain_labels(zef, label_array, use_labeling_priority, ordinal_index)

if nargin < 3
    priority_mode = 1; 
end

if nargin < 4
    ordinal_index = 1; 
end

domain_labels = [];

submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_subcompartments = length(submesh_vec);
n_compartments = length(zef.reuna_mesh_ind);
subcompartment_labeling_priority_vec = zeros(n_subcompartments,1);
compartment_labeling_priority_vec = zeros(length(zef.reuna_mesh_ind),1);

priority_vec = flipud([1:n_subcompartments]');
priority_vec_compartments = flipud([1:n_compartments]');

if use_labeling_priority

counter_ind = 0;

for i = 1 : length(zef.reuna_p)

     compartment_labeling_priority_vec(i) = zef.([zef.compartment_tags{zef.reuna_mesh_ind(i)} '_labeling_priority']);

    for j = 1 : length(zef.reuna_submesh_ind{i})

     counter_ind = counter_ind + 1;
      subcompartment_labeling_priority_vec(counter_ind) = zef.([zef.compartment_tags{zef.reuna_mesh_ind(i)} '_labeling_priority']);

    end
end

priority_vec = max(subcompartment_labeling_priority_vec) + priority_vec;
priority_vec_compartments = max(compartment_labeling_priority_vec) + priority_vec_compartments;
I = find(subcompartment_labeling_priority_vec==0);
subcompartment_labeling_priority_vec(I) = priority_vec(I);
I = find(compartment_labeling_priority_vec==0);
compartment_labeling_priority_vec(I) = priority_vec_compartments(I);

else
subcompartment_labeling_priority_vec = priority_vec;
compartment_labeling_priority_vec = priority_vec_compartments;
end

if not(isempty(label_array))
n_labels = size(label_array,1);
ind_vec_aux = [1:n_labels]';
labeling_priority_vec_aux = subcompartment_labeling_priority_vec(label_array);
for i = 1 : ordinal_index-1
[priority_val priority_ind] = min(labeling_priority_vec_aux,[],2);
labeling_priority_vec_aux(ind_vec_aux + (priority_ind-1)*n_labels) = NaN; 
end
[priority_val priority_ind] = min(labeling_priority_vec_aux,[],2);
priority_ind = sub2ind(size(label_array),[1:size(label_array,1)]',priority_ind);
[domain_labels] = label_array(priority_ind);
end

[~, subcompartment_labeling_priority_vec] = sort(subcompartment_labeling_priority_vec);
subcompartment_labeling_priority_vec(subcompartment_labeling_priority_vec) = [1:length(subcompartment_labeling_priority_vec)];

[~, compartment_labeling_priority_vec] = sort(compartment_labeling_priority_vec);
compartment_labeling_priority_vec(compartment_labeling_priority_vec) = [1:length(compartment_labeling_priority_vec)];


end
