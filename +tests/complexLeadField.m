clc

profile off

profile on

disp("Extracting data from zef…")

N = zef.nodes ;

T = zef.tetra;

S = zef.s2_points (:,1:3)' ;

sigma = zef.sigma (:,1) + 1i ;

disp("Computing surface triangles of mesh…")

surfTri = core.tetraSurfaceTriangles (T) ;

surfTri = transpose ( surfTri ) ;

surfTriA = core.triangleAreas (N', surfTri) ;

disp("Indexing surface nodes…")

surfN = N' ;

disp("Attaching sensors to nodes in a global reference…")

[~, e2nI] = core.attachSensors(S,N',[]);

e2nIG = e2nI ;

disp ("Finding supernodes surrounding electrodes.") ;

sNodes = core.superNodes (T',e2nIG) ;

disp("Computing surface triangle areas for supernodes…")

sNodeA = zeros ( 1, numel (sNodes.surfTri) ) ;

for ii = 1 : numel (sNodeA)
    [triA, ~] = core.triangleAreas (N',sNodes.surfTri {ii}) ;
    sNodeA (ii) = sum (triA) ;
end

disp("Initializing impedances for sensors…")

Z = ones ( 1, size (S,2) ) + 1i ; Z = Z * 1000 ;

reZ = real (Z) ;

imZ = imag (Z) ;

disp("Computing volumes of tetra…")

tetV = core.tetraVolume (N,T,true) ;

disp("Computing stiffness matrix components reA and imA…")

[ reA, imA ] = core.stiffnessMat(N,T,tetV,sigma);

disp("Applying boundary conditions to reA…")

reA = core.stiffMatBoundaryConditions ( reA, reZ, Z, e2nIG, surfTri, surfTriA ) ;

disp("Applying boundary conditions to imA…")

imA = core.stiffMatBoundaryConditions ( imA, imZ, Z, e2nIG, surfTri, surfTriA ) ;

disp("Computing electrode potential matrix B for real and imaginary parts…")

reB = core.potentialMat ( e2nIG, sNodes.tetra, zeros(1,numel(e2nIG)), reZ, Z, size (N,1) );

imB = core.potentialMat ( e2nIG, sNodes.tetra, sNodeA, imZ, Z, size (N,1) );

disp("Computing electrode voltage matrix C…")

reC = core.voltageMat (reZ,Z);

imC = core.voltageMat (imZ,Z);

disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

[ reTM, reSC ] = core.transferMatrix (reA,reB,reC,tolerances=1e-5,useGPU=true) ;

disp("Computing transfer matrix and Schur complement for imaginary part. This will take another (long) while.")

[ imTM, imSC ] = core.transferMatrix (imA,imB,imC,tolerances=1e-5, useGPU=true) ;

disp("Computing real lead field as the product of Schur complement and transpose of transfer matrix…")

reL = reSC * transpose ( reTM ) ;

disp("Computing imaginary lead field as the product of Schur complement and transpose of transfer matrix…")

imL = imSC * transpose ( imTM ) ;

%% Find tetrahedra where dipoles can be placed.

disp ("Peeling active brain layers.")

grayMatterI = zef.brain_ind ;

[ dN, ~, dT, deepTetraI ] = core.peelSourcePositions (N,T,grayMatterI,1) ;

%% Generate dipoles and source Positions, that the dipoles can be interpolated into.

disp ("Generating face-intersecting dipoles.")

[stensilFI, signsFI, sourceMomentsFI, sourceDirectionsFI, sourceLocationsFI, n_of_adj_tetraFI] = core.faceIntersectingDipoles( N, T , deepTetraI ) ;

disp ("Generating edgewise dipoles.")

[stensilEW, signsEW, sourceMomentsEW, sourceDirectionsEW, sourceLocationsEW, n_of_adj_tetraEW] = core.edgewiseDipoles( N, T , deepTetraI ) ;

%% Add interpolation of dipoles to source positions.

disp ("Building interpolation matrix G...")

sourcePos = core.positionSources ( N', T (deepTetraI,:)', numel (deepTetraI) ) ;

G = core.hdivInterpolation ( ...
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

reLGmean = mean (reL,1) ;

imLGmean = mean (imL,1) ;

%% Concatenate the real and imaginary parts as the pages of a single array.

disp ("constructing final L as a 3D array.") ;

L = cat (3,reLGmean, imLGmean) ;

%% View profiler results.

profile viewer
