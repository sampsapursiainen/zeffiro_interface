function [alpha, beta] = zef_ES_find_parameters(varargin)

switch nargin
    case {0, 1}
        if nargin == 0
            zef = evalin('base','zef');
            warning('ZI: no input argument.')
        else
            zef = varargin{1};
        end
        alpha       = zef.ES_alpha;
        alpha_max   = zef.ES_alpha_max;
        beta_min    = zef.ES_beta_min;
        beta        = zef.ES_beta;
        step_size   = zef.ES_step_size;
    case {3}
        [aux1, aux2, step_size] = deal(varargin{1}, varargin{2}, varargin{3});
        alpha       = aux1(1);
        alpha_max   = aux1(end);
        beta        = aux2(1);
        beta_min    = aux2(end);
    case {5}
        [alpha, alpha_max, beta, beta_min, step_size] = deal(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5});
    otherwise
        error('ZI: Insufficient number of arguments');
end

if alpha == 0
    alpha = 1;
end

alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
beta  = exp(log(beta):(log(beta_min)-log(beta))/(step_size-1):log(beta_min))';
end