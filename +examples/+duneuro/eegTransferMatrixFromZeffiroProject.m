function eegT = eegTransferMatrixFromZeffiroProjectFile(kwargs)
%
%   eegT = eegTransfetMatrixFromZeffiroProjectFile(kwargs)
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

    projectFileHandle = matfile(kwargs.projectFilePath) ;

    % Note that we transpose everything loaded from the Zeffiro Project file,
    % because DUNEuro stores individual elements and such in column major order
    % due to CPU cache efficiency reasons.

    meshPoints = transpose(projectFileHandle.nodes) ;

    elements = transpose(projectFileHandle.tetra) - 1 ; % Subtract 1 here because of DUNEuro's 0-based indexing.

    labels = transpose(projectFileHandle.domain_labels) ;

    conductivity = projectFileHandle.sigma ;

    tensors = zeffiro.duneuro.transformTensorForDUNEuro(conductivity(:,3:end)) ;

    sourcePositions = transpose(projectFileHandle.source_positions) ;

    sourceDirections = ones(size(sourcePositions)) ;

    dipoles = [ sourcePositions ; sourceDirections ] ;

    electrodePositions = transpose(projectFileHandle.(kwargs.electrodeFieldName)) ;

    [driverConfig, electrodeConfig] = duneuro.duneuroConfig( ...
        nodes=meshPoints, ...
        elements=elements, ...
        labels=labels, ...
        tensors=tensors, ...
        dipoles=dipoles, ...
        source_model=kwargs.sourceModel ...
    ) ;

    driver = duneuro.duneuro_meeg(driverConfig) ;

    driver.set_electrodes(electrodePositions,electrodeConfig) ;

    eegT = zeffiro.duneuro.eeg_transfer_matrix(driverConfig, driver) ;

    if strlength(kwargs.saveFilePrefix) > 0

        outputFilePath = kwargs.saveFilePrefix + "." + kwargs.sourceModel + "." + string(currentTime) + ".mat" ;

        saveFile = matfile(outputFilePath, Writable=true) ;

        saveFile.eegT = eegT ;

    end % if

end % function
