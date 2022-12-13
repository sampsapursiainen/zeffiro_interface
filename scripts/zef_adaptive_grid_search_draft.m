function adapted_y_ES = zef_adaptive_grid_search_draft(varargin)

%addpath 'C:\Program Files\Mosek\9.3\toolbox\r2015a'
%mosekdiag

switch nargin
    case {0,1}
        if nargin == 0
            zef = evalin('base','zef');
            warning('ZI: No zef were called as input argument.')
        else
            zef = varargin{1};
        end
        adapt_window = 3;
        adapt_search = 5;
        step_size = zef.ES_step_size;
    case {2}
        zef = evalin('base','zef');
        [adapt_window, adapt_search] = deal(varargin{1}, varargin{2});
    case {3,4}
        [zef, adapt_window, adapt_search] = deal(varargin{1}, varargin{2}, varargin{3});
        if nargin < 4
            step_size = zef.ES_step_size;
        else
            step_size = varargin{4};
        end
    otherwise
        error('ZI: Invalid number of arguments.')
end

adapted_y_ES = {};

zef_ES_find_currents(zef)
[alpha, beta] = zef_ES_find_parameters(zef);
[sr, sc] = zef_ES_objective_function(zef);

zef_ES_plot_error_chart(zef)
pause(1);

adapted_y_ES{1} = zef.y_ES_interval;

for stage_idx = 2:adapt_search+1
    s_aux = sc;
    if any(s_aux + (-floor(adapt_window/2):floor(adapt_window/2)) > length(alpha))
        nnz_aux = nnz(s_aux + (-floor(adapt_window/2):floor(adapt_window/2)) > length(alpha));
        sc_2 = s_aux - nnz_aux + (-floor(adapt_window/2):floor(adapt_window/2));
    else
        if floor(adapt_window/2) < sc
            sc_2 = s_aux + (-floor(adapt_window/2):floor(adapt_window/2));
        else
            sc_2 = (-floor(adapt_window/2):floor(adapt_window/2)) - min((-floor(adapt_window/2):floor(adapt_window/2)))+1;
        end
    end

    s_aux = sr;
    if any(s_aux + (-floor(adapt_window/2):floor(adapt_window/2)) > length(beta))
        nnz_aux = nnz(s_aux + (-floor(adapt_window/2):floor(adapt_window/2)) > length(beta));
        sr_2 = s_aux - nnz_aux + (-floor(adapt_window/2):floor(adapt_window/2));
    else
        if floor(adapt_window/2) < sr
            sr_2 = s_aux + (-floor(adapt_window/2):floor(adapt_window/2));
        else
            sr_2 = (-floor(adapt_window/2):floor(adapt_window/2)) - min((-floor(adapt_window/2):floor(adapt_window/2)))+1;
        end
    end

    % Give the limited alpha/beta values based on the last adapt_window
    [alpha_2, beta_2] = zef_ES_find_parameters(alpha(sc_2), beta(sr_2), step_size);

    % Re-calculate using new alpha/beta
    zef_ES_find_currents(zef, alpha_2, beta_2)
    adapted_y_ES{stage_idx} = zef.y_ES_interval; %#ok<AGROW>

    zef_ES_plot_error_chart(zef)
    pause(1);

    alpha = alpha_2;
    beta = beta_2;
    [sr, sc] = zef_ES_objective_function(zef);
end

end
