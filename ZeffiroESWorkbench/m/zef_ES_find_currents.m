zef.h_temp = waitbar(0,'Optimizing ES currents');

if evalin('base','zef.ES_search_type') ~= 1
    [TolFun, reg_param] = zef_ES_find_parameters;
    zef.y_ES_interval = [];
    if evalin('base','zef.ES_current_threshold_checkbox') == 1
        zef.y_ES_interval_threshold = [];
    end
else
    TolFun    = evalin('base','zef.ES_optimizer_tolerance');
    reg_param = evalin('base','zef.ES_regularization_parameter');
end

for i = 1:length(TolFun)
    for j = 1:length(reg_param)

        zef.ES_active_electrodes = [];
        [zef.y_ES, zef.ES_volumetric_current_density, zef.residual_ES, zef.flag_ES] = zef_ES_optimize_current(TolFun(i), reg_param(j));

        if evalin('base','zef.ES_current_threshold_checkbox') == 1
            if zef.ES_current_threshold > 0
                if zef.flag_ES ~= -2
                    waitbar(0.5,zef.h_temp,'Optimizing Thresholded ES currents');
                    zef.y_ES_threshold = zef.y_ES;
                    zef.y_ES_threshold(abs(zef.y_ES_threshold(:)) <= zef.ES_current_threshold.*max(abs(zef.y_ES_threshold(:)))) = 0;
                    zef.ES_active_electrodes = find(abs(zef.y_ES_threshold));
                    [zef.y_ES_threshold, zef.ES_volumetric_current_density_threshold,zef.residual_ES_threshold, zef.flag_ES_threshold] = zef_ES_optimize_current(TolFun(i), reg_param(j));
                else
                    fprintf(['Error: No feasible solution were found in the initial calculations','\n']);
                end
            else
                fprintf(['Error: Invalid threshold value inserted','\n']);
            end
        end
        if evalin('base','zef.ES_search_type') ~= 1
            zef.y_ES_interval.y_ES{i,j} = zef.y_ES;
            zef.y_ES_interval.ES_optimized_current_density{i,j} = zef.ES_volumetric_current_density;
            zef.y_ES_interval.residual{i,j} = zef.residual_ES;
            zef.y_ES_interval.flag_value{i,j} = zef.flag_ES;
            zef.y_ES_interval.optimizer_tolerance_range = TolFun;
            zef.y_ES_interval.reg_param_range = reg_param;
            if evalin('base','zef.ES_current_threshold_checkbox') == 1
                zef.y_ES_interval_threshold.y_ES{i,j} = zef.y_ES_threshold;
                zef.y_ES_interval_threshold.ES_optimized_current_density{i,j} = zef.ES_volumetric_current_density_threshold;
                zef.y_ES_interval_threshold.residual{i,j} = zef.residual_ES_threshold;
                zef.y_ES_interval_threshold.flag_value{i,j} = zef.flag_ES_threshold;
                zef.y_ES_interval.optimizer_tolerance_range = TolFun;
                zef.y_ES_interval.reg_param_range = reg_param;
            end
        end
    end
end

clear i j TolFun reg_param
waitbar(1,zef.h_temp,'Optimizing ES currents');
close(zef.h_temp)