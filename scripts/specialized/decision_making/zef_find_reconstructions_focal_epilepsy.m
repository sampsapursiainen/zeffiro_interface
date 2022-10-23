zef_parameters_focal_epilepsy;

zef_start_dataBank;
       
%EEG
zef.L =  zef.dataBank.tree.node_1_1.data.L;
zef.source_positions = zef.dataBank.tree.node_1_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_1_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_1_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_1_1.data.source_interpolation_ind;

zef.measurements = zef.dataBank.tree.node_1_2.data.measurements;

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

%MNE-RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '20';
zef.h_ramus_snr.String = num2str(snr_val);
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_1_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
zef.dipole_app.inv_snr.Value = num2str(snr_val);
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_1_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_val);
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_1_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_5.data.reconstruction_information = zef.reconstruction_information;

%IAS
ias_map_estimation;
zef.h_ias_type.Value = 1;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_1_2_6.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_6.data.reconstruction_information = zef.reconstruction_information;

%%Standardized IAS (Last step)
ias_map_estimation;
zef.h_ias_type.Value = 3;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_1_2_7.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_7.data.reconstruction_information = zef.reconstruction_information;

%%Standardized IAS (Each step)
ias_map_estimation;
zef.h_ias_type.Value = 2;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_1_2_8.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_8.data.reconstruction_information = zef.reconstruction_information;

%dSPM
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 2;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_1_2_9.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_9.data.reconstruction_information = zef.reconstruction_information;

%**************************************

%MEG
zef.L =  zef.dataBank.tree.node_2_1.data.L;
zef.source_positions = zef.dataBank.tree.node_2_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_2_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_2_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_2_1.data.source_interpolation_ind;

zef.measurements = zef.dataBank.tree.node_2_2.data.measurements;

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

%MNE-RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '20';
zef.h_ramus_snr.String = num2str(snr_val);
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_2_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
zef.dipole_app.inv_snr.Value = num2str(snr_val);
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_2_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_val);
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_1_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_1_2_5.data.reconstruction_information = zef.reconstruction_information;

%IAS
ias_map_estimation;
zef.h_ias_type.Value = 1;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_2_2_6.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_6.data.reconstruction_information = zef.reconstruction_information;

%Standardized IAS (Last step)
ias_map_estimation;
zef.h_ias_type.Value = 3;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_2_2_7.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_7.data.reconstruction_information = zef.reconstruction_information;

%Standardized IAS (Each step)
ias_map_estimation;
zef.h_ias_type.Value = 2;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_2_2_8.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_8.data.reconstruction_information = zef.reconstruction_information;


%dSPM
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 2;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_2_2_9.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_2_2_9.data.reconstruction_information = zef.reconstruction_information;

%**************************************

%MEEG
zef.L =  zef.dataBank.tree.node_3_1.data.L;
zef.source_positions = zef.dataBank.tree.node_3_1.data.source_positions;
zef.sensors = zef.dataBank.tree.node_3_1.data.sensors;
zef.imaging_method = zef.dataBank.tree.node_3_1.data.imaging_method;
zef.source_interpolation_ind = zef.dataBank.tree.node_3_1.data.source_interpolation_ind;

zef.measurements = zef.dataBank.tree.node_3_2.data.measurements;

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

%MNE-RAMUS
zef_ramus_inversion_tool;
zef.h_ramus_hyperprior.Value = 2; 
zef.h_ramus_multires_n_decompositions.String = '20';
zef.h_ramus_snr.String = num2str(snr_val);
eval(zef.h_ramus_start.Callback);
zef.dataBank.tree.node_3_2_3.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_3.data.reconstruction_information = zef.reconstruction_information;

%Dipole Scan
zef_dipole_start;
zef.dipole_app.inv_snr.Value = num2str(snr_val);
eval(zef.dipole_app.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_3_2_4.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_4.data.reconstruction_information = zef.reconstruction_information;

%Beamformer
zef_beamformer_start;
zef.beamformer.inv_snr.Value = num2str(snr_val);
eval(zef.beamformer.StartButton.ButtonPushedFcn);
zef.dataBank.tree.node_3_2_5.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_5.data.reconstruction_information = zef.reconstruction_information;

%IAS
ias_map_estimation;
zef.h_ias_type.Value = 1;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_3_2_6.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_6.data.reconstruction_information = zef.reconstruction_information;

%Standardized IAS (Last step)
ias_map_estimation;
zef.h_ias_type.Value = 3;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_3_2_7.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_7.data.reconstruction_information = zef.reconstruction_information;

%Standardized IAS (Each step)
ias_map_estimation;
zef.h_ias_type.Value = 2;
zef.h_ias_snr.String = num2str(snr_val);
zef.h_ias_n_map_iterations.String = '5';
eval(zef.h_ias_start.Callback);
zef.dataBank.tree.node_3_2_8.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_8.data.reconstruction_information = zef.reconstruction_information;

%dSPM
zef_minimum_norm_estimation;
zef.h_mne_prior.Value = 2;
zef.h_mne_type.Value = 2;
eval(zef.h_mne_start.Callback);
zef.dataBank.tree.node_3_2_9.data.reconstruction = zef.reconstruction;
zef.dataBank.tree.node_3_2_9.data.reconstruction_information = zef.reconstruction_information;