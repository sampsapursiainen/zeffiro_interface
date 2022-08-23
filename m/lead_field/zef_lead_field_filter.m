function [L, source_positions,source_directions] = zef_lead_field_filter(L,source_positions,source_directions,filter_quantile,varargin)


amp_vec = sqrt(sum(L.^2));
filter_ind = find(amp_vec > quantile(amp_vec,filter_quantile));
source_ind = [1:size(source_positions,1)]';

if isequal(size(L,2),3*size(source_positions,1))
source_filter_ind = repmat(source_ind',3,1);
source_filter_ind = source_filter_ind(:);
source_filter_ind = unique(source_filter_ind(filter_ind));
source_ind = setdiff(source_ind,source_filter_ind); 
source_ind = source_ind(:);
lead_field_ind = [3*(source_ind-1)+1 3*(source_ind-1)+2 3*source_ind]';
lead_field_ind = lead_field_ind(:);
source_positions = source_positions(source_ind,:);
L = L(:,lead_field_ind); 
else
source_filter_ind = unique(source_ind(filter_ind));
source_ind = setdiff(source_ind,source_filter_ind); 
source_ind = source_ind(:);
source_positions = source_positions(source_ind,:);
L = L(:,source_ind); 
end

if not(isempty(source_directions))
source_directions = source_directions(source_ind,:);
end

end