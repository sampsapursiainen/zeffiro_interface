function commonSubmitArgs = getCommonSubmitArgs(cluster, numWorkers)
% Get any additional submit arguments for the Slurm sbatch command
% that are common to both independent and communicating jobs.

% Copyright 2016-2019 The MathWorks, Inc.

% https://docs.csc.fi/#computing/running/creating-job-scripts

commonSubmitArgs = '';

% Number of cores/node
ppn = validatedPropValue(cluster, 'ProcsPerNode', 'double');
if ppn>0
    % Don't request more cores/node than workers
    ppn = min(numWorkers,ppn);
    commonSubmitArgs = sprintf('%s --ntasks-per-node=%d',commonSubmitArgs,ppn);
end
commonSubmitArgs = sprintf('%s --ntasks-per-core=1',commonSubmitArgs);


%% REQUIRED

% AccountName
an = validatedPropValue(cluster, 'AccountName', 'char');
if isempty(an)
    emsg = sprintf(['\n\t>> %% Must set AccountName.  E.g.\n\n', ...
                    '\t>> c = parcluster;\n', ...
                    '\t>> c.AdditionalProperties.AccountName = ''account-name'';\n', ...
                    '\t>> c.saveProfile\n\n']);
    error(emsg) %#ok<SPERR>
else
    commonSubmitArgs = [commonSubmitArgs ' -A ' an];
end

% Walltime
wt = validatedPropValue(cluster, 'WallTime', 'char');
if isempty(wt)
    emsg = sprintf(['\n\t>> %% Must set WallTime.  E.g.\n\n', ...
                    '\t>> c = parcluster;\n', ...
                    '\t>> %% 5 hours\n', ...
                    '\t>> c.AdditionalProperties.WallTime = ''05:00:00'';\n', ...
                    '\t>> c.saveProfile\n\n']);
    error(emsg) %#ok<SPERR>
else
    commonSubmitArgs = [commonSubmitArgs ' -t ' wt];
end


%% OPTIONAL

% Partition
qn = validatedPropValue(cluster, 'QueueName', 'char');
if ~isempty(qn)
    commonSubmitArgs = [commonSubmitArgs ' -p ' qn];
end

% Check for GPU
ngpus = validatedPropValue(cluster, 'GpusPerNode', 'double');
if ngpus>0
    gcard = validatedPropValue(cluster, 'GpuCard', 'char', 'v100');
    commonSubmitArgs = sprintf('%s --gres=gpu:%s:%d', commonSubmitArgs, gcard, ngpus);
    commonSubmitArgs = strrep(commonSubmitArgs,'::',':');
end

% Physical Memory used by a single core
mu = validatedPropValue(cluster, 'MemUsage', 'char');
if ~isempty(mu)
    commonSubmitArgs = [commonSubmitArgs ' --mem-per-cpu=' mu];
end

% Local storage space per node
%
%  MW: From the Documentation
%
%       Some nodes in Puhti have a local fast storage available for jobs. The local storage is
%       good for I/O-intensive programs.
%
%       Request local storage using the --gres flag in the job submission:
%
%       --gres=nvme:<local_storage_space_per_node>
%
%       The amount of space is given in GB (with a maximum of 3600 GB per node). The local
%       storage reservation is on a per node basis.
%
%       Use the environment variable $LOCAL_SCRATCH in your batch job scripts to access the local
%       storage on each node.
%
%       Note:
%       The local storage is emptied after the job has finished, so please move any data you want
%       to keep to the shared disk area.
%
%  We'll support it, but not document it, in part because the disk is ephemeral and the user
%  would need to move it before the job is finished.  Not terrible likely to be used.
lss = validatedPropValue(cluster, 'LocalStorageSpacePerNode', 'char');
if ~isempty(lss)
    commonSubmitArgs = [commonSubmitArgs ' --gres=nvme:' lss];
end

% Email notification
ea = validatedPropValue(cluster, 'EmailAddress', 'char');
if ~isempty(ea)
    commonSubmitArgs = [commonSubmitArgs ' --mail-type=ALL --mail-user=' ea];
end

% Every job is going to require a certain number of MATLAB Parallel Server licenses.
% Specification of  licenses which must be allocated to this job.
%
% The /etc/slurm/slurm.conf file must list:
%
%   # MATLAB Parallel Server licenses
%   Licenses=MATLAB_Distrib_Comp_Engine:500
%
% And then call
%
%   % scontrol reconfigure
%
commonSubmitArgs = sprintf('%s --licenses=mdcs:%d',commonSubmitArgs,numWorkers);

% Catch-all
asa = validatedPropValue(cluster, 'AdditionalSubmitArgs', 'char');
if ~isempty(asa)
    commonSubmitArgs = [commonSubmitArgs ' ' asa];
end

commonSubmitArgs = strtrim(commonSubmitArgs);
