clc

profile on

disp("Extracting data from zef…")

N = zef.nodes;

T = zef.tetra;

S = zef.sensors(:,1:3)';

sigma = zef.sigma(:,1) + 1i ;

disp("Computing surface triangles of mesh…")

[surfTri,~] = core.tetraSurfaceTriangles(T,1:size(T,1)) ;

surfTri = transpose ( surfTri ) ;

disp("Indexing surface nodes…")

surfN = transpose ( N (surfTri,:) ) ;

disp("Attaching sensors to surface nodes and in a global reference…")

[~, e2nI] = core.attachSensors(S,surfN,[]);

e2nIG = surfTri(e2nI);

disp("Computing surface triangle areas…")

[triA,triAV] = core.triangleAreas(N',surfTri);

disp("Initializing impedances for sensors…")

Z = ones ( 1, size (S,2) ) + 1i ;

reZ = real (Z) ;

imZ = imag (Z) ;

disp("Computing volumes of tetra…")

tetV = core.tetraVolume (N,T,true) ;

disp("Computing stiffness matrix components reA and imA…")

[ reA, imA ] = core.stiffnessMat(N,T,tetV,sigma);

disp("Applying boundary conditions to reA…")

reA = core.stiffMatBoundaryConditions ( reA, real(Z), Z, e2nIG, surfTri, triA ) ;

disp("Applying boundary conditions to imA…")

imA = core.stiffMatBoundaryConditions ( imA, imag(Z), Z, e2nIG, surfTri, triA ) ;

disp("Combining reA and imA diagonally…")

Asize = size (reA) ;

zeromat = spalloc ( Asize(1), Asize(2), 0 ) ;

A = [ reA, zeromat ; zeromat, imA ];

disp("Computing electrode potential matrix B for real and imaginary parts…")

reB = core.potentialMat ( size(N,1), reZ, Z, triA, e2nIG, surfTri );

imB = core.potentialMat ( size(N,1), imZ, Z, triA, e2nIG, surfTri );

disp("Combining reB and imB…")

Bsize = size (reB, 1) ;

zeromat = spalloc ( Bsize, Bsize, 0 ) ;

B = [ reB, zeromat ; zeromat, imB ];

disp("Computing electrode voltage matrix C…")

reC = core.voltageMat (reZ,Z);

imC = core.voltageMat (imZ,Z);

disp("Combining reC and imC…")

Csize = size (reC, 1) ;

zeromat = spalloc ( Csize, Csize, 0 ) ;

C = [ reC, zeromat ; zeromat, imC ];

disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

[ reTM, reSC ] = core.transferMatrix (reA,reB,reC,tolerances=1e-5) ;

disp("Computing transfer matrix and Schur complement for imaginary part. This will take another (long) while.")

[ imTM, imSC ] = core.transferMatrix (imA,imB,imC,tolerances=1e-5) ;

disp("Computing real lead field as the product of Schur complement and transpose of transfer matrix…")

reL = reSC * transpose ( reTM ) ;

disp("Computing imaginary lead field as the product of Schur complement and transpose of transfer matrix…")

imL = imSC * transpose ( imTM ) ;

profile viewer
