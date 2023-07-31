function x = L1_optimization(A,sigma,y,gamma,x,maxiter,estimation_type)

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

[m,~]=size(A);
A = 1/sigma*A;
b = 1/sigma*y;
reg = sqrt(0.5*pi/m)*norm(A,'fro');

for iter = 1 : maxiter
    if estimation_type == 3
        P_sqrt = abs(x)./gamma;   %Fixed-point/FOCUSS
        L_aux = A.*P_sqrt';
        R = L_aux'/(L_aux*A'+eye(m));
        R = abs(sum(R.'.*L_aux,1));
        T_scale = 1./sqrt(R)';
        D = spdiags(abs(x)./gamma,0,size(A,2),size(A,2));
        ADA_T = A*(D*A');

        x = T_scale.*(D*(A'*((ADA_T + reg*trace(D)*eye(size(ADA_T)))\b)));
    else
        D = spdiags(abs(x)./gamma,0,size(A,2),size(A,2));
        ADA_T = A*(D*A');
        x = D*(A'*((ADA_T + reg*trace(D)*eye(size(ADA_T)))\b));
    end
end
end
