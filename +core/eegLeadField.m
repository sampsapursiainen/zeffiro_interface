function L = eegLeadField ( nodes, tetra, electrodes, triA, e2nI, t2nI, A, params )
%
% L = eegLeadField ( nodes, tetra, electrodes, triA, e2nI, t2nI, A, params )
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
%   The finite elements.
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
% - t2nI
%
%   An index set that maps surface triangles to nodes.
%
% - A
%
%   The stiffness matrix related to the finite element mesh, before
%   method-specific boundary conditions have been applied to it.
%
% - params
%
%   Parameters not directly related to th
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
        nodes      (:,3) double { mustBeFinite }
        tetra      (:,4) double { mustBePositive, mustBeInteger }
        electrodes (:,1) core.ElectrodeSet
        triA       (:,1) double { mustBePositive }
        e2nI       (:,1) double { mustBePositive, mustBeInteger }
        t2nI       (:,1) double { mustBePositive, mustBeInteger }
        A          (:,:) double { mustBeFinite }
        params     (1,1) core.LeadFieldParams = core.LeadFieldParams
    end % arguments

    % Compute connection between electrodes and nodes.

    nN = size ( nodes, 1 ) ;

    eA = electrodes.areas ;

    realB = core.potentialMat ( nN, real ( electrodes.impedances ), electrodes.impedances, triA, eA, e2nI, t2nI ) ;

    if isreal ( electrodes.impedances )

        imagB = sparse ([]) ;

    else

        imagB = core.potentialMat ( nN, imag ( electrodes.impedances ), electrodes.impedances, triA, eA, e2nI, t2nI ) ;

    end

    % Compute voltages between electrodes.

    realC = core.voltageMat ( real ( impedances ), impedances ) ;

    if isreal ( electrodes.impedances )
        imagC = sparse ([]) ;
    else
        imagC = core.voltageMat ( imag ( impedances ), impedances ) ;
    end

    % Modify stiffness matrix A at the active electrodes via the related boundary conditions.

    A = core.stiffMatBoundaryConditions ( A, e2nI, t2nI, triangles, triA ) ;

    % Compute transfer matrix T, a.k.a. the uninterpolated lead field.

    nE = numel ( impedances ) ;

    if all ( isinf ( electrodes.impedances ) )
        electrode_model = "PEM" ;
    else
        electrode_model = "CEM" ;
    end

    realSchurExpr = @(Tcol, ind) realB'* Tcol - realC(:,ind);

    impedance_inf = all ( isinf ( electrodes.impedances ) ) ;

    [realT, realSC, ~] = core.transferMatrix( ...
        A , ...
        realB , ...
        realC , ...
        nN , ...
        nE , ...
        electrode_model , ...
        real ( electrodes.impedances ) , ...
        impedance_inf , ...
        realSchurExpr, ...
        permutation= params.permutation, ...
        precond=params.precond , ...
        tol_val=params.tol_val , ...
        m_max=params.m_max ...
    ) ;

    if ~ isreal ( electrodes.impedances )

        imagSchurExpr = @(Tcol, ind) imagB'* Tcol - imagC(:,ind);

        [imagT, imagSC, ~] = core.transferMatrix( ...
            A , ...
            imagB , ...
            imagC , ...
            nN , ...
            nE , ...
            electrode_model , ...
            imag ( electrodes.impedances ) , ...
            impedance_inf , ...
            imagSchurExpr, ...
            permutation= params.permutation, ...
            precond=params.precond , ...
            tol_val=params.tol_val , ...
            m_max=params.m_max ...
        ) ;

    else

        imagT = [] ;
        imagSC = [] ;

    end

    % Compute the uninterpolated and un-potential-adjusted EEG lead field. The
    % Schur complement propagates each local solution to the global space.

    realL = realSC * realT' ;

    imagL = imagSC * imagT' ;

    L = cat ( 3, realL, imagL ) ;

end % function