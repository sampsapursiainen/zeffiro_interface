function x = L1_optimization(L,sigma,y,gamma,x0,maxiter)

%MAP estimate using EM algorithm
%L1 norm minimization problem (LASSO):
%0.5|1/sigma(Lx-y)\|_2^2+0.5*\sum_i [gamma_i |x_i|]

% L : lead field matrix
% sigma: noise variance
% y: measurements
%for gamma->0 we have less sparse solutions...

%Output: x: dipole amplitude

%This code is used when dipole orientation is fixed!

%EM: is a ridge regression solution given by d^(k) =(A'A+ Q^(k))^-1 A'y

%This code was created by A. Koulouri 29.2.2020
%modified 28.4.2020
%modified to be stable (icreased accuracy) 04.12.2021

[m,~]=size(L);
A = 1/sigma*L;
b = 1/sigma*y;

reg = sqrt(0.5*pi/m)*norm(L,'fro');
 for iter = 1 : maxiter
    D = spdiags(abs(x)./(gamma),0,size(A,2),size(A,2));
    ADA_T = A*(D*A');
    x = D*(A'*((ADA_T + reg*trace(D)*eye(size(ADA_T)))\b));
end
end
