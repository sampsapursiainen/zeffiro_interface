function [current_score_nnz] = zef_ES_rwnnz(y, rwnnz)

sorted_y = cumsum(sort(abs(y),'descend'));
y = 100*sorted_y/norm(y,1);
current_score_nnz = find(round(y,9) >= rwnnz,1);

end