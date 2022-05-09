% Run configCluster on command window before running
%%
c = parcluster;
c.AdditionalProperties.AccountName = 'project_2002680';
% MemUsage to memory per core (in MB)
c.AdditionalProperties.MemUsage = '1024';
% 5 hour walltime
c.AdditionalProperties.WallTime = '10:00:00';
c.AdditionalProperties.EmailAddress = 'paavo.ronni@tuni.fi';
c.AdditionalProperties.QueueName = 'small';
c.NumThreads = 20;
c.saveProfile

%%
j = cell(0);
idx = 1;
folders = {'/scratch/project_2002680/Kalman/Noise14dB/', '/scratch/project_2002680/Kalman/Noise20dB/'};
for fol = folders
    f = fol{1}
    j{idx} = batch(c, @run_cluster_job,1,{fullfile(f,'/data/')}, 'CurrentFolder',fullfile(f,'/zeffiro_interface/'), 'AutoAddClientPath', false)
    idx = idx + 1;
end

%%


