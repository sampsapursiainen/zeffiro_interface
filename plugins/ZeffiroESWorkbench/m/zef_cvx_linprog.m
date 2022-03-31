function [x, flag_val] = zef_cvx_linprog(z,L,b,varargin)

opts = [];

max_1_norm = [];
max_infty_norm = [];

if not(isempty(varargin))
    max_1_norm = varargin{1};
    if length(varargin) > 1
        max_infty_norm = varargin{2};
    end
    if length(varargin) > 2
        opts = varargin{3};
    end
end

flag_val = -2;
n = size(L,2);

try
cvx_solver('sdpt3')
end
if isfield(opts,'TolVal')
    cvx_precision(opts.TolVal)
end

cvx_begin quiet
variable x(n)
minimize(sum(z.*x))
subject to: 
L*x - b <= 0;
if not(isempty(max_1_norm))
sum(abs(x)) <= max_1_norm;
end
if not(isempty(max_infty_norm))
max(abs(x)) <= max_infty_norm;
end
cvx_end


if isequal(cvx_status,'Solved')
    flag_val = 1; 
end
end