function [results_summary] = source_minimal(results_summary, varargin)
    tf = cellfun('isempty',results_summary.y_tes_norm); % true for empty cells
    results_summary.y_tes_norm(tf) = {0};
    clear tf
    tf = cellfun('isempty',results_summary.residual_norm); % true for empty cells
    results_summary.residual_norm(tf) = {0};
    clear tf

    if length(varargin) == 1
        threshold = varargin{1};
    else
        threshold = 1;
    end
    
    for t = 1:length(threshold)
        A = cell2mat(results_summary.y_tes_norm(:,:,t));
        B = cell2mat(results_summary.residual_norm(:,:,t));
        C = B/max(abs(B(:))) + A/max(abs(A(:)));
        
        if isnan(C)
            results_summary.min_value(t,1) = 0;
            results_summary.min_value(t,2) = 0; results_summary.min_value(t,3) = 0;
            if length(varargin) == 1
                results_summary.min_value(t,4) = threshold(t);
            end
        else
            results_summary.min_value(t,1) = min(C(C>0));
            [results_summary.min_value(t,2), results_summary.min_value(t,3)] = find(C == min(C(C>0),[],'all'),1,'first');
            if length(varargin) == 1
                results_summary.min_value(t,4) = threshold(t);
            end
        end
    end
end