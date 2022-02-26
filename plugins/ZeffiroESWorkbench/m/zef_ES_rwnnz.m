function [current_score_nnz, y] = zef_ES_rwnnz(y, rwnnz, varargin)

current_score_nnz_lim = Inf;
if not(isempty(varargin))
    current_score_nnz_lim = varargin{1};
end

if not(isequal(current_score_nnz_lim, 2))   %evalin('base','zef.h_ES_fixed_active_electrodes.Value') == 0;

    sorted_y = sort(abs(y),'descend');
    sorted_y_normalized = 100*cumsum(sorted_y)/sum(sorted_y);
    current_score_nnz = find(round(sorted_y_normalized,9) >= rwnnz,1);
    current_score_nnz = min(current_score_nnz, current_score_nnz_lim);
    current_score_ind = find(abs(y) < sorted_y(current_score_nnz));
    y(current_score_ind) = 0;   %#ok<FNDSB>

else

    y_positive = max(y(:),0);
    sorted_y_positive = sort(y_positive,'descend');
    y_negative = -min(y(:),0);
    sorted_y_negative = sort(y_negative,'descend');

%     current_score_nnz_lim_positive = length(find(y > 0));
%     current_score_nnz_lim_negative = length(find(y < 0));

    if max(y_positive) > max(y_negative)
        current_score_nnz_lim_positive = floor(current_score_nnz_lim/2);
        current_score_nnz_lim_negative = ceil(current_score_nnz_lim/2);
    else
        current_score_nnz_lim_positive = ceil(current_score_nnz_lim/2);
        current_score_nnz_lim_negative = floor(current_score_nnz_lim/2);
    end

    sorted_y = sorted_y_positive(:);
    sorted_y_normalized = 100*cumsum(sorted_y)/sum(sorted_y);
    current_score_nnz = find(round(sorted_y_normalized,9) >= rwnnz,1);
    if not(isempty(current_score_nnz))
        current_score_nnz = min(current_score_nnz, current_score_nnz_lim_positive);
        current_score_ind_positive = find(y_positive < sorted_y(current_score_nnz));
    else
        current_score_ind_positive = [1 : length(y_positive)]';
    end

    sorted_y = sorted_y_negative(:);
    sorted_y_normalized = 100*cumsum(sorted_y)/sum(sorted_y);
    current_score_nnz = find(round(sorted_y_normalized,9) >= rwnnz,1);
    if not(isempty(current_score_nnz))
        current_score_nnz = min(current_score_nnz, current_score_nnz_lim_negative);
        current_score_ind_negative = find(y_negative < sorted_y(current_score_nnz));
    else
        current_score_ind_negative = [1 : length(y_negative)]';
    end

    y(intersect(current_score_ind_positive,current_score_ind_negative)) = 0;

end

end