function [alpha, epsilon] = zef_ES_find_parameters(varargin)

switch nargin
case {0,1,2}
if nargin == 0
zef = evalin('base','zef');
warning('ZI: no input argument.')
else
zef = varargin{1};
end
alpha       = zef.ES_alpha;
alpha_max   = zef.ES_alpha_max;
epsilon_min    = zef.ES_epsilon_min;
epsilon        = zef.ES_epsilon;
if nargin < 2
step_size   = zef.ES_step_size;
else
step_size = varargin{2};
end        
case {3}
[aux1, aux2, step_size] = deal(varargin{1}, varargin{2}, varargin{3});
alpha       = aux1(1);
alpha_max   = aux1(end);
epsilon        = aux2(1);
epsilon_min    = aux2(end);
case {5}
[alpha, alpha_max, epsilon_min, epsilon, step_size] = deal(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5});
otherwise
error('ZI: Insufficient number of arguments');
end

%%
if alpha == 0
    alpha = 1;
end

if epsilon == 0
    epsilon = 1;
end

if alpha ~= alpha_max
    alpha = exp(log(alpha):(log(alpha_max)-log(alpha))/(step_size-1):log(alpha_max))';
end

if epsilon ~= epsilon_min
    epsilon  = exp(log(epsilon):(log(epsilon_min)-log(epsilon))/(step_size-1):log(epsilon_min))';
end

end