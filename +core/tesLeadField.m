function [L, R, G1, G2, G3] = tesLeadField ( nodes, tetra, volumeCurrentI, electrodes, conductivity, kwargs )
%
% [L, R, G1, G2, G3] = tesLeadField ( nodes, tetra, volumeCurrentI, electrodes, conductivity, kwargs )
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
% - R
%
%  A resistivity matrix.
%
% - G1, G2, G3
%
%  The x-, y- and z-components of a volume current matrix G = -σ∇u.
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

    disp("Attaching sensors to the head " + kwargs.attachSensorsTo + "…")

    superNodes = core.SuperNode.fromMeshAndPos (nodes',tetra',electrodes.positions,nodeRadii=electrodes.outerRadii,attachNodesTo=kwargs.attachSensorsTo) ;

    disp("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    disp("Computing volumes of tetra…")

    tetV = core.tetraVolume (nodes,tetra,true) ;

    disp("Computing stiffness matrix components reA and imA…")

    conductivity = core.reshapeTensor (conductivity) ;

    A = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to reA…")

    A = core.stiffMatBoundaryConditions ( A, Z, superNodes ) ;

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    B = core.potentialMat ( superNodes, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    C = core.voltageMat (Z);

    disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

    TM = core.transferMatrix (A,B,C,tolerances=kwargs.pcgTol,useGPU=kwargs.useGPU) ;

    disp ("Computing resistivity matrix…") ;

    SchurC = (C - ctranspose (B) * TM) ;

    I = eye ( size (SchurC) ) ;

    invSchurC = SchurC \ I ;

    R = TM * invSchurC ;

    disp ("Computing volume currents σ∇ψ…")

    [G1, G2, G3] = core.tensorNodeGradient (nodes, tetra, tetV, conductivity, volumeCurrentI) ;

    disp ("Building lead field components…") ;

    G = [ G1 ; G2 ; G3 ] ;

    fullL = - G * R ;

    L = zeros ( numel (electrodes.impedances), 3 * kwargs.sourceN ) ;

    disp ("Restricting lead field to actual source positions…")

    Nvc = numel (volumeCurrentI) ;

    fullL = transpose (fullL) ;

    L (:,1:3:end,:) = fullL (:,sourceTetI) ;
    L (:,2:3:end,:) = fullL (:,Nvc + sourceTetI) ;
    L (:,3:3:end,:) = fullL (:,2 * Nvc + sourceTetI) ;

    mf = matfile ("newLtes.mat", Writable=true);

    mf.G1 = G1 ;
    mf.G2 = G2;
    mf.G3 = G3;
    mf.L = L ;

end % function
