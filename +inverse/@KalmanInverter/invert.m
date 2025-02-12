%% Copyright © 2025- Joonas Lahtinen
function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)

    %
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the Kalman filtering method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of KalmanInverter with the method-specific parameters.
    %
    % - f
    %
    %   Some vector.
    %
    % - L
    %
    %   The lead field that is being inverted.
    %
    % - procFile
    %
    %   A struct with source space indices.
    %
    % - source_direction_mode
    %
    %   The way the orientations of the sources should be interpreted.
    %
    % - opts.use_gpu = false
    %
    %   A logical flag for choosing whether a GPU will be used in
    %   computations, if available.
    %
    % Outputs:
    %
    % - reconstruction
    %
    %   The reconstrution of the dipoles.
    %

    arguments

        self (1,1) inverse.KalmanInverter

        f (:,1) {mustBeA(f,["double","gpuArray"])}

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        procFile (1,1) struct

        source_direction_mode

        source_positions

        opts.use_gpu (1,1) logical = false

        opts.normalize_data (1,1) double = 1

    end


    % Get needed parameters from self and others.

    snr_val = self.signal_to_noise_ratio;
    std_lhood = 10^(-self.signal_to_noise_ratio/20);
    pm_val = self.inv_prior_over_measurement_db;
    amplitude_db = self.inv_amplitude_db;
    pm_val = pm_val - amplitude_db;

    % Then start inverting.
    %% CALCULATION STARTS HERE
% m_0 = prior mean
m = zeros(size(L,2), 1);
    
%Prior covariance is saved in self.prev_step_posterior_cov
if isempty(self.prev_step_posterior_cov)
    if max(size(theta0)) == 1
        self.prev_step_posterior_cov = eye(size(L,2)) * theta0;
    else
        self.prev_step_posterior_cov = diag(theta0);
    end
end


if isempty(self.prev_step_reconstruction)
    if not(strcmp(self.method_type,"Ensembled Kalman filter"))
        self.prev_step_reconstruction = zeros(size(L,2),1);
    else
        self.prev_step_reconstruction = mvnrnd(zeros(size(L,2),1), self.prev_step_posterior_cov, self.number_of_ensembles)';
    end
end

if not(isempty(self.evolution_var))
    self.evolution_cov = diag(self.evolution_var(:,1));
    self.evolution_var(:,1) = [];
end

if opts.use_gpu && gpuDeviceCount > 0
    self.evolution_cov = gpuArray(self.evolution_cov);
    self.noise_cov = gpuArray(self.noise_cov);
    self.prev_step_posterior_cov = gpuArray(self.prev_step_posterior_cov);
end
%% KALMAN FILTER
if strcmp(self.method_type,"Basic Kalman filter")
    % Prediction
    [x, P] = class_kf_predict(self);
    % Update
    [x, P] = kf_update(x, P, f, L, self.noise_cov);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
    end
    z_vec = gather(x);
    self.prev_step_reconstruction = x;
    self.prev_step_posterior_cov = P;
elseif strcmp(self.method_type,"Standardized Kalman filter")
    % Prediction
    [x, P] = class_kf_predict(self);
    % Update
    [x, P, ~, D] = kf_sL_update(x, gather(P), f, L, self.noise_cov);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
    end
    self.prev_step_reconstruction = x;
    z_vec = gather(D*self.prev_step_reconstruction);
    self.prev_step_posterior_cov = P;
elseif strcmp(self.method_type,"Approximated Standardized Kalman filter")
    % Prediction
    [x, P] = class_kf_predict(self);
    % Update
    [x, P, ~, D] = kf_sL_update_approx(x, P, f, L, self.noise_cov);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
    end
    self.prev_step_reconstruction = x;
    z_vec = gather(D*self.prev_step_reconstruction);
    self.prev_step_posterior_cov = P;
elseif strcmp(self.method_type,"Ensembled Kalman filter")
    w = mvnrnd(zeros(size(L,2),1), self.evolution_cov, self.number_of_ensembles)';
    % Forecasts
    x_f = self.state_transition_model_A * self.prev_step_reconstruction + w;
    C = cov(x_f');
    correlationLocalization = true;
    if correlationLocalization
    T = corrcoef(x_f');
    % explain How to find 0.05
    T(abs(T) < 0.05) = 0;
    C = C .* T;
    end
    v = mvnrnd(zeros(size(self.noise_cov,1),1), self.noise_cov, self.number_of_ensembles);
    
    % method to calculate resolution D
    method = '3';
    if(method == '1')
        P_sqrtm = sqrtm(C);
        B = L * P_sqrtm;
        G = B' / (B * B' + self.noise_cov);
        w_t = 1 ./ sum(G.' .* B, 1)';
        D = w_t .* inv(P_sqrtm);
    elseif(method == '2')
        % complexity O(n^3)
        [Ur,Sr,Vr] = svd(C);
        Sr = diag(Sr);
        RNK = sum(Sr > (length(Sr) * eps(single(Sr(1)))));
        SIR = Vr(:,1:RNK) * diag(1./sqrt(Sr(1:RNK))) * Ur(:,1:RNK)'; % square root
        P_sqrtm = Vr(:,1:RNK) * diag(sqrt(Sr(1:RNK))) * Ur(:,1:RNK)';
        B = L * P_sqrtm;
        G = B' / (B * B' + self.noise_cov);
        w_t = 1 ./ sum(G.' .* B, 1)';
        D = w_t .* SIR;
    else
        D = speye(size(C));
    end
    % Update
    K = C * L' / (L * C * L' + self.noise_cov);
    self.prev_step_reconstruction = x_f + K *(f + v' - L*x_f);
    % x_ensemble = x_ensemble';
    mean_x = mean(self.prev_step_reconstruction,2);
    z_vec = D*mean_x;
end

end % function
