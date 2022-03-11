function [TolFun, reg_param, k_val] = zef_ES_find_parameters
TolFun     = evalin('base','zef.ES_optimizer_tolerance');
reg_param  = evalin('base','zef.ES_regularization_parameter');
k_val      = evalin('base','zef.ES_L2_reg_ratio_LL');
step_size  = evalin('base','zef.ES_step_size');

if evalin('base','zef.ES_search_type') == 2
    tol_max       = evalin('base','zef.ES_optimizer_tolerance_max');
    reg_param_max = evalin('base','zef.ES_regularization_parameter_max');
    kval_max      = evalin('base','zef.ES_L2_reg_ratio_UL');

    if tol_max < 1E-10
        tol_max = 1E-10;
        warning('Maxima optimizer tolerance value exceeding solver limit.');
    end

    TolFun    = exp(log(TolFun):(log(tol_max)-log(TolFun))/(step_size-1):log(tol_max))';
    if reg_param == 0
        reg_param = 1;
    end
    reg_param = exp(log(reg_param):(log(reg_param_max)-log(reg_param))/(step_size-1):log(reg_param_max))';
    k_val = exp(log(k_val):(log(kval_max)-log(k_val))/(step_size-1):log(kval_max))'; % k-values

else
    reg_param = 0;
end
