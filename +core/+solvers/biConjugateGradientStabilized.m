function [x,relresnorm,ii] = biConjugateGradientStabilized (A, x0, b, kwargs)
%
% [x,relresnorm,ii] = biConjugateGradientStabilized (A, x0, b, kwargs)
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

    bnorm = vecnorm (b) ;

    residual = b - A * x0 ;

    arbvec = randn ( size (residual) ) ;

    orthogonality = dot (residual, arbvec) ;

    stepdir = residual ;

    x = x0 ;

    for ii = 1 : kwargs.maxiters

        Adir = A * stepdir ;

        stepsize = orthogonality / dot ( arbvec, Adir ) ;

        xcandidate = x + stepsize * stepdir ;

        rejection = residual - stepsize * Adir ;

        rejnorm = vecnorm (rejection) ;

        relresnorm = rejnorm / bnorm ;

        if relresnorm <= kwargs.tolerance

            x = xcandidate ;

            return ;

        end % if

        Arej = A * rejection ;

        rejstepsize = dot ( Arej, rejection ) / dot (Arej, Arej) ;

        x = xcandidate + rejstepsize * rejection ;

        residual = rejection - rejstepsize * Arej ;

        resnorm = vecnorm (residual) ;

        relresnorm = resnorm / bnorm ;

        if relresnorm <= kwargs.tolerance

            return ;

        end % if

        neworthogonality = dot (arbvec,residual) ;

        newstepsize = neworthogonality * stepsize / orthogonality / rejstepsize ;

        stepdir = residual + newstepsize * ( stepdir - rejstepsize * Adir ) ;

        orthogonality = neworthogonality ;

    end % for ii

end % function
