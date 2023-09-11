%%
zef = zef_KalmanDemo_create_measurement();
%%
zef = zef_KalmanDemo_runKalman(zef);
%%
%zef = zef_KalmanDemo_save(zef);
%% Visualization
%(!!!) Under maintenance (!!!)
%zef = zef_Kalman_visualization(project_struct);
%%

function project_struct = zef_KalmanDemo_runKalman(project_struct)
    % How to use kalman without GUI
    % kalman settings
    project_struct.inv_snr = 25;
    project_struct.inv_sampling_frequency = 2500;
    project_struct.inv_low_cut_frequency = 0;
    project_struct.inv_high_cut_frequency = 0;
    project_struct.number_of_frames = 26;
    project_struct.inv_time_1 = 0;
    project_struct.inv_time_2 = 0;
    project_struct.inv_time_3 = 0.0004;
    project_struct.normalize_data = 1;
    project_struct.inv_evolution_prior = -34;
    % 1 kalman, 2 enkf, 3 kalman sl, 4 kalman spatial sl
    project_struct.filter_type = 1;
    % 1 none, 2 RTS
    project_struct.kf_smoothing = 1;

    % run the inverse method
    [project_struct] = zef_KF(project_struct);

end % function

function project_struct = zef_KalmanDemo_save(project_struct)
    zef_save(project_struct,'example_project.mat','data/');
    zef_close_all(project_struct);
end

function project_struct = zef_KalmanDemo_create_measurement()

    % Create mesh and lead field based on a segmentation folder. It is the default
    % value for the meshing example, and hence not given here.

    project_struct = examples.lead_field_example ( ...
        'mesh_resolution' , 4.5 , ...
        'n_sources' , 2000 , ...
        'source_direction_mode' , 1 , ... Cartesian sources
        'mesh_smoothing_on' , true , ...
        'refinement_on' , true , ...
        'refinement_surface_on' , true , ...
        'lead_field_type' , 1 ... EEG
    ) ;

    % simulate the originators of somatosensory P20/N20 component and EEG measurement

    noise_dB = 25;  %magnitude of measurement noise
    sampling_frequency = 2500;  %sampling reguency (for data-making)

    % cortical originator:
    pos(1,:) = [-33,-37,80]; %position
    ori(1,:) = [0.2,1,0]; %orientation vector
    amp(1) = 10; %amplitudi (nAm)


    % thalamic originator:
    pos(2,:) = [-12,-32,50]; %position
    ori(2,:) = [0.2,0.196,-0.98058]; %orientation vector
    amp(2) = 10; %amplitudi (nAm)

    ori = ori./sqrt(sum(ori.^2,2));  %set the L2-norm to 1

    t = 0:(1/sampling_frequency):0.01;    %time course in seconds
    sz = find(t>0.008,1);     %width of the Gaussian pulse (Blackman-Harris window)
    time_series = [zeros(1,length(t)-sz),blackmanharris(sz)']; %model the time evolution of  dipole strengths as Gaussian pulses
    %In the time series, the cortical source (1) peaks at 0.006 s and
    %the thalamic source (2) at 0.004 s, 2 ms apart as the duration of the
    %neural signal is estimated to travel from thalamus to the cortex.
    time_series(2,:) = flip(time_series);
    noise = randn(size(project_struct.L,1),length(t));  %Gaussian measurement noise
    %find the proper indices for non-normal directioned (cartesian directioned)
    %lead field inside the brain, i.e., excluding skin, skull and other outter
    %layers
    project_struct.source_direction_mode = 2;
    [~,n_interp,procFile] = zef_processLeadfields(project_struct);
    project_struct.source_direction_mode = 1;

    mesh_points = project_struct.source_positions(procFile.s_ind_0,:); %source points within the brain
    source_ind = nan(2,1);
    %find the source points that best corresponds to the given source locations
    %in variable "pos" by Euclidean distance
    for i = 1:2
        [~,source_ind(i)] = min(sum((mesh_points-pos(i,:)).^2,2));
    end
    source_ind = [source_ind;source_ind+n_interp;source_ind+2*n_interp]; %set source point indices to "3D" indices for the lead field
    L = 1e-6*project_struct.L(:,procFile.s_ind_1(source_ind));  %lead field matrix for these two sources tranformed into proper units

    project_struct.measurements = (L.*ori(:)')*repmat((amp'.*time_series),3,1);    %noiseless measurements
    %additing the noise based on the SNR
    project_struct.measurements = project_struct.measurements + (10^(-noise_dB/20)*sqrt(sum(project_struct.measurements.^2,2)./sum(noise.^2,2))).*noise;

end % function

function project_struct = zef_KalmanDemo_visualize(project_struct)
    zef.h_zeffiro.Visible = 1;
    zef.use_display = 1;
    project_struct.visualization_type = 3;
    zef_visualize_surfaces(project_struct)
end

function project_struct = zef_Kalman_visualization(project_struct)
    zef_figure_tool
    project_struct.h_zeffiro.Visible = 1;
    project_struct.use_display = 1;
    project_struct.visualization_type = 3;
    project_struct.cp2_on = 0;
    project_struct.cp_on = 0;
    project_struct.cp3_on = 0;
    zef_visualize_surfaces
end
