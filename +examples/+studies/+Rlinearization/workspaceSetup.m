% A script for retrieving values from zef and converting them to a suitable format.

f1 = 100 ;

projectPath = fullfile ("data", "head_for_R_linearization_f=" + f1 + "Hz.mat") ;

zef = matfile (projectPath) ;

nodes = zef.nodes / 1e3 ;

tetra = zef.tetra ;

electrodePos1 = zef.s2_points([41,42],:) / 1e3 ; % zef.s2_points([23,27],:) / 1e3;

% electrodePos2 = zef.s2_points([34,48],:) / 1e3 ;

f2 = 1010 ;

contactResistance = 270 ;

doubleLayerResistance = 1e4 ;

capacitance = 1e-7 ;

contactSurfaceRadii = 0.5e-3 ;

superNodes1 = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodePos1',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

superNodes2 = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodePos2',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

ee1 = zefCore.ElectrodeSet (contactResistances=contactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=superNodes1,frequencies=f1) ;

conductivity = zefCore.reshapeTensor (zef.sigma(:,1)) ;

eps0 = 8.8541878188e-12 ;

permittivity = zefCore.reshapeTensor (zef.epsilon(:,1)) * eps0;

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

[ L1x, L1y, L1z, R1 ] = zefCore.tesLeadField ( T1, S1, Gx1, Gy1, Gz1 ) ;

[ sourcePos, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

[ L1x, L1y, L1z ] = zefCore.parcellateLeadField (L1x, L1y, L1z, aggregationI, aggregationN, 1)

disp ("Reordering rows of L in xyz order…") ;

L = zefCore.intersperseArray ( [ Lx ; Ly ; Lz ], 1, 3) ;

disp ("Transposing L...")

L = transpose (L) ;

%% Linearization bit.

targetF = 1e5 + eps (1e5) + 1 ;

stepSize = targetF - f1 ;

dfs = [ stepSize, stepSize ] ;

invS1 = S1 \ eye ( size (S1) ) ;

newR1 = zefCore.linearizeResistivityMatrix (R1, A1, B1, T1, invS1, ee1, dfs, 1:2) ;

save("f=" + f1 + "Hz.mat", "-v7.3") ;
