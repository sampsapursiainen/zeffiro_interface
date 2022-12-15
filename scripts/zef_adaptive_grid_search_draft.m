function adapted_y_ES = zef_adaptive_grid_search_draft(varargin)
%   adapted_y_ES returns an N-by-1 cell array of shrinking y_ES values
%   using a finer grid search using a narrow hyperparameter range based on
%   the initial exhaustive search produced by zef_ES_optimization.
% 
%   The shrinkage begins at the optimal solution along with its M-by-M
%   hyperparameters neighbors (if the optimal solution is located at the
%   limits, the center of the window will be adjusted to match the grid).
%
%   FUNCTION DESCRIPTION
%   ----------------------
%   Using [1] argument(s):
%   -----------------------
%   adapted_y_ES(___) or adapted_y_ES(zef)
%       evaluate the struct 'zef' which includes the hyperparameter values.
%       The M size of the window and the N number of adaptive instances
%       will automatically set by default. By default, if no zef struct is
%       provided, it will be evaluated in the workspace. 
%
%   ----------------------
%   Using [2] argument(s):
%   ----------------------
%   adapted_y_ES(M, N)
%       uses M as the size of the window, and N as the
%       number of refined adaptive instances.
%       The struct 'zef' will be evaluated in the workspace.
% 
%   ----------------------
%   Using [3] argument(s):
%   ----------------------
%   adapted_y_ES(zef, M, N)
%       zef will be included. M and N are used as stated using [2]
%       arguments.
%
%   adapted_y_ES(M, N, S)
%       generates a new row vector for both alpha and beta individually
%       using their minimun and maximum values, with S points between them.
%       (See: 'zef_ES_find_parameters' for more)
%       The struct 'zef' will be evaluated in the workspace.
%
%   ----------------------
%   Using [4] argument(s):
%   ----------------------
%   adapted_y_ES(zef, M, N, S)
%       zef will be included. M, N and S are used as stated using [3]
%       arguments.
%

%addpath 'C:\Program Files\Mosek\9.3\toolbox\r2015a'
%% pre-allocate arguments and variables
switch nargin
    case {0,1}
        if nargin == 0
            zef = evalin('base','zef');
            warning('ZI: No zef were called as an input argument.')
        else
            zef = varargin{1};
        end
        %%% default settings
        adapt_window = 3;
        adapt_instances = 5;
        step_size = zef.ES_step_size;
    case {2}
        zef = evalin('base','zef');
        [adapt_window, adapt_instances] = deal(varargin{1}, varargin{2});
        step_size = zef.ES_step_size;
    case {3}
        if isstruct(varargin{1})
            [zef, adapt_window, adapt_instances] = deal(varargin{1}, varargin{2}, varargin{3});
            step_size = zef.ES_step_size;
        else
            zef = evalin('base','zef');
            [adapt_window, adapt_instances, step_size] = deal(varargin{1}, varargin{2}, varargin{3});
        end
    case {4}
        [zef, adapt_window, adapt_instances, step_size] = deal(varargin{1}, varargin{2}, varargin{3}, varargin{4});
    otherwise
        error('ZI: Invalid number of arguments.')
end
adapted_y_ES = {};
%% Calculate initial solution
[alpha, beta] = zef_ES_find_parameters(zef, step_size);
zef_ES_find_currents(zef, alpha, beta, step_size);
adapted_y_ES{1} = zef.y_ES_interval;

zef_ES_plot_error_chart(zef); pause(1)
%%
for stage_idx = 2:adapt_instances+1
    [sr, sc] = zef_ES_objective_function(zef);
    sc_2 = update_window_position(adapt_window, alpha, sc);
    sr_2 = update_window_position(adapt_window, beta, sr);

    % update alpha/beta based on the last adapt_window
    [alpha_2, beta_2] = zef_ES_find_parameters(alpha(sc_2), beta(sr_2), step_size);
    zef_ES_find_currents(zef, alpha_2, beta_2, step_size)
    adapted_y_ES{stage_idx} = zef.y_ES_interval; %#ok<AGROW>

    zef_ES_plot_error_chart(zef); pause(1)

    % Update initial alpha/beta (slide)
    alpha = alpha_2;
    beta = beta_2;
end
%% nested functions
    function srsc = update_window_position(adapt_window, param_aux, s_opt)
        if any(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) > length(param_aux))
            nnz_aux = nnz(s_opt + (-floor(adapt_window/2):floor(adapt_window/2)) > length(param_aux));
            srsc = s_opt - nnz_aux + (-floor(adapt_window/2):floor(adapt_window/2));
        else
            if floor(adapt_window/2) < s_opt
                srsc = s_opt + (-floor(adapt_window/2):floor(adapt_window/2));
            else
                srsc = (-floor(adapt_window/2):floor(adapt_window/2)) - min((-floor(adapt_window/2):floor(adapt_window/2)));
            end
        end
    end
end % End of function