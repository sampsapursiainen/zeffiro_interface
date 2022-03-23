function [L, source_positions,source_directions] = zef_lead_field_filter(L,source_positions,source_directions,filter_quantile,varargin)

lead_field_type = 1; 
if not(isempty(varargin))
lead_field_type = varargin{1};
end

if isequal(lead_field_type,1)
amp_vec = sqrt(sum(L.^2));
else
amp_vec = sqrt(sum(L.^2,2));
end
filter_ind = find(amp_vec > quantile(amp_vec,filter_quantile));
source_ind = [1:size(source_positions,1)]';

if isempty(source_directions)
source_filter_ind = repmat(source_ind',3,1);
source_filter_ind = source_filter_ind(:);
source_filter_ind = unique(source_filter_ind(filter_ind));
source_ind = setdiff(source_ind,source_filter_ind); 
source_ind = source_ind(:);
lead_field_ind = [3*(source_ind-1)+1 3*(source_ind-1)+2 3*source_ind]';
lead_field_ind = lead_field_ind(:);
source_positions = source_positions(source_ind,:);
if isequal(lead_field_type,1)
L = L(:,lead_field_ind); 
else
L = L(lead_field_ind,:); 
end
else
source_filter_ind = unique(source_ind(filter_ind));
source_ind = setdiff(source_ind,source_filter_ind); 
source_ind = source_ind(:);
source_positions = source_positions(source_ind,:);
if isequal(lead_field_type,1)
L = L(:,source_ind); 
else
L = L(source_ind,:);    
end
source_directions = source_directions(source_ind,:);
end

end