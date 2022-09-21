function ret = runJob
try
profile on
ret = cell(0);
ret{1} = maxNumCompThreads;
file_path = '/scratch/project_2005561/';
%file_path = '/media/datadisk/paavo/modeldata/';
orig_file = 'P20N20_SEP_timeseries_multiLF_10k_leadfield_20step_rts.mat';
save_file = 'P20N20_SEP_timeseries_multiLF_10k_leadfield_20step_rts_rec.mat';
fullpath = fullfile(file_path,orig_file);
tic;
zeffiro_interface('start_mode','nodisplay',...
    'open_project', fullpath, ...
    'run_script', 'zef_kf_start',...
    'run_script', '[zef.reconstruction, zef.reconstruction_information] = zef_KF;',...
    'run_script', append('zef.save_file_path = ', '''',file_path,'''', ';'),...
    'run_script', append('zef.save_file = ', '''',save_file,'''', ';'),...
    'run_script', 'zef.save_switch = 7;',...
    'run_script', 'zef_save_nodisplay;');
ret{2} = toc;
profile off
profsave(profile('info'), fullfile(file_path,'myResults'));
catch exception
    ret{3} = exception;
end
end
