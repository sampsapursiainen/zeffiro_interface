function prec = jacobi ( A )
%
% prec = jacobi ( A )
%
% Computes the Jacobi preconditioner for the matrix A of a system Ax = b.
%

    arguments
        A (:,:)
    end

    invDiag = 1 ./ diag ( A ) ;

    N = numel (invDiag) ;

    prec = sparse ( 1:N, 1:N, invDiag, N, N ) ;

end % function
