function [P1, P2] = ssor ( A, kwargs )
%
% [P1, P2] = ssor ( A, kwargs )
%
% Computes the SSOR preconditioner M, split into 2 factors P1 and P2 for the
% matrix A of a symmetric system Ax = b. To actually apply the preconditioner,
% as in to solve z = inv M * x for z, one needs solve the following system by 2
% back-substitutions:
%
%   P1 * c = x
%   P2 * z = c
%
% kwargs:
%
% - coeff = 1
%
%   The preconditioner constant used in the computation. Must be in the
%   interval [0,2]. The default value of 1 corresponds to the Gauss--Seidel
%   preconditioner.
%

    arguments
        A (:,:) { mustBeFinite }
        kwargs.coeff (1,1) double { mustBeInRange(kwargs.coeff, 0, 2) } = 1
    end

    N = size (A,1) ;

    L = tril ( A, 1 ) ;

    U = triu ( A, 1 ) ;

    Dvec = diag ( A ) ;

    invD = sparse ( 1:N, 1:N, 1 ./ Dvec, N, N ) ;

    D = sparse ( 1:N, 1:N, Dvec, N, N ) ;

    coeff = kwargs.coeff ;

    P1 = speye (N) + coeff * L * invD ;

    P2 = D + coeff * U ;

end % function
