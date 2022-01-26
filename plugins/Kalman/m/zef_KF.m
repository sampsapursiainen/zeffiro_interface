function [z, reconstruction_information] = zef_KF(void)

%% Initial parameters
mne_prior = evalin('base','zef.mne_prior');
snr_val = evalin('base','zef.inv_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = evalin('base','zef.inv_sampling_frequency');
high_pass = evalin('base','zef.inv_low_cut_frequency');
low_pass = evalin('base','zef.inv_high_cut_frequency');
number_of_frames = evalin('base','zef.number_of_frames');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
source_positions = evalin('base', 'zef.source_positions');

%% Reconstruction identifiers
reconstruction_information.tag = 'Kalman';
reconstruction_information.inv_time_1 = evalin('base','zef.inv_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.inv_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.inv_time_3');
reconstruction_information.sampling_freq = evalin('base','zef.inv_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.inv_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.inv_low_cut_frequency');
reconstruction_information.number_of_frames = evalin('base','zef.number_of_frames');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
% reconstruction_information.ias_hyperprior = evalin('base','zef.ias_hyperprior');
reconstruction_information.snr_val = evalin('base','zef.inv_snr');
reconstruction_information.pm_val = evalin('base','zef.inv_prior_over_measurement_db');

%%
multires_dec =  evalin('base','zef.kf_multires_dec');
multires_ind =  evalin('base','zef.kf_multires_ind');
multires_count = evalin('base','zef.kf_multires_count'); 
n_multires = evalin('base','zef.inv_multires_n_levels');
sparsity_factor = evalin('base','zef.inv_multires_sparsity');
n_decompositions = evalin('base','zef.inv_multires_n_decompositions');


weight_vec_aux = (sparsity_factor.^[0:n_multires-1]');


% mr_dec = multires_dec{1}{2};
%mr_dec_xyz = [mr_dec ; mr_dec + size(source_positions,1);mr_dec + 2*size(source_positions,1)];

%%
[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

%get ellipse filteres full measurement data. f_data: "sensors" x "time points"
[f_data] = zef_getFilteredData; 

% m_0 = prior mean
m = zeros(size(L,2), 1);
% Initial covariance matrix 
% find gaussian prior
[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),evalin('base','zef.normalize_data'),0);
P = eye(size(L,2)) * theta0;

% try different values 1, 10e-10,  10e-9kk
% add a smoothing matrix
Q_A = connectivity_matrix(source_positions,6);
beta = 10e-10;
alpha = 0.1;

%Q = beta* (alpha * eye(size(L,2)) +  Q_A);
Q = 3e-10 * eye(size(L,2));
% std_lhood
R = std_lhood^2 * eye(size(L,1));

% Transition matrix is Identity matrix
A = eye(size(L,2));

z_inverse_results = cell(0);
%% CALCULATION STARTS HERE
% Waitbar for iterations 
h = waitbar(0,('Kalman iterations.'));

%z_vec_aux = zeros(size(L_aux,2),1);
iter_ind = 0;
source_count_aux = 0;

for n_rep = 1:n_decompositions
    iter_ind = iter_ind + 1;
    n_mr_dec = length(multires_dec{n_rep}{1});
    
    if source_direction_mode == 1 || source_direction_mode == 2
    mr_dec = [multires_dec{n_rep}{1}; multires_dec{n_rep}{1}+n_interp ; multires_dec{n_rep}{1} + 2*n_interp];
    mr_dec = mr_dec(:);
    mr_ind = [multires_ind{n_rep}{1} ; multires_ind{n_rep}{1} + n_mr_dec ; multires_ind{n_rep}{1} + 2*n_mr_dec];
    mr_ind = mr_ind(:);
    end

    if source_direction_mode == 3 
    mr_dec = multires_dec{n_rep}{1}; 
    mr_dec = mr_dec(:);
    mr_ind = multires_ind{n_rep}{1}; 
    mr_ind = mr_ind(:);
    end
    
    L_aux = L(:,mr_dec);
    % m_0 = prior mean
    m = zeros(size(L_aux,2), 1);
    [theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L_aux,2),evalin('base','zef.normalize_data'),0);
    P = eye(size(L_aux,2)) * theta0;
    % Transition matrix is Identity matrix
    A = eye(size(L_aux,2));
    Q = 3e-10 * eye(size(L_aux,2));
    % std_lhood
    R = std_lhood^2 * eye(size(L_aux,1));

    if number_of_frames > 1
    z_inverse = cell(0);
    P_store = cell(0);
        
    for f_ind = 1: number_of_frames
        waitbar(f_ind/number_of_frames,h,['Kalman iterations ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
        f = zef_getTimeStep(f_data, f_ind, true);
        % Prediction 
        [m,P] = kf_predict(m, P, A, Q);
        % Update 
        [m, P] = kf_update(m, P, f, L_aux, R); 
        P_store{f_ind} = P;
        z_inverse{f_ind} = m;
    end

    m_s = z_inverse{end};
    
    P_s = P_store{end};
    % TODO Make separate RTS smoothing function
    z_inverse_smoothed = cell(0);
    z_inverse_smoothed{number_of_frames} = m_s;
    z_inverse_results{number_of_frames}{n_rep} = m_s(mr_ind);

    for f_ind = number_of_frames - 1:-1:1
        waitbar(f_ind/number_of_frames,h,['Kalman RTS smoothing ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    
        P = P_store{f_ind};
        m = z_inverse{f_ind};
        P_ = A * P * A' + Q;
        m_ = A * m;
        G =  (P * A) / P_;
        m_s = m + G * (m_s - m_);
        z_inverse_smoothed{f_ind} = m_s;
        z_inverse_results{f_ind}{n_rep} = m_s(mr_ind);
    end
    
    


    end


end

% TODO make a independent kalman function



for i = 1:size(z_inverse_results,2)
    z_inverse_results{i} = mean([z_inverse_results{i}{:}],2);
end

[z] = zef_postProcessInverse(z_inverse_results, procFile);
%normalize the reconstruction so that the highest value is equal to 1
[z] = zef_normalizeInverseReconstruction(z);
% CALCULATION ENDS HERE
close(h);
end
