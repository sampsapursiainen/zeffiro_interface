%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [x,conv_val,n_iter] = pcg(A,b,tol_val,max_it,M,x);

r = - ( -b + A*x );
z = M\r;
p = z;
j = 1;

conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));

while (conv_val > tol_val) & (j < max_it)
aux_vec = A*p;
    alpha = sum(z.*r)./sum(p.*aux_vec);
    x = x + alpha(ones(size(p,1),1),:).*p;
    rnew = r - alpha(ones(size(p,1),1),:).*aux_vec;
    znew = M\rnew;
    beta = sum(znew.*rnew)./sum(z.*r);
    p = znew + beta(ones(size(p,1),1),:).*p;
    r = rnew;
    z = znew;
    j = j + 1;
    conv_val = sqrt(max(sum(r.^2)'./sum(b.^2)'));
end

n_iter = j;

return
