function cleanJobStorageLocation(c)
% Deletes all content from the job storage location.

% Copyright 2014-2019 The MathWorks, Inc.

narginchk(1,1)

if isa(c,'parallel.cluster.Generic')==false
    error('Must supply cluster object.')
end

% Store the current filename for the errors, warnings and
% dctSchedulerMessages
currFilename = mfilename;

% Delete local job storage location
jsl = c.JobStorageLocation;
if exist(jsl,'dir')==7
    [success,emsg,eid] = rmdir(jsl,'s');
    if success==false
        error(eid,emsg)
    end
end

% Create local job storage location
[success,emsg,eid] = mkdir(jsl);
if success==false
    error(eid,emsg)
end

% Get Cluster Host and Remote Job Storage Location

FAILED = false;
try
    % Don't bother checking if the fields exist.  If they don't, we'll
    % return early anyway.
    clusterHost = c.AdditionalProperties.ClusterHost;
    remoteJobStorageLocation = c.AdditionalProperties.RemoteJobStorageLocation;
catch
    FAILED = true;
end
if FAILED==true || isempty(clusterHost) || isempty(remoteJobStorageLocation)
    % If either of these are empty, we (a) can't connect to the cluster
    % (must be running "shared") or (b) there's nothing to cleanup
    % (directory is empty).  Return early.
    return
end

% Get remote connection
% getRemoteConnection is not on our path, so temporarily add its folder,
% call it, then remove the folder from our path.
addpath(c.IntegrationScriptsLocation)
remoteConnection = getRemoteConnection(c, clusterHost, remoteJobStorageLocation, false);
rmpath(c.IntegrationScriptsLocation)

% Delete old remote job storage location
try
    commandToRun = sprintf('rm -rf %s',remoteJobStorageLocation);
    % Execute the command on the remote host.
    [cmdFailed, cmdOut] = remoteConnection.runCommand(commandToRun);
catch err
    cmdFailed = true;
    cmdOut = err.message;
end
if cmdFailed
    dctSchedulerMessage(1, '%s: Failed to delete remote job storage location on cluster.  Reason:\n\t%s', currFilename, cmdOut);
end

% We could recreate the remote job storage location, but the next time we
% submit a job, it'll automatically get created for us.  Additionally, we
% need to have the storage metadata file recreated anyway.  The next job we
% create will generate this warning:

% Warning: The storage metadata file did not exist. Recreating it.

% % try
% %     commandToRun = sprintf('mkdir -p %s',remoteJobStorageLocation);
% %     % Execute the command on the remote host.
% %     [cmdFailed, cmdOut] = remoteConnection.runCommand(commandToRun);
% % catch err
% %     cmdFailed = true;
% %     cmdOut = err.message;
% % end
% % if cmdFailed
% %     dctSchedulerMessage(1, '%s: Failed to create remote job storage location on cluster.  Reason:\n\t%s', currFilename, cmdOut);
% % end
