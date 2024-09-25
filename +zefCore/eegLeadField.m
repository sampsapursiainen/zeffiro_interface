function L = eegLeadField ( nodes, tetra, grayMatterI, electrodes, conductivity, kwargs )
%
% L = eegLeadField ( nodes, tetra, grayMatterI, electrodes, conductivity, kwargs )
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
        electrodes                    (:,1) zefCore.ElectrodeSet
        conductivity                  (:,:) double { mustBeFinite }
        kwargs.pcgTol                 (1,1) double { mustBePositive, mustBeFinite }=  1e-6
        kwargs.sourceN                (1,1) double { mustBePositive } = 1000
        kwargs.attachSensorsTo        (1,1) string { mustBeMember(kwargs.attachSensorsTo,["surface","volume"]) } = "volume"
        kwargs.peelingRadius          (1,1) double { mustBeNonnegative, mustBeFinite } = 0
        kwargs.HdivOptimizationMethod (1,1) string { mustBeMember(kwargs.HdivOptimizationMethod,["pbo","mpo"]) } = "pbo"
        kwargs.useGPU                 (1,1) logical = true
    end % arguments

    disp ("Peeling source positions…")

    [ ~, ~, ~, deepTetraI ] = zefCore.peelSourcePositions (nodes, tetra, grayMatterI, kwargs.peelingRadius) ;

    assert ( kwargs.sourceN <= numel (deepTetraI), "You cannot request more sources than there are unpeeled active tetra. The number of unpeeled active tetra is " + numel (deepTetraI) + "." ) ;

    disp ("Positioning sources…")

    [ sourcePos, ~ ] = zefCore.positionSources ( nodes', tetra (deepTetraI,:)', kwargs.sourceN ) ;

    disp("Attaching sensors to the head " + kwargs.attachSensorsTo + "…")

    superNodes = zefCore.SuperNode.fromMeshAndPos (nodes',tetra',electrodes.positions,nodeRadii=electrodes.outerRadii,attachNodesTo=kwargs.attachSensorsTo) ;

    disp("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    disp("Computing volumes of tetra…")

    tetV = zefCore.tetraVolume (nodes,tetra,true) ;

    disp("Computing stiffness matrix components A and A…")

    conductivity = zefCore.reshapeTensor (conductivity) ;

    A = zefCore.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to A…")

    A = zefCore.stiffMatBoundaryConditions ( A, Z, superNodes ) ;

    disp("Computing electrode potential matrix B…")

    B = zefCore.potentialMat ( superNodes, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    C = zefCore.impedanceMat (Z);

    disp("Computing transfer matrix and Schur complement. This will take a while.")

    TM = zefCore.transferMatrix (A,B,tolerances=kwargs.pcgTol,useGPU=true) ;

    SC = ctranspose (B) * TM - C ;

    disp("Computing lead field as the product of Schur complement and transpose of transfer matrix…")

    L = SC * transpose ( TM ) ;

    disp ("Generating face-intersecting dipoles.")

    [stensilFI, signsFI, ~, sourceDirectionsFI, sourceLocationsFI, ~] = zefCore.faceIntersectingDipoles ( nodes, tetra , deepTetraI ) ;

    disp ("Generating edgewise dipoles.")

    [stensilEW, signsEW, ~, sourceDirectionsEW, sourceLocationsEW, ~] = zefCore.edgewiseDipoles ( nodes, tetra , deepTetraI ) ;

    disp ("Building interpolation matrix G...")

    G = zefCore.hdivInterpolation ( ...
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

    LG = L * G ;

    disp ("Setting zero potential level as the column means of the lead field components.")

    LGmean = mean (LG,1) ;

    L = LG - LGmean ;

    mf = matfile("newLeeg.mat",Writable=true);

    mf.L = L ;

end % function
