function job = create_csc_job ( kwargs )
%
% utilities.cluster.create_csc_job (
%   ClusterProfile=...,
%   InputFn=...,
%   NofOutputs=...,
%   FnInputs=...,
%   kwargs ...
% )
%
% Creates a remote job on the CSC Puhti supercomputer.
%
% NOTE: You must have run the configCluster Matlab script provided by CSC at
% https://docs.csc.fi/apps/matlab/#installing-the-tool-scripts, and set up your
% credentials for this to work.
%
% Inputs:
%
% - kwargs.AttachedFiles
%
%   Data files that are to be copied to the workers.
%
% - kwargs.AutoAddClientPath
%
%   A boolean that determines whether the local matlab path is uploaded and
%   added into the matlab path of the workers on the remote.
%
% - kwargs.AutoAttachFiles
%
%   Whether to automatically upload the dependencies of InputFn to the workers.
%
% - kwargs.CaptureDiary
%
%   Whether to capture the diary of the jobs. Might be useful for remote
%   debugging, but also requires more data to be transferred over the wire.
%
% - kwargs.ClusterProfile
%
%   The name of the Matlab cluster profile, that was generated when the
%   configCluster function provided by the CSC was successfully run on the
%   system, where this function is being invoked.
%
% - kwargs.CurrentFolder
%
%   The path on the cluster that the job is run int. Zeffiro should probably be
%   installed in this folder...
%
% - kwargs.EnvironmentVariables
%
%   The list of environment variables that is to be uploaded to the workers.
%
% - kwargs.FnInputs
%
%   The inputs that the function takes in a (1,:) cell array.
%
% - kwargs.InputFn
%
%   A pointer to the function that will be run on the remote cluster.
%
% - kwargs.NofOutputs
%
%   The number of outputs that kwargs.InputFn returns.
%
% - kwargs.Pool
%
%   The number of workers to make into a parallel pool, either given as a
%   single non-negative integer or a pair of such integers. The latter case
%   will be interpreted as a range.
%
% Outputs:
%
% - job
%
%   The job that was sent to the remote cluster for evaluation. Call diary(job)
%   to find out what the current status of the job is, and fetchOutputs(job) to
%   collect the data from the cluster, once it is done with a computation.
%

    arguments
        kwargs.ClusterProfile (1,1) string { isExistingClusterProfile }
        kwargs.FnInputs (1,:) cell
        kwargs.InputFn (1,1) function_handle
        kwargs.NofOutputs (1,1) double { mustBeInteger, mustBePositive }
        kwargs.AttachedFiles (:,1) string = string([])
        kwargs.AutoAddClientPath (1,1) logical = true
        kwargs.AutoAttachFiles (1,1) logical = true
        kwargs.CaptureDiary (1,1) logical = true
        kwargs.CurrentFolder (1,1) string = "."
        kwargs.EnvironmentVariables (:,1) string = string([])
        kwargs.Pool (:,1) double { mustBeNonnegative, mustBeInteger } = 0
    end

    % Generate a parcluster with the given profile name.

    pc = parcluster ( kwargs.ClusterProfile ) ;

    % Check size of parallel pool.

    if not ( numel ( kwargs.Pool ) == 1 ) || not ( numel ( kwargs.Pool ) == 2 )

        poolsize = size ( kwargs.Pool ) ;

        error ( "Received a pool size specification of size " ...
            + poolsize ...
            + ". The size of a worker pool must be given as a single non-negative integer, " ...
            + "or a pair of such integers, which is interpreted as a range of possible values." ...
        ) ;

    end % if

    % Create and return the job.

    job = batch( ...
        pc, ...
        kwargs.InputFn, ...
        kwargs.NofOutputs, ...
        kwargs.FnInputs, ...
        "AttachedFiles", kwargs.AttachedFiles, ...
        "AutoAddClientPath", kwargs.AutoAddClientPath, ...
        "AutoAttachFiles", kwargs.AutoAttachFiles, ...
        "CaptureDiary", kwargs.CaptureDiary, ...
        "CurrentFolder", kwargs.CurrentFolder, ...
        "EnvironmentVariables", kwargs.EnvironmentVariables, ...
        "Pool", kwargs.Pool ...
    ) ;

end % function

%%%%%%%%%%%%%%% Helper functions.

function isExistingClusterProfile ( pn )
%
% isExistingClusterProfile
%
% Checks whether a given profile name is in the list of available profiles.
%

    arguments
        pn (1,1) string
    end

    % First get available profiles as a column vector of strings.

    profile_cells = parallel.listProfiles ;

    if isrow ( profile_cells )

        profile_cells = transpose ( profile_cells ) ;

    end

    profile_strings = string ( profile_cells ) ;

    % Then check for the existence of the given profile.

    if not ( ismember ( pn, profile_strings ) )

        err_msg = "The given profile name " ...
            + pn ...
            + " does not exist in the list of Matlab profiles. " ...
            + "Make sure you've run the configCluster function procided by CSC, if that is where you " ...
            + "intended the computation to run." ;

        eid_type = "nonExistentClusterProfile" ;

        throwAsCaller ( MException ( eid_type, err_msg ) )

    end

end % function
