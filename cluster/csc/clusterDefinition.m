function [def] = clusterDefinition()
% This function will be used to read in the mdcs.rc and to extract
% the necessary information in order to build the cluster profile
% in MATLAB.  clusterDefinition will pass back a structure to 
% configCluster.

% Copyright 2017 The MathWorks, Inc.

% Determine the location of the mdcs.rc file; we assume that 
% it is in the same directory as configCluster.
mdcsRC = fullfile(fileparts(mfilename('fullpath')),'mdcs.rc');

% Open mdcs.rc for reading in the required fields
[mdcsRC, errormsg] = fopen(mdcsRC, 'r');

% If mdcs.rc does not exist or can't be accessed, throw an error
if mdcsRC < 0
    error('Unable to read or access mdcs.rc\n%s', errormsg)
end

% Ensure mdcs.rc file is closed after read, regardless of this script
% finishing successfully. 
c = onCleanup(@()fclose(mdcsRC));

% Loop through until we reach the end of the file
while ~feof(mdcsRC)
    % Grab a line from the mdcsRC
    tline = fgetl(mdcsRC);
    % If the line does not start with a '#' or is not empty, grab the 
    % content of the line.
    if ~strncmp(tline,'#', 1) && ~isempty(strtrim(tline))
        % Use '=' to split the line into a field and value keypair
        [field, value] = strtok(tline, '=');
        % Remove any spaces from field
        field = strtrim(field);
        % Using strtrim to get rid of the '=' from value
        value = strtrim(value(2:end));
        % Create a struct of fields/values to be used in configCluster later on
        def.(field) = value;
    end
end

% Error checking

validSubmissionTypes = {'local', 'remote', 'remotesubmission'};

if isempty(def.Type)
    error('Submission type must be specified in the mdcs.rc configuration file.')
else
    def.Type = lower(def.Type);
end
    
if ~ismember(def.Type, validSubmissionTypes)
        error(['Invalid submission type specified in the mdcs.rc configuration file.' ...
        10 'Valid configuration options are: local, remote, or remotesubmission.' ])
end

if isempty(def.NumWorkers)
    error('NumWorkers must be specified in the mdcs.rc configuration file.')
end

if strcmp(def.Type, 'remote') || strcmp(def.Type, 'remotesubmission')
    if isempty(def.ClusterMatlabRoot)
        % For local, we assume cluster MATLAB root is the same as where the
        % user is running MATLAB from, so no check is necessary
        error('When using type %s, specify the ClusterMatlabRoot directory on the cluster in the mdcs.rc configuration file.', def.Type)
    end
    
    % If cluster is running Windows OS, change the second argument to 'pc'
    def.ClusterMatlabRoot = lastCharacterCheck(def.ClusterMatlabRoot, 'unix');
    
    if isempty(def.ClusterHost)
        error('When using type %s, specify the ClusterHost headnode hostname in the mdcs.rc configuration file.', def.Type)
    end
    
    if isempty(def.RemoteJobStorageLocation)
        if strcmp(def.Type, 'remote') || (ispc && strcmp(def.Type, 'remotesubmission'))
            error('When using type %s, specify the RemoteJobStorageLocation on the cluster in the mdcs.rc configuration file.', def.Type)
        end
    end
    
    % If cluster is running Windows OS, change the second argument to 'pc'
    % from 'unix'
    def.RemoteJobStorageLocation = lastCharacterCheck(def.RemoteJobStorageLocation, 'unix');
else
    if ~isempty(def.LocalJobStorageLocation)
        if ispc
            def.LocalJobStorageLocation = lastCharacterCheck(def.LocalJobStorageLocation, 'pc');
        else
            def.LocalJobStorageLocation = lastCharacterCheck(def.LocalJobStorageLocation, 'unix');
        end
    end
end

if strcmp(def.Type, 'remotesubmission')
    if ispc
        if ~isempty(def.JobStorageLocationOnPC)
            def.RemoteSubmissionClientDir = lastCharacterCheck(def.JobStorageLocationOnPC, 'pc');
        else
            error(['When using remotesubmission, JobStorageLocationOnPC field must not be empty in the mdcs.rc configuration file.' ...
                  10 'Specify the UNC Path that the MATLAB client has access to on the cluster.'])
        end
    else
        if ~isempty(def.RemoteJobStorageLocation)
            def.RemoteSubmissionClientDir = lastCharacterCheck(def.RemoteJobStorageLocation, 'unix');
        else
            error(['When using remotesubmission, RemoteJobStorageLocation field must not be empty in the mdcs.rc configuration file.' ...
                  10 'Specify the path the MATLAB client has access to on the cluster.'])
        end
    end
end


function out = lastCharacterCheck(in, machineType)

% Verify that the last string is '/' or '\' and if not, append it

% Set a default in case no modifications are required
out = in; 

% Check to see if we need to append a slash as a last character
if strcmp(machineType, 'pc')
    if ~strcmp(in(end), '\')
        out = strcat(in, '\');
    end
else
    if ~strcmp(in(end), '/')
        out = strcat(in,'/');
    end
end
