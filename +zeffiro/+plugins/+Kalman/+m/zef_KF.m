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
[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

%get ellipse filteres full measurement data. f_data: "sensors" x "time points"
[f_data] = zef_getFilteredData; 
timeSteps = arrayfun(@(x) zef_getTimeStep(f_data, x, true, [], zef), 1:number_of_frames, 'UniformOutput', false);

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
    q_value = find_evolution_prior(L, theta0, time_step, evolution_prior_db);
    Q = q_value*eye(size(L,2));
end
reconstruction_information.Q = q_value;

% std_lhood
R = std_lhood^2 * eye(size(L,1));

Q_Store = cell(0);

%% KALMAN FILTER
filter_type = zef.KF.filter_type.Value;
smoothing = zef.kf_smoothing;
if filter_type == '1'
    [P_store, z_inverse] = zeffiro.plugins.Kalman.m.kalman_filter(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing);
elseif filter_type == '2'
    n_ensembles = str2double(zef.KF.number_of_ensembles.Value);
    z_inverse = zeffiro.plugins.Kalman.m.EnKF(m,A,P,Q,L,R,timeSteps,number_of_frames, n_ensembles);
elseif filter_type == '3'
    [P_store, z_inverse] = zeffiro.plugins.Kalman.m.kalman_filter_sLORETA(m,P,A,Q,L,R,timeSteps, number_of_frames, smoothing);
end

%% RTS SMOOTHING

if (smoothing == 2)
[~, m_s_store, ~] = zeffiro.plugins.Kalman.m.RTS_smoother(P_store, z_inverse, A, Q, number_of_frames);
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