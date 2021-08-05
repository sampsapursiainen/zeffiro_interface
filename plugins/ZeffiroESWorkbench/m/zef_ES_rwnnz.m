function [current_score_nnz, y] = zef_ES_rwnnz(y, rwnnz, varargin)

current_score_nnz_lim = Inf;
if not(isempty(varargin))
    current_score_nnz_lim = varargin{1};
end

sorted_y = sort(abs(y),'descend');
sorted_y_normalized = 100*cumsum(sorted_y)/sum(sorted_y);
current_score_nnz = find(round(sorted_y_normalized,9) >= rwnnz,1);
current_score_nnz = min(current_score_nnz, current_score_nnz_lim);
current_score_ind = find(abs(y) < sorted_y(current_score_nnz));
y(current_score_ind) = 0;   %#ok<FNDSB>
end