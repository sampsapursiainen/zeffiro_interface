function eegT = eegTransferMatrixFromZeffiroProject(kwargs)
%
%   eegT = eegTransfetMatrixFromZeffiroProject(kwargs)
%
% Loads data from a given Zeffiro Project file and computes
% an EEG transfer matrix using the duneuro-matlab library.
%
% Supposes that duneuro-matlab has been installed in a MATLAB
% package +duneuro somewhere on your MATLAB path.
%
% Arguments:
%
%    kwargs.projectFilePath (1,1) string { mustBeFile }
%
% A path to the Zeffiro project file
%
%    kwargs.electrodeFieldName (1,1) string = "s2_points"
%
% A field name of the electrode positions stored in the project file.
%
%    kwargs.sourceModel (1,:) char = 'whitney'
%
% The source model used by DUNEUro. We use the H(div) source model here to
% match that of Zeffiro, but another good option is 'local_subtraction'.
%
%    kwargs.saveFilePrefix (1,1) string = ""
%
% If this is non-empty, the transfer matrix is also automatically saved to a file.
% The current time and the used source model are appended to the file path prefix.
%
    arguments
        kwargs.projectFilePath (1,1) string { mustBeFile }
        kwargs.electrodeFieldName (1,1) string = "s2_points"
        kwargs.sourceModel (1,:) char = 'whitney'
        kwargs.saveFilePrefix (1,1) string = ""
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

    sourcePositions = transpose(projectFileHandle.source_positions) ;

    disp("Setting Cartesian source directions...")

    sourceDirections = ones(size(sourcePositions)) ;

    disp("Constructing dipoles...")

    dipoles = [ sourcePositions ; sourceDirections ] ;

    disp("Loading electrode positions...")

    electrodePositions = transpose(projectFileHandle.(kwargs.electrodeFieldName)) ;

    disp("Setting up DUNEuro driver configuration object...")

    [driverConfig, electrodeConfig] = duneuro.duneuroConfig( ...
        nodes=meshPoints, ...
        elements=elements, ...
        labels=labels, ...
        tensors=tensors, ...
        dipoles=dipoles, ...
        source_model=kwargs.sourceModel ...
    ) ;

    disp("Generating DUNEuro driver...")

    driver = duneuro.duneuro_meeg(driverConfig) ;

    disp("Setting driver electrodes...")

    driver.set_electrodes(electrodePositions,electrodeConfig) ;

    disp("Starting transfer matrix computation...")

    eegT = zeffiro.duneuro.eeg_transfer_matrix(driverConfig, driver) ;

    if strlength(kwargs.saveFilePrefix) > 0

        outputFilePath = kwargs.saveFilePrefix + "." + kwargs.sourceModel + "." + string(currentTime) + ".mat" ;

        disp("Saving eegT to " + outputFilePath + "...")

        saveFile = matfile(outputFilePath, Writable=true) ;

        saveFile.eegT = eegT ;

    end % if

    disp("Done.")

end % function
