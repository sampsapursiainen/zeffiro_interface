function pc = config_csc_cluster ( kwargs )
%
% config_csc_cluster (
%   computingproject,
%   memusage,
%   queuename,
%   walltime,
%   kwargs
% )
%
% Runs the configCluster function provided as a part of the CSC setup tools,
% which can be obtained from https://docs.csc.fi/apps/matlab/#installing-the-tool-scripts,
% as long as one has credentials to the linked service.
%
% Inputs:
%
% - computingproject
%
%   The name of the computing project which will be billed for the jobs sent to
%   it. Must have the form project_<integer>, where <integer> is a positive
%   integer.
%
% - memusage
%
%   The expected maximum memory usage per worker of the next job that is to be sent to the cluster.
%   Has the format "<integer><suffix>", where <suffix> is one of "k", "m" or "g".
%
% - queuename
%
%   The name of the partition where the job will be sent. One of "test",
%   "interactive", "small", "large", "longrun", "hugemem", "hugemem_longrun",
%   "gputest", "gpu".
%
% - walltime
%
%   The maximum expected runtime of a job sent to the cluster. Must have the
%   format hh:mm:ss, where hh represents hours, mm represents minutes and ss
%   represents seconds.
%
% - kwargs.emailaddress = ""
%
%   Set this to your e-mail address, if you wish to receive notifications about job progression.
%
% - kwargs.gpucard = ""
%
%   Set this to the name of a GPU card you wish to use, when sending a job to
%   the "gputest" or "gpu" partitions.
%
% - kwargs.gpuspernode = 1
%
%   Set this to the number of GPUs you wish to use per remote cluster node.
%   Remember that this might have an effect on the project billing.
%
% Outputs:
%
% - pc
%
%   The parcluster whose settings this function modified or set.
%

    arguments
        computingproject (1,1) string { hasValidComputingProjectFormat }
        memusage (1,1) string { hasValidWallTimeFormat }
        queuename (1,1) string { mustBeMember( kwargs.queuename, ["test","interactive","small","large","longrun","hugemem","hugemem_longrun","gputest","gpu"] ) }
        walltime (1,1) string
        kwargs.emailaddress (1,1) string = ""
        kwargs.gpucard { mustBeMember( kwargs.gpucard, [ "", "v100" ] ) } = ""
        kwargs.gpuspernode (1,1) double { mustBeInteger, mustBeNonnegative } = 1
    end

    % Perform a few additional error checks.

    if ismember ( queuename, [ "gputest" ; "gpu" ] ) && gpucard == ""

        error ( "You intended to use the GPU partition " + queuename + ", but did not specify a GPU type via this function's arguments. Try again." ) ;

    end

    % Start out by calling the CSC-provided cluster configuration function.

    configCluster ;

    % Create a parcluster from the most recent configuration.

    pc = parcluster ;

    % Set parcluster properties.

    pc.AdditionalProperties.ComputingProject = kwargs.computingproject ;
    pc.AdditionalProperties.MemUsage = kwargs.memusage ;
    pc.AdditionalProperties.QueueName = kwargs.queuename ;
    pc.AdditionalProperties.WallTime = kwargs.walltime ;
    pc.AdditionalProperties.EmailAddress = kwargs.emailaddress ;
    pc.AdditionalProperties.GpuCard = kwargs.gpucard;
    pc.AdditionalProperties.GpusPerNode = kwargs.gpuspernode ;

    % Save the profile.

    pc.saveProfile ;

end % function

%%%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%%%

function hasValidComputingProjectFormat ( cp )
%
% hasValidComputingProjectFormat
%
% A validator function for checking the validity of a computing project string.
% It has to be of the form project_integer.
%

    arguments
        cp (1,1) string
    end

    msg = "The given computing project string " + cp + " does not have the required format 'project_<integer>', where <integer> is a non-negative integer." ;

    eid = "invalidComputingProjectFormat" ;

    split_cp_str = split ( cp, "_" ) ;

    if numel ( split_cp_str ) ~= 2

        throwAsCaller ( MException ( eid, msg ) )

    end

    prefix = split_cp_str ( 1 ) ;

    number = double ( split_cp_str ( 2 ) ) ;

    if prefix ~= "project"

        throwAsCaller ( MException ( eid, msg ) )

    end


    if isnan ( number ) || number < 0

        throwAsCaller ( MException ( eid, msg ) )

    end

end % function

function hasValidWallTimeFormat ( wt )
%
% hasValidWallTimeFormat
%
% A validator function for checking that the passed-in wall time string has a
% correct format.
%


    arguments
        wt (1,1) string
    end

    msg = "The given wall time string " + cp + " does not have the required format 'hours:minutes:seconds', where hours, minutes and seconds are all non-negative." ;

    eid = "invalidWallTimeFormat" ;

    split_wt_str = split ( cp, ":" ) ;

    if numel ( split_cp_str ) ~= 3

        throwAsCaller ( MException ( eid, msg ) )

    end

    hours   = double ( split_wt_str ( 1 ) ) ;
    minutes = double ( split_wt_str ( 2 ) ) ;
    seconds = double ( split_wt_str ( 3 ) ) ;

    if any ( isnan ( [hours, minutes, seconds] ) ) || any ( [ hours, minutes, seconds ] < 0 )

        throwAsCaller ( MException ( eid, msg ) )

    end

end % function

function hasValidMemUsageFormat ( in )
%
% hasValidMemUsageFormat
%
% Validates that a given memory usage string has a correct format.
%

    arguments
        in (1,1) string
    end

    msg = "The given memory usage string " + cp + " does not have the required format <integer><suffix>, where <integer> is a positive integer and <suffix> is one of '', 'k', 'm' or 'g'." ;

    eid = "invalidMemUsageFormat" ;

    in_len = strlength ( in ) ;

    last_char = extractBetween ( in, in_len, in_len ) ;

    in_double = double ( in ) ;

    last_char_double = double ( last_char ) ;

    if isnan ( last_char_double ) && not ( ismember ( last_char, [ "k" ; "m" ; "g" ] ) )

        throwAsCaller ( MException ( eid, msg ) )

    else if isnan ( in_double )

        throwAsCaller ( MException ( eid, msg ) )

    else

        % All is fine.

    end % if

end % function
