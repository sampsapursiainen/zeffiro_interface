function [TolFun, reg_param] = zef_ES_find_parameters

clear Tol Fun reg_param
tol_min   = evalin('base','zef.ES_optimizer_tolerance');
tol_max   = evalin('base','zef.ES_optimizer_tolerance_max');
reg_param_min = evalin('base','zef.ES_regularization_parameter');
reg_param_max = evalin('base','zef.ES_regularization_parameter_max');

if isinf(log10(reg_param_min))
    reg_param_min = 1;
end

if tol_min == 0
    tol_min = 1E-1;
    zef.h_ES_optimizer_tolerance.Value = num2str(1E-1);
end

idx = log10(reg_param_min):log10(reg_param_max);
reg_param = [power(10,idx)]';
if reg_param(1) == 1
   reg_param(1) = 0;
end

idx = abs(log10(tol_min)):abs(log10(tol_max));
TolFun = [power(10,-(idx))]';

end