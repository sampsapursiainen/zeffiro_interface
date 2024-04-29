function L = tesLeadField ( nodes, tetra, volumeCurrentI, electrodes, conductivity, kwargs )
%
% L = tesLeadField ( nodes, tetra, volumeCurrentI, electrodes, conductivity, kwargs )
%
% Computes an uninterpolated transcranial electrical stimulation (tES) lead field matrix.
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
% - volumeCurrentI
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
        nodes                  (:,3) double { mustBeFinite }
        tetra                  (:,4) double { mustBePositive, mustBeInteger, mustBeFinite }
        volumeCurrentI         (1,:) uint32 { mustBePositive }
        electrodes             (:,1) core.ElectrodeSet
        conductivity           (:,:) double { mustBeFinite }
        kwargs.pcgTol          (1,1) double { mustBePositive, mustBeFinite } = 1e-6
        kwargs.attachSensorsTo (1,1) string { mustBeMember(kwargs.attachSensorsTo,["surface","volume"]) } = "volume"
        kwargs.useGPU          (1,1) logical = true
        kwargs.sourceN         (1,1) double { mustBePositive } = 1000
    end % arguments

    disp ("Positioning sources…")

    [ ~, sourceTetI ] = core.positionSources ( nodes', tetra (volumeCurrentI,:)', kwargs.sourceN ) ;

    volumeCurrentI = volumeCurrentI (sourceTetI) ;

    disp("Attaching sensors to the head " + kwargs.attachSensorsTo + "…")

    superNodes = core.SuperNode.fromMeshAndPos (nodes',tetra',electrodes.positions,nodeRadii=electrodes.outerRadii,attachNodesTo=kwargs.attachSensorsTo) ;

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

    conductivity = core.reshapeTensor (conductivity) ;

    [ reA, imA ] = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    nonEmptyImA = nnz (imA) > 0 ;

    disp("Applying boundary conditions to reA…")

    reA = core.stiffMatBoundaryConditions ( reA, reZ, Z, superNodes ) ;

    if nonEmptyImA

        disp("Applying boundary conditions to imA…")

        imA = core.stiffMatBoundaryConditions ( imA, imZ, Z, superNodes ) ;

    end

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    reB = core.potentialMat ( superNodes, reZ, Z, size (nodes,1) );

    imB = core.potentialMat ( superNodes, imZ, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    reC = core.voltageMat (reZ,Z);

    imC = core.voltageMat (imZ,Z);

    disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

    [ reTM, reSC ] = core.transferMatrix (reA,reB,reC,tolerances=kwargs.pcgTol,useGPU=kwargs.useGPU) ;

    if nonEmptyImA

        disp("Computing transfer matrix and Schur complement for imaginary part. This will take another (long) while.")

        [ imTM, imSC ] = core.transferMatrix (imA,imB,imC,tolerances=kwargs.pcgTol, useGPU=kwargs.useGPU) ;

    else

        imTM = [] ;
        imSC = [] ;

    end

    disp ("Computing resistivity matrix…") ;

    reSchurC = (reSC - transpose (reB) * reTM) ;

    reI = eye ( size (reSchurC) ) ;

    invReSchurC = reSchurC \ reI ;

    reR = reTM * invReSchurC ;

    if nonEmptyImA

        imSchurC = (imSC - transpose (imB) * imTM) ;

        imI = eye ( size (imSchurC) ) ;

        invImSchurC = imSchurC \ imI ;

        imR = imTM * invImSchurC ;

    else

        imR = [] ;

    end

    disp ("Computing volume currents σ∇ψ…")

    [G1, G2, G3] = core.tensorNodeGradient (nodes, tetra, tetV, conductivity, volumeCurrentI) ;

    disp ("Building lead field components…") ;

    G = [ G1 ; G2 ; G3 ] ;

    reL = G * reR ;

    if isempty (imR)

        imL = [] ;

    else

        imL = G * imR ;

    end

    disp ("Constructing final L as a 3D array…") ;

    L = pagetranspose ( cat (3,reL,imL) );

end % function
