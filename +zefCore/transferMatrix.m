function T = transferMatrix ( A, B, kwargs )
%
% T = transferMatrix ( A, B, C, kwargs )
%
% Builds a transfer matrix T that maps measurements from sensors to FE mesh
% nodes, from a given stiffness matrix A, and sensor matrices B and C from a
% discretized system
%
%   [ A B ; B' C ] * [ u ; v ] = [ x ; y ]
%
% Input:
%
% - A (:,:) sparse
%
%   A stiffness matrix related to the FE system under observation.
%
% - B (:,:) sparse
%
%   A sparse matrix that maps potentials from sensors to FE nodes.
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

    arguments
        A (:,:) double { mustBeFinite }
        B (:,:) double { mustBeFinite }
        kwargs.permutation    (:,1) double { mustBeInteger, mustBePositive } = symamd (A)
        kwargs.preconditioner (:,1) double = 1 ./ full ( diag ( A ) )
        kwargs.tolerances     (:,1) double { mustBePositive, mustBeFinite } = 1e-6
        kwargs.useGPU         (1,1) logical = true
        kwargs.maxiters       (1,1) { mustBePositive, mustBeInteger, mustBeFinite } = ceil ( 1.5 * size (A,1) )
        kwargs.solver (1,1) function_handle = @zefCore.solvers.biConjugateGradientStabilized
    end

    disp (newline + "Building a transfer matrix T = A \ B:") ;

    % Preallocate output.

    n_of_fem_nodes = size ( A, 1 ) ;

    n_of_electrodes = size ( B, 2 ) ;

    T = zeros ( n_of_fem_nodes, n_of_electrodes );

    % Permute stiffness matrix A if a preconditioner requires it. Also
    % construct an inverse permutation so that the final result can be
    % presented in the original order.

    invperm = sortrows ([ kwargs.permutation (1:n_of_fem_nodes)' ]) ;

    invperm = invperm (:,2) ;

    A = A ( kwargs.permutation, kwargs.permutation ) ;

    % Preallocate vectors used by the solver and copy them to GPU if wanted and able.

    b = zeros ( n_of_fem_nodes, 1 ) ;
    x = zeros ( n_of_fem_nodes , 1 ) ;

    tolerances = kwargs.tolerances ;

    if isscalar (tolerances)
        tolerances = tolerances * ones ( n_of_electrodes, 1 ) ;
    end

    preconditioner = kwargs.preconditioner (kwargs.permutation) ;

    if kwargs.useGPU && gpuDeviceCount("available") > 0
        b = gpuArray (b) ;
        x = gpuArray (x) ;
        A = gpuArray (A) ;
        tolerances = gpuArray (tolerances) ;
        preconditioner = gpuArray (preconditioner) ;
    end % if

    % Start generating T column by column by inverting A against B.

    for i = 1 : n_of_electrodes

        zefCore.dispProgress (i, n_of_electrodes) ;

        b (:) = full ( B (:,i) ) ;

        tolerance = tolerances (i) ;

        x (:) = 0 ;

        b (:) = b (kwargs.permutation) ;

        % Open the door, get on the floor, everybody do the dinosaur. Or use PCG iteration.

        [ x(:), relResNorm, iters ] = kwargs.solver ( A, x, b, tolerance=tolerance, preconditioner=preconditioner, maxiters=kwargs.maxiters ) ;

        if relResNorm > tolerance

            error ( "Solver did not converge after the theoretical maximum number of iterations " + iters + ". The relative residual norm was " + gather (relResNorm) + "." ) ;

        end

        x (:) = x (invperm) ;

        T (:,i) = x ;

    end % for

end % function
