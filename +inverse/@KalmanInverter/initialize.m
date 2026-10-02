function self = initialize(self,L,f_data,source_direction_mode)
%initialize  Set Kalman noise covariance, initial prior theta0, and process noise Q.
%
%   Zeffiro Interface.
%   Copyright © 2025- Joonas Lahtinen
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Called once from utilities.inverse.run_frame_loop before the per-frame
%   invert loop. Inverse tools → Kalman uses zef_KF (DTI Q lives there).
%   Resets prev_step_reconstruction / prev_step_posterior_cov so a new run
%   does not reuse the last filter state. noise_cov defaults to SNR-scaled
%   identity (or is trace-normalized if the user already set a matrix).
%   theta0 from early-frame data variance and lead-field sensitivity, unless
%   theta0 is already set (scalar or one entry per lead-field column). A set
%   value is kept so a caller can pass the PM-SNR prior of Prasikala et al.,
%   BSPC 121 (2026) 110233, which is not the sensitivity-scaling expression.
%   Q (evolution_cov or evolution_var) depends on evolution_prior_model —
%   sensitivity scaling uses temporal differences of f_data; "User supplied Q"
%   requires evolution_cov to match size(L,2).
%
%   Inputs:  L — lead field; f_data — m×T measurements;
%            source_direction_mode — 1/2 Cartesian triples (class interleaved),
%            3 per-column energy. Default 1 when omitted.
%   Output:  self with priors and transition model A (identity if unset).

    arguments

        self (1,1) inverse.KalmanInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

        source_direction_mode = 1

    end

    self.prev_step_posterior_cov = [];
    self.prev_step_reconstruction = [];
    self.posterior_covs = cell(0);
    self.filter_standardization_D = cell(0);
    supplied_theta0 = self.theta0;

    external_Q = [];
    if strcmp(self.evolution_prior_model, "User supplied Q")
        external_Q = self.evolution_cov;
    end
    self.evolution_cov = [];
    if not(isprop(self,'evolution_var'))
        self.addprop('evolution_var');
    end
    self.evolution_var = [];

    % SNR → noise power p² = 10^(-SNR/10). Signal fraction (1-p²) scales priors.
    noise_p2 = 10^(-self.signal_to_noise_ratio/10);

    if isempty(self.noise_cov)
        self.noise_cov = noise_p2 * eye(size(L,1));
    else
        self.noise_cov = size(L,1)*self.noise_cov/trace(self.noise_cov);
    end
    
    n_noise = min(double(self.number_of_noise_steps), size(f_data, 2));
    n_noise = max(n_noise, 1);
    if n_noise < 2
        data_power = mean(f_data(:, 1).^2);
    else
        data_power = mean(var(f_data(:, 1:n_noise), 0, 2));
    end
    col_energy = zef_leadfield_column_energy(L, source_direction_mode);
    if isempty(supplied_theta0)
        self.theta0 = (1-noise_p2)*10.^(self.initial_prior_steering_db/10)*data_power./col_energy;
    else
        if isa(supplied_theta0, "gpuArray")
            supplied_theta0 = gather(supplied_theta0);
        end
        supplied_theta0 = double(supplied_theta0);
        n_state = size(L, 2);
        if ~isscalar(supplied_theta0)
            supplied_theta0 = supplied_theta0(:);
            if numel(supplied_theta0) ~= n_state
                error("KalmanInverter:initialize:BadTheta0", ...
                    "theta0 must be a positive scalar or a vector of length %d; got %d.", ...
                    n_state, numel(supplied_theta0));
            end
        end
        if ~all(isfinite(supplied_theta0(:))) || ~all(supplied_theta0(:) > 0)
            error("KalmanInverter:initialize:BadTheta0", ...
                "theta0 must be finite and positive.");
        end
        self.theta0 = supplied_theta0;
    end

    needs_temporal_diff = ismember(self.evolution_prior_model, ...
        ["Sensitivity scaling", "Avg. sensit. scaling", "SVD-based", "Avg. SVD-based"]);
    if needs_temporal_diff && size(f_data, 2) < 2
        self.evolution_var = transpose((1-noise_p2) * 10^(self.evolution_prior_db/20) ./ col_energy);
    else
    switch self.evolution_prior_model
        case "User supplied Q"
            if isempty(external_Q)
                error("KalmanInverter:initialize:MissingUserQ", ...
                    "evolution_prior_model is ""User supplied Q"" but evolution_cov is empty. " + ...
                    "Pass your process-noise matrix Q in MethodParams as field ""evolution_cov"".");
            end
            if isa(external_Q, "gpuArray")
                external_Q = gather(external_Q);
            end
            external_Q = double(external_Q);
            n_state = size(L, 2);
            if ~isequal(size(external_Q), [n_state, n_state])
                error("KalmanInverter:initialize:BadUserQSize", ...
                    "Q (evolution_cov) must be %d-by-%d to match the lead-field column count; got %s.", ...
                    n_state, n_state, mat2str(size(external_Q)));
            end
            self.evolution_cov = external_Q;
        case "Sensitivity scaling"
            %Since R = noise_p2*eye, we have 
            % A_noise = (1/(p*A_signal))*A_signal => SNR = p^2*A_signal^2 =
            % (q||L||^2)^2/E[||noise||^2]
            % => E[dy^2] -> sqrt(E[dy^2])
        f = sqrt(mean(diff(f_data').^2,2))*10^(self.evolution_prior_db/20);
        f = [f;f(end)];
        self.evolution_var =  transpose((1-noise_p2)*f./col_energy);
    case "Avg. sensit. scaling"
        %case 1 but spatial sensitivity is averaged
        f = sqrt(mean(diff(f_data').^2,2))*10^(self.evolution_prior_db/20);
        f = [f;f(end)];
        self.evolution_var =  transpose((1-noise_p2)*f/mean(col_energy));
        case "SVD-based"
        %Mathematically quarantees a good tracking but numerically instable
        %in 2024
        [~,S,V] =  svd(L,"econ");
        f = diff(f_data')';
        f = 10^(self.evolution_prior_db/20)*sum(f.^2,2)./sum(f_data.^2,2);         
        S = max((diag(S).^2),noise_p2/(1-noise_p2));
        self.evolution_cov = (V.*(f./S)')*V';
    case "Avg. SVD-based"
        %averaged signal space contribution
        S =  svd(L);
        f = diff(f_data')';
        f = sum(f.^2,2)./sum(f_data.^2,2);         
        S = max(S.^2,noise_p2/(1-noise_p2));
        self.evolution_cov =  (mean(f./S)*10^(self.evolution_prior_db/20))*speye(size(L,2));
    case "Reworked original"
        self.evolution_cov = self.time_step*(svds(L,1).^(2)/sum(L(:).^2))*10^(self.evolution_prior_db/20)*speye(size(L,2));
    end
    end

    if isempty(self.state_transition_model_A)
        % Transition matrix is Identity matrix (sparse; same as dense I)
        self.state_transition_model_A = speye(size(L,2));
    end

end
