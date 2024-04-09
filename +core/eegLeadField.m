function L = eegLeadField ( nodes, tetra, grayMatterI, electrodes, conductivity, kwargs )
%
% L = eegLeadField ( nodes, tetra, electrodes, kwargs )
%
% Computes an uninterpolated elecroencephalography lead field matrix.
%
% Inputs:
%
% - nodes
%
%   The finite element nodes.
%
% - tetra
%
%   The surface tetra that the electrodes are attached to.
%
% - grayMatterI
%
%   Which elements in the head volume are considered active.
%
% - electrodes
%
%   The electrodes the lead field will map potentials to.
%
% - conductivity
%
%   A 3D conductivity tensor, encoded wither as a 1×Ntetra vector in the
%   isotrophiv case, or as a 6×Ntetra matrix in the anisotrophic case, with
%   each column containing the values σxx, σyy, σzz, σxy, σxz and σyz.
%
% - kwargs.pcgTol
%
%   Relative residual tolerance of the PCG solver that is used to construct a transfer matrix.
%
% - kwargs.sourceN
%
%   The number of source locations one wishes to generate.
%
% - kwargs.attachSensorsTo ∈ {"volume","surface"}
%
%   Whether to attach sensors to the entire volume, or just the surface of a
%   head model.
%
% - kwargs.peelingRadius = 0
%
%   The distance from active compartment surfaces, within which source
%   positions are not allowed.
%
% - kwargs.HdivOptimizationMethod ∈ {"pbo","mpo"} = "pbo"
%
%   Whether to use Position-Based Optimization or Mean Position and Orientation
%   as a means of interpolating dipoles to source positions.
%
% Outputs:
%
% - L
%
%   The EEG lead field. If the impedances Z of the electrodes were complex,
%   this will contain 2 pages: the first contains a lead field corresponding to
%   the real part and the second page will correspond to the imaginary part of
%   Z.
%
    arguments
        nodes                         (:,3) double { mustBeFinite }
        tetra                         (:,4) double { mustBePositive, mustBeInteger, mustBeFinite }
        grayMatterI                   (1,:) uint32 { mustBePositive }
        electrodes                    (:,1) core.ElectrodeSet
        conductivity                  (:,:) double { mustBeFinite }
        kwargs.pcgTol                 (1,1) double { mustBePositive, mustBeFinite }=  1e-6
        kwargs.sourceN                (1,1) double { mustBePositive } = 1000
        kwargs.attachSensorsTo        (1,1) string { mustBeMember(kwargs.attachSensorsTo,["surface","volume"]) } = "volume"
        kwargs.peelingRadius          (1,1) double { mustBeNonnegative, mustBeFinite } = 0
        kwargs.HdivOptimizationMethod (1,1) string { mustBeMember(kwargs.HdivOptimizationMethod,["pbo","mpo"]) } = "pbo"
    end % arguments

    disp("Attaching sensors to the head " + kwargs.attachSensorsTo + "…")

    if kwargs.attachSensorsTo == "volume"

        [~, superNodeCenters] = core.attachSensors (electrodes.positions,nodes',[]);

    else

        % First find head surface triangles and their coordinates.

        surfTri = transpose ( core.tetraSurfaceTriangles (tetra) ) ;

        surfTriCoords = transpose ( nodes (surfTri,:) ) ;

        % Then attach sensors to surface triangles and map the result to global nodal indices.

        [~, superNodeCenters] = core.attachSensors (electrodes.positions, surfTriCoords, []);

        superNodeCenters = surfTri (superNodeCenters) ;

    end % if

    disp ("Finding electrode--head contact surfaces…") ;

    sNodes = core.superNodes (tetra',superNodeCenters,radii=electrodes.outerRadii,nodes=nodes) ;

    sNodeA = zeros ( 1, numel (sNodes.surfTri) ) ;

    for ii = 1 : numel (sNodeA)
        [triA, ~] = core.triangleAreas (nodes',sNodes.surfTri {ii}) ;
        sNodeA (ii) = sum (triA) ;
    end

    disp("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    reZ = real (Z) ;

    imZ = imag (Z) ;

    % Handle the real case.

    reZ (imZ == 0) = 1 ;

    imZ (imZ == 0) = 1 ;

    disp("Computing volumes of tetra…")

    tetV = core.tetraVolume (nodes,tetra,true) ;

    disp("Computing stiffness matrix components reA and imA…")

    [ reA, imA ] = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    nonEmptyImA = nnz (imA) > 0 ;

    disp("Applying boundary conditions to reA…")

    reA = core.stiffMatBoundaryConditions ( reA, reZ, Z, superNodeCenters, sNodes.surfTri, sNodeA ) ;

    if nonEmptyImA

        disp("Applying boundary conditions to imA…")

        imA = core.stiffMatBoundaryConditions ( imA, imZ, Z, superNodeCenters, sNodes.surfTri, sNodeA ) ;

    end

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    reB = core.potentialMat ( superNodeCenters, sNodes.tetra, sNodeA, reZ, Z, size (nodes,1) );

    imB = core.potentialMat ( superNodeCenters, sNodes.tetra, sNodeA, imZ, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    reC = core.voltageMat (reZ,Z);

    imC = core.voltageMat (imZ,Z);

    disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

    [ reTM, reSC ] = core.transferMatrix (reA,reB,reC,tolerances=1e-6,useGPU=true) ;

    if nonEmptyImA

        disp("Computing transfer matrix and Schur complement for imaginary part. This will take another (long) while.")

        [ imTM, imSC ] = core.transferMatrix (imA,imB,imC,tolerances=1e-6, useGPU=true) ;

    else

        imTM = [] ;
        imSC = [] ;

    end

    disp("Computing real lead field as the product of Schur complement and transpose of transfer matrix…")

    reL = reSC * transpose ( reTM ) ;

    disp("Computing imaginary lead field as the product of Schur complement and transpose of transfer matrix…")

    imL = imSC * transpose ( imTM ) ;

    disp ("Peeling source positions…")

    [ ~, ~, ~, deepTetraI ] = core.peelSourcePositions (nodes, tetra, grayMatterI, kwargs.peelingRadius) ;

    disp ("Generating face-intersecting dipoles.")

    [stensilFI, signsFI, ~, sourceDirectionsFI, sourceLocationsFI, ~] = core.faceIntersectingDipoles ( nodes, tetra , deepTetraI ) ;

    disp ("Generating edgewise dipoles.")

    [stensilEW, signsEW, ~, sourceDirectionsEW, sourceLocationsEW, ~] = core.edgewiseDipoles ( nodes, tetra , deepTetraI ) ;

    disp ("Building interpolation matrix G...")

    sourcePos = core.positionSources ( nodes', tetra (deepTetraI,:)', kwargs.sourceN ) ;

    G = core.hdivInterpolation ( ...
        deepTetraI, ...
        transpose (sourcePos), ...
        kwargs.HdivOptimizationMethod, ...
        stensilFI, ...
        signsFI, ...
        sourceDirectionsFI, ...
        sourceLocationsFI, ...
        stensilEW, ...
        signsEW, ...
        sourceDirectionsEW, ...
        sourceLocationsEW ...
    ) ;

    disp ("Applying G to the real an imaginary parts of the lead field.") ;

    reLG = reL * G ;

    if isempty (imL)

        imLG = [] ;

    else

        imLG = imL * G ;

    end

    disp ("Setting zero potential level as the column means of the lead field components.")

    reLGmean = mean (reLG,1) ;

    imLGmean = mean (imLG,1) ;

    reLGM = reLG - reLGmean ;

    imLGM = imLG - imLGmean ;

    disp ("constructing final L as a 3D array.") ;

    L = cat (3,reLGM, imLGM) ;

end % function
