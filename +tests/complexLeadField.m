clc

profile off

profile on

disp("Extracting data from zef…")

powOfTen = 1e-3 ;

N = zef.nodes * powOfTen ;

T = zef.tetra;

S = zef.s2_points (:,1:3)' * powOfTen ;

sigma = zef.sigma (:,1) + 1i ;

disp("Indexing surface nodes…")

surfN = N' ;

disp("Attaching sensors to nodes in a global reference…")

[~, superNodeCenters] = zefCore.attachSensors(S,N',[]);

disp ("Finding supernodes surrounding electrodes.") ;

sNodes = zefCore.superNodes (T',superNodeCenters) ;

disp("Computing surface triangle areas for supernodes…")

sNodeA = zeros ( 1, numel (sNodes.surfTri) ) ;

for ii = 1 : numel (sNodeA)
    [triA, ~] = zefCore.triangleAreas (N',sNodes.surfTri {ii}) ;
    sNodeA (ii) = sum (triA) ;
end

disp("Initializing impedances for sensors…")

Z = ones ( 1, size (S,2) ) + 1i ; Z = Z * 1000 ;

reZ = real (Z) ;

imZ = imag (Z) ;

disp("Computing volumes of tetra…")

tetV = zefCore.tetraVolume (N,T,true) ;

disp("Computing stiffness matrix components reA and imA…")

[ reA, imA ] = zefCore.stiffnessMat(N,T,tetV,sigma);

disp("Applying boundary conditions to reA…")

reA = zefCore.stiffMatBoundaryConditions ( reA, reZ, Z, superNodeCenters, sNodes.surfTri, sNodeA ) ;

disp("Applying boundary conditions to imA…")

imA = zefCore.stiffMatBoundaryConditions ( imA, imZ, Z, superNodeCenters, sNodes.surfTri, sNodeA ) ;

disp("Computing electrode potential matrix B for real and imaginary parts…")

reB = zefCore.potentialMat ( superNodeCenters, sNodes.tetra, sNodeA, reZ, Z, size (N,1) );

imB = zefCore.potentialMat ( superNodeCenters, sNodes.tetra, sNodeA, imZ, Z, size (N,1) );

disp("Computing electrode voltage matrix C…")

reC = zefCore.impedanceMat (reZ,Z);

imC = zefCore.impedanceMat (imZ,Z);

disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

[ reTM, reSC ] = zefCore.transferMatrix (reA,reB,reC,tolerances=1e-6,useGPU=true) ;

disp("Computing transfer matrix and Schur complement for imaginary part. This will take another (long) while.")

[ imTM, imSC ] = zefCore.transferMatrix (imA,imB,imC,tolerances=1e-6, useGPU=true) ;

disp("Computing real lead field as the product of Schur complement and transpose of transfer matrix…")

reL = reSC * transpose ( reTM ) ;

disp("Computing imaginary lead field as the product of Schur complement and transpose of transfer matrix…")

imL = imSC * transpose ( imTM ) ;

%% Find tetrahedra where dipoles can be placed.

disp ("Peeling active brain layers.")

grayMatterI = zef.brain_ind ;

[ dN, ~, dT, deepTetraI ] = zefCore.peelSourcePositions (N,T,grayMatterI,1 * powOfTen) ;

%% Generate dipoles and source Positions, that the dipoles can be interpolated into.

disp ("Generating face-intersecting dipoles.")

[stensilFI, signsFI, sourceMomentsFI, sourceDirectionsFI, sourceLocationsFI, n_of_adj_tetraFI] = zefCore.faceIntersectingDipoles( N, T , deepTetraI ) ;

disp ("Generating edgewise dipoles.")

[stensilEW, signsEW, sourceMomentsEW, sourceDirectionsEW, sourceLocationsEW, n_of_adj_tetraEW] = zefCore.edgewiseDipoles( N, T , deepTetraI ) ;

%% Add interpolation of dipoles to source positions.

disp ("Building interpolation matrix G...")

sourcePos = zefCore.positionSources ( N', T (deepTetraI,:)', numel (deepTetraI) ) ;

G = zefCore.hdivInterpolation ( ...
    deepTetraI, ...
    transpose (sourcePos), ...
    "pbo", ...
    stensilFI, ...
    signsFI, ...
    sourceDirectionsFI, ...
    sourceLocationsFI, ...
    stensilEW, ...
    signsEW, ...
    sourceDirectionsEW, ...
    sourceLocationsEW ...
) ;

%% Interpolate real and imaginary lead fields to source positions.

disp ("Applying G to the real an imaginary parts of the lead field.") ;

reLG = reL * G ;

imLG = imL * G ;

%% Set reference potential level by subtracting column means from the lead fields.

disp ("Setting zero potential level as the column means of the lead field components.")

reLGmean = mean (reLG,1) ;

imLGmean = mean (imLG,1) ;

reLGM = reLG - reLGmean ;

imLGM = imLG - imLGmean ;

%% Concatenate the real and imaginary parts as the pages of a single array.

disp ("constructing final L as a 3D array.") ;

L = cat (3,reLGM, imLGM) ;

%% View profiler results.

profile viewer
