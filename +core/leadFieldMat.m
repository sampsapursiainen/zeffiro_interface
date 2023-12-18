function L = leadFieldMat (nodes, tetra, sigma, sensors, modality, triA, s2nI, t2nI, acI, params)
%
% L = leadFieldMat (nodes, tetra, sigma, sensors, modality, triA, s2nI, t2nI, params)
%
% Computes a lead field L of a given modality.
%
% Inputs:
%
% - nodes
%
%   Finite element nodes.
%
% - tetra
%
%   Tetrahedral finite elements.
%
% - sigma
%
%   A parameter such as conductivity, related to the individual elements.
%
% - sensors
%
%   A set of sensors. Must be a subclass of Sensor.
%
% - modality
%
%   One of "EEG", "MEG", "gMEG", "EIT" or "tES".
%
% - triA
%
%   Areas of the triangles that are associated with electrodes.
%
% - s2nI
%
%   An index set mapping sensors to nodes.
%
% - t2nI
%
%   An index set mapping triangles to the nodes that are associated with
%   electrodes.
%
% - acI
%
%   Active compartment index set. Contains the indices of the tetra that belong
%   to active compartments.
%
% - params
%
%   Other parameters related to lead field consruction.
%
% Outputs:
%
% - L
%
%   The set of lead field matrices. If complex sigma was given as input, the
%   output is a 3D array with the lead field corresponding to the real part of
%   sigma as the first page, and the imaginary part as the second page.
%
%   As the parameters related to the sensors such as impedances might also be
%   complex, this array might contain additional pages corresponsing to these.
%   The the lead field corresponding to the real part of sensor parameters is
%   always on the odd page, and the imaginary part on an even page. First come
%   the real parts and then the imaginary parts.
%

    arguments
        nodes    (:,3) double                 { mustBeFinite }
        tetra    (:,4) double                 { mustBeFinite, mustBePositive, mustBeInteger }
        sigma    (:,1) double                 { mustBeNonNan mustBeFinite }
        sensors  (:,1)                        { mustBeA(sensors, "core.Sensor") }
        modality (1,1) core.LeadFieldModality
        triA     (:,1) double                 { mustBeFinite, mustBePositive }
        s2nI     (:,1) double                 { mustBeInteger, mustBePositive }
        t2nI     (:,1) double                 { mustBeInteger, mustBePositive }
        acI      (:,1) double                 { mustBeInteger, mustBePositive }
        params   (1,1) core.LeadFieldParams
    end

    import core.LeadFieldModality

    % Compute volumes of the tetrahedra.

    tetraV = core.tetraVolume(nodes, tetra, true);

    % Compute stiffness matrix.

    if isreal ( sigma )

        realA = core.stiffnessMat ( nodes, tetra, tetraV, sigma ) ;
        imagA = sparse ([]) ;

    else

        realA = core.stiffnessMat ( nodes, tetra, tetraV, real(sigma) ) ;
        imagA = core.stiffnessMat ( nodes, tetra, tetraV, imag(sigma) ) ;

    end

    % Compute uninterpolated lead field.

    if modality == LeadFieldModality.EEG && isreal ( sigma )

        realL = core.eegLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = [] ;

    elseif modality == LeadFieldModality.EEG

        realL = core.megLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = core.megLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, imagA ) ;

    elseif modality == LeadFieldModality.MEG && isreal ( sigma )

        realL = core.megLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = [] ;

    elseif modality == LeadFieldModality.MEG

        realL = core.megLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = core.megLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, imagA ) ;

    elseif modality == LeadFieldModality.gMEG && isreal ( sigma )

        realL = core.eegLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = [] ;

    elseif modality == LeadFieldModality.gMEG

        realL = core.gMegLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = core.gMegLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, imagA ) ;

    elseif modality == LeadFieldModality.tES && isreal ( sigma )

        realL = core.tesLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = [] ;

    elseif modality == LeadFieldModality.tES

        realL = core.tesLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = core.tesLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, imagA ) ;

    elseif modality == LeadFieldModality.EIT && isreal ( sigma )

        realL = core.eitLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = [] ;

    elseif modality == LeadFieldModality.EIT

        realL = core.eitLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, realA ) ;
        imagL = core.eitLeadField ( nodes, tetra, sensors, triA, s2nI, t2nI, imagA ) ;

    else

        error ( "Unknown lead field modality " + modality ) ;

    end

    % Peel off unwanted tetra.

    peeledI = core.peelSourcePositions ( nodes, tetra, acI, params.acceptable_source_depth ) ;

    % Then build a dipole interpolation matrix.

    [interpM, ~] = core.leadFieldInterpolation ( ...
        nodes, ...
        tetra, ...
        acI, ...
        params.source_model, ...
        peeledI, ...
        [], ... nearest neighbour indices, that were supposed to be used with "continuous" source models.
        params.optimization_system_type, ...
        regparam ...
    ) ;

    realL = pagemtimes ( realL, interpM );
    imagL = pagemtimes ( imagL, interpM );

    L = cat ( 3, realL, imagL ) ;

end % function
