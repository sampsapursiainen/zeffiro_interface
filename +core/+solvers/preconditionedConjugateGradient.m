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
%   The numerical tolerance of the solver.
%
% - preconditioner
%
%   A preconditioner matrix. Needs to be positive definite and symmetric.
%

    arguments
        A                     (:,:)
        b                     (:,1)
        startPoint            (:,1)
        kwargs.tolerance      (1,1) double { mustBePositive } = 1e-5
        kwargs.preconditioner (:,:) double = diag(diag(A))\eye(size(A))
    end

    Asize = size ( A ) ;

    assert ( all ( size ( kwargs.preconditioner ) == Asize ), "The size of the given preconditioner needs to match the size of A." )

    % Set initial values for the iteration, including the preconditioned step direction.

    residual = b - A * startPoint ;

    precResidual = kwargs.preconditioner * residual ;

    stepDir = precResidual ;

    pos = startPoint

    for ii = 1 : Asize ( 1 )

        % Compute values for next round.

        stepSize = ( residual' * precResidual ) / ( stepDir' * A * stepDir ) ;

        nextPos = pos + stepSize * stepDir ;

        nextResidual = residual - stepSize * A * stepDir

        resNorm = norm ( nextResidual )

        if resNorm < kwargs.tolerance

            return

        end % if

        precNextResidual = kwargs.preconditioner * nextResidual ;

        nextStepSize = ( nextResidual' * precNextResidual ) / ( residual' * precResidual ) ;

        % Update current values for use in the next round.

        stepDir = precNextResidual + nextStepSize * stepDir ;

        pos = nextPos ;

        residual = nextResidual ;

        precResidual = precNextResidual ;

    end % while

    error ( "The preconditioned conjugate gradient iteration did not converge." )

end % function
