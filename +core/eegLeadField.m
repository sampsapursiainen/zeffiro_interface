function L = eegLeadField ( nodes, triangles, electrodes, triA, e2nI, realA, imagA, kwargs )
%
% L = eegLeadField ( nodes, triangles, electrodes, triA, e2nI, realA, imagA, kwargs )
%
% Computes an uninterpolated elecroencephalography lead field matrix.
%
% Inputs:
%
% - nodes
%
%   The finite element nodes.
%
% - triangles
%
%   The surface triangles that the electrodes are attached to.
%
% - electrodes
%
%   The electrodes the lead field will map potentials to.
%
% - triA
%
%   Areas of the surface triangles touching the electrodes.
%
% - e2nI
%
%   An index set that maps electrodes to nodes.
%
% - realA
%
%   Real part of a stiffness matrix.
%
% - imagA
%
%   Imaginary part of a stiffness matrix.
%
% - kwargs.pcgTol
%
%   Relative residual tolerance of the PCG solver that is used to construct a transfer matrix.
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
        nodes         (:,3) double { mustBeFinite }
        triangles     (3,:) uint32 { mustBePositive }
        electrodes    (:,1) core.ElectrodeSet
        triA          (:,1) double { mustBePositive }
        e2nI          (:,1) double { mustBePositive, mustBeInteger }
        realA         (:,:) double { mustBeFinite }
        imagA         (:,:) double { mustBeFinite }
        kwargs.pcgTol (1,1) core.LeadFieldParams = 1e-5
    end % arguments

    disp ("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    reZ = real (Z) ;

    imZ = imag (Z) ;

    disp ("Applying boundary conditions to realA…")

    realA = core.stiffMatBoundaryConditions ( realA, reZ, Z, s2nI, surfTri, triA ) ;

    if not ( isreal ( Z ) )

        disp ("Applying boundary conditions to imagA…")

        imagA = core.stiffMatBoundaryConditions ( imagA, imZ, Z, s2nI, surfTri, triA ) ;

    end

    disp ("Compute connection between electrodes and nodes.")

    nN = size ( nodes, 1 ) ;

    realB = core.potentialMat ( nN, reZ, Z, triA, e2nI, triangles ) ;

    imagB = core.potentialMat ( nN, imZ, Z, triA, e2nI, triangles ) ;

    disp ("Compute voltages between electrodes.")

    realC = core.voltageMat ( reZ, Z ) ;

    imagC = core.voltageMat ( imZ, Z ) ;

    % Compute transfer matrix T, a.k.a. the uninterpolated lead field.

    [ realT, realSC ] = core.transferMatrix( ...
        realA , ...
        realB , ...
        realC , ...
        tolerances = min ( reZ, 1 ) * kwargs.pcgTol ...
    ) ;

    if not ( isreal ( Z ) )

        [ imagT, imagSC ] = core.transferMatrix( ...
            imagA , ...
            imagB , ...
            imagC , ...
            tolerances = min ( imZ, 1 ) * kwargs.pcgTol ...
        ) ;

    else

        imagT = [] ;

        imagSC = [] ;

    end

    % Compute the uninterpolated and un-potential-adjusted EEG lead field. The
    % Schur complement propagates each local solution near the electrodes to
    % the global space.

    realL = realSC * realT' ;

    imagL = imagSC * imagT' ;

    L = cat ( 3, realL, imagL ) ;

end % function
