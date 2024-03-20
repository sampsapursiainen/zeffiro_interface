function preconditionedConjugateGradient(kwargs)

    arguments
        kwargs.testTol (1,1) double { mustBePositive } = 1e-6
        kwargs.testSize (1,1) double { mustBePositive, mustBeInteger } = 10
    end

    testA = core.operators.randPosDefMat (kwargs.testSize) ;

    testb = rand (kwargs.testSize,1) ;

    testx = testA \ testb ;

    x0 = zeros (kwargs.testSize,1) ;

    pcgx = core.solvers.preconditionedConjugateGradient (testA,testb,x0, tolerance=kwargs.testTol) ;

    diffmaxnorm = max ( vecnorm (pcgx - testx, Inf) ) ;

    disp ("PCG iteration converged with infimum norm " + diffmaxnorm)

end
