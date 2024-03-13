function L = eegLeadField ( nodes, triangles, electrodes, triA, e2nI, A, params )
%
% L = eegLeadField ( nodes, triangles, electrodes, triA, e2nI, A, params )
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
% - A
%
%   The stiffness matrix related to the finite element mesh, before
%   method-specific boundary conditions have been applied to it.
%
% - params
%
%   Parameters related to the numerical methods of the lead field construction.
%   See core.LeadFieldParams for details.
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
        triangles  (3,:) uint32 { mustBePositive }
        electrodes (:,1) core.ElectrodeSet
        triA       (:,1) double { mustBePositive }
        e2nI       (:,1) double { mustBePositive, mustBeInteger }
        A          (:,:) double { mustBeFinite }
        params     (1,1) core.LeadFieldParams = core.LeadFieldParams
    end % arguments

    % Compute connection between electrodes and nodes.

    nN = size ( nodes, 1 ) ;

    realB = core.potentialMat ( nN, Znum, real ( impedances ), triA, e2nI, triangles ) ;

    if isreal ( electrodes.impedances )

        imagB = sparse ([]) ;

    else

        imagB = core.potentialMat ( nN, Znum, imag ( impedances ), triA, e2nI, triangles ) ;

    end

    % Compute voltages between electrodes.

    realC = core.voltageMat ( real ( impedances ), impedances ) ;

    if isreal ( electrodes.impedances )
        imagC = sparse ([]) ;
    else
        imagC = core.voltageMat ( imag ( impedances ), impedances ) ;
    end

    % Modify stiffness matrix A at the active electrodes via the related boundary conditions.

    A = core.stiffMatBoundaryConditions ( A, Znum, impedances, e2nI, triangles, triA, kwargs ) ;

    % Compute transfer matrix T, a.k.a. the uninterpolated lead field.

    [ realT, realSC ] = core.transferMatrix( ...
        real (A) , ...
        realB , ...
        realC , ...
        tolerances = min ( real ( electrodes.impedances ), 1 ) * params.solver_tolerance ...
    ) ;

    if ~ isreal ( electrodes.impedances )

        [imagT, imagSC, ~] = core.transferMatrix( ...
            imag (A) , ...
            imagB , ...
            imagC , ...
            tolerances = min ( imag ( electrodes.impedances ), 1 ) * params.solver_tolerance ...
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
