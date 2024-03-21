function prec = ssor ( A, kwargs )
%
% prec = ssor ( A, kwargs )
%
% Computes the SSOR preconditioner for the matrix A of a system Ax = b.
%
% kwargs:
%
% - coeff = 1
%
%   The preconditioner constant used in the computation. The default value of 1
%   corresponds to the Gauss--Seidel preconditioner.
%

    arguments
        A (:,:) { mustBeFinite }
        kwargs.coeff (1,1) double { mustBeInRange(kwargs.coeff, 0, 2) } = 1
    end

    L = tril ( A ) ;

    U = triu ( A ) ;

    D = diag ( diag ( A ) ) ;

    invD = 1 ./ D ;

    coeff = kwargs.coeff ;

    prec = ( D + coeff * L ) * invD * ( D + coeff * U ) ;

end % function
