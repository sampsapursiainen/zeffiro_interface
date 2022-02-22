function id = schedID(job)
% Prints out the scheduler job ID for the job.

% Copyright 2014-2019 The MathWorks, Inc.

if verLessThan('matlab','9.7')==false
    error('%s is only supported prior to 9.7.  Use job.getTaskSchedulerIDs() instead.',mfilename)
end

narginchk(1,1)
if numel(job)>1
    error('Must only supply one job.')
end

if ~isa(job,'parallel.job.CJSIndependentJob') ...
        && ~isa(job,'parallel.job.CJSCommunicatingJob')
    error('Must provide Independent or Communicating Job')
end

jcd = job.Parent.getJobClusterData(job);
if isempty(jcd)
    error('Job has not been submitted.')
end

id = jcd.ClusterJobIDs;
if length(id)==1
    id = id{:};
end

end
