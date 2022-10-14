%SNR 
snr_val = 5; 

%EEG
zef.L =  zef.dataBank.tree.node_1_1.data.L;
zef.source_positions = zef.dataBank.tree.node_1_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_1_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_1_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_1_1.data.source_interpolation_ind;

rand_data_point = randperm(size(zef.source_positions,2)); 
rand_data_point = rand_data_point(1);
rand_data_dir = randperm(3); 
rand_data_dir = rand_data_dir(1); 
zef.measurements = zef.L(:,3*(rand_data_point-1)+rand_data_dir);
zef.measurements = zef.measurements + 10.^(-snr_val/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.resection_points = zef.source_positions(rand_data_point,:);

%MNE
zef_minimum_norm_estimation
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback)
zef.dataBank.tree.node_1_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback)
zef.dataBank.tree.node_1_2_2.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_2.data.reconstruction_information = zef.reconstruction_information;

%RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '10';
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_1_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
eval(zef.dipole_app.StartButton.ButtonPushedFcn)
zef.dataBank.tree.node_1_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.cov_type.Value = '4';
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
zef.measurements = zef.measurements + 10.^(-snr_val/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.resection_points = zef.source_positions(rand_data_point,:);

%MNE
zef_minimum_norm_estimation
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback)
zef.dataBank.tree.node_2_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback)
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
eval(zef.dipole_app.StartButton.ButtonPushedFcn)
zef.dataBank.tree.node_2_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.cov_type.Value = '4';
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
zef.measurements = zef.measurements + 10.^(-snr_val/20)*max(abs(zef.measurements))*randn(size(zef.measurements));
zef.resection_points = zef.source_positions(rand_data_point,:);

%MNE
zef_minimum_norm_estimation
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 1;
eval(zef.h_mne_start.Callback)
zef.dataBank.tree.node_3_2_1.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_1.data.reconstruction_information = zef.reconstruction_information;

%sLORETA
zef.h_mne_type.Value = 3;
eval(zef.h_mne_start.Callback)
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
eval(zef.dipole_app.StartButton.ButtonPushedFcn)
zef.dataBank.tree.node_3_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.cov_type.Value = '4';
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_3_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_5.data.reconstruction_information = zef.reconstruction_information;

