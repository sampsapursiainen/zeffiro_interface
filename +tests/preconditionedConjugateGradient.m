function preconditionedConjugateGradient(kwargs)

    arguments
        kwargs.testTol (1,1) double { mustBePositive } = 1e-2
        kwargs.pcgTol (1,1) double { mustBePositive } = 1e-5
        kwargs.testSize (1,1) double { mustBePositive, mustBeInteger } = 10
    end

    testA = zefCore.operators.randPosDefMat (kwargs.testSize) ;

    testb = rand (kwargs.testSize,1) ;

    testx = testA \ testb ;

    x0 = zeros (kwargs.testSize,1) ;

    [ pcgx, relResNorm, iters ] = zefCore.solvers.preconditionedConjugateGradient (testA, testb, x0, tolerance=kwargs.pcgTol) ;

    infnorm = vecnorm (pcgx - testx, Inf) ;

    assert ( infnorm <= kwargs.testTol, "PCG iteration did not converge after the theoretical maximum of " + iters + " iterations. The relative residual norm was " + relResNorm ) ;

    disp ("PCG iteration converged with infinity norm " + infnorm) ;

end
