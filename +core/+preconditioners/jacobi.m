function prec = jacobi ( A )
%
% prec = jacobi ( A )
%
% Computes the Jacobi preconditioner for the matrix A of a system Ax = b.
%

    arguments
        A (:,:)
    end

    prec = diag ( diag ( A ) ) \ eye ( size ( A ) ) ;

end % function
