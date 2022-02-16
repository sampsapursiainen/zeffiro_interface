function [schedulerIDs, numTasks] = getSimplifiedSchedulerIDsForJob(job, data)
%GETSIMPLIFIEDSCHEDULERIDSFORJOB Returns the smallest possible list of Slurm JobIDs that describe the MATLAB job.
%
% SCHEDULERIDS = getSimplifiedSchedulerIDsForJob(JOB) returns the smallest
% possible list of Slurm job IDs that describe the MATLAB job JOB. The
% function converts child job IDs of a job array to the parent job ID of
% the array, and removes any duplicates.
%
% [SCHEDULERIDS, NUMTASKS] = getSimplifiedSchedulerIDsForJob(JOB) also
% returns the number of tasks that SCHEDULERIDS represents.

% Copyright 2019 The MathWorks, Inc.

if verLessThan('matlab', '9.7') 
    schedulerIDs = data.ClusterJobIDs;
    numTasks = numel(job.Tasks);
else 
    schedulerIDs = job.getTaskSchedulerIDs();
    numTasks = numel(schedulerIDs);
end

% Child jobs within a job array will have a schedulerID of the form
% <parent job ID>_<array index>.
schedulerIDs = regexprep(schedulerIDs, '_\d+', '');
schedulerIDs = unique(schedulerIDs, 'stable');

end
