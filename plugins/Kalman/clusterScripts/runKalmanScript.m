%================================================
% Some of the setting might already applied to the 
% saved project. 

%
% This script:

% 1. Set noise of the measurement
% 2. Selects the leadfield
% 3. creates a measurement data 
% 4. runs kalman
% 5. saves measurement and reconstruction to 
%    data bank
% 6. creates a figure with parcellation tool
% 7. saves the figure

%================================================

% open GUI tools
zef_start_dataBank;
zef_kf_start;
zef_minimum_norm_estimation;

find_synthetic_source;

zef_parcellation_tool;
zef_update;

% SNR 1, 3, 5, 10. 0dB, 9.542dB, 13.98dB, 20dB
% Set noise level
noise_level = -20;
for zef_n = 1:length(zef.synth_source_data)
    zef.synth_source_data{zef_n}.parameters{8,2} = num2str(noise_level);
end
% Default -46dB ,-25 -15, -5
bg_noise = -46;
zef.find_synth_source.h_bg_noise.Value = num2str(bg_noise);
zef.fss_bg_noise = str2num(zef.find_synth_source.h_bg_noise.Value);

%Click toggle buttton twice
zef.find_synth_source.h_plot_switch.Value = '1';
zef.find_synth_source.h_plot_switch.Value = '0';
zef.synth_source_updated_true = false;


% Load leadfield
zef.dataBank.hash = 'node_5';
zef.dataBank.loadParents=false; 
zef_dataBank_getHashForMenu;
zef_dataBank_setData;

zef_update;
for i = 1:2
%find synth source


% Generate time sequence "button"
zef_update_fss; 
[zef.time_sequence,zef.time_variable] = zef_generate_time_sequence;

% Create synthetic data "button"
zef_update_fss; 
zef.measurements = zef_find_source;

inv_type = 'MNE';
switch inv_type
    case 'kalman'
        % RUN KALMAN
        zef.KF.inv_multires_n_levels.Value = '1';
        zef.KF.inv_multires_sparsity.Value = '1';
        zef.KF.inv_multires_n_decompositions.Value = '1';


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
        zef.KF.number_of_frames.Value = '48';
        zef.KF.inv_time_3.Value = '0.0002';

        zef.KF.normalize_data.Value = '4';
        zef.KF.kf_smoothing.Value = '1';

        %eval('base',zef.KF.ApplyButton.ButtonPushedFcn);
        zef_props = properties(zef.KF); 
        for zef_i = 1:length(zef_props) 
            if isprop(zef.KF.(zef_props{zef_i}),'Value') 
                zef.(zef_props{zef_i}) = str2num(zef.KF.(zef_props{zef_i}).Value); 
            end
        end
        clear zef_props zef_i;
        [zef.kf_multires_dec, zef.kf_multires_ind, zef.kf_multires_count] = make_multires_dec();
        [zef.reconstruction, zef.reconstruction_information] = zef_KF;
        % END KALMAN
    case 'MNE'
        zef.h_mne_prior.Value = 2;
        zef.h_mne_type.Value = 3;
        zef.h_mne_sampling_frequency.String = '5000';
        zef.h_mne_low_cut_frequency.String = '0';
        zef.h_mne_high_cut_frequency.String = '0';
        zef.h_mne_normalize_data.Value = 4;
        zef.h_mne_time_1.String = '0.121';
        zef.h_mne_time_2.String = '0';
        zef.h_mne_time_3.String = '0.0002';
        zef.h_mne_number_of_frames.String = '48';
        
        zef_update_mne;
        [zef.reconstruction, zef.reconstruction_information] = zef_find_mne_reconstruction([]);
end



% save to databank

zef.dataBank.app.Entrytype.Value = 'data';
zef_dataBank_addButtonPress;

zef.dataBank.app.Entrytype.Value = 'reconstruction';
zef_dataBank_addButtonPress;



zef.h_parcellation_plot_type.Value = 20;
zef.h_time_series_tools_list.Value = 21;

% Take sg006 and lh023
zef.h_parcellation_list.Value = [23,78];
zef.parcellation_selected = get(zef.h_parcellation_list,'value');

zef.parcellation_time_series = zef_parcellation_time_series([]);
zef_plot_parcellation_time_series([]);

save_path = zef.save_file_path;
savefig(fullfile(save_path,['figures/rec_',num2str(i),'.fig']))

end