function jsl = jobStorageLocation(job)
% Prints out the job storage location for the job.

% Copyright 2014-2019 The MathWorks, Inc.

narginchk(1,1)
if numel(job)>1
    error('Must only supply one job.')
end

if ~isa(job,'parallel.job.CJSIndependentJob') ...
        && ~isa(job,'parallel.job.CJSCommunicatingJob')
    error('Must provide Independent or Communicating Job')
end

jsl = fullfile(job.Parent.JobStorageLocation,['Job' num2str(job.ID)]);
if exist(jsl,'dir')==false
    error('Failed to find job storage location for Job %d.',job.ID)
end

end
