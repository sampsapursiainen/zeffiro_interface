%================================================
% Some of the setting are already applied to the 
% saved project. For example leadfield is selected
% and each source noise levels are already set to
% the project file.
% Also some of the parcellation tool settings are 
% already selected at the project file.

%
% This script:
% 1. creates a measurement data 
% 2. runs kalman
% 3. saves measurement and reconstruction to 
%   data bank
% 4. creates a figure with parcellation tool
% 5. saves the figure

%================================================

% open GUI tools
zef_start_dataBank;
zef_kf_start;

find_synthetic_source;
zef_update;
for i = 1:50
%find synth source


% Generate time sequence "button"
zef_update_fss; 
[zef.time_sequence,zef.time_variable] = zef_generate_time_sequence;

% Create synthetic data "button"
zef_update_fss; 
zef.measurements = zef_find_source;



% RUN KALMAN
zef.KF.inv_multires_n_levels.Value = '1';
zef.KF.inv_multires_sparsity.Value = '1';
zef.KF.inv_multires_n_decompositions.Value = '1';
[zef.kf_multires_dec, zef.kf_multires_ind, zef.kf_multires_count] = make_multires_dec();

% Basic Kalman,EnKF,Kalman sLORETA 1,2,3
zef.KF.filter_type.Value = '1';
zef.KF.number_of_ensembles.Value = '100';
%Spatially balanced, Spatially constant 1,2
zef.KF.mne_prior.Value = '1';
zef.KF.inv_snr.Value = '26';
zef.KF.inv_sampling_frequency.Value = '5000';
zef.KF.inv_low_cut_frequency.Value = '0';
zef.KF.inv_high_cut_frequency.Value = '0';
zef.KF.inv_time_1.Value = '0.121';
zef.KF.inv_time_2.Value = '0';
zef.KF.number_of_frames.Value = '20';
zef.KF.inv_time_3.Value = '0.0005';

zef.KF.normalize_data.Value = '4';
zef.KF.kf_smoothing.Value = '1';

eval('base',zef.KF.ApplyButton.ButtonPushedFcn);

[zef.reconstruction, zef.reconstruction_information] = zef_KF;

% save to databank

zef.dataBank.app.Entrytype.Value = 'data';
zef_dataBank_addButtonPress;

zef.dataBank.app.Entrytype.Value = 'reconstruction';
zef_dataBank_addButtonPress;

zef_parcellation_tool;
zef_update;

zef.h_parcellation_plot_type.Value = 20;
zef.h_time_series_tools_list.Value = 21;

zef.parcellation_time_series = zef_parcellation_time_series([]);
zef_plot_parcellation_time_series([]);

save_path = zef.save_file_path;
savefig(fullfile(save_path,['figures/rec_',num2str(i),'.fig']))

end