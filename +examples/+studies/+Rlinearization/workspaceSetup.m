% A script for retrieving values from zef and converting them to a suitable format.

projectPath = fullfile ("data", "head_for_R_linearization.mat") ;

zef = matfile (projectPath) ;

electrodePos1 = zef.s2_points([23,27],:);

electrodePos2 = zef.s2_points([34,48],:);

f1 = 1000 ;

f2 = 1010 ;

superNodes1 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos1',nodeRadii=1,attachNodesTo="surface") ;

superNodes2 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos2',nodeRadii=1,attachNodesTo="surface") ;

ee1 = zefCore.ElectrodeSet (innerRadii=0,outerRadii=1,wetResistances=400, doubleLayerResistances=15,capacitances=3.5e-6,contactSurfaces=superNodes1,frequencies=f1) ;

ee2 = zefCore.ElectrodeSet (innerRadii=0,outerRadii=1,wetResistances=400, doubleLayerResistances=15,capacitances=3.5e-6,contactSurfaces=superNodes2,frequencies=f2) ;

conductivity = zefCore.reshapeTensor (zef.sigma(:,1)) ;

permittivity = zefCore.reshapeTensor (zef.epsilon(:,1)) ;

nodes = zef.nodes ;

tetra = zef.tetra ;

activeI = zef.brain_ind ;

sourceN = 5000 ;

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

Z1s = ee1.impedances ;

Z2s = ee2.impedances ;

contactSurf1 = electrodePairs(1).contactSurfaces ;

contactSurf2 = electrodePairs(2).contactSurfaces ;

iniA1 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity1) ;

iniA2 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity2) ;

A1 = zefCore.stiffMatBoundaryConditions (iniA1, Z1s, contactSurf1) ;

A2 = zefCore.stiffMatBoundaryConditions (iniA2, Z2s, contactSurf2) ;

B1 = zefCore.potentialMat ( contactSurf1, Z1s, size (nodes,1) );

B2 = zefCore.potentialMat ( contactSurf2, Z2s, size (nodes,1) );

C1 = zefCore.voltageMat (Z1s);

C2 = zefCore.voltageMat (Z2s);

solverTol = 1e-8 ;

T1 = zefCore.transferMatrix (A1,B1,tolerances=solverTol,useGPU=true) ;

T2 = zefCore.transferMatrix (A2,B2,tolerances=solverTol,useGPU=true) ;

S1 = zefCore.schurComplement (T1, ctranspose(B1), C1) ;

S2 = zefCore.schurComplement (T2, ctranspose(B2), C2) ;

[Gx1, Gy1, Gz1] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

[Gx2, Gy2, Gz2] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

[ ~, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

[ L1, R1 ] = zefCore.tesLeadField ( T1, S1, Gx1, Gy1, Gz1, aggregationI, aggregationN ) ;

[ L2, R2 ] = zefCore.tesLeadField ( T2, S2, Gx2, Gy2, Gz2, aggregationI, aggregationN ) ;
