function x = generalizedMinimumResidual (A,x0,b,kwargs)
%
% x = generalizedMinimumResidual (A,x0,b,kwargs)
%
% Computes and approximate solution for the linear system A x = b using the
% GMRES method.
%
% Inputs:
%
% - A
%
%   The system matrix. Needs to be invertible.
%
% - x0
%
%   An initial guess for the solution.
%
% - b
%
%   The right-hand side of our system.
%
% - kwargs.tolerance = 1e-5
%
%   A tolerance value for the solution.
%

    arguments
        A  (:,:) { mustBeFinite }
        x0 (:,1) { mustBeFinite }
        b  (:,1) { mustBeFinite }
        kwargs.tolerance (1,1) double { mustBePositive } = 1e-5
    end

    x = x0 ;

    [Nrows, Ncols] = size (A) ;

    assert (Nrows == Ncols, "Argument 1 must be an invertible square matrix.")

    residual = b - A * x0 ;

    resNorm = vecnorm (residual) ;

    unitResidual = residual / resNorm ;

    UR = zeros (Nrows, 1) ;

    for Hcol = 1 : Nrows

        Aur = A * unitResidual ;

        H = zeros (Hcol+1,Hcol) ;

        % NOTE: we're allocating more space for storing unit residuals in UR
        % during every iteration, but a good pre-allocation strategy for this
        % problem is not easy to find, since we need all results from previous
        % iterations and do not know space requirements beforehand.

        UR (:,Hcol) = unitResidual ;

        for Hrow = 1 : Hcol

            unitResDotAur = dot ( UR (:,Hrow), Aur ) ;

            H (Hrow, Hcol) = unitResDotAur ;

            Aur = Aur - unitResDotAur * unitRes ;

        end % for Hrow

        AurNorm = vecnorm (Aur) ;

        solutionReached = AurNorm <= kwargs.tolerance ;

        H (Hcol+1,Hcol) = AurNorm ;

        lsqSol = lsqminnorm ( H, cat (1, resNorm, zeros (Hcol,1) ) ) ;

        x = UR (:,1:Hcol) * lsqSol + x0 ;

        if solutionReached

            return ;

        end % if

        unitResidual = Aur / AurNorm ;

    end % for Hcol

end % function
