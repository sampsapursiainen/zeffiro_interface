function [alpha, beta] = zef_ES_find_parameters
alpha       = evalin('base','zef.ES_alpha');
beta        = evalin('base','zef.ES_beta');


step_size   = evalin('base','zef.ES_step_size');

%if evalin('base','zef.ES_search_type') == 2
    alpha_max   = evalin('base','zef.ES_alpha_max');
    beta_min    = evalin('base','zef.ES_beta_min');
       
    if alpha == 0
        alpha = 1;
    end
    alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
    beta  = exp(log(beta):(log(beta_min)-log(beta))/(step_size-1):log(beta_min))';
end