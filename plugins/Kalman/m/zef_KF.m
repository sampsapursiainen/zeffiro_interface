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
standardization_exponent = zef.standardization_exponent;
time_step = zef.inv_time_3;

%% Reconstruction identifiers
reconstruction_information.tag = 'Kalman';
reconstruction_information.inv_time_1 = zef.inv_time_1;
reconstruction_information.inv_time_2 = zef.inv_time_2;
reconstruction_information.inv_time_3 = zef.inv_time_3;
reconstruction_information.normalize_data = zef.normalize_data;
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

[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),zef.normalize_data,0);

% Transition matrix is Identity matrix
P = eye(size(L,2)) * theta0;

A = eye(size(L,2));

% If q_value given in the function call
if nargin > 1
    Q = q_value*eye(size(L,2));
else
    zef_init_gaussian_prior_options;
    evolution_prior_db = zef.inv_evolution_prior;
    q_value = find_evolution_prior(L, theta0, number_of_frames, evolution_prior_db, pm_val, snr_val);
    Q = q_value*eye(size(L,2));
end
reconstruction_information.Q = q_value;

% std_lhood
R = std_lhood^2 * eye(size(L,1));

Q_Store = cell(0);

%% KALMAN FILTER
filter_type = zef.filter_type;
smoothing = zef.kf_smoothing;
if filter_type == 1
    [P_store, z_inverse] = kalman_filter(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing);
elseif filter_type == 2
    n_ensembles = str2double(zef.KF.number_of_ensembles.Value);
    z_inverse = EnKF(m,A,P,Q,L,R,timeSteps,number_of_frames, n_ensembles);
elseif filter_type == 3
    [P_store, D_store, z_inverse] = kalman_filter_sLORETA(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing,standardization_exponent);
elseif filter_type == 4
    [P_store, z_inverse] = kalman_filter(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing);
    P_old = eye(size(L,2)) * theta0;
    H = L * sqrtm(P_old);
    W = inv((diag(diag(H'*inv(H*H' + R)*H))).^standardization_exponent);
    z_inverse = cellfun(@(x) W*x, z_inverse, 'UniformOutput', false);

end

%% RTS SMOOTHING

if (smoothing == 2)
    [~, m_s_store, ~] = RTS_smoother_nonstandardized(P_store, z_inverse, A, Q, number_of_frames);
    z_inverse = m_s_store;
elseif smoothing == 3
    if exist('D_store','var')
        [~, z_inverse, ~] = RTS_smoother_standardized(P_store, D_store, z_inverse, A, Q, number_of_frames);
    else
        warning('The filtering is done with a method non-compatible with the selected smoother. Smoothing neglected.')
    end
elseif smoothing == 4
    [~, z_inverse, ~] = RTS_smoother_normal2standardized(P_store, z_inverse, A, Q, L, R, standardization_exponent, number_of_frames);
elseif smoothing == 5
    if filter_type == 1
        [~, z_inverse, ~] = RTS_smoother_standardized(P_store, cell(0), z_inverse, A, number_of_frames);
    else
        [~, z_inverse, ~] = sample_RTS_smoother(P_store, D_store, z_inverse, A, number_of_frames, filter_type);
    end
end

%% POSTPROCESSING
[z] = zef_postProcessInverse(z_inverse, procFile);
%normalize the reconstruction so that the highest value is equal to 1
[z] = zef_normalizeInverseReconstruction(z);
%% CALCULATION ENDS HERE
zef.reconstruction_information = reconstruction_information;
zef.reconstruction = z;

end
