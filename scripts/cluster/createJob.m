% Run configCluster on command window before running
%%
c = parcluster;
c.AdditionalProperties.AccountName = 'project_<number>';
% MemUsage to memory per core (in MB)
c.AdditionalProperties.MemUsage = '250000';
% 5 hour walltime
c.AdditionalProperties.WallTime = '05:00:00';
c.AdditionalProperties.EmailAddress = 'etu.suku@tuni.fi';
c.AdditionalProperties.QueueName = 'small';
c.saveProfile

%%
j = batch(c, 'runSript', 'CurrentFolder', '/projappl/project_<number>/m', 'AutoAddClientPath', false)
