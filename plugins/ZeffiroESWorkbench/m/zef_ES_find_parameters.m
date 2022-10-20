function [alpha, beta] = zef_ES_find_parameters(zef)

if nargin == 0
    zef = evalin('base','zef');
end

alpha       = zef.ES_alpha;
beta        = zef.ES_beta;
step_size   = zef.ES_step_size;

alpha_max   = zef.ES_alpha_max;
beta_min    = zef.ES_beta_min;
       
if alpha == 0
    alpha = 1;
end

alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
beta  = exp(log(beta):(log(beta_min)-log(beta))/(step_size-1):log(beta_min))';
end