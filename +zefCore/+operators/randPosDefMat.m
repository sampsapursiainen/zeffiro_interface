function M = randPosDefMat (n, kwargs)
%
% M = randPosDefMat (n,charmean=0)
%
% Generates a full random positive definite matrix of size n×n. The optional
% second keyword argument can be used to shift the mode of the random
% distribution.
%
% Code borrowed from https://math.stackexchange.com/a/798129.
%

    arguments
        n (1,1) double { mustBeInteger, mustBePositive, mustBeFinite }
        kwargs.charmean (1,1) double { mustBeReal, mustBeFinite } = 0
    end

    Q = randn (n,n) ;

    mu = kwargs.charmean ;

    M = Q' * diag ( abs ( mu + randn (n,1) ) ) * Q ;

end % function
