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

surfN = N' ; % transpose ( N (surfTri,:) ) ;

disp("Attaching sensors to nodes in a global reference…")

[~, e2nI] = core.attachSensors(S,N',[]);

e2nIG = e2nI ; % surfTri(e2nI);

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

[ dN, ~, dT, dtI ] = core.peelSourcePositions (N,T,grayMatterI,1) ;

%% Generate dipoles and source Positions, that the dipoles can be interpolated into.

disp ("Generating face-intersecting dipoles.")

[stensilFI, signsFI, sourceMomentsFI, sourceDirectionsFI, sourceLocationsFI, n_of_adj_tetraFI] = core.faceIntersectingDipoles( N, T , dtI ) ;

disp ("Generating edgewise dipoles.")

[stensilEW, signsEW, sourceMomentsEW, sourceDirectionsEW, sourceLocationsEW, n_of_adj_tetraEW] = core.edgewiseDipoles( N, T , dtI ) ;

%% Add interpolation of dipoles to source positions.

disp ("Building interpolation matrix...")

warning off

[G,sourcePos] = core.hdivInterpolation ( ...
    N, ...
    T, ...
    dtI, ...
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

warning on

%%

profile viewer
