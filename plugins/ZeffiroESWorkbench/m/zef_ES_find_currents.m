function zef_ES_find_currents

zef_data.L_aux                       = evalin('base','zef.L');
zef_data.L_aux = zef_data.L_aux';
zef_data.source_positions            = evalin('base','zef.inv_synth_source(:,1:3)');
zef_data.source_directions           = evalin('base','zef.inv_synth_source(:,4:6)');
zef_data.relative_source_amplitude   = evalin('base','zef.ES_relative_source_amplitude');
zef_data.total_max_current = evalin('base','zef.ES_total_max_current');
zef_data.max_current_channel = evalin('base','zef.ES_max_current_channel');
zef_data.search_method = evalin('base','zef.ES_search_method');
zef_data.active_electrodes = evalin('base','zef.ES_active_electrodes');
zef_data.source_positions_aux = evalin('base','zef.source_positions');
zef_data.source_density = evalin('base','zef.ES_source_density');
zef_data.inv_synth_source = evalin('base','zef.inv_synth_source');
zef_data.relative_weight_nnz = evalin('base','zef.ES_relative_weight_nnz');
zef_data.score_dose = evalin('base','zef.ES_score_dose');
zef_data.solver_package = evalin('base','zef.ES_solver_package');

simplex = evalin('base','zef.ES_simplex');
display = evalin('base','zef.ES_simplex');
absolute_tolerance = evalin('base','zef.ES_absolute_tolerance');
relative_tolerance = evalin('base','zef.ES_relative_tolerance');

solver_tolerance = evalin('base','zef.ES_solver_tolerance');
step_tolerance = evalin('base','zef.ES_step_tolerance');
constraint_tolerance = evalin('base','zef.ES_constraint_tolerance');
algorithm = evalin('base','zef.ES_algorithm');

max_n_iterations = evalin('base','zef.ES_max_n_iterations');
max_time         = evalin('base','zef.ES_max_time');

aux_string = [ lower(zef_data.solver_package) '_path'];
if evalin('base',['isfield(zef,''' aux_string ''')'])
    solver_path = evalin('base',['zef.' aux_string ]);
else
    solver_path = '';
end

if isequal(lower(zef_data.solver_package),'mosek')
    if not(ismember(zef_data.search_method,[5]))
    zef_data.opts = mskoptimset('linprog');
    else
        zef_data.opts = mskoptimset('quadprog');
    end
else
     pwd_aux = pwd;
    dir_aux = [toolboxdir('optim') filesep 'optim'];
    cd(dir_aux);
        if not(ismember(zef_data.search_method,[5]))
    zef_data.opts = optimset('linprog');
    else
        zef_data.opts = optimset('quadprog');
        end;
    cd(pwd_aux)
end

zef_data.Solver = zef_data.solver_package;
zef_data.opts.Display    = 'off';
zef_data.opts.Simplex = simplex;

if isinf(max_n_iterations)
    zef_data.opts.MaxIter = intmax;
else
    zef_data.opts.MaxIter = max_n_iterations;
end

zef_data.opts.TolX    = step_tolerance;
zef_data.opts.TolCon  = constraint_tolerance;
zef_data.opts.TolAbs    = absolute_tolerance;
zef_data.opts.TolRel  = relative_tolerance;
zef_data.opts.MaxIter = max_n_iterations;
zef_data.opts.MaxTime = max_time;
zef_data.opts.Algorithm  = algorithm;
zef_data.opts.Display    = display;
zef_data.opts.TolFun     = solver_tolerance;


if isequal(lower(zef_data.solver_package),'matlab')
    pwd_aux = pwd;
    dir_aux = [toolboxdir('optim') filesep 'optim'];
    cd(dir_aux);
        if not(ismember(zef_data.search_method,[5]))
     zef_data.h_linprog = str2func('linprog');
    else
        zef_data.h_quadprog = str2func('quadprog');
    end
   
    cd(pwd_aux)
elseif not(isempty(solver_path))
    pwd_aux = pwd;
    path_aux = solver_path;
    cd(path_aux);
    if not(ismember(zef_data.search_method,[5]))
     zef_data.h_linprog = str2func('linprog');
    else
        zef_data.h_quadprog = str2func('quadprog');
    end
    cd(pwd_aux)
else
    if not(ismember(zef_data.search_method,[5]))
     zef_data.h_linprog = str2func('linprog');
    else
        zef_data.h_quadprog = str2func('quadprog');
    end
end


if isempty(evalin('base','zef.source_positions'))
    error('--ZI: No discretized sources found. Perhaps you forgot to calculate or load them...?')
end

[alpha, beta] = zef_ES_find_parameters;

%% Waitbar
if exist('wait_bar_temp','var') == 1
    delete(wait_bar_temp)
end
wait_bar_temp = waitbar([0 0],sprintf(['Package: ' zef_data.solver_package '. Optimizing: i = %d, j = d%'],0,0), ...
    'Name','ZEFFIRO Interface: ES Optimization...', ...
    'CreateCancelbtn','setappdata(gcbf,''canceling'',1)', ...
    'Visible','on');


%% The real task...
zef_data_2.y_ES_interval = [];

n_parallel = evalin('base','zef.parallel_processes');
if ismember(evalin('base','zef.ES_search_method'),[1 2])
    try
        if isempty(gcp)
            parpool(n_parallel)
        end
    catch
        delete(gcp('nocreate'));
        parpool(n_parallel);
    end
end
if not(isequal(zef_data.search_method,4))
lattice_size = evalin('base','zef.ES_step_size');
else
    lattice_size = 1; 
end
for i = 1 : lattice_size
    j= 0;
    while  j <  lattice_size
        p_ind_max = min(lattice_size-j,n_parallel);
        parfor parallel_ind = 1 : p_ind_max
            
            if getappdata(wait_bar_temp,'canceling')
                error('The calculations were interrupted by the user.')
            end
            
            tic;
            [y_ES{parallel_ind}, volumetric_current_density{parallel_ind}, residual{parallel_ind}, flag{parallel_ind}, source_magnitude{parallel_ind}, source_position_index{parallel_ind}, source_directions{parallel_ind}] = zef_ES_optimize_current(zef_data,alpha(parallel_ind+j),beta(i));
            
        end
        
        for parallel_ind = 1 : p_ind_max
            j = j + 1;
            zef_data_2.y_ES_interval.y_ES{i,j}                         = y_ES{parallel_ind};
            zef_data_2.y_ES_interval.volumetric_current_density{i,j}   = volumetric_current_density{parallel_ind};
            zef_data_2.y_ES_interval.residual{i,j}                     = residual{parallel_ind};
            zef_data_2.y_ES_interval.flag{i,j}                         = flag{parallel_ind};
            zef_data_2.y_ES_interval.source_magnitude{i,j}             = source_magnitude{parallel_ind};
            
            if ismember(flag{parallel_ind},[1,3]) && norm(y_ES{parallel_ind},2) > 0
                for running_index = 1:length(source_position_index{parallel_ind})
                    vec_1 = source_magnitude{parallel_ind}(running_index)*source_directions{parallel_ind}(running_index,:);
                    norm_vec_1 = norm(vec_1,2);
                    
                    if isequal(evalin('base','zef.ES_roi_range'),0)
                        source_running_ind = source_position_index{parallel_ind}(running_index);
                    else
                        source_running_ind = rangesearch(zef_data.source_positions_aux,zef_data.source_positions_aux(source_position_index{parallel_ind}(running_index),:), evalin('base','zef.ES_roi_range'));
                        source_running_ind = source_running_ind{1};
                    end
                    
                    vec_2 = mean(volumetric_current_density{parallel_ind}(:,source_running_ind),2);
                    norm_vec_2 = norm(vec_2,2);
                    if isequal(norm_vec_2,0)
                        norm_vec_2 = 1;
                    end
                    vec_index = setdiff(1:length(volumetric_current_density{parallel_ind}), source_running_ind);
                    zef_data_2.y_ES_interval.field_source(running_index).field_source{i,j}         = (volumetric_current_density{parallel_ind}(:,source_running_ind));
                    zef_data_2.y_ES_interval.field_source(running_index).magnitude{i,j}            = mean(sum(volumetric_current_density{parallel_ind}(:,source_running_ind).*repmat(vec_1',1,length(source_running_ind))./norm_vec_1));
                    zef_data_2.y_ES_interval.field_source(running_index).angle{i,j}                = 180/pi*acos(dot(vec_1',vec_2)/(norm_vec_1'*norm_vec_2));
                    zef_data_2.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = abs(1 - norm(vec_2)/norm_vec_1);
                    zef_data_2.y_ES_interval.field_source(running_index).relative_error{i,j}       = norm(vec_1'-vec_2)./norm_vec_1;
                    zef_data_2.y_ES_interval.field_source(running_index).avg_off_field{i,j}        = mean(sqrt(sum(volumetric_current_density{parallel_ind}(:, vec_index).^2)));
                end
            else
                for running_index = 1:length(source_position_index{parallel_ind})
                    zef_data_2.y_ES_interval.field_source(running_index).field_source{i,j}         = 0;
                    zef_data_2.y_ES_interval.field_source(running_index).magnitude{i,j}            = 0;
                    zef_data_2.y_ES_interval.field_source(running_index).angle{i,j}                = 360;
                    zef_data_2.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = 1;
                    zef_data_2.y_ES_interval.field_source(running_index).relative_error{i,j}       = 1;
                    zef_data_2.y_ES_interval.field_source(running_index).avg_off_field{i,j}        = Inf;
                end
            end
            
        end
        waitbar([j/length(alpha) i/length(beta)] , wait_bar_temp, sprintf(['Package: ' zef_data.solver_package '. Optimizing: %1.2e -- %1.2e'], beta(i), alpha(j)));
    end
    waitbar([j/length(alpha) i/length(beta)] , wait_bar_temp, sprintf(['Package: ' zef_data.solver_package '. Optimizing: %1.2e -- %1.2e'], beta(i), alpha(j)));
    
    
end

zef_data_2.y_ES_interval.alpha  = alpha;
zef_data_2.y_ES_interval.beta   = beta;

if exist('wait_bar_temp') %#ok<EXIST>
    delete(wait_bar_temp)
end

assignin('base','zef_data',zef_data_2);
zef_assign_data;

end