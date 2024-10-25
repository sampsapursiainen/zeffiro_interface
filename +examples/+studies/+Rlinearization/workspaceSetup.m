% A script for retrieving values from mf and converting them to a suitable format.

currentTime = datetime("now",Format="yy-MM-dd-hh:mm") ;

currentTimeStr = string (currentTime) ;

f1 = 1e5 ;

sourceN = 1e4 ; % size(tetra,1) ;

projectPath = fullfile ("data", "head_for_R_linearization_f=100000Hz.mat") ;

mf = matfile (projectPath) ;

nodes = mf.nodes / 1e3 ;

tetra = mf.tetra ;

electrodePos1 = mf.s2_points([41,42],:) / 1e3 ; % mf.s2_points([23,27],:) / 1e3;

% electrodePos2 = mf.s2_points([34,48],:) / 1e3 ;

f2 = 1010 ;

contactResistance = 270 ;

newContactResistance = contactResistance + 5e3 ;

doubleLayerResistance = 1e4 ;

capacitance = 1e-7 ;

contactSurfaceRadii = 5e-3 ;

contactSurfaces = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodePos1',nodeRadii=contactSurfaceRadii, attachNodesTo="surface") ;

electrodes = zefCore.ElectrodeSet (contactResistances=contactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=contactSurfaces,frequencies=f1) ;

newElectrodes = zefCore.ElectrodeSet (contactResistances=newContactResistance, doubleLayerResistances=doubleLayerResistance,capacitances=capacitance, contactSurfaces=contactSurfaces,frequencies=f1) ;

conductivity = zefCore.reshapeTensor (mf.sigma(:,1)) ;

eps0 = 8.8541878188e-12 ;

permittivity = zefCore.reshapeTensor (mf.epsilon(:,1)) * eps0;

activeI = mf.brain_ind ;

f1s = electrodes.frequencies ;

f1 = f1s (end) ;

angFreq1 = 2 * pi * f1 ;

admittivity = conductivity + 1i * angFreq1 * permittivity ;

tetraV = zefCore.tetraVolume (nodes, tetra, true) ;

Zs = electrodes.impedances ;

contactSurf1 = electrodes.contactSurfaces ;

iniA = zefCore.stiffnessMat (nodes, tetra, tetraV, admittivity) ;

A = zefCore.stiffMatBoundaryConditions (iniA, Zs, contactSurf1) ;

B = zefCore.potentialMat ( contactSurf1, Zs, size (nodes,1) );

C = zefCore.impedanceMat (Zs);

solverTol = 1e-12 ;

T = zefCore.transferMatrix (A,B,tolerances=solverTol,useGPU=true) ;

S = zefCore.schurComplement (T, ctranspose(B), C) ;

invS = S \ eye ( size (S) ) ;

R = zefCore.resistivityMatrix (T, invS) ;

[Gx, Gy, Gz] = zefCore.tensorNodeGradient (nodes, tetra, tetraV, admittivity, activeI) ;

%% Initial lead field.

[ Lx, Ly, Lz ] = zefCore.tesLeadField ( R, Gx, Gy, Gz ) ;

% [ sourcePos, aggregationN, aggregationI, ~ ] = zefCore.positionSourcesRectGrid (nodes, tetra, activeI, sourceN) ;

[ sourcePos, elementI] = zefCore.positionSources ( nodes', tetra(activeI,:)', sourceN ) ;

% [ pLx, pLy, pLz ] = zefCore.parcellateLeadField (Lx, Ly, Lz, aggregationI, aggregationN, 1) ;

pLx = Lx (elementI,:) ;

pLy = Ly (elementI,:) ;

pLz = Lz (elementI,:) ;

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

disp (newline + "Linearized lead field..." + newline) ;

linR = zefCore.linearizeResistivityMatrix (R, A, B, T, invS, electrodes, newElectrodes, 1:2) ;

[linLx, linLy, linLz] = zefCore.tesLeadField (linR, Gx, Gy, Gz) ;

linpLx = linLx (elementI,:) ;

linpLy = linLy (elementI,:) ;

linpLz = linLz (elementI,:) ;

liniL = zefCore.intersperseArray ( [ linpLx ; linpLy ; linpLz ], 1, 3) ;

linL = transpose (liniL) ;

%% Computing a reference lead field.

disp (newline + "Reference lead field..." + newline)

refZs = newElectrodes.impedances ;

refA = zefCore.stiffMatBoundaryConditions (iniA, refZs, contactSurf1) ;

refB = zefCore.potentialMat ( contactSurf1, refZs, size (nodes,1) );

refC = zefCore.impedanceMat (refZs);

refT = zefCore.transferMatrix (refA,refB,tolerances=solverTol,useGPU=true) ;

refS = zefCore.schurComplement (refT, ctranspose(refB), refC) ;

refInvS = refS \ eye ( size (refS) ) ;

refR = zefCore.resistivityMatrix (refT, refInvS) ;

[refLx, refLy, refLz] = zefCore.tesLeadField (refR, Gx, Gy, Gz) ;

refpLx = refLx (elementI,:) ;

refpLy = refLy (elementI,:) ;

refpLz = refLz (elementI,:) ;

refiL = zefCore.intersperseArray ( [ refpLx ; refpLy ; refpLz ], 1, 3) ;

refL = transpose (refiL) ;

%% Compute lead field deviations.

disp (newline + "Computing lead field deviations…") ;

dlinLandL = linL - L ;

drefLandL = refL - L ;

dlinLandrefL = linL - refL ;

%% Saving results to a file.

save("f=" + f1 + "Hz,r=" + contactSurfaceRadii + "m,Rc=" + contactResistance + "Ω,Rd=" + doubleLayerResistance + "Ω,Cd=" + capacitance + "F,newRc=" + newContactResistance + "Ω,time=" + currentTimeStr + ".mat", "-v7.3") ;
