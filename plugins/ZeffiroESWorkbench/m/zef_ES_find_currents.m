%% Try-catch for securing waitbar will be deleted in case of an error
try % <--- try-catch function used to delete waitbar in case of an error.
    %% Waitbar preparation
    try
        if isempty(evalin('base','zef.source_positions'))
            warning('No discretized sources found. Perhaps you forgot to calculate them...? or forgot to load a file?')
            return
        end
    catch
        error('zef.source_positions does not exist!')
    end
    wait_bar_temp = waitbar(0,sprintf('Optimizing ES currents: i = %d, j = d%',0,0), ...
        'Name','ZEFFIRO Interface: ES Optimization...', ...
        'CreateCancelbtn','setappdata(gcbf,''canceling'',1)', ...
        'Visible','on');
    %% clear cells for interval search
    if evalin('base','zef.ES_search_type') ~= 1
        zef.y_ES_interval = [];
        if evalin('base','zef.ES_current_threshold_checkbox') == 1
            zef.y_ES_interval_threshold = [];
        end
    end
    %% Threshold validation
    %Validate the Threshold value (must be a positive value)
    if evalin('base','zef.ES_current_threshold') < 0
        zef.ES_current_threshold_checkbox = 0;
        warning('Error: Invalid threshold value inserted.');
    end
    %% TolFun and reg_param preparation
    if evalin('base','zef.ES_search_type') <= 2
        [TolFun, reg_param] = zef_ES_find_parameters;
    elseif evalin('base','zef.ES_search_type') == 3
        [TolFun] = zef_ES_find_parameters;
        TolFun = TolFun(1);
        reg_param = 0;
    end
    
    waitbar_ind = 1/(length(reg_param)*length(TolFun));
    %% For loop using TolFun and reg_param
    for i = 1:length(TolFun)
        for j = 1:length(reg_param)
            %% Check for Cancel button
            if getappdata(wait_bar_temp,'canceling')
                break
            end
            waitbar(waitbar_ind, wait_bar_temp, sprintf('Optimizing ES currents: \n Opt.Tol = %d -- Reg.Param = %d', TolFun(i), reg_param(j)));
%             %% Active electrodes
%             if evalin('base','zef.ES_search_type') == 3
%                 zef.ES_active_electrodes = zef_ES_4x1_fun;
%             else
%                 zef.ES_active_electrodes = [];
%             end
            %% LP Solver using TolFun(i) and reg_param(j)
            tic
            try
                [y_ES, volumetric_current_density, residual, flag, source_position_index, source_directions, source_magnitude] = zef_ES_optimize_current(TolFun(i), reg_param(j));
            catch ME
                delete(wait_bar_temp)
                rethrow(ME)
            end
            %% Allocation of LP results and the used search type
            if evalin('base','zef.ES_search_type') == 1
                zef.y_ES_single.y_ES                                = y_ES;
                zef.y_ES_single.volumetric_current_density          = volumetric_current_density;
                zef.y_ES_single.residual                            = residual;
                zef.y_ES_single.flag                                = flag;
                zef.y_ES_single.optimizer_tolerance                 = TolFun;
                zef.y_ES_single.reg_param                           = reg_param;
                for running_index = 1:length(source_position_index)
                    vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                    vec_2 = (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_single.field_source(running_index).field_source =         (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_single.field_source(running_index).magnitude    = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
                    zef.y_ES_single.field_source(running_index).angle        = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                    zef.y_ES_single.field_source(running_index).relative     = norm(vec_2)/norm(vec_1');
                    zef.y_ES_single.field_source(running_index).error_norm   = norm(vec_1'-vec_2);
                    
                end
                zef.y_ES_single.elapsed_time                        = toc;
                
                % y_ES_single Threshold
                if evalin('base','zef.ES_current_threshold_checkbox')
                    if evalin('base','zef.y_ES_single.flag') ~= -2
                        y_ES_threshold = y_ES;
                        y_ES_threshold(abs(y_ES_threshold(:)) <= zef.ES_current_threshold.*max(abs(y_ES_threshold(:)))) = 0;
                        
                        zef.ES_active_electrodes = find(abs(y_ES_threshold));
                        [y_ES_threshold, volumetric_current_density_threshold, residual_threshold, flag_threshold, source_position_index, source_directions] = zef_ES_optimize_current(TolFun(i), reg_param(j));
                        
                        zef.y_ES_single_threshold.y_ES                          = y_ES_threshold;
                        zef.y_ES_single_threshold.volumetric_current_density    = volumetric_current_density_threshold;
                        zef.y_ES_single_threshold.residual                      = residual_threshold;
                        zef.y_ES_single_threshold.flag                          = flag_threshold;
                        zef.y_ES_single_threshold.optimizer_tolerance           = TolFun;
                        zef.y_ES_single_threshold.reg_param                     = reg_param;
                        for running_index = 1:length(source_position_index)
                            vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                            vec_2 = (volumetric_current_density_threshold(:,source_position_index(running_index)).^2);
                            zef.y_ES_single_threshold.field_source(running_index).field_source =         (volumetric_current_density_threshold(:,source_position_index(running_index)).^2);
                            zef.y_ES_single_threshold.field_source(running_index).magnitude    = sqrt(sum(volumetric_current_density_threshold(:,source_position_index(running_index)).^2));
                            zef.y_ES_single_threshold.field_source(running_index).angle        = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                            zef.y_ES_single_threshold.field_source(running_index).relative     = norm(vec_2)/norm(vec_1');
                            zef.y_ES_single_threshold.field_source(running_index).error_norm   = norm(vec_1'-vec_2);
                        end
                        zef.y_ES_single_threshold.threshold_value               = zef.ES_current_threshold;
                        zef.y_ES_single_threshold.elapsed_time                  = toc;
                    else
                        zef.y_ES_single_threshold.y_ES                          = 0;
                        zef.y_ES_single_threshold.volumetric_current_density    = volumetric_current_density_threshold;
                        zef.y_ES_single_threshold.residual                      = 0;
                        zef.y_ES_single_threshold.flag                          = -2;
                        zef.y_ES_single_threshold.optimizer_tolerance           = TolFun;
                        zef.y_ES_single_threshold.reg_param                     = reg_param;
                        for running_index = 1:length(source_position_index)
                            zef.y_ES_single_threshold.field_source(running_index).field_source = 0;
                            zef.y_ES_single_threshold.field_source(running_index).magnitude = 0;
                            zef.y_ES_single_threshold.field_source(running_index).angle = 0;
                            zef.y_ES_single_threshold.field_source(running_index).relative = 0;
                            zef.y_ES_single_threshold.field_source(running_index).error_norm = 0;
                        end
                        zef.y_ES_single_threshold.threshold_value               = zef.ES_current_threshold;
                        zef.y_ES_single_threshold.elapsed_time                  = toc;
                    end
                end
                
            elseif evalin('base','zef.ES_search_type') >= 2
                zef.y_ES_interval.y_ES{i,j}                         = y_ES;
                zef.y_ES_interval.volumetric_current_density{i,j}   = volumetric_current_density;
                zef.y_ES_interval.residual{i,j}                     = residual;
                zef.y_ES_interval.flag{i,j}                         = flag;
                zef.y_ES_interval.optimizer_tolerance{i,j}          = TolFun;
                zef.y_ES_interval.reg_param{i,j}                    = reg_param;
                for running_index = 1:length(source_position_index)
                    vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                    vec_2 = (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_interval.field_source(running_index).field_source{i,j} =         (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_interval.field_source(running_index).magnitude{i,j}    = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
                    zef.y_ES_interval.field_source(running_index).angle{i,j}        = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                    zef.y_ES_interval.field_source(running_index).relative{i,j}     = norm(vec_2)/norm(vec_1');
                    zef.y_ES_interval.field_source(running_index).error_norm{i,j}   = norm(vec_1'-vec_2);
                end
                zef.y_ES_interval.elapsed_time{i,j}                 = toc;
                
                % y_ES_interval Threshold
                if evalin('base','zef.ES_current_threshold_checkbox')
                    if evalin('base',['zef.y_ES_interval.flag{' num2str(i) ',' num2str(j) '}']) ~= 2
                        y_ES_threshold = y_ES;
                        y_ES_threshold(abs(y_ES_threshold(:)) <= zef.ES_current_threshold.*max(abs(y_ES_threshold(:)))) = 0;
                        zef.ES_active_electrodes = find(abs(y_ES_threshold));
                        
                        [y_ES_threshold, volumetric_current_density_threshold, residual_threshold, flag_threshold, source_position_index, source_directions] = zef_ES_optimize_current(TolFun(i), reg_param(j));
                        
                        zef.y_ES_interval_threshold.y_ES{i,j}                       = y_ES_threshold;
                        zef.y_ES_interval_threshold.optimized_current_density{i,j}  = volumetric_current_density_threshold;
                        zef.y_ES_interval_threshold.residual{i,j}                   = residual_threshold;
                        zef.y_ES_interval_threshold.flag_value{i,j}                 = flag_threshold;
                        zef.y_ES_interval_threshold.optimizer_tolerance{i,j}        = TolFun;
                        zef.y_ES_interval_threshold.reg_param{i,j}                  = reg_param;
                        for running_index = 1 : length(source_position_index)
                            vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                            vec_2 = (volumetric_current_density_threshold(:,source_position_index(running_index)).^2);
                            zef.y_ES_interval.field_source(running_index).field_source{i,j} =         (volumetric_current_density_threshold(:,source_position_index(running_index)).^2);
                            zef.y_ES_interval.field_source(running_index).magnitude{i,j}    = sqrt(sum(volumetric_current_density_threshold(:,source_position_index(running_index)).^2));
                            zef.y_ES_interval.field_source(running_index).angle{i,j}        = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                            zef.y_ES_interval.field_source(running_index).relative{i,j}     = norm(vec_2)/norm(vec_1');
                            zef.y_ES_interval.field_source(running_index).error_norm{i,j}   = norm(vec_1'-vec_2);
                        end
                        zef.y_ES_interval_threshold.elapsed_time{i,j}               = toc;
                    else
                        zef.y_ES_interval_threshold.y_ES{i,j}                       = 0;
                        zef.y_ES_interval_threshold.optimized_current_density{i,j}  = volumetric_current_density_threshold;
                        zef.y_ES_interval_threshold.residual{i,j}                   = 0;
                        zef.y_ES_interval_threshold.flag_value{i,j}                 = -2;
                        zef.y_ES_interval_threshold.optimizer_tolerance{i,j}        = TolFun;
                        zef.y_ES_interval_threshold.reg_param{i,j}                  = reg_param;
                        for running_index = 1 : length(source_position_index)
                            zef.y_ES_interval.field_source(running_index).field_source{i,j} = 0;
                            zef.y_ES_interval.field_source(running_index).magnitude{i,j}    = 0;
                            zef.y_ES_interval.field_source(running_index).angle{i,j}        = 0;
                            zef.y_ES_interval.field_source(running_index).relative{i,j}     = 0;
                            zef.y_ES_interval.field_source(running_index).error_norm{i,j}   = 0;
                        end
                        zef.y_ES_interval_threshold.elapsed_time{i,j}               = toc;
                    end
                end
            end
            %% Update waitbar
            waitbar_ind = waitbar_ind + 1/(length(reg_param)*length(TolFun));
        end
    end
    total_time = sum(cell2mat(zef.y_ES_interval.elapsed_time));
    %% Wrapping up and clear of temp. values
    delete(wait_bar_temp)
    clear i j TolFun reg_param
    clear y_ES* volumetric_current_density* residual* flag*
    clear wait* vec* running_index source*
catch ME
    delete(wait_bar_temp)
    clear i j TolFun reg_param
    clear y_ES* volumetric_current_density* residual* flag*
    clear wait* vec* running_index source*
    rethrow(ME)
end