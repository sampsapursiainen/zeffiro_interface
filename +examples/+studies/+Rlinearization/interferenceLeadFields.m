function [L1, L2, R1, R2] = interferenceLeadFields (nodes, tetra, conductivity, permittivity, electrodePairs, activeI, sourceN, kwargs)
%
% [L1, L2, R1, R2] = interferenceLeadFields (nodes, tetra, conductivity, permittivity, electrodePairs, sourceN, kwargs)
%
% Computes two lead fields for corresponding two pairs of tACS electrodes at
% different frequencies.
%

    arguments
        nodes (:,3) double { mustBeFinite }
        tetra (:,4) double { mustBePositive, mustBeInteger }
        conductivity (6,:) double { mustBeFinite }
        permittivity (6,:) double { mustBeFinite }
        electrodePairs (1,:) zefCore.ElectrodeSet
        activeI (:,1) double { mustBePositive, mustBeInteger }
        sourceN (1,1) double { mustBeInteger, mustBePositive }
        kwargs.solverTol (1,1) double { mustBePositive, mustBeFinite } = 1e-8
    end

    f1s = electrodePairs(1).frequencies ;

    f2s = electrodePairs(2).frequencies ;

    assert (all ( f1s == f1s (1) ), "All frequencies of electrode pair 1 need to be the same.") ;

    assert (all ( f1s == f1s (1) ), "All frequencies of electrode pair 2 need to be the same.") ;

    f1 = f1s (end) ;

    f2 = f2s (end) ;

    angFreq1 = 2 * pi * f1 ;

    angFreq2 = 2 * pi * f2 ;

    admittivity1 = conductivity + 1i * angFreq1 * permittivity ;

    admittivity2 = conductivity + 1i * angFreq2 * permittivity ;

    tetraV = zefCore.tetraVolume (nodes, tetra, true) ;

    Z1s = electrodePairs(1).impedances ;

    Z2s = electrodePairs(2).impedances ;

    contactSurf1 = electrodePairs(1).contactSurfaces ;

    contactSurf2 = electrodePairs(2).contactSurfaces ;

    iniA1 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity1) ;

    iniA2 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity2) ;

    A1 = zefCore.stiffMatBoundaryConditions (iniA1, Z1s, contactSurf1) ;

    A2 = zefCore.stiffMatBoundaryConditions (iniA2, Z2s, contactSurf2) ;

    B1 = zefCore.potentialMat ( contactSurf1, Z1s, size (nodes,1) );

    B2 = zefCore.potentialMat ( contactSurf2, Z2s, size (nodes,1) );

    C1 = zefCore.impedanceMat (Z1s);

    C2 = zefCore.impedanceMat (Z2s);

    T1 = zefCore.transferMatrix (A1,B1,tolerances=kwargs.solverTol,useGPU=true) ;

    T2 = zefCore.transferMatrix (A2,B2,tolerances=kwargs.solverTol,useGPU=true) ;

    S1 = zefCore.schurComplement (T1, ctranspose(B1), C1) ;

    S2 = zefCore.schurComplement (T2, ctranspose(B2), C2) ;

    [Gx1, Gy1, Gz1] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

    [Gx2, Gy2, Gz2] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

    [ ~, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

    [ L1, R1 ] = zefCore.tesLeadField ( T1, S1, Gx1, Gy1, Gz1, aggregationI, aggregationN ) ;

    [ L2, R2 ] = zefCore.tesLeadField ( T2, S2, Gx2, Gy2, Gz2, aggregationI, aggregationN ) ;

end % function
