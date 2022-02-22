function independentSubmitFcn(cluster, job, environmentProperties)
%INDEPENDENTSUBMITFCN Submit a MATLAB job to a Slurm cluster
%
% Set your cluster's PluginScriptsLocation to the parent folder of this
% function to run it when you submit an independent job.
%
% See also parallel.cluster.generic.independentDecodeFcn.

% Copyright 2010-2019 The MathWorks, Inc.

% Store the current filename for the errors, warnings and dctSchedulerMessages
currFilename = mfilename;
if ~isa(cluster, 'parallel.Cluster')
    error('parallelexamples:GenericSLURM:NotClusterObject', ...
        'The function %s is for use with clusters created using the parcluster command.', currFilename)
end

decodeFunction = 'parallel.cluster.generic.independentDecodeFcn';

if cluster.HasSharedFilesystem
    error('parallelexamples:GenericSLURM:NotNonSharedFileSystem', ...
        'The function %s is for use with nonshared filesystems.', currFilename)
end

if ~strcmpi(cluster.OperatingSystem, 'unix')
    error('parallelexamples:GenericSLURM:UnsupportedOS', ...
        'The function %s only supports clusters with unix OS.', currFilename)
end

remoteConnection = getRemoteConnection(cluster);

[useJobArrays, maxJobArraySize] = iGetJobArrayProps(cluster, remoteConnection);
% Store data for future reference
cluster.UserData.UseJobArrays = useJobArrays;
if useJobArrays
    cluster.UserData.MaxJobArraySize = maxJobArraySize;
end

enableDebug = 'false';
if isprop(cluster.AdditionalProperties, 'EnableDebug') ...
        && islogical(cluster.AdditionalProperties.EnableDebug) ...
        && cluster.AdditionalProperties.EnableDebug
    enableDebug = 'true';
end

% The job specific environment variables
% Remove leading and trailing whitespace from the MATLAB arguments
matlabArguments = strtrim(environmentProperties.MatlabArguments);
% MW: Due to Lustre FS, need to use /tmp
userName = validatedPropValue(cluster, 'UserNameOnCluster', 'char');
prefdir = ['/tmp/' userName '/matlab_prefdir'];
if verLessThan('matlab', '9.7')
    variables = {'MDCE_DECODE_FUNCTION', decodeFunction; ...
        'MDCE_STORAGE_CONSTRUCTOR', environmentProperties.StorageConstructor; ...
        'MDCE_JOB_LOCATION', environmentProperties.JobLocation; ...
        'MDCE_MATLAB_EXE', environmentProperties.MatlabExecutable; ...
        'MDCE_MATLAB_ARGS', matlabArguments; ...
        'PARALLEL_SERVER_DEBUG', enableDebug; ...
        'MLM_WEB_LICENSE', environmentProperties.UseMathworksHostedLicensing; ...
        'MLM_WEB_USER_CRED', environmentProperties.UserToken; ...
        'MLM_WEB_ID', environmentProperties.LicenseWebID; ...
        'MDCE_LICENSE_NUMBER', environmentProperties.LicenseNumber; ...
        'MATLAB_PREFDIR', prefdir; ...
        'MDCE_STORAGE_LOCATION', remoteConnection.JobStorageLocation};
else
    variables = {'PARALLEL_SERVER_DECODE_FUNCTION', decodeFunction; ...
        'PARALLEL_SERVER_STORAGE_CONSTRUCTOR', environmentProperties.StorageConstructor; ...
        'PARALLEL_SERVER_JOB_LOCATION', environmentProperties.JobLocation; ...
        'PARALLEL_SERVER_MATLAB_EXE', environmentProperties.MatlabExecutable; ...
        'PARALLEL_SERVER_MATLAB_ARGS', matlabArguments; ...
        'PARALLEL_SERVER_DEBUG', enableDebug; ...
        'MLM_WEB_LICENSE', environmentProperties.UseMathworksHostedLicensing; ...
        'MATLAB_PREFDIR', prefdir; ...
        'MLM_WEB_USER_CRED', environmentProperties.UserToken; ...
        'MLM_WEB_ID', environmentProperties.LicenseWebID; ...
        'PARALLEL_SERVER_LICENSE_NUMBER', environmentProperties.LicenseNumber; ...
        'PARALLEL_SERVER_STORAGE_LOCATION', remoteConnection.JobStorageLocation};
end
% Trim the environment variables of empty values.
nonEmptyValues = cellfun(@(x) ~isempty(strtrim(x)), variables(:,2));
variables = variables(nonEmptyValues, :);

% Get the correct quote and file separator for the Cluster OS.
% This check is unnecessary in this file because we explicitly
% checked that the ClusterOsType is unix.  This code is an example
% of how to deal with clusters that can be unix or pc.
if strcmpi(cluster.OperatingSystem, 'unix')
    quote = '''';
    fileSeparator = '/';
else
    quote = '"';
    fileSeparator = '\';
end

% The local job directory
localJobDirectory = cluster.getJobFolder(job);
% How we refer to the job directory on the cluster
remoteJobDirectory = remoteConnection.getRemoteJobLocation(job.ID, cluster.OperatingSystem);

% The script name is independentJobWrapper.sh
scriptName = 'independentJobWrapper.sh';
% The wrapper script is in the same directory as this file
dirpart = fileparts(mfilename('fullpath'));
localScript = fullfile(dirpart, scriptName);
% Copy the local wrapper script to the job directory
copyfile(localScript, localJobDirectory);

% The command that will be executed on the remote host to run the job.
remoteScriptName = sprintf('%s%s%s', remoteJobDirectory, fileSeparator, scriptName);
quotedScriptName = sprintf('%s%s%s', quote, remoteScriptName, quote);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CUSTOMIZATION MAY BE REQUIRED %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
additionalSubmitArgs = sprintf('--ntasks=1 --cpus-per-task=%d', cluster.NumThreads);
commonSubmitArgs = getCommonSubmitArgs(cluster, 1);
if ~isempty(commonSubmitArgs) && ischar(commonSubmitArgs)
    additionalSubmitArgs = strtrim([additionalSubmitArgs, ' ', commonSubmitArgs]) %#ok<NOPRT>
end

% Only keep and submit tasks that are not cancelled. Cancelled tasks
% will have errors.
isPendingTask = cellfun(@isempty, get(job.Tasks, {'Error'}));
tasks = job.Tasks(isPendingTask);
taskIDs = cell2mat(get(tasks,{'ID'}));
numberOfTasks = numel(tasks);

% Only use job arrays when you can get enough use out of them.
% The submission method in this function requires a minimum maxJobArraySize
% of 10 to get enough use of job arrays.
if numberOfTasks < 2 || maxJobArraySize < 10
    useJobArrays = false;
end

if useJobArrays
    % Check if there are more tasks than will fit in one job array. Slurm
    % will not accept a job array index greater than its MaxArraySize
    % parameter, as defined in slurm.conf, even if the overall size of the
    % array is less than MaxArraySize. For example, for the default
    % (inclusive) upper limit of MaxArraySize=1000, array indices of 1 to
    % 1000 would be accepted, but 1001 or above would not. To get around
    % this restriction, submit the full array of tasks in multiple Slurm
    % job arrays, hereafter referred to as subarrays. Round the
    % MaxArraySize down to the nearest power of 10, as this allows the log
    % file of taskX to be named TaskX.log.  See iGenerateLogFileName.
    if taskIDs(end) > maxJobArraySize
        % Use the nearest power of 10 as subarray size. This will make the
        % naming of log files easier.
        maxJobArraySizeToUse = 10^floor(log10(maxJobArraySize));
        % Group task IDs into bins of jobArraySize size.
        groups = findgroups(floor(taskIDs./maxJobArraySizeToUse));
        % Count the number of elements in each group and form subarrays.
        jobArraySizes = splitapply(@numel, taskIDs, groups);
    else
        maxJobArraySizeToUse = maxJobArraySize;
        jobArraySizes = numel(tasks);
    end
    taskIDGroupsForJobArrays = mat2cell(taskIDs,jobArraySizes);
    
    jobName = sprintf('Job%d',job.ID);
    numJobArrays = numel(taskIDGroupsForJobArrays);
    commandsToRun = cell(numJobArrays, 1);
    jobIDs = cell(numJobArrays, 1);
    schedulerJobArrayIndices = cell(numJobArrays, 1);
    for ii = 1:numJobArrays
        % Slurm only accepts task IDs up to maxArraySize. Shift all task
        % IDs down below the limit.
        taskOffset = (ii-1)*maxJobArraySizeToUse;
        schedulerJobArrayIndices{ii} = taskIDGroupsForJobArrays{ii} - taskOffset;
        % Save the offset as an environment variable to pass to the tasks
        % during Slurm submission.
        environmentVariables = [variables; ...
            {'PARALLEL_SERVER_TASK_ID_OFFSET', num2str(taskOffset)}];
        
        % Create a character vector with the ranges of IDs to submit.
        jobArrayString = iCreateJobArrayString(schedulerJobArrayIndices{ii});
        
        logFileName = iGenerateLogFileName(ii, maxJobArraySizeToUse);
        % Choose a file for the output. Please note that currently,
        % JobStorageLocation refers to a directory on disk, but this may
        % change in the future.
        logFile = sprintf('%s%s%s', remoteJobDirectory, fileSeparator, logFileName);
        quotedLogFile = sprintf('%s%s%s', quote, logFile, quote);
        
        % Create a script to submit a Slurm job - this
        % will be created in the job directory
        dctSchedulerMessage(5, '%s: Generating script for job array %i', currFilename, ii);
        commandsToRun{ii} = iGetCommandToRun(localJobDirectory, remoteJobDirectory, fileSeparator, jobName, ...
            quotedLogFile, quotedScriptName, environmentVariables, additionalSubmitArgs, jobArrayString);
    end
else
    % Do not use job arrays and submit each task individually.
    taskLocations = environmentProperties.TaskLocations(isPendingTask);
    jobIDs = cell(1, numberOfTasks);
    commandsToRun = cell(numberOfTasks, 1);
    % Loop over every task we have been asked to submit
    for ii = 1:numberOfTasks
        taskLocation = taskLocations{ii};
        % Add the task location to the environment variables
        if verLessThan('matlab', '9.7')
            environmentVariables = [variables; ...
            {'MDCE_TASK_LOCATION', taskLocation}];
        else
            environmentVariables = [variables; ...
            {'PARALLEL_SERVER_TASK_LOCATION', taskLocation}];
        end
        
        % Choose a file for the output. Please note that currently,
        % JobStorageLocation refers to a directory on disk, but this may
        % change in the future.
        logFile = sprintf('%s%s%s', remoteJobDirectory, fileSeparator, sprintf('Task%d.log', taskIDs(ii)));
        quotedLogFile = sprintf('%s%s%s', quote, logFile, quote);
        
        % Submit one task at a time
        jobName = sprintf('Job%d.%d', job.ID, taskIDs(ii));
        
        % Create a script to submit a Slurm job - this will be created in
        % the job directory
        dctSchedulerMessage(5, '%s: Generating script for task %i', currFilename, ii);
        commandsToRun{ii} = iGetCommandToRun(localJobDirectory, remoteJobDirectory, fileSeparator, jobName, ...
            quotedLogFile, quotedScriptName, environmentVariables, additionalSubmitArgs);
    end
end
dctSchedulerMessage(4, '%s: Starting mirror for job %d.', currFilename, job.ID);
% Start the mirror to copy all the job files over to the cluster
remoteConnection.startMirrorForJob(job);
for ii=1:numel(commandsToRun)
    commandToRun = commandsToRun{ii};
    jobIDs{ii} = iSubmitJobUsingCommand(remoteConnection, job, commandToRun);
end

% Define the schedulerIDs
if useJobArrays
    % The scheduler ID of each task is a combination of the job ID and the
    % scheduler array index. cellfun pairs each job ID with its
    % corresponding scheduler array indices in schedulerJobArrayIndices and
    % returns the combination of both. For example, if jobIDs = {1,2} and
    % schedulerJobArrayIndices = {[1,2];[3,4]}, the schedulerID is given by
    % combining 1 with [1,2] and 2 with [3,4], in the canonical form of the
    % scheduler.
    schedulerIDs = cellfun(@(jobID,arrayIndices) jobID + "_" + arrayIndices, ...
        jobIDs, schedulerJobArrayIndices, 'UniformOutput',false);
    schedulerIDs = vertcat(schedulerIDs{:});
else
    % The scheduler ID of each task is the job ID.
    schedulerIDs = convertCharsToStrings(jobIDs);
end

if verLessThan('matlab', '9.7')
    % set the cluster host, remote job storage location and job ID on the job cluster data
    jobData = struct('ClusterJobIDs', {schedulerIDs}, ...
        'RemoteHost', remoteConnection.Hostname, ...
        'RemoteJobStorageLocation', remoteConnection.JobStorageLocation, ...
        'HasDoneLastMirror', false);
    cluster.setJobClusterData(job, jobData);
else
    % Set the scheduler ID for each task
    set(tasks, 'SchedulerID', schedulerIDs);

    % Set the cluster host and remote job storage location on the job cluster data
    jobData = struct('type', 'generic', ...
        'RemoteHost', remoteConnection.Hostname, ...
        'RemoteJobStorageLocation', remoteConnection.JobStorageLocation, ...
        'HasDoneLastMirror', false);
    cluster.setJobClusterData(job, jobData);
end

function [useJobArrays, maxJobArraySize] = iGetJobArrayProps(cluster, remoteConnection)
% Look for useJobArrays and maxJobArray size in the following order:
% 1.  Additional Properties
% 2.  User Data
% 3.  Query scheduler for MaxJobArraySize
% Set defaults
useJobArrays = true;
maxJobArraySize = 0;

if isprop(cluster.AdditionalProperties, 'UseJobArrays')
    if ~islogical(cluster.AdditionalProperties.UseJobArrays)
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'UseJobArrays must be a logical scalar');
    end
    useJobArrays = cluster.AdditionalProperties.UseJobArrays;
elseif isfield(cluster.UserData,'UseJobArrays')
    % If no user preference, then use job arrays by default.
    useJobArrays = cluster.UserData.UseJobArrays;
end

if ~useJobArrays
    return;
end

if isprop(cluster.AdditionalProperties, 'MaxJobArraySize')
    if ~isnumeric(cluster.AdditionalProperties.MaxJobArraySize) || ...
            cluster.AdditionalProperties.MaxJobArraySize < 1
        error('parallelexamples:GenericSLURM:IncorrectArguments', ...
            'MaxJobArraySize must be a positive integer');
    end
    maxJobArraySize = cluster.AdditionalProperties.MaxJobArraySize;
    return
end
if isfield(cluster.UserData,'MaxJobArraySize')
    maxJobArraySize = cluster.UserData.MaxJobArraySize;
    return
end

[useJobArrays, maxJobArraySize] = iGetJobArrayPropsFromScheduler(remoteConnection);

function [useJobArrays, maxJobArraySize] = iGetJobArrayPropsFromScheduler (remoteConnection)
% get job array information by querying the scheduler.
commandToRun = 'scontrol show config';
try
    % Execute the command on the remote host.
    [cmdFailed, cmdOut] = remoteConnection.runCommand(commandToRun);
catch err
    cmdFailed = true;
    cmdOut = err.message;
end
if cmdFailed
    error('parallelexamples:GenericSLURM:FailedToRetrieveInfo', ...
        'Failed to retrieve Slurm configuration information using command:\n\t%s.\nReason: %s', ...
        commandToRun, cmdOut);
end

maxJobArraySize = 0;
% Extract the maximum array size for job arrays. For Slurm, the
% configuration line that contains the maximum array index looks like this:
% MaxArraySize = 1000
% Use a regular expression to extract this parameter.
tokens = regexp(cmdOut,'MaxArraySize\s*=\s*(\d+)', 'tokens','once');

if isempty(tokens)
    % No job array support.
    useJobArrays = false;
    return;
end

if (str2double(tokens) == 0)
    useJobArrays = false;
    return;
end

useJobArrays = true;
% Set the maximum array size.
maxJobArraySize = str2double(tokens{1});
% In Slurm, MaxArraySize is an exclusive upper bound. Subtract one to obtain
% the inclusive upper bound.
maxJobArraySize = maxJobArraySize - 1;

function commandToRun = iGetCommandToRun(localJobDirectory, remoteJobDirectory, fileSeparator, jobName, ...
    quotedLogFile, quotedScriptName, environmentVariables, additionalSubmitArgs, jobArrayString)
if nargin < 9
    jobArrayString = [];
end

localScriptName = tempname(localJobDirectory);
[~, scriptName] = fileparts(localScriptName);
remoteScriptLocation = sprintf('%s%s%s', remoteJobDirectory, fileSeparator, scriptName);
createSubmitScript(localScriptName, jobName, quotedLogFile, quotedScriptName, ...
    environmentVariables, additionalSubmitArgs, jobArrayString);
% Create the command to run on the remote host.
commandToRun = sprintf('sh %s', remoteScriptLocation);

function jobID = iSubmitJobUsingCommand(remoteConnection, job, commandToRun)
currFilename = mfilename;
% Ask the cluster to run the submission command.
dctSchedulerMessage(4, '%s: Submitting job using command:\n\t%s', currFilename, commandToRun);
% Execute the command on the remote host.
[cmdFailed, cmdOut] = remoteConnection.runCommand(commandToRun);
if cmdFailed
    % Stop the mirroring if we failed to submit the job - this will also
    % remove the job files from the remote location
    % Only stop mirroring if we are actually mirroring
    if remoteConnection.isJobUsingConnection(job.ID)
        dctSchedulerMessage(5, '%s: Stopping the mirror for job %d.', currFilename, job.ID);
        try
            remoteConnection.stopMirrorForJob(job);
        catch err
            warning('parallelexamples:GenericSLURM:FailedToStopMirrorForJob', ...
                'Failed to stop the file mirroring for job %d.\nReason: %s', ...
                job.ID, err.getReport);
        end
    end
    error('parallelexamples:GenericSLURM:FailedToSubmitJob', ...
        'Failed to submit job to Slurm using command:\n\t%s.\nReason: %s', ...
        commandToRun, cmdOut);
end

jobID = extractJobId(cmdOut);
if isempty(jobID)
       warning('parallelexamples:GenericSLURM:FailedToParseSubmissionOutput', ...
        'Failed to parse the job identifier from the submission output: "%s"', ...
        cmdOut);
end

function rangesString = iCreateJobArrayString(taskIDs)
% Create a character vector with the ranges of task IDs to submit
if taskIDs(end) - taskIDs(1) + 1 == numel(taskIDs)
    % There is only one range.
    rangesString = sprintf('%d-%d',taskIDs(1),taskIDs(end));
else
    % There are several ranges.
    % Calculate the step size between task IDs.
    step = diff(taskIDs);
    % Where the step changes, a range ends and another starts. Include
    % the initial and ending IDs in the ranges as well.
    isStartOfRange = [true; step > 1];
    isEndOfRange   = [step > 1; true];
    rangesString = strjoin(compose('%d-%d', ...
        taskIDs(isStartOfRange),taskIDs(isEndOfRange)),',');
end

function logFileName = iGenerateLogFileName(subArrayIdx, jobArraySize)
% This function builds the log file specifier, which is then passed to
% Slurm to tell it where each task's output should go. This will be equal
% to TaskX.log where X is the MATLAB ID. Slurm will not accept a job array
% index greater than its MaxArraySize parameter. As a result MATLAB IDs
% must be shifted down below MaxArraySize. To ensure that the log file for 
% Task X is called TaskX.log, round the maximum array size down to the
% nearest power of 10 and manually construct the log file specifier. For
% example, for a MaxArraySize of 1500, the Slurm job arrays will be of
% size 1000, and MATLAB task IDs will map as illustrated by the following
% table:
%
%    MATLAB ID | Slurm ID | Log file specifier
%    ----------+----------+--------------------
%       1- 999 |   1-999  | Task%a.log
%    1000-1999 | 000-999  | Task1%3a.log
%    2000-2999 | 000-999  | Task2%3a.log
%    3000      | 000      | Task3%3a.log
% 
% Note that Slurm expands %a to the Slurm ID, and %3a to the Slurm ID
% padded with zeros to 3 digits.
if subArrayIdx == 1
    % Job arrays have more than one task. Use %a so that Slurm expands it
    % into the actual task ID.
    logFileName = 'Task%a.log';
else
    % For subsequent subarrays after the first one, prepend the index to %a
    % to identify the batch of log files and form the final log file name.
    padding = floor(log10(jobArraySize));
    logFileName = sprintf('Task%d%%%da.log',subArrayIdx-1,padding);
end
