function zef = zef_update_labeling_priority(zef,update_type,labeling_priority_vec)

use_settings = 0;

if nargin < 2
    update_type = [];
end

if nargin < 3
    labeling_priority_vec = [];
    use_settings = 1;
end

n_compartments = length(zef.reuna_mesh_ind);

if use_settings

    item_selected = zef.h_labeling_priority_order.Value;
    [~,~,labeling_priority_vec] = zef_choose_domain_labels(zef,[],1);
    [~, labeling_priority_vec] = sort(labeling_priority_vec);

    labeling_priority_vec = (labeling_priority_vec(:)');

    if isequal(update_type,'one step up')
        if item_selected > 1
            labeling_priority_vec = [labeling_priority_vec(1:item_selected-2) labeling_priority_vec(item_selected) labeling_priority_vec(item_selected-1) labeling_priority_vec(item_selected+1:end)];
        end
    elseif isequal(update_type,'one step down')
        if item_selected < length(labeling_priority_vec)
            labeling_priority_vec = [labeling_priority_vec(1:item_selected-1) labeling_priority_vec(item_selected+1) labeling_priority_vec(item_selected) labeling_priority_vec(item_selected+2:end)];
        end
    elseif isequal(update_type,'top')
        labeling_priority_vec = [labeling_priority_vec(item_selected) labeling_priority_vec(1:item_selected-1) labeling_priority_vec(item_selected+1:end)];
    elseif isequal(update_type,'bottom')
        labeling_priority_vec = [labeling_priority_vec(1:item_selected-1) labeling_priority_vec(item_selected+1:end) labeling_priority_vec(item_selected)];
    end

end

%labeling_priority_vec_1 = fliplr(labeling_priority_vec);
%labeling_priority_vec = labeling_priority_vec_2(labeling_priority_vec_1);

items = cell(n_compartments,1);
for i = 1 : n_compartments
    zef.([zef.compartment_tags{zef.reuna_mesh_ind(labeling_priority_vec(i))} '_labeling_priority']) = i;
    items{i} = zef.([zef.compartment_tags{zef.reuna_mesh_ind(labeling_priority_vec(i))} '_name']);
end

if use_settings
    zef.h_labeling_priority_order.Items = items;
end

end