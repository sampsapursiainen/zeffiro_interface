function [zef] = zef_KF(zef, q_value)
% Optimal q_value as parameter
%% Initial parameters
snr_val = zef.inv_snr;
pm_val = zef.inv_prior_over_measurement_db;
amplitude_db = zef.inv_amplitude_db;
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = zef.inv_sampling_frequency;
high_pass = zef.inv_low_cut_frequency;
low_pass = zef.inv_high_cut_frequency;
number_of_frames = zef.number_of_frames;
source_direction_mode = zef.source_direction_mode; 
source_directions = zef.source_directions;
source_positions = zef.source_positions;
time_step = zef.inv_time_3;

%% Reconstruction identifiers
reconstruction_information.tag = 'Kalman';
reconstruction_information.inv_time_1 = zef.inv_time_1;
reconstruction_information.inv_time_2 = zef.inv_time_2;
reconstruction_information.inv_time_3 = zef.inv_time_3;
reconstruction_information.sampling_freq = zef.inv_sampling_frequency;
reconstruction_information.low_pass = zef.inv_high_cut_frequency;
reconstruction_information.high_pass = zef.inv_low_cut_frequency;
reconstruction_information.number_of_frames = zef.number_of_frames;
reconstruction_information.source_direction_mode = zef.source_direction_mode;
reconstruction_information.source_directions = zef.source_directions;
reconstruction_information.snr_val = zef.inv_snr;
reconstruction_information.pm_val = zef.inv_prior_over_measurement_db;

%%
[L,n_interp, procFile] = zef_processLeadfields(zef);

%get ellipse filteres full measurement data. f_data: "sensors" x "time points"
[f_data] = zef_getFilteredData(zef); 
timeSteps = arrayfun(@(x) zef_getTimeStep(f_data, x, zef), 1:number_of_frames, 'UniformOutput', false);

z_inverse_results = cell(0);
%% CALCULATION STARTS HERE
% m_0 = prior mean
m = zeros(size(L,2), 1);
    
%[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),zef.normalize_data,0);
    
% Transition matrix is Identity matrix
%P = eye(size(L,2)) * theta0;

P = (1-std_lhood^2)*10.^(-(snr_val-pm_val)/10)*diag(mean(var(f_data(:,1:zef.kf_number_of_noise_steps),0,2))./repelem(sum(reshape(sum(L.^2),3,[])),3));

A = eye(size(L,2));
q_given_flag = false;
% If q_value given in the function call
if nargin > 1
    if max(size(q_value)) == 1
        Q = q_value*eye(size(L,2));
    elseif min(size(q_value)) == 1
        Q = diiag(q_value(:));
    else
        Q = q_value;
    end
    q_given_flag = true;
else
    zef_init_gaussian_prior_options;
    evolution_prior_db = zef.inv_evolution_prior;
    q_value = find_evolution_prior(L, f_data, std_lhood, evolution_prior_db, zef.kf_evolution_prior_mode);
    if zef.kf_evolution_prior_mode <= 2
        %time-dependent models
        Q = q_value;
    else
        q_given_flag = true;
        if zef.kf_evolution_prior_mode == 3
            %full matrix model
            Q = q_value;
        else
            %iid models
            Q = q_value*eye(size(L,2));
        end
    end
end
reconstruction_information.Q = q_value;
clear q_value
% std_lhood
R = std_lhood^2 * eye(size(L,1));

Q_Store = cell(0);

%% KALMAN FILTER
filter_type = zef.filter_type;
smoothing = zef.kf_smoothing;
if filter_type == 1
    [P_store, z_inverse] = kalman_filter(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing,q_given_flag);
elseif filter_type == 2
    n_ensembles = zef.number_of_ensembles;
    z_inverse = EnKF(m,A,P,Q,L,R,timeSteps,number_of_frames, n_ensembles,q_given_flag);
elseif filter_type == 3
    [P_store, z_inverse] = kalman_filter_sLORETA(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing,q_given_flag);
elseif filter_type == 4 
    [P_store, z_inverse] = kalman_filter(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing,q_given_flag);
    P_old = eye(size(L,2)) * theta0;
    H = L * sqrtm(P_old);
    W = inv(sqrtm(diag(diag(H'*inv(H*H' + R)*H))));
    z_inverse = cellfun(@(x) W*x, z_inverse, 'UniformOutput', false);
    
end

%% RTS SMOOTHING

if (smoothing == 2)
[~, m_s_store, ~] = RTS_smoother(P_store, z_inverse, A, Q, number_of_frames);
z_inverse = m_s_store;
end

%% POSTPROCESSING
[z] = zef_postProcessInverse(z_inverse, procFile);
%normalize the reconstruction so that the highest value is equal to 1
[z] = zef_normalizeInverseReconstruction(z);
%% CALCULATION ENDS HERE
zef.reconstruction_information = reconstruction_information;
zef.reconstruction = z;

end