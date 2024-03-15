function nextPos = preconditionedConjugateGradient (A, b, startPoint, kwargs)
%
% solution = preconditionedConjugateGradient (A, b, start_point, kwargs)
%
% Solves the linear system Ax = b for x using preconditioned conjugate gradient method.
%
% kwargs:
%
% - tolerance
%
%   The numerical tolerance of the solver relative to the norm of b.
%
% - preconditioner
%
%   A preconditioner matrix. Needs to be positive definite and symmetric.
%

    arguments
        A                     (:,:)
        b                     (:,1)
        startPoint            (:,1)
        kwargs.tolerance      (1,1) { mustBePositive } = 1e-5
        kwargs.preconditioner (:,1) = 1 ./ full ( diag ( A ) )
    end

    Asize = size ( A, 1 ) ;

    assert ( numel ( kwargs.preconditioner ) == Asize, "The size of the given preconditioner needs to match the size of A." )

    % Set initial values for the iteration, including the preconditioned step direction.

    residual = b - A * startPoint ;

    precResidual = kwargs.preconditioner .* residual ;

    stepDir = precResidual ;

    pos = startPoint ;

    bnorm = vecnorm (b) ;

    for ii = 1 : Asize

        % Compute values for next round.

        Ad = A * stepDir ;

        stepSize = dot ( residual, precResidual ) / dot ( stepDir, Ad ) ;

        nextPos = pos + stepSize * stepDir ;

        nextResidual = residual - stepSize * Ad ;

        resNorm = vecnorm ( nextResidual ) ;

        relNorm = resNorm / bnorm ;

        if relNorm <= kwargs.tolerance

            return

        end % if

        precNextResidual = kwargs.preconditioner .* nextResidual ;

        nextStepSize = dot ( nextResidual, precNextResidual ) / dot ( residual, precResidual ) ;

        % Update current values for use in the next round.

        stepDir = precNextResidual + nextStepSize * stepDir ;

        pos = nextPos ;

        residual = nextResidual ;

        precResidual = precNextResidual ;

    end % while

    error ( "The preconditioned conjugate gradient iteration did not converge." )

end % function
