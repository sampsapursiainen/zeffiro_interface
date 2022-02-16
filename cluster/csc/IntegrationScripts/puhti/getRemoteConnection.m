function remoteConnection = getRemoteConnection(cluster)
%GETREMOTECONNECTION Get a connected RemoteClusterAccess
%
% getRemoteConnection will either retrieve a RemoteClusterAccess from the
% cluster's UserData or it will create a new RemoteClusterAccess.

% Copyright 2010-2019 The MathWorks, Inc.

% Store the current filename for the dctSchedulerMessages
currFilename = mfilename;

if ~isprop(cluster.AdditionalProperties, 'ClusterHost')
    error('parallelexamples:GenericSLURM:MissingAdditionalProperties', ...
        'Required field %s is missing from AdditionalProperties.', 'ClusterHost');
end
clusterHost = cluster.AdditionalProperties.ClusterHost;
if ~ischar(clusterHost)
    error('parallelexamples:GenericSLURM:IncorrectArguments', ...
        'Hostname must be a character vector');
end

if ~isprop(cluster.AdditionalProperties, 'RemoteJobStorageLocation')
    error('parallelexamples:GenericSLURM:MissingAdditionalProperties', ...
        'Required field %s is missing from AdditionalProperties.', 'RemoteJobStorageLocation');
end
remoteJobStorageLocation = cluster.AdditionalProperties.RemoteJobStorageLocation;
if ~ischar(remoteJobStorageLocation)
    error('parallelexamples:GenericSLURM:IncorrectArguments', ...
        'RemoteJobStorageLocation must be a character vector');
end
if isprop(cluster.AdditionalProperties, 'UseUniqueSubfolders')
    useUniqueSubfolders = cluster.AdditionalProperties.UseUniqueSubfolders;
    if ~islogical(useUniqueSubfolders)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'UseUniqueSubfolders must be a logical scalar');
    end
else
    useUniqueSubfolders = false;
end

needToCreateNewConnection = false;
if isempty(cluster.UserData)
    needToCreateNewConnection = true;
else
    if ~isstruct(cluster.UserData)
        error('parallelexamples:GenericSLURM:IncorrectUserData', ...
            ['Failed to retrieve remote connection from cluster''s UserData.\n' ...
            'Expected cluster''s UserData to be a structure, but found %s'], ...
            class(cluster.UserData));
    end
    
    if isfield(cluster.UserData, 'RemoteConnection')
        % Get the remote connection out of the cluster user data
        remoteConnection = cluster.UserData.RemoteConnection;
        
        % And check it is of the type that we expect
        if isempty(remoteConnection)
            needToCreateNewConnection = true;
        else
            clusterAccessClassname = 'parallel.cluster.RemoteClusterAccess';
            if ~isa(remoteConnection, clusterAccessClassname)
                error('parallelexamples:GenericSLURM:IncorrectArguments', ...
                    ['Failed to retrieve remote connection from cluster''s UserData.\n' ...
                    'Expected the RemoteConnection field of the UserData to contain an object of type %s, but found %s.'], ...
                    clusterAccessClassname, class(remoteConnection));
            end
            
            if useUniqueSubfolders
                username = remoteConnection.Username;
                expectedRemoteJobStorageLocation = iBuildUniqueSubfolder(remoteJobStorageLocation, ...
                    username, iGetFileSeparator(cluster));
            else
                expectedRemoteJobStorageLocation = remoteJobStorageLocation;
            end
            
            if ~remoteConnection.IsConnected
                needToCreateNewConnection = true;
            elseif ~(strcmpi(remoteConnection.Hostname, clusterHost) && ...
                    remoteConnection.IsFileMirrorSupported && ...
                    strcmpi(remoteConnection.JobStorageLocation, expectedRemoteJobStorageLocation))
                % The connection stored in the user data does not match the cluster host
                % and remote location requested
                warning('parallelexamples:GenericSLURM:DifferentRemoteParameters', ...
                    ['The current cluster is already using cluster host %s and remote job storage location %s.\n', ...
                    'The existing connection to %s will be replaced.'], ...
                    remoteConnection.Hostname, remoteConnection.JobStorageLocation, remoteConnection.Hostname);
                cluster.UserData.RemoteConnection = [];
                needToCreateNewConnection = true;
            end
        end
    else
        needToCreateNewConnection = true;
    end
end

if ~needToCreateNewConnection
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CUSTOMIZATION MAY BE REQUIRED %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the credential options from the user using simple
% MATLAB dialogs or command line input.  You should change
% this section if you wish for users to provide their credential
% options in a different way.
% The pertinent options are:
% username - the username to use when running commands on the remote host
% useIdentityFile - whether or not to use an identity file (true/false).
%                   False means that a password is used
% identityFile - the full path to the identity file
% identityFileHasPassphrase - whether or not the identity file requires a passphrase
%                     (true/false).

% Use the UI if MATLAB has been started with a desktop
useUI = isempty(javachk('awt'));
username = iGetUsername(cluster, useUI);
[useIdentityFile, identityFile] = iGetIdentityFile(cluster, useUI);
if useIdentityFile
    identityFileHasPassphrase = iGetIdentityFileHasPassphrase(cluster, useUI);
    dctSchedulerMessage(1, '%s: Identity file %s will be used for remote connections', ...
        currFilename, username, identityFile);
    userArgs = {username, ...
        'IdentityFilename', identityFile, 'IdentityFileHasPassphrase', identityFileHasPassphrase};
else
    userArgs = {username};
end
cluster.saveProfile

% Now connect and store the connection
dctSchedulerMessage(1, '%s: Connecting to remote host %s', ...
    currFilename, clusterHost);
if useUniqueSubfolders
    remoteJobStorageLocation = iBuildUniqueSubfolder(remoteJobStorageLocation, ...
        username, iGetFileSeparator(cluster));
end
remoteConnection = parallel.cluster.RemoteClusterAccess.getConnectedAccessWithMirror(clusterHost, remoteJobStorageLocation, userArgs{:});
dctSchedulerMessage(5, '%s: Storing remote connection in cluster''s user data.', currFilename);
cluster.UserData.RemoteConnection = remoteConnection;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function username = iGetUsername(cluster, useUI)

if isprop(cluster.AdditionalProperties, 'Username')
    username = cluster.AdditionalProperties.Username;
    if ~ischar(username)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'Username must be a character vector');
    end
    return
end

if useUI
    dlgMessage = sprintf('Enter the username for %s', cluster.AdditionalProperties.ClusterHost);
    dlgTitle = 'User Credentials';
    numlines = 1;
    usernameResponse = inputdlg(dlgMessage, dlgTitle, numlines);
    % Hitting cancel gives an empty cell array, but a user providing an empty string gives
    % a (non-empty) cell array containing an empty string
    if isempty(usernameResponse)
        % User hit cancel
        error('parallelexamples:GenericSLURM:UserCancelledOperation', ...
            'User cancelled operation.');
    end
    username = char(usernameResponse);
else
    % useUI == false
    username = input(sprintf('Enter the username for %s:\n', cluster.AdditionalProperties.ClusterHost), 's');
end

cluster.AdditionalProperties.Username = username;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [useIdentityFile, identityFile] = iGetIdentityFile(cluster, useUI)

useIdentityFile = false;
identityFile = '';

shouldPromptForUseIdentityFile = true;

% If AdditionalProperties.UseIdentityFile is defined, it takes precedence.
if isprop(cluster.AdditionalProperties, 'UseIdentityFile')
    shouldPromptForUseIdentityFile = false;
    useIdentityFile = cluster.AdditionalProperties.UseIdentityFile;
    if ~islogical(useIdentityFile)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'UseIdentityFile must be a logical scalar');
    end
    if ~useIdentityFile
        return
    end
end

% At this point AdditionalProperties.UseIdentityFile is either undefined or true.
% If AdditionalProperties.IdentityFile is defined, then assume that the user wants to use it as identity file.
if isprop(cluster.AdditionalProperties, 'IdentityFile')
    shouldPromptForUseIdentityFile = false;
    useIdentityFile = true;
    identityFile = cluster.AdditionalProperties.IdentityFile;
    if ~ischar(identityFile) || isempty(identityFile)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'IdentityFile must be a nonempty character vector');
    end
end

if shouldPromptForUseIdentityFile
    % At this point, UseIdentityFile and IdentityFile are both undefined
    if useUI
        dlgMessage = sprintf('Use an identity file to login to %s?', cluster.AdditionalProperties.ClusterHost);
        dlgTitle = 'User Credentials';
        identityFileResponse = questdlg(dlgMessage, dlgTitle);
        if strcmp(identityFileResponse, 'Cancel')
            % User hit cancel
            error('parallelexamples:GenericSLURM:UserCancelledOperation', 'User cancelled operation.');
        end
        useIdentityFile = strcmp(identityFileResponse, 'Yes');
    else
        validYesNoResponse = {'y', 'n'};
        identityFileMessage = sprintf('Use an identity file to login to %s? (y or n)\n', cluster.AdditionalProperties.ClusterHost);
        identityFileResponse = iLoopUntilValidStringInput(identityFileMessage, validYesNoResponse);
        useIdentityFile = strcmpi(identityFileResponse, 'y');
    end
    cluster.AdditionalProperties.UseIdentityFile = useIdentityFile;
    % If useIdentityFile is false, there is nothing left to do.
    if ~useIdentityFile
        return
    end
end

% If identityFile is empty, then AdditionalProperties.IdentityFile was undefined and we need to prompt for the file path.
if ~isempty(identityFile)
    return
end

if useUI
    dlgMessage = 'Select Identity File to use';
    [filename, pathname] = uigetfile({'*.*', 'All Files (*.*)'},  dlgMessage);
    % If the user hit cancel, then filename and pathname will both be 0.
    if isequal(filename, 0) && isequal(pathname,0)
        error('parallelexamples:GenericSLURM:UserCancelledOperation', 'User cancelled operation.');
    end
    identityFile = fullfile(pathname, filename);
else
    % useUI == false
    while isempty(identityFile)
        identityFile = input(sprintf('Please enter the full path to the Identity File to use:\n'), 's');
    end
end

cluster.AdditionalProperties.IdentityFile = identityFile;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function identityFileHasPassphrase = iGetIdentityFileHasPassphrase(cluster, useUI)

if isprop( cluster.AdditionalProperties, 'IdentityFileHasPassphrase' )
    identityFileHasPassphrase = cluster.AdditionalProperties.IdentityFileHasPassphrase;
    if ~islogical(identityFileHasPassphrase)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'IdentityFileHasPassphrase must be a logical scalar');
    end
    return
end

if useUI
    dlgMessage = 'Does the identity file require a password?';
    dlgTitle = 'User Credentials';
    passphraseResponse = questdlg(dlgMessage, dlgTitle);
    if strcmp(passphraseResponse, 'Cancel')
        % User hit cancel
        error('parallelexamples:GenericSLURM:UserCancelledOperation', 'User cancelled operation.');
    end
    identityFileHasPassphrase = strcmp(passphraseResponse, 'Yes');
else
    % useUI == false
    passphraseMessage = 'Does the identity file require a password? (y or n)\n';
    passphraseResponse = iLoopUntilValidStringInput(passphraseMessage, validYesNoResponse);
    identityFileHasPassphrase = strcmpi(passphraseResponse, 'y');
end

cluster.AdditionalProperties.IdentityFileHasPassphrase = identityFileHasPassphrase;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function returnValue = iLoopUntilValidStringInput(message, validValues)
% Function to loop until a valid response is obtained user input
returnValue = '';

while isempty(returnValue) || ~any(strcmpi(returnValue, validValues))
    returnValue = input(message, 's');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subfolder = iBuildUniqueSubfolder(remoteJobStorageLocation, username, fileSeparator)
% Function to build unique location using username and MATLAB release version
release = ['R' version('-release')];
subfolder = [remoteJobStorageLocation fileSeparator username fileSeparator release];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fileSeparator = iGetFileSeparator(cluster)
% Function to return file separator for cluster operating system
if strcmpi(cluster.OperatingSystem, 'unix')
    fileSeparator = '/';
else
    fileSeparator = '\';
end
