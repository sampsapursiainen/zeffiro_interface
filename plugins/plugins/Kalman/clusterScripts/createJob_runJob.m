% Run configCluster on command window before running
%%
c = parcluster;
c.AdditionalProperties.AccountName = 'project_2002680';
% MemUsage to memory per core (in MB)
c.AdditionalProperties.MemUsage = '1024';
% 5 hour walltime
c.AdditionalProperties.WallTime = '48:00:00';
c.AdditionalProperties.EmailAddress = 'paavo.ronni@tuni.fi';
c.AdditionalProperties.QueueName = 'small';
c.NumThreads = 20;
c.saveProfile

%%
j = cell(0);
idx = 1;
run_profiler = false;
folders = {'/scratch/project_2002680/Kalman/KalmanSLAuditory/', '/scratch/project_2002680/Kalman/KalmanAuditory/'};
for fol = folders
    f = fol{1}
    j{idx} = batch(c, @run_cluster_job,1,{fullfile(f,'/data/'), run_profiler}, 'CurrentFolder',fullfile(f,'/zeffiro_interface/'), 'AutoAddClientPath', false)
    idx = idx + 1;
end

%%


