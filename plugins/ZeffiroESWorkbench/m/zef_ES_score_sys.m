function [current_score] = zef_ES_score_sys(y, rwnnz)
if istable(y)
    y = table2array(y);
end
sorted_y = cumsum(sort(abs(y),'descend'));
y = 100*sorted_y/norm(y,1);
current_score = find(y >= rwnnz,1);
end
