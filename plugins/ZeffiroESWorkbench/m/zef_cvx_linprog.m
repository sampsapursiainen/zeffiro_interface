function [x, flag_val] = zef_cvx_linprog(z,L,b,varargin)

opts = [];

if not(isempty(varargin))
        opts = varargin{1};
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
cvx_end


if isequal(cvx_status,'Solved')
    flag_val = 1; 
end
end