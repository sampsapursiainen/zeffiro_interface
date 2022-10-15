file_name = 'training_dataset_p1_10dB.mat';
project_file_name = 'p1_scaled_normal.mat';
folder_name = [fileparts(mfilename('fullpath')) filesep 'data'];
training_data_size = 50; 
snr_vec = [10]; 

training_data = struct;
file_name = [folder_name filesep file_name];
project_file_name = [folder_name filesep project_file_name];

zef = zeffiro_interface('start_mode','nodisplay','open_project',project_file_name);
zef_start_dataBank;

waitbar_counter = 0; 
h_waitbar = zef_waitbar(waitbar_counter/(training_data_size*length(snr_vec)),'Creating training dataset.');

for data_ind = 1 : training_data_size
for snr_ind = 1 : length(snr_vec)
    
waitbar_counter = waitbar_counter + 1; 
zef_waitbar(waitbar_counter/(training_data_size*length(snr_vec)),h_waitbar,'Creating training dataset.');
    
%EEG
zef.L =  zef.dataBank.tree.node_1_1.data.L;
zef.source_positions = zef.dataBank.tree.node_1_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_1_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_1_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_1_1.data.source_interpolation_ind;

rand_data_point = randperm(size(zef.source_positions,2)); 
rand_data_point = rand_data_point(1);
rand_data_dir = randn(3,1);
rand_data_dir = rand_data_dir/norm(rand_data_dir,2);
zef.measurements = rand_data_dir(1)*zef.L(:,3*(rand_data_point-1)+1)+rand_data_dir(2)*zef.L(:,3*(rand_data_point-1)+2)+rand_data_dir(3)*zef.L(:,3*(rand_data_point-1)+3);
zef.measurements = zef.measurements + 10.^(-snr_vec(snr_ind)/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.measurements = zef.measurements.*blackmanharris(zef.inv_sampling_frequency)';
zef.resection_points = zef.source_positions(rand_data_point,:);

zef.inv_snr = snr_vec(snr_ind);

%MNE
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;

zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_1_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_1_2_2.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_2.data.reconstruction_information = zef.reconstruction_information;

%RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '10';
zef.h_ramus_snr.String = num2str(snr_vec(snr_ind));
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_1_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
zef.dipole_app.inv_snr.Value = '20';
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_1_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_1_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_5.data.reconstruction_information = zef.reconstruction_information;

%**************************************

%MEG
zef.L =  zef.dataBank.tree.node_2_1.data.L;
zef.source_positions = zef.dataBank.tree.node_2_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_2_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_2_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_2_1.data.source_interpolation_ind;

rand_data_point = randperm(size(zef.source_positions,2)); 
rand_data_point = rand_data_point(1);
rand_data_dir = randperm(3); 
rand_data_dir = rand_data_dir(1); 
zef.measurements = zef.L(:,3*(rand_data_point-1)+rand_data_dir);
zef.measurements = zef.measurements + 10.^(-snr_vec(snr_ind)/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.measurements = zef.measurements.*blackmanharris(zef.inv_sampling_frequency)';
zef.resection_points = zef.source_positions(rand_data_point,:);

%MNE
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_2_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_2_2_2.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_2.data.reconstruction_information = zef.reconstruction_information;

%RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '10';
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_2_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_2_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_2_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_5.data.reconstruction_information = zef.reconstruction_information;


%**************************************

%MEEG
zef.L =  zef.dataBank.tree.node_3_1.data.L;
zef.source_positions = zef.dataBank.tree.node_3_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_3_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_3_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_3_1.data.source_interpolation_ind;

rand_data_point = randperm(size(zef.source_positions,2)); 
rand_data_point = rand_data_point(1);
rand_data_dir = randperm(3); 
rand_data_dir = rand_data_dir(1); 
zef.measurements = zef.L(:,3*(rand_data_point-1)+rand_data_dir);
zef.measurements = zef.measurements + 10.^(-snr_vec(snr_ind)/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.measurements = zef.measurements.*blackmanharris(zef.inv_sampling_frequency)';
zef.resection_points = zef.source_positions(rand_data_point,:);

%MNE
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_3_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_3_2_2.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_2.data.reconstruction_information = zef.reconstruction_information;

%RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '10';
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_3_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_3_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_3_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_5.data.reconstruction_information = zef.reconstruction_information;

zef_decision_script_perpepi_example;

training_data.table_data{data_ind}{snr_ind} = h_t.Data;
training_data.cluster_index_data{data_ind}{snr_ind} = J_aux;

end
end

training_data.snr_vec = snr_vec;

save(file_name,'training_data','-v7.3');
zef_close_all

