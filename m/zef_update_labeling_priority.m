function zef = zef_update_labeling_priority(zef,update_type,labeling_priority_vec)

use_settings = 0;

if nargin < 2
update_type = [];
end

if nargin < 3
    labeling_priority_vec = [];
    use_settings = 1;
end

if use_settings

item_selected = zef.h_labeling_priority_order.Value; 
[~,~,labeling_priority_vec] = zef_choose_domain_labels(zef,[],1);
labeling_priority_vec = labeling_priority_vec(:)';

if isequal(update_type,'one step up')
if item_selected > 1
labeling_priority_vec = [labeling_priority_vec(1:item_selected-2) labeling_priority_vec(item_selected) labeling_priority_vec(item_selected-1) labeling_priority_vec(item_selected+1:end)];
end
elseif isequal(update_type,'one step down')
 if item_selected < length(labeling_priority_vec)
labeling_priority_vec = [labeling_priority_vec(1:item_selected-1) labeling_priority_vec(item_selected+1) labeling_priority_vec(item_selected) labeling_priority_vec(item_selected+2:end)];
 end
 elseif isequal(update_type,'top')
labeling_priority_vec = [labeling_priority_vec(item_selected) labeling_priority_vec(1:item_selected-1) labeling_priority_vec(1:item_selected+1)]; 
elseif isequal(update_type,'bottom')
labeling_priority_vec = [labeling_priority_vec(1:item_selected-1) labeling_priority_vec(1:item_selected+1) labeling_priority_vec(item_selected)];
end

end

items = cell(length(zef.compartment_tags),1);
for i = 1 : length(zef.compartment_tags) 
zef.([zef.compartment_tags{i} '_labeling_priority']) = labeling_priority_vec(i);
items{i} = zef.([zef.compartment_tags{labeling_priority_vec(i)} '_name']);
end

if use_settings
zef.h_labeling_priority_order.Items = items; 
end

end