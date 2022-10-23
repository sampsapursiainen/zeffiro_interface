training_data_file_name = '';
credibility_data_file_name = 'credibility_dataset_p1_10dB.mat';
project_file_name = '';

supervised_clustering = 'off';
frame_number = 1; 
max_iter = 10000;
training_data_size = 50; 
snr_vec = [10];
frame_number = 1;
cred_val_rec = 0.90;
cred_val_points = 0.90;
max_n_clusters = 100;
n_dynamic_levels = 4;
tol_val_rec = 1e-3;
tol_val_points = 1e-6;
reg_param_rec = 1E-1;
reg_param_points = 1e-3;

folder_name = [fileparts(mfilename('fullpath')) filesep 'data'];

credibility_data_file_name = [folder_name filesep credibility_data_file_name];
training_data_file_name = [folder_name filesep training_data_file_name];
project_file_name = [folder_name filesep project_file_name];