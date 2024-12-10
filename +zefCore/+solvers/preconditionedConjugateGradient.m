function [ pos, relResNorm, ii ] = preconditionedConjugateGradient (A, startPoint, b, kwargs)
%
% [ solution, relResNorm, ii ] = preconditionedConjugateGradient (A, b, start_point, kwargs)
%
% Solves the linear system Ax = b for x using preconditioned conjugate gradient
% method. Returns the approximate solution, in addition to the relative
% residual norm at the given point, and the number of iterations it took to
% reach the solution.
%
% kwargs:
%
% - tolerance = 1e-5
%
%   The numerical tolerance of the solver relative to the norm of b.
%
% - preconditioner = Jacobi
%
%   A preconditioner matrix. Needs to be positive definite and symmetric.
%
% - maxiters = 1.5 * size (A)
%
%   The maximum number of PCG iterations to be performed. Due to possible
%   numerical inaccuracies, this defaults to a size that is larger than the
%   theoretical number of maximum iterations, which is the size of A.
%

    arguments
        A                     (:,:)
        startPoint            (:,1)
        b                     (:,1)
        kwargs.tolerance      (1,1) { mustBePositive } = 1e-5
        kwargs.preconditioner (:,:) = 1 ./ full ( diag ( A ) )
        kwargs.maxiters       (1,1) { mustBePositive, mustBeInteger, mustBeFinite } = size (A,1)
    end

    Asize = size ( A, 1 ) ;

    assert ( size ( kwargs.preconditioner, 1 ) == Asize, "The size of the given preconditioner needs to match the size of A." )

    % Set initial values for the iteration, including the preconditioned step direction.

    residual = b - A * startPoint ;

    P = kwargs.preconditioner ;

    % Choose method of applying the preconditioner.

    if isvector ( P )

        applyP = @times ;

    elseif ismatrix ( P )

        applyP = @mtimes ;

    else

        error ( "The given preconditioner needs to be a matrix or a vector of size A." )

    end

    precResidual = applyP (P, residual) ;

    stepDir = precResidual ;

    pos = startPoint ;

    bnorm = vecnorm (b) ;

    for ii = 1 : kwargs.maxiters

        % Check for convergence.

        resNorm = vecnorm ( residual ) ;

        relResNorm = resNorm / bnorm ;

        if relResNorm <= kwargs.tolerance

            return

        end % if

        % Compute values for next round.

        Ad = A * stepDir ;

        stepSize = dot ( residual, precResidual ) / dot ( stepDir, Ad ) ;

        pos = pos + stepSize * stepDir ;

        nextResidual = residual - stepSize * Ad ;

        precNextResidual = applyP ( P, nextResidual ) ;

        nextStepSize = dot ( nextResidual, precNextResidual ) / dot ( residual, precResidual ) ;

        % Update current values for use in the next round.

        stepDir = precNextResidual + nextStepSize * stepDir ;

        residual = nextResidual ;

        precResidual = precNextResidual ;

    end % for

end % function
