function ret = run_cluster_job(file_path, profiler_on)
try
if profiler_on
    profile on
end
ret = cell(0);
ret{1} = maxNumCompThreads;
%file_path = '/scratch/project_2002680/Kalman/Noise14dB/data/';
%file_path = '/media/datadisk/paavo/thesis_results/TestProject/';

orig_file = 'P20N20_SEP_withbig.mat';
save_file = 'P20N20_SEP_withbig_save.mat';
fullpath = fullfile(file_path,orig_file);
tic;
zeffiro_interface('start_mode','nodisplay',...
    'open_project', fullpath, ...
    'run_script', append('zef.save_file_path = ', '''',file_path,'''', ';'),...
    'run_script', append('zef.save_file = ', '''',save_file,'''', ';'),...
    'run_script', 'runKalmanScript_auditory',...
    'run_script', 'zef.save_switch = 7;',...
    'run_script', 'zef_save_nodisplay;');
ret{2} = toc;
if profiler_on
    profile off
    profsave(profile('info'), fullfile(file_path,'myResults'));
end
catch exception
    ret{3} = exception;
end
end
