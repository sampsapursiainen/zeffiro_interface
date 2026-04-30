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

        self (1,1) inverse.UKFNMMInverter

        f (:,1) {mustBeA(f,["double","gpuArray"])}

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        procFile (1,1) struct

        source_direction_mode

        source_positions

        opts.use_gpu (1,1) logical = false

        opts.normalize_data (1,1) double = 1

    end


    % Get needed parameters from self and others.
    theta0 = self.theta0;

    % Then start inverting.
    %% CALCULATION STARTS HERE
    
%Prior covariance is saved in self.prev_step_posterior_cov
if isempty(self.posterior_covs)
    if max(size(theta0)) == 1
        self.posterior_covs{1} = eye(size(L,2)) * theta0;
    else
        self.posterior_covs{1} = diag(theta0);
    end
end

first_step_boolean = false;
if isempty(self.reconstruction)
    self.reconstruction = zeros(size(L,2),1);
    first_step_boolean = true;
    self.modified_L = L;
    for n = 1:size(source_positions,1)
        s_ind = 3*n-[2,1,0];
        [u,~,~] = svd(L(:,s_ind),"econ");
        self.modified_L(:,s_ind) = u;
    end
end

if not(isempty(self.evolution_var))
    self.evolution_cov = diag(self.evolution_var(:,1));
    self.evolution_var(:,1) = [];
end

if opts.use_gpu && gpuDeviceCount > 0
    self.evolution_cov = gpuArray(self.evolution_cov);
    self.noise_cov = gpuArray(self.noise_cov);
    self.posterior_covs{end} = gpuArray(self.posterior_covs{end});
end
%% KALMAN FILTER
    % Prediction
    [x, P] = plugins.ClassKF.class_kf_predict(self);
    % Update
    [x, P] = plugins.ClassKF.kf_update(x, P, f, self.modified_L, self.noise_cov);
    if self.use_smoothing
        self.posterior_covs = [self.posterior_covs,gather(P)];
    end
    z_vec = gather(x);
    self.time_steps_left = self.time_steps_left - 1;
    if first_step_boolean
        self.reconstruction = x;
    else
        self.reconstruction(:,end+1) = x;
    end
%-------------------------------------------------------------------------------
    if self.time_steps_left <= 0
        if self.use_smoothing
            [self.reconstruction, self] = smoother(self, self.modified_L);
        end
        self.use_smoothing = false;
    end

end