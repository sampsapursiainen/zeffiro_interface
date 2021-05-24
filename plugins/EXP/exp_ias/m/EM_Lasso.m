function x = EM_Lasso(L,sigma,y,gamma,x0)


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

[m,~]=size(L);
A = 1/sigma*L;
b = 1/sigma*y;
%At = A';


%x = zeros(n,1)+1e-7;

converged = 0;
conv_thres = 1e-6;
maxiter=10;

iter=1;

log_prob_lap = @(x,gamma) -(m*log(sigma)+ 0.5 * (A*x-b)'*(A*x-b)+ 0.5* sum(gamma.*abs(x)))+sum(log(gamma));

%log_prob_lap = @(x,gamma) -(0.5 * (A*x-b)'*(A*x-b)+ 0.5* sum(gamma.*abs(x)));

%THE PROBLEM CAN BE SOLVED USING SVD alternatively!


% Singular value decomposition to fasten code
% - see Griffin and Brown, 2005, for details
  
  %[U, S, V] = svd(A);
  %ind = find(diag(S)>10^-10);
  %S = S(ind,ind);
  %U = U(:,ind);
  %V = V(:,ind);
  %y_hat = S\U'*b;
  %S_2 = S^-2; 

  x = x0; %initialization...

  log_old = log_prob_lap(x,gamma);

  iter_ind = 0;
  
while (converged==0)
    
  iter_ind = iter_ind + 1;
       
    D = diag(2*gamma./abs(x));
    ADA = A*D*A';
    x = A'*((ADA + eye(size(ADA)))\b);
    
    log_new = log_prob_lap(x,gamma);
    

    % % We have converged if the slope of the function falls below 'threshold', 
    % % i.e., |f(t) - f(t-1)| / avg < threshold,
    % % where avg = (|f(t)| + |f(t-1)|)/2 
    % % 'threshold' defaults to 1e-4.
    % % This stopping criterion is from Numerical Recipes in C p423
    
    
    delta_log = abs(log_new-log_old);
    avg_neg_log = (abs(log_new)+abs(log_old)+eps)/2;
    if (delta_log/avg_neg_log)<conv_thres
        converged=1;
    end
%     if  (log_new-log_old)<-2*eps
%           warning('convergenceTest:neglog_Decrease', 'objective decreased!'); 
%     end    
    
    log_old = log_new;
    
     if iter == maxiter
        break;
     end
        iter=iter+1;
    
end
end