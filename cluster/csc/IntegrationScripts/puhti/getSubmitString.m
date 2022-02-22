function submitString = getSubmitString(jobName, quotedLogFile, quotedCommand, additionalSubmitArgs, jobArrayString)
%GETSUBMITSTRING Gets the correct sbatch command for a Slurm cluster

% Copyright 2010-2019 The MathWorks, Inc.

if ~isempty(jobArrayString)
    jobArrayString = strcat(' --array=''[', jobArrayString, ']''');
end

submitString = sprintf('sbatch --job-name=%s%s --output=%s %s %s', ...
    jobName, jobArrayString, quotedLogFile, additionalSubmitArgs, quotedCommand);
