function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)
%invert  One Kalman predict-update step; output is filtered (or standardized) source estimate.
%
%   Zeffiro Interface.
%   Copyright © 2025- Joonas Lahtinen
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Called once per frame by utilities.inverse.run_frame_loop. Inverse
%   tools → Kalman uses plugins/Kalman/m/zef_KF.m instead (that
%   plugin is also where DTI structural Q lives).
%
%   State carried on self: prev_step_reconstruction, prev_step_posterior_cov
%   (initialized from theta0 on the first frame). Optional evolution_var
%   consumes one column per frame into evolution_cov. If use_smoothing,
%   posterior_covs grows by one gathered P per frame for smoother().
%
%   method_type (mustBeMember on the class):
%     "Basic Kalman filter" — ClassKF predict + kf_update; z = x.
%     "Standardized Kalman filter" — kf_sL_update; z = D*x.
%     "Approximated Standardized Kalman filter" — kf_sL_update_approx; z = D*x.
%     "Ensembled Kalman filter" — ensemble forecast, corrcoef localization
%       (|ρ|<0.05 zeroed), Kalman gain; z = mean(ensemble).
%
%   [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, ...
%       source_positions, opts)
%
%   Inputs
%     f     - n_sensors×1 current frame (filtered).
%     L     - n_sensors×n_dof observation model (lead field).
%     procFile, source_direction_mode, source_positions - common invert
%             signature; unused in this method.
%     opts.use_gpu - move covariances to gpuArray when a device exists.
%     opts.normalize_data - unused here.
%
%   Outputs
%     z_vec - n_dof×1 filtered (or standardized) estimate.
%     self  - updated x, P, optional posterior_covs.

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


    theta0 = self.theta0;

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
    % Time-varying diagonal Q: consume one column of evolution_var per frame.
    qv = self.evolution_var(:,1);
    self.evolution_var(:,1) = [];
    nq = numel(qv);
    self.evolution_cov = spdiags(qv(:), 0, nq, nq);
end

if opts.use_gpu && gpuDeviceCount > 0
    if issparse(self.evolution_cov)
        self.evolution_cov = full(self.evolution_cov);
    end
    self.evolution_cov = gpuArray(self.evolution_cov);
    self.noise_cov = gpuArray(self.noise_cov);
    self.prev_step_posterior_cov = gpuArray(self.prev_step_posterior_cov);
    if ~isempty(self.prev_step_reconstruction) && ~isa(self.prev_step_reconstruction, "gpuArray")
        self.prev_step_reconstruction = gpuArray(self.prev_step_reconstruction);
    end
    if ~isa(f, "gpuArray")
        f = gpuArray(f);
    end
    if ~isa(L, "gpuArray")
        L = gpuArray(L);
    end
end
% Basic KF: predict then kf_update; z = x.
% Standardized / approx sKF always run the sLORETA update so D_t is the
% filter prior operator. RTS stores raw x and applies stored D after the
% backward pass (same exponent as the filter).
% EnKF: ensemble forecast + correlation localization.
if strcmp(self.method_type,"Basic Kalman filter")
    % Prediction
    [x, P] = inverse.kf.class_kf_predict(self);
    % Update
    [x, P] = inverse.kf.kf_update(x, P, f, L, self.noise_cov);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
    end
    z_vec = gather(x);
    self.prev_step_reconstruction = x;
    self.prev_step_posterior_cov = P;
elseif strcmp(self.method_type,"Standardized Kalman filter")
    % Prediction
    [x, P] = inverse.kf.class_kf_predict(self);
    % Update
    [x, P, ~, D] = inverse.kf.kf_sL_update(x, P, f, L, self.noise_cov, ...
        self.standardization_exponent);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
        self.filter_standardization_D = [self.filter_standardization_D, {gather(D)}];
    end
    self.prev_step_reconstruction = x;
    self.prev_step_posterior_cov = P;
    if strcmp(self.smoother_type,"RTS")
        z_vec = gather(x);
    else
        z_vec = gather(D*self.prev_step_reconstruction);
    end
elseif strcmp(self.method_type,"Approximated Standardized Kalman filter")
    % Prediction
    [x, P] = inverse.kf.class_kf_predict(self);
    % Update
    [x, P, ~, D] = inverse.kf.kf_sL_update_approx(x, P, f, L, self.noise_cov, ...
        self.standardization_exponent);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
        self.filter_standardization_D = [self.filter_standardization_D, {gather(D)}];
    end
    self.prev_step_reconstruction = x;
    self.prev_step_posterior_cov = P;
    if strcmp(self.smoother_type,"RTS")
        z_vec = gather(x);
    else
        z_vec = gather(D*self.prev_step_reconstruction);
    end
elseif strcmp(self.method_type,"Ensembled Kalman filter")
    w = mvnrnd(zeros(size(L,2),1), self.evolution_cov, self.number_of_ensembles)';
    % Forecasts
    x_f = self.state_transition_model_A * self.prev_step_reconstruction + w;
    C = cov(x_f');
    T = corrcoef(x_f');
    T(abs(T) < 0.05) = 0;
    C = C .* T;
    v = mvnrnd(zeros(size(self.noise_cov,1),1), self.noise_cov, self.number_of_ensembles);
    K = C * L' / (L * C * L' + self.noise_cov);
    self.prev_step_reconstruction = x_f + K *(f + v' - L*x_f);
    z_vec = mean(self.prev_step_reconstruction,2);
end

end % function
