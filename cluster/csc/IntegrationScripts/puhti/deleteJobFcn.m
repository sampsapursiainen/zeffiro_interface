function deleteJobFcn(cluster, job)
%DELETEJOBFCN Deletes a job on cluster
%
% Set your cluster's PluginScriptsLocation to the parent folder of this
% function to run it when you delete a job.

% Copyright 2017-2018 The MathWorks, Inc.
cancelJobFcn(cluster, job);
