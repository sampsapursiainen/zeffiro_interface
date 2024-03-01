function [T, S, A] = transferMatrix ( A, B, C, kwargs )
%
% [T, S, A] = transferMatrix ( A, B, C, kwargs )
%
% Builds a transfer matrix T and its Schur complement S from a given stiffness
% matrix A, matrices B and C, sizes n_of_fem_nodes and n_of_electrodes, a
% permutation matrix and a precoditioner, through preconditioned conjugate
% gradient (PCG) iteration.
%
% Input:
%
% - A (:,:) sparse
%
%   A stiffness matrix related to the FE system under observation.
%
% - B (:,:) sparse
%
%   A sparse matrix that maps potentials from electrodes to FEM nodes.
%
% - C (:,:) sparse
%
%   A matrix that contains the ungrounded voltages or potentials of electrodes
%   on its diagonal.
%
% - kwargs.maxiters = size ( A, 1 )
%
%   Theoretically, the PCG algorithm should converge in a number of steps that
%   is equal to the number of rows of A (as it should be the same as that of
%   B).
%
% - kwargs.preconditioner = 1 ./ diag ( A )
%
%   A preconditioner vector. By default, this is the Jacobi preconditioner.
%
% - kwargs.permutation (1,1) double = 1 : size (A,1)
%
%   A permutation of A and columns of B, used by the preconditioner of the PCG
%   solver. Could be (for example) symamd(A), symmd(A) or symrcm(A) or just 1 :
%   size(A,1), if no permutation is desired.
%
% - kwargs.tolerances = 1e-6
%
%   The per-column tolerances of the PCG solver when solving each column of the
%   system separately. If given as a scalar, all columns will use the same
%   tolerance.
%
% - kwargs.useGPU = true
%
%   Determines whether to use a GPU when running the solver.
%
% Output:
%
% - T
%
%   A transfer matrix that maps potentials from sensors to finite element nodes.
%
% - S
%
%   The Schur complement of T.
%
% - A
%
%   A possibly permuted stiffness matrix A.
%

    arguments
        A (:,:)
        B (:,:) sparse
        C (:,:) sparse
        kwargs.permutation (:,1) double { mustBeInteger, mustBePositive } = 1 : size (A,1)
        kwargs.preconditioner (:,1) double = 1 ./ full ( diag ( A ) )
        kwargs.tolerances (:,1) double { mustBePositive, mustBeFinite } = 1e-6
        kwargs.useGPU (1,1) logical = true
    end

    % Preallocate output.

    n_of_fem_nodes = size ( A, 1 ) ;

    n_of_electrodes = size ( B, 2 ) ;

    T = zeros ( n_of_fem_nodes, n_of_electrodes );

    S = zeros (n_of_electrodes);

    % Permute stiffness matrix A if a preconditioner requires it. Also
    % construct an inverse permutation so that the final result can be
    % presented in the original order.

    invperm = sortrows ([ kwargs.permutation (1:n_of_fem_nodes)' ]) ;

    invperm = invperm (:,2) ;

    A = A ( kwargs.permutation, kwargs.permutation ) ;

    % Preallocate vectors used by the solver and copy them to GPU if wanted and able.

    b = zeros ( n_of_fem_nodes, 1 ) ;
    x = zeros ( n_of_fem_nodes , 1 ) ;
    r = b (kwargs.permutation);
    p = r ;

    if kwargs.useGPU && gpuDeviceCount("available") > 0
        b = gpuArray (b) ;
        x = gpuArray (x) ;
        r = gpuArray (r) ;
        p = gpuArray (p) ;
        A = gpuArray (A) ;
    end % if

    % Initialize per-column tolerances.

    if isscalar (kwargs.tolerances)
        tolerances = kwargs.tolerances * ones ( n_of_electrodes, 1 ) ;
    else
        tolerances = kwargs.tolerances ;
    end

    % Start generating T column by column.

    for i = 1 : n_of_electrodes

        b (:) = full ( B (:,i) ) ;

        tolerance = tolerances (i) ;

        x (:) = 0 ;

        norm_b = norm (b);

        r (:) = b (kwargs.permutation);

        p (:) = r;

        m = 0 ;

        % Open the door, get on the floor, everybody do the dinosaur. Or use PCG iteration.

        while ( norm(r,2) / norm_b > tolerance) && (m < kwargs.maxiters)

            a = A * p;
            a_dot_p = sum ( conj (a) .* p ) ;
            aux_val = sum ( conj (r) .* p ) ;
            lambda = aux_val ./ a_dot_p ;
            x (:) = x + lambda * p ;
            r (:) = r - lambda * a ;
            inv_M_r = kwargs.preconditioner .*  r ;
            aux_val = sum ( conj (inv_M_r) .* a ) ;
            gamma = aux_val ./ a_dot_p ;
            p (:) = inv_M_r - gamma * p ;
            m = m + 1 ;

        end % while

        relativeResidual = norm (r) / norm_b ;

        r (:) = x (invperm) ;

        x = r;

        T (:,i) = x;

        S (:,i) = C (:,i) - B' * x ;

        if tolerance < relativeResidual
            error('PCG iteration did not converge.') ;
        end

    end % for

end % function
