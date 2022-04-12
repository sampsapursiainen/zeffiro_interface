switch evalin('base','zef.ES_search_method')
    case {1,2}
        if isempty(evalin('base','zef.source_positions'))
            error('--ZI: No discretized sources found. Perhaps you forgot to calculate or load them...?')
        end
        
        [alpha, beta, k_val] = zef_ES_find_parameters;
        if     evalin('base','zef.ES_search_method') == 1
            val_aux = beta;
        elseif evalin('base','zef.ES_search_method') == 2
            val_aux = k_val;
        end
        
        switch evalin('base','zef.ES_search_type')
            case 1
                tic;
                [y_ES, volumetric_current_density, residual, flag, source_magnitude, source_position_index, source_directions] = zef_ES_optimize_current(alpha, val_aux);
                zef.y_ES_single.elapsed_time                        = toc;
                zef.y_ES_single.y_ES                                = y_ES;
                zef.y_ES_single.volumetric_current_density          = volumetric_current_density;
                zef.y_ES_single.residual                            = residual;
                zef.y_ES_single.flag                                = flag;
                zef.y_ES_single.source_magnitude                    = source_magnitude;
                for running_index = 1:length(source_position_index)
                    vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                    vec_2 = (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_single.field_source(running_index).field_source   =         (volumetric_current_density(:,source_position_index(running_index)).^2);
                    zef.y_ES_single.field_source(running_index).magnitude      = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
                    zef.y_ES_single.field_source(running_index).angle          = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                    zef.y_ES_single.field_source(running_index).relative_norm  = abs(1 - norm(vec_2)/norm(vec_1'));
                    zef.y_ES_single.field_source(running_index).relative_error = norm(vec_1'-vec_2)./norm(vec_1');
                end
                zef.y_ES_single.optimizer_tolerance     = beta;
                zef.y_ES_single.alpha                   = alpha;
            case 2
                %% Waitbar
                if exist('wait_bar_temp','var') == 1
                    delete(wait_bar_temp)
                end
                wait_bar_temp = waitbar(0,sprintf('Optimizing: i = %d, j = d%',0,0), ...
                    'Name','ZEFFIRO Interface: ES Optimization...', ...
                    'CreateCancelbtn','setappdata(gcbf,''canceling'',1)', ...
                    'Visible','on');
                
                waitbar_ind = 1/(length(alpha)*length(val_aux));
                %% The real task...
                lattice_size = evalin('base','zef.ES_step_size');
                zef.y_ES_interval = [];
                
                for i = 1:lattice_size
                    for j = 1:lattice_size
                        if getappdata(wait_bar_temp,'canceling')
                            error('The calculations were interrupted by the user.')
                        end
                        waitbar(waitbar_ind, wait_bar_temp, sprintf('Optimizing: \n %1.2e -- %1.2e', val_aux(i), alpha(j)));
                        
                        tic;
                        [y_ES, volumetric_current_density, residual, flag, source_magnitude, source_position_index, source_directions] = zef_ES_optimize_current(alpha(j), val_aux(i));
                        zef.y_ES_interval.elapsed_time{i,j}                 = toc;
                        
                        zef.y_ES_interval.y_ES{i,j}                         = y_ES;
                        zef.y_ES_interval.volumetric_current_density{i,j}   = volumetric_current_density;
                        zef.y_ES_interval.residual{i,j}                     = residual;
                        zef.y_ES_interval.flag{i,j}                         = flag;
                        zef.y_ES_interval.source_magnitude{i,j}             = source_magnitude;
                        for running_index = 1:length(source_position_index)
                            vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                            vec_2 = volumetric_current_density(:,source_position_index(running_index));
                            vec_index = setdiff(1:length(volumetric_current_density), source_position_index(running_index));
                            zef.y_ES_interval.field_source(running_index).field_source{i,j}         =         (volumetric_current_density(:,source_position_index(running_index)));
                            zef.y_ES_interval.field_source(running_index).magnitude{i,j}            = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
                            zef.y_ES_interval.field_source(running_index).angle{i,j}                = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                            zef.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = abs(1 - norm(vec_2)/norm(vec_1'));
                            zef.y_ES_interval.field_source(running_index).relative_error{i,j}       = norm(vec_1'-vec_2)./norm(vec_1');
                            zef.y_ES_interval.field_source(running_index).avg_off_field{i,j}        = mean(sqrt(sum(volumetric_current_density(:, vec_index).^2)));
                        end
                        waitbar_ind = waitbar_ind + 1/(length(alpha)*length(val_aux));
                    end
                end
                
                zef.y_ES_interval.reg_param                          = alpha;
                if     evalin('base','zef.ES_search_method') == 1
                    zef.y_ES_interval.optimizer_tolerance            = beta;
                elseif evalin('base','zef.ES_search_method') == 2
                    zef.y_ES_interval.k_val                          = k_val;
                end
        end
    case 3
        [y_ES, volumetric_current_density, residual, flag, source_magnitude, source_position_index, source_directions] = zef_ES_optimize_current;
        
        zef.y_ES_4x1.y_ES                                = y_ES;
        zef.y_ES_4x1.volumetric_current_density          = volumetric_current_density;
        zef.y_ES_4x1.residual                            = residual;
        zef.y_ES_4x1.flag                                = flag;
        zef.y_ES_4x1.source_magnitude                    = source_magnitude;
        for running_index = 1:length(source_position_index)
            vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
            vec_2 = (volumetric_current_density(:,source_position_index(running_index)).^2);
            zef.y_ES_4x1.field_source(running_index).field_source   =         (volumetric_current_density(:,source_position_index(running_index)).^2);
            zef.y_ES_4x1.field_source(running_index).magnitude      = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
            zef.y_ES_4x1.field_source(running_index).angle          = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
            zef.y_ES_4x1.field_source(running_index).relative_norm  = abs(1 - norm(vec_2)/norm(vec_1'));
            zef.y_ES_4x1.field_source(running_index).relative_error = norm(vec_1'-vec_2)./norm(vec_1');
        end
        zef.y_ES_4x1.separation_angle                    = evalin('base','zef.ES_separation_angle');
end
if exist('wait_bar_temp') %#ok<EXIST>
    delete(wait_bar_temp)
end