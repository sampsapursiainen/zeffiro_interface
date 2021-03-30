function [TolFun, reg_param] = zef_ES_find_parameters
if evalin('base','zef.ES_search_type') == 1
    TolFun       = evalin('base','zef.ES_optimizer_tolerance');
    reg_param     = evalin('base','zef.ES_regularization_parameter');
else
    TolFun        = evalin('base','zef.ES_optimizer_tolerance');
    tol_max       = evalin('base','zef.ES_optimizer_tolerance_max');
    reg_param     = evalin('base','zef.ES_regularization_parameter');
    reg_param_max = evalin('base','zef.ES_regularization_parameter_max');
    
    % Ensure tol_max meet function criteria
    if tol_max < 1E-10
        tol_max = 1E-1;
        warning('Maxima optimizer tolerance value exceeding solver limit. Value has been calculated using 1E10 instead.');
        beep; pause(0.2);
    end
end
    
% Ensure tol_min meet function criteria
if TolFun <= 0
    TolFun = 1E-1;
    warning('Initial optimizer tolerance value set as Zero. Value has been calculated using 0.1 (1E-1) instead.');
    beep; pause(0.2);
end

% Power 10
if evalin('base','zef.ES_search_method') == 1 && evalin('base','zef.ES_search_type') ~= 1
    tol_min = TolFun;
    if isinf(log10(reg_param))
        reg_param = 1;
        warning('Initial regularization parameter set as Zero when using search method: Power 10. Initial value is calculated as 1 instead.');
        beep; pause(0.2);
    end
    idx = log10(reg_param):log10(reg_param_max);
    reg_param = power(10, idx)';
    idx = abs(log10(tol_min)):abs(log10(tol_max));
    TolFun    = power(10,-(idx))';
    clear idx

% Lattice
elseif evalin('base','zef.ES_search_method') == 2 && evalin('base','zef.ES_search_type') ~= 1
    step_size = evalin('base','zef.ES_step_size');
    TolFun    = exp(log(tol_min):(log(tol_max)-log(tol_min))/(step_size-1):log(tol_max))';
    TolFun    = min(TolFun,evalin('base','zef.ES_optimizer_tolerance'));
    TolFun    = max(TolFun,evalin('base','zef.ES_optimizer_tolerance_max'));
    reg_param = exp(log(reg_param):(log(reg_param_max)-log(reg_param))/(step_size-1):log(reg_param_max))';
else

end