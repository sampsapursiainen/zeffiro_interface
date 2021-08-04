%% Try-catch for securing waitbar will be deleted in case of an error
try
    if evalin('base','zef.ES_search_type') == 2
        zef.y_ES_interval = [];
    end
    
    [TolFun, reg_param, kval] = zef_ES_find_parameters;  
    %% LP
    m = evalin('base','zef.ES_search_type');
    lattice_size = evalin('base','zef.ES_step_size');
    switch m
        case 1
            tic;
            [y_ES, volumetric_current_density, residual, flag, source_position_index, source_directions, source_magnitude] = zef_ES_optimize_current(TolFun, reg_param);
            
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
            zef.y_ES_single.optimizer_tolerance                 = TolFun;
            zef.y_ES_single.reg_param                           = reg_param;
            zef.y_ES_single.elapsed_time                        = toc;

            
           
        case 2
            if exist('wait_bar_temp','var') == 1
                delete(wait_bar_temp)
            end
            wait_bar_temp = waitbar(0,sprintf('Optimizing ES currents: i = %d, j = d%',0,0), ...
                'Name','ZEFFIRO Interface: ES Optimization...', ...
                'CreateCancelbtn','setappdata(gcbf,''canceling'',1)', ...
                'Visible','on');
            try
                if isempty(evalin('base','zef.source_positions'))
                    delete(wait_bar_temp)
                    error('No discretized sources found. Perhaps you forgot to calculate them...? or forgot to load a file...?')
                end
            catch
                delete(wait_bar_temp)
                error('zef.source_positions does not exist!')
            end
            waitbar_ind = 1/(length(reg_param)*length(kval));
            
            for i = 1:lattice_size
                for j = 1:lattice_size
                    if getappdata(wait_bar_temp,'canceling')
                        error('The calculations were interrupted by the user.')
                    end
                    
                                        if evalin('base','zef.ES_search_method') == 1
                        param_val_aux = TolFun(i);
                    elseif evalin('base','zef.ES_search_method') == 2
                        param_val_aux = kval(i);
                    end
                    
                    waitbar(waitbar_ind, wait_bar_temp, sprintf('Optimizing ES currents: \n Opt.Tol = %d -- Reg.Param = %d', param_val_aux, reg_param(j)));

                    tic;

                    [y_ES, volumetric_current_density, residual, flag, source_position_index, source_directions, source_magnitude] = zef_ES_optimize_current(param_val_aux, reg_param(j));
                    
                    zef.y_ES_interval.y_ES{i,j}                         = y_ES;
                    zef.y_ES_interval.volumetric_current_density{i,j}   = volumetric_current_density;
                    zef.y_ES_interval.residual{i,j}                     = residual;
                    zef.y_ES_interval.flag{i,j}                         = flag;
                    zef.y_ES_interval.source_magnitude{i,j}             = source_magnitude;
                    for running_index = 1:length(source_position_index)
                        vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                        vec_2 = volumetric_current_density(:,source_position_index(running_index));
                        zef.y_ES_interval.field_source(running_index).field_source{i,j}   =         (volumetric_current_density(:,source_position_index(running_index)));
                        zef.y_ES_interval.field_source(running_index).magnitude{i,j}      = sqrt(sum(volumetric_current_density(:,source_position_index(running_index)).^2));
                        zef.y_ES_interval.field_source(running_index).angle{i,j}          = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                        zef.y_ES_interval.field_source(running_index).relative_norm_error{i,j}  = abs(1 - norm(vec_2)/norm(vec_1'));
                        zef.y_ES_interval.field_source(running_index).relative_error{i,j} = norm(vec_1'-vec_2)./norm(vec_1');
                    end
                    zef.y_ES_interval.elapsed_time{i,j}                 = toc;
                    waitbar_ind = waitbar_ind + 1/(length(reg_param)*length(kval));
                end 
            end
            zef.y_ES_interval.optimizer_tolerance               = kval;
            zef.y_ES_interval.reg_param                         = reg_param;
    end % End switch
      if exist('wait_bar_temp')
delete(wait_bar_temp)
      end
%total_time = sum(cell2mat(zef.y_ES_interval.elapsed_time));
%% Wrapping up and clear of temp. values
clear i j kval reg_param m LP_vec TolFun
clear y_ES* volumetric_current_density* residual* flag*
clear wait* vec* running_index source*
catch ME
    if exist('wait_bar_temp')
   delete(wait_bar_temp)
    end
    clear i j kval reg_param m lattice_size param_val_aux TolFun
    clear y_ES* volumetric_current_density* residual* flag*
    clear wait* vec* running_index source*
    rethrow(ME)
end