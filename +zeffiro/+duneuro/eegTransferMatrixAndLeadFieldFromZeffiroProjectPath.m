function [eegT, eegL, finalElectrodePositions] = eegTransferMatrixAndLeadFieldFromZeffiroProjectPath(kwargs)
%
%   [eegT, eegL, finalElectrodePositions] = eegTransferMatrixAndLeadFieldFromZeffiroProjectPath(kwargs)
%
% Loads data from a given Zeffiro Project file and computes
% an EEG transfer matrix using the duneuro-matlab library.
% Also returns the related EEG lead field of size electrodes
% times sources times 3.
%
% Supposes that duneuro-matlab has been installed in a MATLAB
% package +duneuro somewhere on your MATLAB path.
%
% Arguments:
%
%    kwargs.projectFilePath (1,1) string { mustBeFile }
%
%   kwargs.eegT (:,:) double { mustBeFinite } = []
%
% A transfer matrix related to the geometry, source and sensor positions in the given project file.
% This takes precedence over other eegT arguments if not empty.
%
%   kwargs.eegTFilePath (1,1) string = ""
%
% The transfer matrix file path related to the geometry, source and sensor positions in the given project file.
% This is used if kwargs.eegT was not given and this points to an existing .mat file.
%
% A path to the Zeffiro project file
%
%    kwargs.electrodeFieldName (1,1) string = "sensors"
%
% A field name of the electrode positions stored in the project file.
%
%    kwargs.sourceModel (1,:) char = 'whitney'
%
% The source model used by DUNEUro. We use the H(div) source model here to
% match that of Zeffiro, but another good option is 'local_subtraction'.
%
%    kwargs.sourcePositions (3,:) double { mustBeFinite } = []
%
% If this is not empty, it will be used as the set of source positions
% instead of loading the positions from the project file.
%
%    kwargs.electrodePositions (3,:) double { mustBeFinite } = []
%
% If this is not empty, it will be used as the set of electrode positions
% instead of loading the electrode positions from the project file.
%
%    kwargs.saveFilePrefix (1,1) string = ""
%
% If this is non-empty, the transfer matrix is also automatically saved to a file.
% The current time and the used source model are appended to the file path prefix.
%
%   kwargs.electrodeTranslationVector (1,3) double { mustBeFinite } = [0 0 0]
%
% A vector for translating the electrodes found in the given project file.
% The default position is sometimes a bit off.
%
%   kwargs.skinCompartmentIndex (1,1) double { mustBeInteger  } = 0
%
% If this is given and positive, the electrodes will be projected to the nearest points
% on surface mesh of the skin after translation by electrodeTranslationVector,
% before the transfer matrix computation starts.
%
    arguments (Input)
        kwargs.projectFilePath (1,1) string { mustBeFile }
        kwargs.eegT (:,:) double { mustBeFinite } = []
        kwargs.eegTFilePath (1,1) string = ""
        kwargs.sourceModel (1,:) char = 'whitney'
        kwargs.sourcePositions (3,:) double { mustBeFinite } = []
        kwargs.electrodePositions (3,:) double { mustBeFinite } = []
        kwargs.electrodeFieldName (1,1) string = "sensors"
        kwargs.electrodeTranslationVector (1,3) double { mustBeFinite } = [0 0 0]
        kwargs.saveFilePrefix (1,1) string = ""
        kwargs.skinCompartmentIndex (1,1) double { mustBeInteger } = 0
    end

    arguments (Output)
        eegT (:,:) double { mustBeFinite }
        eegL (:,:,:) double { mustBeFinite }
        finalElectrodePositions (3,:) double { mustBeFinite }
    end

    currentTime = datetime("now", Format="yyyy-MM-dd-HH-mm-ss-SSS") ;

    disp("Opening file handle...")

    projectFileHandle = matfile(kwargs.projectFilePath) ;

    % Note that we transpose everything loaded from the Zeffiro Project file,
    % because DUNEuro stores individual elements and such in column major order
    % due to CPU cache efficiency reasons.

    disp("Loading mesh points...")

    meshPoints = transpose(projectFileHandle.nodes) ;

    disp("Loading mesh elements...")

    elements = transpose(projectFileHandle.tetra) - 1 ; % Subtract 1 here because of DUNEuro's 0-based indexing.

    disp("Loading mesh labels...")

    labels = transpose(projectFileHandle.domain_labels) ;

    disp("Loading mesh conductivity...")

    conductivity = projectFileHandle.sigma ;

    disp("Checking conductivity size...")

    [~, conductivityColN] = size(conductivity) ;

    if conductivityColN == 8

        conductivity = conductivity(:,3:end) ;

    elseif conductivityColN == 2

        conductivity = conductivity(:,1) ;

    else

        conductivity = conductivity ;

    end

    disp("Transforming Zeffiro conductivity to DUNEuro conductivity...")

    tensors = zeffiro.duneuro.transformTensorForDUNEuro(conductivity) ;

    disp("Loading source positions...")

    if ~ isempty(kwargs.sourcePositions)

        sourcePositions = kwargs.sourcePositions ;

    else

        sourcePositions = transpose(projectFileHandle.source_positions) ;

    end

    sourceN = size(sourcePositions,2) ;

    disp("Setting Cartesian source directions...")

    sourceDirectionsX = [
        ones(1, sourceN) ;
        zeros(2, sourceN) ;
    ] ;

    sourceDirectionsY = [
        zeros(1, sourceN) ;
        ones(1, sourceN) ;
        zeros(1, sourceN) ;
    ] ;

    sourceDirectionsZ = [
        zeros(2, sourceN) ;
        ones(1, sourceN) ;
    ] ;

    disp("Constructing Cartesian dipoles...")

    dipoles = [ sourcePositions ; sourceDirectionsX ] ;

    dipoles(:,:,2) = [ sourcePositions ; sourceDirectionsY ] ;

    dipoles(:,:,3) = [ sourcePositions ; sourceDirectionsZ ] ;

    disp("Loading electrode positions...")

    if ~ isempty(kwargs.electrodePositions)

        electrodePositions = kwargs.electrodePositions ;

    else

        loadedElectrodePositions = projectFileHandle.(kwargs.electrodeFieldName) ;

        electrodePositions = transpose(loadedElectrodePositions(:,1:3)) ;

    end

    disp("Translating electrode positions by [" + strjoin(string(kwargs.electrodeTranslationVector), ",") + "]...")

    translatedElectrodePositions = electrodePositions + transpose(kwargs.electrodeTranslationVector) ;

    if kwargs.skinCompartmentIndex > 0

        disp("Projecting electrode points to skin surface...") ;

        skinPointsCells = projectFileHandle.reuna_p ;

        skinPoints = transpose(skinPointsCells{kwargs.skinCompartmentIndex}) ;

        skinTrianglesCells = projectFileHandle.reuna_t ;

        skinTriangles = transpose(skinTrianglesCells{kwargs.skinCompartmentIndex}) ;

        skinTriangleVertices = skinPoints(:,skinTriangles) ;

        disp("Computing distances of electrodes to triangles...") ;

        distancesToTriangles = zeffiro.geometry.distancesFromPointsToTriangles(translatedElectrodePositions,skinTriangleVertices) ;

        disp("Finding smallest distances per electrode...")

        [~,minDistanceI] = min(distancesToTriangles,[],2) ;

        disp("Attaching electrodes to triangles...") ;

        triangleCentroids = zeffiro.geometry.elementCentroids(skinTriangles(:,minDistanceI),skinPoints) ;

        finalElectrodePositions = triangleCentroids ;

    else

        finalElectrodePositions = translatedElectrodePositions ;

    end % if

    disp("Preallocating lead field componentwise...") ;

    eegL = nan( ...
        size(electrodePositions,2), ...
        size(sourcePositions, 2), ...
        3 ...
    ) ;

    disp("Setting up DUNEuro driver configuration object...")

    [driverConfig, electrodeConfig] = duneuro.duneuroConfig( ...
        nodes=meshPoints, ...
        elements=elements, ...
        labels=labels, ...
        tensors=tensors, ...
        source_model=kwargs.sourceModel ...
    ) ;

    disp("Generating DUNEuro driver...")

    driver = duneuro.duneuro_meeg(driverConfig) ;

    disp("Setting driver electrodes...")

    driver.set_electrodes(finalElectrodePositions,electrodeConfig) ;

    disp("Starting transfer matrix computation...")

    if ~ isempty(kwargs.eegT)

        eegT = kwargs.eegT ;

    elseif isfile(kwargs.eegTFilePath)

        eegTFile = matfile(kwargs.eegTFilePath) ;

        eegT = eegTFile.eegT ;

    else

        eegT = driver.compute_eeg_transfer_matrix(driverConfig) ;

    end % if

    meshPointN = size(meshPoints,2) ;

    electrodeN = size(electrodePositions,2) ;

    eegTSize = size(eegT) ;

    assert(all(eegTSize == [meshPointN,electrodeN]), "The given eegT did not have a size of mesh points times electrodes.") ;

    assert(all(isfinite(eegT), "all"), "The utilized eegT had Inf or NaN elements.") ;

    for page = 1 : 3

        disp("Applying transfer matrix to dipoles to produce lead field page " + page + "...")

        eegL(:,:,page) = driver.apply_eeg_transfer(eegT, dipoles(:,:,page), driverConfig) ;

    end % for

    if strlength(kwargs.saveFilePrefix) > 0

        outputFilePath = kwargs.saveFilePrefix + "." + kwargs.sourceModel + "." + string(currentTime) + ".mat" ;

        saveFile = matfile(outputFilePath, Writable=true) ;

        disp("Saving eegT to " + outputFilePath + "...")

        saveFile.eegT = eegT ;

        disp("Saving eegL to " + outputFilePath + "...")

        saveFile.eegL = eegL ;

        disp("Saving electrode positions to " + outputFilePath + "...") ;

        saveFile.electrodePositions = squeeze(finalElectrodePositions) ;

        disp("Saving source positions to " + outputFilePath + "...") ;

        saveFile.sourcePositions = sourcePositions ;

    end % if

    disp("Done.")

end % function
