function L = leadFieldMat (nodes, tetra, sigma, sensors, modality, acI, params)
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
        nodes     (:,3) double                 { mustBeFinite }
        tetra     (:,4) double                 { mustBeFinite, mustBePositive, mustBeInteger }
        sigma     (:,1) double                 { mustBeNonNan mustBeFinite }
        sensors   (:,1)                        { mustBeA(sensors, "core.Sensor") }
        modality  (1,1) core.LeadFieldModality
        acI       (:,1) double                 { mustBeInteger, mustBePositive }
        params    (1,1) core.LeadFieldParams
    end

    import core.LeadFieldModality

    disp("Computing surface triangles of mesh…")

    [ surfTri,~ ] = core.tetraSurfaceTriangles ( tetra,1:size(tetra,1) ) ;

    surfTri = transpose ( surfTri ) ;

    disp ("Indexing surface nodes…")

    surfN = transpose ( nodes (surfTri,:) ) ;

    disp ("Attaching sensors to surface nodes in a global reference…")

    [ ~, e2nI ] = core.attachSensors(sensors.positions',surfN,[]) ;

    s2nI = surfTri (e2nI) ;

    disp ("Computing surface triangle areas…")

    [ triA, ~ ] = core.triangleAreas(nodes',surfTri);

    disp("Computing volumes of tetra…")

    tetV = core.tetraVolume (nodes,tetra,true) ;

    disp("Computing stiffness matrix components reA and imA…")

    [ reA, imA ] = core.stiffnessMat(nodes,tetra,tetV,sigma);

    % Compute uninterpolated lead field.

    if modality == LeadFieldModality.EEG

        L = core.eegLeadField ( nodes, surfTri, sensors, triA, s2nI, reA, imA, pcgTol=params.solver_tolerance ) ;

    elseif modality == LeadFieldModality.MEG

        error ("MEG lead field is currently unimplemented in this module.")

    elseif modality == LeadFieldModality.gMEG

        error ("gMEG lead field is currently unimplemented in this module.")

    elseif modality == LeadFieldModality.tES

        error ("tES lead field is currently unimplemented in this module.")

    elseif modality == LeadFieldModality.EIT && isreal ( sigma )

        error ("EIT lead field is currently unimplemented in this module.")

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
