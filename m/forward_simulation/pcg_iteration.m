%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [x,conv_val,n_iter] = pcg_iteration(A,b,tol_val,max_it,M,x)

if nargin < 5 
    M = [];
end

if nargin < 6
    x = zeros(size(A,1),1);
end

if isequal(class(A),'function_handle')
    r = - ( -b + A(x) );
else
r = - ( -b + A*x );
end
    if isequal(class(M),'function_handle')
    z = M(r);
    elseif isempty(M)
    z = r;
    else
    z = M\r;
    end
    p = z;
    j = 1;

conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));

while (conv_val > tol_val) & (j < max_it)
    if isequal(class(A),'function_handle')
    aux_vec = A(p);
    else
aux_vec = A*p;
    end
    alpha = sum(z.*r)./sum(p.*aux_vec);
    x = x + alpha(ones(size(p,1),1),:).*p;
    rnew = r - alpha(ones(size(p,1),1),:).*aux_vec;
   if isequal(class(M),'function_handle')
   znew = M(rnew);
   elseif isempty(M)
       znew = rnew;
    else
    znew = M\rnew;
   end
    beta = sum(znew.*rnew)./sum(z.*r);
    p = znew + beta(ones(size(p,1),1),:).*p;
    r = rnew;
    z = znew;
    j = j + 1;
    conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));
end

n_iter = j;

return
