function srsc = zef_ES_centralize_recursive_search_window(adapt_window, original_window, param_aux, s_opt)
if adapt_window < length(param_aux)
    if any(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) >= length(param_aux)) %&& ~any(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) >= original_window)
        nnz_aux = nnz(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) > length(param_aux));
        srsc = s_opt - nnz_aux + (-floor(adapt_window/2):floor(adapt_window/2));
    else
        if floor(adapt_window/2) < s_opt && ~any(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) >= original_window)
            srsc = s_opt + (-floor(adapt_window/2):floor(adapt_window/2));
        else
            srsc = (-floor(adapt_window/2):floor(adapt_window/2)) - min((-floor(adapt_window/2):floor(adapt_window/2))-1);
        end
    end
else
    srsc = 1:adapt_window;
end
end