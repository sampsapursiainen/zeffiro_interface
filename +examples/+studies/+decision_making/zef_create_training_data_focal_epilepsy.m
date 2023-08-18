%file_name = 'training_dataset_p1_10dB.mat';
examples.studies.decision_making.zef_parameters_focal_epilepsy;

training_data = struct;

if not(exist('zef','var'))
    zef = zeffiro_interface('start_mode','nodisplay','open_project',project_file_name);
end
zef_start_dataBank;

waitbar_counter = 0;
h_waitbar = zef_waitbar(waitbar_counter,(training_data_size*length(snr_vec)),'Creating training dataset.');

for data_ind = 1 : training_data_size
    for snr_ind = 1 : length(snr_vec)

        waitbar_counter = waitbar_counter + 1;
        zef_waitbar(waitbar_counter,(training_data_size*length(snr_vec)),h_waitbar,'Creating training dataset.');

        rand_data_point = randperm(size(zef.source_positions,2));
        rand_data_point = rand_data_point(1);
        rand_data_dir = randn(3,1);
        rand_data_dir = rand_data_dir/norm(rand_data_dir,2);

        %EEG
        zef.L =  zef.dataBank.tree.node_1_1.data.L;
        zef.source_positions = zef.dataBank.tree.node_1_1.data.source_positions;
        zef.sensors = zef.dataBank.tree.node_1_1.data.sensors;
        zef.imaging_method = zef.dataBank.tree.node_1_1.data.imaging_method;
        zef.source_interpolation_ind = zef.dataBank.tree.node_1_1.data.source_interpolation_ind;

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

        %MNE-RAMUS
        zef_ramus_inversion_tool;
        zef.h_ramus_hyperprior.Value = 2;
        zef.h_ramus_multires_n_decompositions.String = '20';
        zef.h_ramus_snr.String = num2str(snr_vec(snr_ind));
        eval(zef.h_ramus_start.Callback);
        zef.dataBank.tree.node_1_2_3.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_3.data.reconstruction_information = zef.reconstruction_information;

        %Dipole Scan
        zef_dipole_start;
        zef.dipole_app.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.dipole_app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_1_2_4.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_4.data.reconstruction_information = zef.reconstruction_information;

        %Beamformer
        zef_beamformer_start;
        zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.beamformer.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_1_2_5.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_5.data.reconstruction_information = zef.reconstruction_information;

        %IAS
        ias_map_estimation;
        zef.h_ias_type.Value = 1;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_1_2_6.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_6.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Last step)
        ias_map_estimation;
        zef.h_ias_type.Value = 3;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_1_2_7.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_7.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Each step)
        ias_map_estimation;
        zef.h_ias_type.Value = 2;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
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

        %EXP-L1
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 1;
        zef.EXP.parameters.exp_hypermode = 3;
        zef.EXP.parameters.exp_theta0 = 1e-8;
        zef.EXP.parameters.exp_beta = 3;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 10;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_1_2_10.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_10.data.reconstruction_information = zef.reconstruction_information;

        %EXP-L1-sLORETA
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 3;
        zef.EXP.parameters.exp_hypermode = 2;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 10;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_1_2_11.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_11.data.reconstruction_information = zef.reconstruction_information;

        %**************************************

        %MEG
        zef.L =  zef.dataBank.tree.node_2_1.data.L;
        zef.source_positions = zef.dataBank.tree.node_2_1.data.source_positions;
        zef.sensors = zef.dataBank.tree.node_2_1.data.sensors;
        zef.imaging_method = zef.dataBank.tree.node_2_1.data.imaging_method;
        zef.source_interpolation_ind = zef.dataBank.tree.node_2_1.data.source_interpolation_ind;

        zef.measurements = rand_data_dir(1)*zef.L(:,3*(rand_data_point-1)+1)+rand_data_dir(2)*zef.L(:,3*(rand_data_point-1)+2)+rand_data_dir(3)*zef.L(:,3*(rand_data_point-1)+3);
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

        %MNE-RAMUS
        zef_ramus_inversion_tool;
        zef.h_ramus_hyperprior.Value = 2;
        zef.h_ramus_multires_n_decompositions.String = '20';
        zef.h_ramus_snr.String = num2str(snr_vec(snr_ind));
        eval(zef.h_ramus_start.Callback);
        zef.dataBank.tree.node_2_2_3.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_3.data.reconstruction_information = zef.reconstruction_information;

        %Dipole Scan
        zef_dipole_start;
        zef.dipole_app.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.dipole_app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_2_2_4.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_4.data.reconstruction_information = zef.reconstruction_information;

        %Beamformer
        zef_beamformer_start;
        zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.beamformer.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_1_2_5.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_1_2_5.data.reconstruction_information = zef.reconstruction_information;

        %IAS
        ias_map_estimation;
        zef.h_ias_type.Value = 1;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_2_2_6.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_6.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Last step)
        ias_map_estimation;
        zef.h_ias_type.Value = 3;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_2_2_7.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_7.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Each step)
        ias_map_estimation;
        zef.h_ias_type.Value = 2;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
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

        %EXP-L1
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 1;
        zef.EXP.parameters.exp_hypermode = 3;
        zef.EXP.parameters.exp_theta0 = 1e-8;
        zef.EXP.parameters.exp_beta = 3;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 1;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_2_2_10.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_10.data.reconstruction_information = zef.reconstruction_information;

        %EXP-L1-sLORETA
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 3;
        zef.EXP.parameters.exp_hypermode = 2;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 5;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_2_2_11.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_2_2_11.data.reconstruction_information = zef.reconstruction_information;

        %**************************************

        %MEEG
        zef.L =  zef.dataBank.tree.node_3_1.data.L;
        zef.source_positions = zef.dataBank.tree.node_3_1.data.source_positions;
        zef.sensors = zef.dataBank.tree.node_3_1.data.sensors;
        zef.imaging_method = zef.dataBank.tree.node_3_1.data.imaging_method;
        zef.source_interpolation_ind = zef.dataBank.tree.node_3_1.data.source_interpolation_ind;

        zef.measurements = rand_data_dir(1)*zef.L(:,3*(rand_data_point-1)+1)+rand_data_dir(2)*zef.L(:,3*(rand_data_point-1)+2)+rand_data_dir(3)*zef.L(:,3*(rand_data_point-1)+3);
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

        %MNE-RAMUS
        zef_ramus_inversion_tool;
        zef.h_ramus_hyperprior.Value = 2;
        zef.h_ramus_multires_n_decompositions.String = '20';
        zef.h_ramus_snr.String = num2str(snr_vec(snr_ind));
        eval(zef.h_ramus_start.Callback);
        zef.dataBank.tree.node_3_2_3.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_3.data.reconstruction_information = zef.reconstruction_information;

        %Dipole Scan
        zef_dipole_start;
        zef.dipole_app.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.dipole_app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_3_2_4.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_4.data.reconstruction_information = zef.reconstruction_information;

        %Beamformer
        zef_beamformer_start;
        zef.beamformer.inv_snr.Value = num2str(snr_vec(snr_ind));
        eval(zef.beamformer.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_3_2_5.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_5.data.reconstruction_information = zef.reconstruction_information;

        %IAS
        ias_map_estimation;
        zef.h_ias_type.Value = 1;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_3_2_6.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_6.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Last step)
        ias_map_estimation;
        zef.h_ias_type.Value = 3;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
        zef.h_ias_n_map_iterations.String = '5';
        eval(zef.h_ias_start.Callback);
        zef.dataBank.tree.node_3_2_7.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_7.data.reconstruction_information = zef.reconstruction_information;

        %%Standardized IAS (Each step)
        ias_map_estimation;
        zef.h_ias_type.Value = 2;
        zef.h_ias_snr.String = num2str(snr_vec(snr_ind));
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

        %EXP-L1
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 1;
        zef.EXP.parameters.exp_hypermode = 3;
        zef.EXP.parameters.exp_theta0 = 5e-3;
        zef.EXP.parameters.exp_beta = 3;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 1;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_3_2_10.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_10.data.reconstruction_information = zef.reconstruction_information;

        %EXP-L1-sLORETA
        zef = zef_exp_app_start(zef);
        zef.EXP.app.inv_snr.Value = snr_vec(1);
        zef.EXP.parameters.exp_estimation_type = 3;
        zef.EXP.parameters.exp_hypermode = 2;
        zef.EXP.parameters.exp_q = 1;
        zef.EXP.parameters.exp_n_map_iterations = 5;
        zef.EXP.parameters.exp_n_L1_iterations = 5;
        eval(zef.EXP.app.StartButton.ButtonPushedFcn);
        zef.dataBank.tree.node_3_2_11.data.reconstruction = zef.reconstruction;
        zef.dataBank.tree.node_3_2_11.data.reconstruction_information = zef.reconstruction_information;

        [z_inverse_results,z_inverse_info] = zef_dataBank_get_reconstructions(zef,frame_number);

        training_data.z_inverse_results{data_ind}{snr_ind} = z_inverse_results;
        training_data.z_inverse_info{data_ind}{snr_ind} = z_inverse_info;
        training_data.dipole_positions{data_ind}{snr_ind} = zef.source_positions(rand_data_point,:);
        training_data.dipole_moments{data_ind}{snr_ind} = rand_data_dir;


    end
end

training_data.snr_vec = snr_vec;

save(training_data_file_name,'training_data','-v7.3');
%zef_close_all

