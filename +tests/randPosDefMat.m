function randPosDefMat (kwargs)
    arguments
        kwargs.testsize (1,1) double { mustBePositive, mustBeInteger } = 10
    end

    testM = core.operators.randPosDefMat ( kwargs.testsize ) ;

    eigvals = eig (testM) ;

    assert ( all ( eigvals > 0 ), "The given random positive definite matrix was not positive definite." )

end