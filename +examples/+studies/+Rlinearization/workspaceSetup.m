% A script for retrieving values from mf and converting them to a suitable format.

f1 = 1e5 ;

projectPath = fullfile ("data", "head_for_R_linearization.mat") ;

mf = matfile (projectPath) ;

nodes = mf.nodes / 1e3 ;

tetra = mf.tetra ;

electrodePos1 = mf.s2_points([41,42],:) / 1e3 ; % mf.s2_points([23,27],:) / 1e3;

% electrodePos2 = mf.s2_points([34,48],:) / 1e3 ;

f2 = 1010 ;

contactResistance = 270 ;

newContactResistance = contactResistance + 1e3 ;

doubleLayerResistance = 15 ;

capacitance = 1e-7 ;

contactSurfaceRadii = 5e-3 ;

superNodes1 = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodePos1',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

% superNodes2 = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodePos2',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

electrodes = zefCore.ElectrodeSet (contactResistances=contactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=superNodes1,frequencies=f1) ;

newElectrodes = zefCore.ElectrodeSet (contactResistances=newContactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=superNodes1,frequencies=f1) ;

conductivity = zefCore.reshapeTensor (mf.sigma(:,1)) ;

eps0 = 8.8541878188e-12 ;

permittivity = zefCore.reshapeTensor (mf.epsilon(:,1)) * eps0;

activeI = mf.brain_ind ;

f1s = electrodes.frequencies ;

f1 = f1s (end) ;

angFreq1 = 2 * pi * f1 ;

admittivity1 = conductivity + 1i * angFreq1 * permittivity ;

tetraV = zefCore.tetraVolume (nodes, tetra, true) ;

Z1s = electrodes.impedances ;

contactSurf1 = electrodes.contactSurfaces ;

iniA1 = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity1) ;

A1 = zefCore.stiffMatBoundaryConditions (iniA1, Z1s, contactSurf1) ;

B1 = zefCore.potentialMat ( contactSurf1, Z1s, size (nodes,1) );

C1 = zefCore.impedanceMat (Z1s);

solverTol = 1e-8 ;

T1 = zefCore.transferMatrix (A1,B1,tolerances=solverTol,useGPU=true) ;

S1 = zefCore.schurComplement (T1, ctranspose(B1), C1) ;

[Gx1, Gy1, Gz1] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity1, activeI) ;

%%

[ Lx, Ly, Lz, R1 ] = zefCore.tesLeadField ( T1, S1, Gx1, Gy1, Gz1 ) ;

sourceN = 10000 ; % size(tetra,1) ;

[ sourcePos, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

% [ sourcePos, elementI] = zefCore.positionSources ( nodes', tetra(activeI,:)', sourceN ) ;

[ pLx, pLy, pLz ] = zefCore.parcellateLeadField (Lx, Ly, Lz, aggregationI, aggregationN, 1) ;

% pLx = Lx (elementI,:) ;
% pLy = Ly (elementI,:) ;
% pLz = Lz (elementI,:) ;

% pSize = [size(sourcePos,1), 1] ;
%
% pLx = zeros (pSize(1),electrodes.electrodeCount) ;
% pLy = zeros (pSize(1),electrodes.electrodeCount) ;
% pLz = zeros (pSize(1),electrodes.electrodeCount) ;
%
% pLx(:,1) = accumarray ( aggregationI, Lx(:,1), pSize ) ./ aggregationN ;
% pLx(:,2) = accumarray ( aggregationI, Lx(:,2), pSize ) ./ aggregationN ;
%
% pLy(:,1) = accumarray ( aggregationI, Ly(:,1), pSize ) ./ aggregationN ;
% pLy(:,2) = accumarray ( aggregationI, Ly(:,2), pSize ) ./ aggregationN ;
%
% pLz(:,1) = accumarray ( aggregationI, Lz(:,1), pSize ) ./ aggregationN ;
% pLz(:,2) = accumarray ( aggregationI, Lz(:,2), pSize ) ./ aggregationN ;

iL = zefCore.intersperseArray ( [ pLx ; pLy ; pLz ], 1, 3) ;

L = transpose (iL) ;

%% Linearization bit.

invS1 = S1 \ eye ( size (S1) ) ;

newR1 = zefCore.linearizeResistivityMatrix (R1, A1, B1, T1, invS1, electrodes, newElectrodes, 1:2) ;

save("f=" + f1 + "Hz,r=" + contactSurfaceRadii + "m,Rc=" + contactResistance + "Ω.mat", "-v7.3") ;
