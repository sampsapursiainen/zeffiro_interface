%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [x,conv_val,n_iter] = pcg_iteration_gpu(A,b,tol_val,max_it,M,x,gpu_extended_memory);
 
if nargin < 5 
    M = [];
end

if nargin < 6
    x = zeros(size(A,1),1);
end

if nargin < 7
    gpu_extended_memory = 3;
end

if not(isequal(class(A),'function_handle'))
A = gpuArray(A);
end
b = gpuArray(double(b));
x = gpuArray(double(x));

if isequal(class(M),'function_handle')
M = gpuArray(M);
end


if isequal(class(A),'function_handle')
    r = - ( -b + A(x));
else
r = - ( -b + A*x );
end
    if isequal(class(M),'function_handle')
    z = M(r);
    elseif isempty(M)
        z = r;
    else
    z = M.*r;
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
    x = x + alpha.*p;
    rnew = r - alpha.*aux_vec;
    if isequal(class(M),'function_handle')
   znew = M(rnew);
   elseif isempty(M)
       znew = rnew;
    else
    znew = M.*rnew;
   end
    beta = sum(znew.*rnew)./sum(z.*r);
    p = znew + beta.*p;
    r = rnew;
    z = znew;
    j = j + 1;
    conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));
end

n_iter = j;

if ismember(gpu_extended_memory,[0 2])
x = gather(x);
end

return
