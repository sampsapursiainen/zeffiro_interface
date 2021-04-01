wait_bar_temp = waitbar(0,sprintf('Optimizing ES currents: i = %d, j = d%',0,0), ...
    'Name','ZEFFIRO Interface: ES Optimization...', ...
    'CreateCancelbtn','setappdata(gcbf,''canceling'',1)', ...
    'Visible','on');

% if doing an interval-based search, clear cells
if evalin('base','zef.ES_search_type') ~= 1
    zef.y_ES_interval = [];
    if evalin('base','zef.ES_current_threshold_checkbox') == 1
        zef.y_ES_interval_threshold = [];
    end
end

% Validate the Threshold value (must be a positive value)
if zef.ES_current_threshold < 0
    zef.ES_current_threshold_checkbox = 0;
    warning('Error: Invalid threshold value inserted.'); beep;
end

[TolFun, reg_param] = zef_ES_find_parameters;
waitbar_ind = 1/(length(reg_param)*length(TolFun));

for i = 1:length(TolFun)
    for j = 1:length(reg_param)
        
        % Check for Cancel button
        if getappdata(wait_bar_temp,'canceling')
            break
        end
        waitbar(waitbar_ind, wait_bar_temp, sprintf('Optimizing ES currents: \n Opt.Tol = %d -- Reg.Param = %d', TolFun(i), reg_param(j)));
        
        % Active electrodes
        zef.ES_active_electrodes = [];
        
        % Solver calculation
        [y_ES, volumetric_current_density, residual, flag] = zef_ES_optimize_current(TolFun(i), reg_param(j));
        
        % Allocation of results
        if evalin('base','zef.ES_search_type') == 1
            zef.y_ES_single.y_ES = y_ES;
            zef.y_ES_single.volumetric_current_density = volumetric_current_density;
            zef.y_ES_single.residual = residual;
            zef.y_ES_single.flag = flag;
            zef.y_ES_single.optimizer_tolerance = TolFun;
            zef.y_ES_single.reg_param = reg_param;
            if evalin('base','zef.ES_current_threshold_checkbox')
                if evalin('base','zef.y_ES_single.flag') ~= -2
                    % Solver calculation with threshold
                    y_ES_threshold = y_ES;
                    y_ES_threshold(abs(y_ES_threshold(:)) <= zef.ES_current_threshold.*max(abs(y_ES_threshold(:)))) = 0;
                    zef.ES_active_electrodes = find(abs(y_ES_threshold));
                    [y_ES_threshold, volumetric_current_density_threshold, residual_threshold, flag_threshold] = zef_ES_optimize_current(TolFun(i), reg_param(j));
                    
                    zef.y_ES_single_threshold.y_ES = y_ES_threshold;
                    zef.y_ES_single_threshold.volumetric_current_density = volumetric_current_density_threshold;
                    zef.y_ES_single_threshold.residual = residual_threshold;
                    zef.y_ES_single_threshold.flag = flag_threshold;
                    zef.y_ES_single_threshold.optimizer_tolerance = TolFun;
                    zef.y_ES_single_threshold.reg_param = reg_param;
                    zef.y_ES_single_threshold.threshold_value = zef.ES_current_threshold;
                else
                    zef.y_ES_single_threshold.y_ES = 0;
                    zef.y_ES_single_threshold.volumetric_current_density = volumetric_current_density_threshold;
                    zef.y_ES_single_threshold.residual = 0;
                    zef.y_ES_single_threshold.flag = -2;
                    zef.y_ES_single_threshold.optimizer_tolerance = TolFun;
                    zef.y_ES_single_threshold.reg_param = reg_param;
                    zef.y_ES_single_threshold.threshold_value = zef.ES_current_threshold;
                end
            end
        else
            zef.y_ES_interval.y_ES{i,j} = y_ES;
            zef.y_ES_interval.volumetric_current_density{i,j} = volumetric_current_density;
            zef.y_ES_interval.residual{i,j} = residual;
            zef.y_ES_interval.flag{i,j} = flag;
            if evalin('base','zef.ES_current_threshold_checkbox')
                if evalin('base',['zef.y_ES_interval.flag{' num2str(i) ',' num2str(j) '}']) ~= 2
                    % Solver calculation with threshold
                    y_ES_threshold = y_ES;
                    y_ES_threshold(abs(y_ES_threshold(:)) <= zef.ES_current_threshold.*max(abs(y_ES_threshold(:)))) = 0;
                    zef.ES_active_electrodes = find(abs(y_ES_threshold));
                    [y_ES_threshold, volumetric_current_density_threshold, residual_threshold, flag_threshold] = zef_ES_optimize_current(TolFun(i), reg_param(j));
                    
                    zef.y_ES_interval_threshold.y_ES{i,j} = y_ES_threshold;
                    zef.y_ES_interval_threshold.optimized_current_density{i,j} = volumetric_current_density_threshold;
                    zef.y_ES_interval_threshold.residual{i,j} = residual_threshold;
                    zef.y_ES_interval_threshold.flag_value{i,j} = flag_threshold;

                    zef.y_ES_interval_threshold.threshold_value = zef.ES_current_threshold;
                else
                    zef.y_ES_interval_threshold.y_ES{i,j} = 0;
                    zef.y_ES_interval_threshold.optimized_current_density{i,j} = volumetric_current_density_threshold;
                    zef.y_ES_interval_threshold.residual{i,j} = 0;
                    zef.y_ES_interval_threshold.flag_value{i,j} = -2;
                end
            end
        end
        
        % Update waitbar
        waitbar_ind = waitbar_ind + 1/(length(reg_param)*length(TolFun));
    end
end
if exist('zef','var') && isfield(zef,'y_ES_interval')
    zef.y_ES_interval.optimizer_tolerance = TolFun;
    zef.y_ES_interval.reg_param = reg_param;
    if evalin('base','zef.ES_current_threshold_checkbox')
        zef.y_ES_interval_threshold.optimizer_tolerance = TolFun;
        zef.y_ES_interval_threshold.reg_param = reg_param;
        zef.y_ES_interval_threshold.threshold_value = zef.ES_current_threshold;
    end
end
delete(wait_bar_temp)
clear i j TolFun reg_param waitbar_ind y_ES volumetric_current_density residual flag y_ES_threshold volumetric_current_density_threshold residual_threshold flag_threshold wait_bar_temp