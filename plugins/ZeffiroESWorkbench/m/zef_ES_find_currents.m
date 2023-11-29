function zef = zef_ES_find_currents(varargin)
%% Loading data
switch nargin
    case {0,1}
        if nargin == 0
            zef = evalin('base','zef');
        else
            zef = varargin{1};
        end
        [alpha, epsilon] = zef_ES_find_parameters(zef);
    case {3}
        [zef, alpha, epsilon] = deal(varargin{1}, varargin{2}, varargin{3});
    otherwise
        error('ZI: Too many input arguments.')
end
%% zef_data allocation
zef_data.L_aux                  = zef.L';
zef_data.source_positions       = zef.inv_synth_source(:,1:3);
zef_data.source_directions      = zef.inv_synth_source(:,4:6);
zef_data.inv_synth_source       = zef.inv_synth_source;

zef_data.source_positions_aux   = zef.source_positions;

zef_data.total_max_current      = zef.ES_total_max_current;
zef_data.max_current_channel    = zef.ES_max_current_channel;

zef_data.search_method          = zef.ES_opt_method;
zef_data.solver_package         = zef.ES_opt_solver_list{zef.ES_opt_solver};
zef_data.active_electrodes      = zef.ES_active_electrodes;

zef_data.source_density         = zef.ES_source_density;

zef_data.relative_weight_nnz    = zef.ES_relative_weight_nnz;
zef_data.score_dose             = zef.ES_score_dose;

if zef.ES_opt_solver == 4
    if exist('../mosek/', 'dir') == 7
        oldpath = pwd;
        cd ..
        addpath(genpath('mosek/'))
        cd(oldpath)
    else
        error('ZI: unable to find relevant mosek folder. Are you initializing your calculations outside the main-branch working directory?')
    end
    
    
end

if isequal(lower(zef_data.solver_package),'mosek')
    if not(ismember(zef_data.search_method, 5))
        zef_data.opts = mskoptimset('linprog');
    else
        pwd_aux = pwd;
        dir_aux = [toolboxdir('optim') filesep 'optim'];
        cd(dir_aux);
        if not(ismember(zef_data.search_method, 5))
            zef_data.opts = optimset('linprog');
        else
            zef_data.opts = optimset('quadprog');
        end
        cd(pwd_aux);
    end
end

zef_data.opts.solver = zef_data.solver_package;

if isequal(lower(zef_data.solver_package),'matlab')
    pwd_aux = pwd;
    dir_aux = [toolboxdir('optim') filesep 'optim'];
    cd(dir_aux);
    if not(ismember(zef_data.search_method, 5))
        zef_data.h_linprog = str2func('linprog');
    else
        zef_data.h_quadprog = str2func('quadprog');
    end
    cd(pwd_aux);
end

display                 = zef.ES_display;
absolute_tolerance      = zef.ES_absolute_tolerance;
relative_tolerance      = zef.ES_relative_tolerance;
constraint_tolerance    = zef.ES_constraint_tolerance;
solver_tolerance        = zef.ES_solver_tolerance;
step_tolerance          = zef.ES_step_tolerance;

algorithm               = zef.ES_opt_algorithm;

max_n_iterations        = zef.ES_max_n_iterations;
max_time                = zef.ES_max_time;

if isinf(max_n_iterations)
    zef_data.opts.MaxIter = intmax;
else
    zef_data.opts.MaxIter = max_n_iterations;
end

zef_data.opts.TolX      = step_tolerance;
zef_data.opts.TolCon    = constraint_tolerance;
zef_data.opts.TolAbs    = absolute_tolerance;
zef_data.opts.TolRel    = relative_tolerance;
zef_data.opts.MaxIter   = max_n_iterations;
zef_data.opts.MaxTime   = max_time;
zef_data.opts.Algorithm = lower(algorithm);
zef_data.opts.Display   = display;
zef_data.opts.TolFun    = solver_tolerance;

if isempty(zef.source_positions)
    error('ZI: No discretized sources found. Perhaps you forgot to calculate or load them...?')
end
%% waitbar
zef.use_waitbar = 0;
if zef.use_waitbar == 1
    wait_bar_temp = zef_waitbar(...
        [0 0], ...
        sprintf(['Optimizer: ' zef_data.solver_package ', ' 'Algorithm: ' zef_data.opts.Algorithm ', Optimizing: i = %d, j = d%' '.'], 0, 0)...
        );
end
%% The real task...
zef.y_ES_interval = [];

n_parallel = zef.parallel_processes;
if ismember(zef.ES_opt_method, [1 2])
    if isempty(gcp('nocreate'))
        parpool(n_parallel);
    else
        h_pool = gcp;
        if not(isequal(h_pool.NumWorkers,n_parallel))
            delete(h_pool)
            parpool(n_parallel);
        end
    end
end

if zef_data.search_method ~= 4
    if nargin ~= 4
        step_size = zef.ES_step_size;
    else
        step_size = varargin{4};
    end
else
    step_size = 1;
end

for i = 1:step_size
    j = 0;
    while j < step_size
        p_ind_max = min(step_size - j, n_parallel);
        parfor parallel_ind = 1:p_ind_max %parfor
            run_time{parallel_ind} = now;
            
            [y_ES{parallel_ind}, ...
                volumetric_current_density{parallel_ind}, ...
                residual{parallel_ind}, ...
                flag{parallel_ind}, ...
                source_amplitude{parallel_ind}, ...
                source_position_index{parallel_ind}, ...
                source_directions{parallel_ind}] = zef_ES_optimize_current(zef_data, alpha(parallel_ind + j), epsilon(i)); %#ok<PFBNS>
            
            run_time{parallel_ind} = 86400*(now - run_time{parallel_ind});
        end
        
        for parallel_ind = 1:p_ind_max
            j = j + 1;
            zef.y_ES_interval.run_time{i,j}                     = run_time{parallel_ind};
            zef.y_ES_interval.y_ES{i,j}                         = y_ES{parallel_ind};
            zef.y_ES_interval.volumetric_current_density{i,j}   = volumetric_current_density{parallel_ind};
            zef.y_ES_interval.residual{i,j}                     = residual{parallel_ind};
            zef.y_ES_interval.flag{i,j}                         = flag{parallel_ind};
            zef.y_ES_interval.source_amplitude{i,j}             = source_amplitude{parallel_ind};
            zef.y_ES_interval.nnz{i,j}                          = zef_ES_rwnnz(y_ES{parallel_ind}, zef_data.relative_weight_nnz, zef_data.score_dose);
            %% Field source
            if ismember(flag{parallel_ind}, [1, 3]) && norm(y_ES{parallel_ind}, 2) > 0
                for running_index = 1:length(source_position_index{parallel_ind})
                    vec_1 = source_amplitude{parallel_ind}(running_index)*source_directions{parallel_ind}(running_index,:);
                    norm_vec_1 = norm(vec_1, 2);
                    
                    if isequal(zef.ES_roi_range, 0)
                        source_running_ind = source_position_index{parallel_ind}(running_index);
                    else
                        source_running_ind = rangesearch(zef_data.source_positions_aux, ...
                            zef_data.source_positions(running_index, :), ...
                            zef.ES_roi_range);
                        source_running_ind = source_running_ind{1};
                    end
                    
                    vec_2 = mean(volumetric_current_density{parallel_ind}(:,source_running_ind),2);
                    norm_vec_2 = norm(vec_2,2);
                    if isequal(norm_vec_2,0)
                        norm_vec_2 = 1;
                    end
                    vec_index = setdiff(1:length(volumetric_current_density{parallel_ind}), source_running_ind);
                    zef.y_ES_interval.field_source(running_index).field_source{i,j}         = (volumetric_current_density{parallel_ind}(:,source_running_ind));
                    zef.y_ES_interval.field_source(running_index).amplitude{i,j}            = mean(sum(volumetric_current_density{parallel_ind}(:,source_running_ind).*repmat(vec_1',1,length(source_running_ind))./norm_vec_1));
                    zef.y_ES_interval.field_source(running_index).angle{i,j}                = 180/pi*acos(dot(vec_1',vec_2) / (norm_vec_1'*norm_vec_2));
                    zef.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = abs(1 - norm(vec_2) / norm_vec_1);
                    zef.y_ES_interval.field_source(running_index).relative_error{i,j}       = norm(vec_1'/norm(vec_1) - vec_2/norm(vec_2));
                    zef.y_ES_interval.field_source(running_index).avg_off_field{i,j}        = mean(sqrt(sum(volumetric_current_density{parallel_ind}(:, vec_index).^2)));
                end
            else
                for running_index = 1:length(source_position_index{parallel_ind})
                    zef.y_ES_interval.field_source(running_index).field_source{i,j}         = 0;
                    zef.y_ES_interval.field_source(running_index).amplitude{i,j}            = 0;
                    zef.y_ES_interval.field_source(running_index).angle{i,j}                = 360;
                    zef.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = 1;
                    zef.y_ES_interval.field_source(running_index).relative_error{i,j}       = 1;
                    zef.y_ES_interval.field_source(running_index).avg_off_field{i,j}        = Inf;
                end
            end
        end
        
        if zef.use_waitbar
            zef_waitbar([j/length(alpha) i/length(epsilon)] , wait_bar_temp, sprintf(['Optimizer: ' zef_data.solver_package ', ' 'Algorithm: ' zef_data.opts.Algorithm ', Optimizing: %1.2e -- %1.2e' '.'], epsilon(i), alpha(j)));
        end
    end
    if zef.use_waitbar
        zef_waitbar([j/length(alpha) i/length(epsilon)] , wait_bar_temp, sprintf(['Optimizer: ' zef_data.solver_package ', ' 'Algorithm: ' zef_data.opts.Algorithm ', Optimizing: %1.2e -- %1.2e' '.'], epsilon(i), alpha(j)));
    end
end

zef.y_ES_interval.alpha     = alpha;
zef.y_ES_interval.epsilon   = epsilon;

if exist('wait_bar_temp') %#ok<EXIST>
    close(wait_bar_temp)
end

if nargout == 0
    %assignin('base','zef',zef);
    assignin('caller','zef',zef);
end
end