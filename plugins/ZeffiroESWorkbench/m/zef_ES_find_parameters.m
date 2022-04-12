function [alpha, beta, k_val] = zef_ES_find_parameters
beta        = evalin('base','zef.ES_beta');
alpha       = evalin('base','zef.ES_alpha');
k_val       = evalin('base','zef.ES_L2_LB');
step_size   = evalin('base','zef.ES_step_size');

if evalin('base','zef.ES_search_type') == 2
    beta_max    = evalin('base','zef.ES_beta_max');
    alpha_max   = evalin('base','zef.ES_alpha_max');
    k_val_max   = evalin('base','zef.ES_L2_UB');
    
    if beta_max < 1E-10
        beta_max = 1E-10;
        warning('Minimum beta value exceeding allowed lower limit.');
    end
    
    beta    = exp(log(beta):(log(beta_max)-log(beta))/(step_size-1):log(beta_max))';
    if alpha == 0
        alpha = 1;
    end
    alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
    k_val = exp(log(k_val):(log(k_val_max)-log(k_val))/(step_size-1):log(k_val_max))';
    
else
    alpha = 0;
end
