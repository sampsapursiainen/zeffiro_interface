function [y_cvx, flag_val] = zef_cvx_ls(A_cvx, b_cvx)
n = size(A_cvx,2); %#ok<NASGU>

try
    cvx_solver('sdpt3')
end

cvx_begin quiet
variable y_cvx(n)
minimize( norm(A_cvx * y_cvx - b_cvx,2) )
A_cvx * y_cvx - b_cvx <= 0; %#ok<VUNUS>
cvx_end

if isequal(cvx_status,'Solved')
    flag_val = 1;
else
    flag_val = -2;
end