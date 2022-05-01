function [alpha, beta, kval] = zef_ES_find_parameters
alpha       = evalin('base','zef.ES_alpha');
beta        = evalin('base','zef.ES_beta');
kval        = evalin('base','zef.ES_kval');

step_size   = evalin('base','zef.ES_step_size');

if evalin('base','zef.ES_search_type') == 2
    alpha_max   = evalin('base','zef.ES_alpha_max');
    beta_min    = evalin('base','zef.ES_beta_min');
    kval_max    = evalin('base','zef.ES_kval_max');
       
    if alpha == 0
        alpha = 1;
    end
    alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
    
    if beta_min < 1E-10
        beta_min = 1E-10;
        warning('Minimum beta value exceeding allowed lower limit.');
    end
    beta  = exp(log(beta):(log(beta_min)-log(beta))/(step_size-1):log(beta_min))';
    
    kval  = exp(log(kval_max):(log(kval)-log(kval_max))/(step_size-1):log(kval))';
end