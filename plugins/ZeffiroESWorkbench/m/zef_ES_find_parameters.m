function [TolFun, reg_param] = zef_ES_find_parameters
TolFun        = evalin('base','zef.ES_optimizer_tolerance');
reg_param     = evalin('base','zef.ES_regularization_parameter');

if (1E-10 > TolFun) || (TolFun > 1E-1)
    TolFun = 0.1;
    warning('Optimizer tolerance has been set to 0.1 to meet LinProg.');
end

if evalin('base','zef.ES_search_type') ~= 1
    tol_max       = evalin('base','zef.ES_optimizer_tolerance_max');
    reg_param_max = evalin('base','zef.ES_regularization_parameter_max');
    
    % Ensure tol_max meet function criteria
    if tol_max < 1E-10
        tol_max = 1E-10;
        warning('Maxima optimizer tolerance value exceeding solver limit.');
    end
    
    % Power 10
    if evalin('base','zef.ES_search_method') == 1
        if isinf(log10(reg_param))
            reg_param = 1;
            warning('Initial regularization parameter set as Zero when using search method: Power 10. Intial value is calculated using 1.');
        end
        if isinf(log10(reg_param_max))
            reg_param_max = 1;
        end
            
        idx = log10(reg_param):log10(reg_param_max);
        reg_param = power(10, idx)';
        if reg_param(1) == 0
            reg_param(1) = 1;
        end
        idx = abs(log10(TolFun)):abs(log10(tol_max));
        TolFun    = power(10,-(idx))';
        % Lattice
    elseif evalin('base','zef.ES_search_method') == 2
        step_size = evalin('base','zef.ES_step_size');
        TolFun    = exp(log(TolFun):(log(tol_max)-log(TolFun))/(step_size-1):log(tol_max))';
        TolFun    = min(TolFun,evalin('base','zef.ES_optimizer_tolerance'));
        TolFun    = max(TolFun,evalin('base','zef.ES_optimizer_tolerance_max'));
        if reg_param == 0
            reg_param = 1;
        end
        reg_param = exp(log(reg_param):(log(reg_param_max)-log(reg_param))/(step_size-1):log(reg_param_max))';
    end
end