function [TolFun, reg_param, kval] = zef_ES_find_parameters
TolFun        = evalin('base','zef.ES_optimizer_tolerance');
reg_param     = evalin('base','zef.ES_regularization_parameter');
kval          = evalin('base','zef.ES_L2_reg_ratio_LL');

if (1E-10 > TolFun) || (TolFun > 1E-1)
    TolFun = 0.1;
    warning('Optimizer tolerance has been set to 0.1 to meet LinProg requirements.');
end

if evalin('base','zef.ES_search_type') == 2 && evalin('base','zef.ES_search_method') ~= 3
    tol_max       = evalin('base','zef.ES_optimizer_tolerance_max');
    reg_param_max = evalin('base','zef.ES_regularization_parameter_max');
    kval_max          = evalin('base','zef.ES_L2_reg_ratio_UL');
    
    % Ensure tol_max meet function criteria
    if tol_max < 1E-10
        tol_max = 1E-10;
        warning('Maxima optimizer tolerance value exceeding solver limit.');
    end
    
    % Lattice

        step_size = evalin('base','zef.ES_step_size');
        TolFun    = exp(log(TolFun):(log(tol_max)-log(TolFun))/(step_size-1):log(tol_max))';
        if reg_param == 0
            reg_param = 1;
        end
        reg_param = exp(log(reg_param):(log(reg_param_max)-log(reg_param))/(step_size-1):log(reg_param_max))';
        kval = exp(log(kval):(log(kval_max)-log(kval))/(step_size-1):log(kval_max))'; % k-values
 
else
    reg_param = 0;
end