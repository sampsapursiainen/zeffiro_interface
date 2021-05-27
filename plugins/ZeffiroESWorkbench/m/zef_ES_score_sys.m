function [current_score] = zef_ES_score_sys(y, rwnnz)

sorted_y = cumsum(sort(abs(y),'descend'));

y = 100*sorted_y/norm(y,1);

current_score = find(y >= rwnnz,1);

% type = 1;
% if not(isempty(varargin))
%     type = varargin{1};
% end
% 
% y = abs(y(:));
% max_y = max(y);
% y = y/max_y;
% 
% if type == 1
%     y = ceil(n_levels*y);
% else
%     y = round(n_levels*y);
% end
% 
% current_score = max_y*sum(y)/n_levels;
% %point_score = 1000*current_score/(length(y));

end