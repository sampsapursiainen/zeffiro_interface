function [x, function_val, flag_val] = zef_cvx_linprog(z,A,b,Aeq,beq,lb,ub,varargin)
%Finds the minimum of z'*x with respect to x and with the constraint A x  - b <= 0
%Outputs: x (size: [n x 1]), flag_val (1 if the solution was found -2
%otherwise)
%Arguments: z (size: [n x 1]), A (size: [m x n]), b
%(size: [m x 1])
%Variable argument list: max_1_norm (size: [1 x 1], maximum 1-norm for x), max_infty_norm (size: [1 x 1], maximum infinity norm for x) 




opts = [];
solver_package = 'sdpt3';

max_1_norm = []; %#ok<*NASGU>
max_infty_norm = [];
function_val = [];

if not(isempty(varargin))
        opts = varargin{1};
end

flag_val = -2;
n = size(A,2);

if isfield(opts,'solver')
    solver_package = opts.solver;
end

try
cvx_solver(solver_package)
end

if isfield(opts,'TolFun')
    cvx_precision(opts.TolFun)
end

if isequal(opts.Display,'off')
cvx_begin quiet
variable x(n)
minimize sum(z.*x)
subject to: 
A*x - b <= 0; %#ok<*VUNUS>
if not(isempty(lb))
x >= lb;
end
if not(isempty(ub))
x <= ub;
end
if not(isempty(Aeq))
Aeq*x == beq;
end
cvx_end
else
   cvx_begin 
variable x(n)
minimize sum(z.*x)
subject to: 
A*x - b <= 0; %#ok<*VUNUS>
if not(isempty(lb))
x >= lb;
end
if not(isempty(ub))
x <= ub;
end
if not(isempty(Aeq))
Aeq*x == beq;
end
cvx_end 
end

if isequal(cvx_status,'Solved')
    flag_val = 1; 
    function_val = norm(A*x-b,1);
    
end
end
