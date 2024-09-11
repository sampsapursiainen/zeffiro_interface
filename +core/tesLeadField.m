function [L, R, Gx, Gy, Gz] = tesLeadField ( nodes, tetra, tetV, volumeCurrentI, sourceTetI, electrodes, contactSurfaces, conductivity, kwargs )
%
% [L, R, Gx, Gy, Gz] = tesLeadField ( nodes, tetra, tetV, volumeCurrentI, electrodes, conductivity, kwargs )
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
% - tetV
%
%   The volumes of the tetra.
%
% - volumeCurrentI
%
%   Which elements in the head volume are considered active.
%
% - sourceTetI
%
%   The indices of volumeCurrentI, that actually contain volumetric currents.
%
% - electrodes
%
%   The electrodes the lead field will map potentials to.
%
% - contactSurfaces
%
%   The contact surfaces of the above electrodes.
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
% - Gx, Gy, Gz
%
%  The x-, y- and z-components of a volume current matrix G = -σ∇u.
%
    arguments
        nodes                  (:,3) double { mustBeFinite }
        tetra                  (:,4) double { mustBePositive, mustBeInteger, mustBeFinite }
        tetV                   (:,1) double { mustBePositive, mustBeFinite }
        volumeCurrentI         (1,:) uint32 { mustBePositive }
        sourceTetI             (1,:) uint32 { mustBePositive }
        electrodes             (:,1) core.ElectrodeSet
        contactSurfaces        (:,1) core.SuperNode
        conductivity           (:,:) double { mustBeFinite }
        kwargs.pcgTol          (1,1) double { mustBePositive, mustBeFinite } = 1e-6
        kwargs.attachSensorsTo (1,1) string { mustBeMember(kwargs.attachSensorsTo,["surface","volume"]) } = "volume"
        kwargs.useGPU          (1,1) logical = true
    end % arguments

    disp("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    disp("Computing stiffness matrix components reA and imA…")

    conductivity = core.reshapeTensor (conductivity) ;

    A = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to reA…")

    A = core.stiffMatBoundaryConditions ( A, Z, contactSurfaces ) ;

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    B = core.potentialMat ( contactSurfaces, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    C = core.voltageMat (Z);

    disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

    TM = core.transferMatrix (A,B,tolerances=kwargs.pcgTol,useGPU=kwargs.useGPU) ;

    disp ("Computing resistivity matrix…") ;

    SchurC = (C - ctranspose (B) * TM) ;

    I = eye ( size (SchurC) ) ;

    invSchurC = SchurC \ I ;

    R = TM * invSchurC ;

    disp ("Computing volume currents σ∇ψ…")

    [Gx, Gy, Gz] = core.tensorNodeGradient (nodes, tetra, tetV, conductivity, volumeCurrentI) ;

    disp ("Resricting volume currents to source tetra...")

    Gx = Gx (sourceTetI,:) ;

    Gy = Gy (sourceTetI,:) ;

    Gz = Gz (sourceTetI,:) ;

    disp ("Building lead field components…") ;

    Lx = - Gx * R ;

    Ly = - Gy * R ;

    Lz = - Gz * R ;

    disp ("Reordering rows of L in xyz order…") ;

    L = core.intersperseArray ( [ Lx ; Ly ; Lz ], 1, 3) ;

    L = transpose (L) ;

end % function
