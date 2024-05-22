function solution = biConjugateGradientStabilized (A, x0, b, kwargs)
%
% solution = biConjugateGradientStabilized ()
%
% Solves an unsymmetric linear system A x = b with the BiCGSTAB method, or the
% combined bi-conjugate gradient and GMRES method.
%
% Inputs:
%
% - A
%
%   The system matrix.
%
% - x0
%
%   An initial guess for the solution x.
%
% - b
%
%   The right-hand side of the linear system.
%
% - kwargs.maxiters = size (A,1)
%
%   The maximum number of iterations.
%
% - kwargs.tolerance = 1e-5
%
%   The tolerance of the solver.
%

    arguments
        A  (:,:) { mustBeFinite }
        x0 (:,1) { mustBeFinite }
        b  (:,1) { mustBeFinite }
        kwargs.maxiters (1,1) double { mustBeInteger } = size (A,1)
        kwargs.tolerance (1,1) double { mustBePositive, mustBeFinite } = 1e-5
    end

    residual = b - A * x0 ;

    arbvec = vecnorm (residual) * randn ( size (residual) ) ;

    orthogonality = dot (residual, arbvec) ;

    stepdir = residual ;

    x = x0 ;

    for ii = 1 : kwargs.maxiters

        Ad = A * stepdir ;

        stepsize = orthogonality / dot ( arbvec, Ad ) ;

        xcandidate = x + stepsize * Ad ;

        rejection = residual - stepsize * Ad ;

        if vecnorm (xcandidate) <= kwargs.tolerance

            x = xcandidate ;

            return ;

        end % if

        Arej = A * rejection ;

        rejstepsize = dot ( Arej, rejection ) / dot (Arej, Arej) ;

        x = xcandidate + rejstepsize * rejection ;

        residual = rejection - rejstepsize * Arej ;

        if vecnorm (residual) <= kwargs.tolerance

            return ;

        end % if

        neworthogonality = dot (arbvec,residual) ;

        newstepsize = neworthogonality * stepsize / orthogonality / rejstepsize ;

        stepdir = residual + newstepsize * ( stepdir - rejstepsize * rejection ) ;

        orthogonality = neworthogonality ;

    end % for ii

end % function
