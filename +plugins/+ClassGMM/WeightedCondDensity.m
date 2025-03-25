function   [log_lh,mahalaD]=WeightedCondDensity(positions, mu, weight, Sigma, p, sharedCov, CovType)
%WDENSITY Weighted conditional density and mahalanobis distance.
%   LOG_LH = WDENSITY(...) returns log of component conditional density
%   (weighted by the component probability) of X. LOG_LH is a N-by-K matrix
%   LOG_LH, where K is the number of Gaussian components. LOG_LH(I,J) is
%   log (Pr(point I|component J) * Prob( component J))
%
%   [LOG_LH, MAHALAD]=WDENSITY(...) returns the Mahalanobis distance in
%   the N-by-K matrix MAHALAD. MAHALAD(I,J) is the Mahalanobis distance of
%   point I from the mean of component J.

%   Copyright 2015 The MathWorks, Inc.

    log_prior = log(p);
    [n,d]=size(positions);
    k=size(mu,1);
    log_lh = zeros(n,k,'like',positions);
    if nargout > 1
      mahalaD = zeros(n,k,'like',positions);
    end
    logDetSigma = -Inf;
    for j = 1:k
        if sharedCov
            if j == 1
                if CovType == 2 % full covariance
                    [L,f] = chol(Sigma);
                    diagL = diag(L);
                    if (f ~= 0)|| any(abs(diagL) < eps(max(abs(diagL)))*size(L,1))
                        error(message('stats:gmdistribution:wdensity:IllCondCov'));
                    end
                    logDetSigma = 2*sum(log(diagL));
                else %diagonal
                    L = sqrt(Sigma);
                    if  any(L < eps( max(L))*d)
                          error(message('stats:gmdistribution:wdensity:IllCondCov'));
                    end
                    logDetSigma = sum( log(Sigma) );
                end
            end
        else %different covariance
            if CovType == 2 %full covariacne
                % compute the log determinant of covariance
                [L,f] = chol(Sigma(:,:,j) );
                diagL = diag(L);
                if (f ~= 0) || any(abs(diagL) < eps(max(abs(diagL)))*size(L,1))
                     error(message('stats:gmdistribution:wdensity:IllCondCov'));
                end
                logDetSigma = 2*sum(log(diagL));
            else %diagonal covariance
                L = sqrt(Sigma(:,:,j)); % a vector
                if  any(L < eps(max(L))*d)
                     error(message('stats:gmdistribution:wdensity:IllCondCov'));
                end
                logDetSigma = sum(log(Sigma(:,:,j)) );
            end
        end
        
        if CovType == 2
             %log_lh(:,j) = sum(weight.*((positions - mu(j,:))/L).^2, 2); 
             log_lh(:,j) = sum(((positions - mu(j,:))/L).^2, 2); 
        else %diagonal covariance
             %log_lh(:,j) = sum(((positions - mu(j,:))./L).^2, 2); 
             log_lh(:,j) = sum(((positions - mu(j,:))./L).^2, 2); 
        end
        
        if nargout > 1
             mahalaD(:,j) = log_lh(:,j);
        end
        log_lh(:,j) = -0.5*(log_lh(:,j) + logDetSigma);
    end
    %log_lh is a N by K matrix, log_lh(i,j) is log \alpha_j(x_i|\theta_j)
    log_lh = log_lh + log_prior - d*log(2*pi)/2;

   
