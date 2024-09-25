% A script for retrieving values from zef and converting them to a suitable format.

projectPath = fullfile ("data", "head_for_R_linearization.mat") ;

zef = matfile (projectPath) ;

electrodePos1 = zef.s2_points([23,34],:); % zef.s2_points([23,27],:);

electrodePos2 = zef.s2_points([34,48],:);

f1 = 1000 ;

f2 = 1010 ;

contactResistance = 270 ;

doubleLayerResistance = 1e4 ;

capacitance = 1e-7 ;

contactSurfaceRadii = 5 ;

superNodes1 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos1',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

superNodes2 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos2',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

ee1 = zefCore.ElectrodeSet (contactResistances=contactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=superNodes1,frequencies=f1) ;

conductivity = zefCore.reshapeTensor (zef.sigma(:,1)) ;

permittivity = zefCore.reshapeTensor (zef.epsilon(:,1)) ;

nodes = zef.nodes ;

tetra = zef.tetra ;

activeI = zef.brain_ind ;

sourceN = 5000 ;

f1s = ee1.frequencies ;

f1 = f1s (end) ;

angFreq1 = 2 * pi * f1 ;

admittivity1 = conductivity + 1i * angFreq1 * permittivity ;

tetraV = zefCore.tetraVolume (nodes, tetra, true) ;

Z1s = ee1.impedances ;

contactSurf1 = ee1.contactSurfaces ;

iniA1 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity1) ;

A1 = zefCore.stiffMatBoundaryConditions (iniA1, Z1s, contactSurf1) ;

B1 = zefCore.potentialMat ( contactSurf1, Z1s, size (nodes,1) );

C1 = zefCore.impedanceMat (Z1s);

solverTol = 1e-8 ;

T1 = zefCore.transferMatrix (A1,B1,tolerances=solverTol,useGPU=true) ;

S1 = zefCore.schurComplement (T1, ctranspose(B1), C1) ;

[Gx1, Gy1, Gz1] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

[ ~, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

[ L1, R1 ] = zefCore.tesLeadField ( T1, S1, Gx1, Gy1, Gz1, aggregationI, aggregationN ) ;

%% Linearization bit.

dfs = [ 0, 1e3 ] ;

invS1 = S1 \ eye ( size (S1) ) ;

newR1 = zefCore.linearizeResistivityMatrix (R1, A1, B1, T1, invS1, ee1, dfs, 1:2) ;

save("f=" + f1 + ".mat", "-v7.3") ;
