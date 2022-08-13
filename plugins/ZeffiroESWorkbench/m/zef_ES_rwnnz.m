function [current_score_nnz, y] = zef_ES_rwnnz(y, rwnnz, varargin)

if any(isnan(y)) || isempty(y) 
    y = []; 
    current_score_nnz = 0; 
    return
end
    
rwnnz = 1 - rwnnz;

current_score_nnz_lim = Inf;
if not(isempty(varargin))
    current_score_nnz_lim = varargin{1};
end

if not(isequal(current_score_nnz_lim, 2))   %evalin('base','zef.h_ES_fixed_active_electrodes.Value') == 0;
    
    sorted_y = sort(abs(y),'descend');
    sorted_sum_y = sum(sorted_y);
    if sorted_sum_y == 0
        sorted_sum_y = 1;
        current_score_ind = 1:length(y);
        current_score_nnz = 0;
    else
        sorted_y_normalized = cumsum(sorted_y)/(sorted_sum_y);
        current_score_nnz = find(sorted_y_normalized >= rwnnz,1);
        current_score_nnz = min(current_score_nnz, current_score_nnz_lim);
        current_score_ind = find(abs(y) < sorted_y(current_score_nnz));
    end
    
    y(current_score_ind) = 0;
    
else

    [~,y_positive] = max(y(:));
    [~, y_negative] = min(y(:));
    
    current_score_nnz = 2;;
  
 y(setdiff([1:length(y)],[y_negative y_positive])) = 0;

  
end

end