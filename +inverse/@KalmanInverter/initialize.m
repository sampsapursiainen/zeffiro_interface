%% Copyright © 2025- Joonas Lahtinen
function self = initialize(self,L,f_data)
    %
    % initialization function
    %
    % Initialize recursively updated variables before the computation of
    % the first time step.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of KalmanInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.KalmanInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end

    self.prev_step_posterior_cov = [];
    self.prev_step_reconstruction = [];
    self.evolution_cov = [];
    self.evolution_var = [];
    
    noise_p2 = 10^(-self.signal_to_noise_ratio/10);

    if isempty(self.noise_cov)
        self.noise_cov = noise_p2 * eye(size(L,1));
    else
        self.noise_cov = size(L,1)*self.noise_cov/trace(self.noise_cov);
    end

    self.theta0 = (1-noise_p2)*10.^(self.initial_prior_steering_db/10)*diag(mean(var(f_data(:,1:self.number_of_noise_steps),0,2))./repelem(sum(reshape(sum(L.^2),3,[])),3));

    switch self.evolution_prior_model
        case "Sensitivity scaling"
            %Since R = noise_p2*eye, we have 
            % A_noise = (1/(p*A_signal))*A_signal => SNR = p^2*A_signal^2 =
            % (q||L||^2)^2/E[||noise||^2]
            % => E[dy^2] -> sqrt(E[dy^2])
        f = sqrt(mean(diff(f_data').^2,2))*10^(self.evolution_prior_db/20);
        f = [f;f(end)];
        self.evolution_var =  transpose((1-noise_p2)*f./repelem(sum(reshape(sum(L.^2),3,[])),3));
    case "Avg. sensit. scaling"
        %case 1 but spatial sensitivity is averaged
        f = sqrt(mean(diff(f_data').^2,2))*10^(self.evolution_prior_db/20);
        f = [f;f(end)];
        self.evolution_var =  transpose((1-noise_p2)*f/mean(repelem(sum(reshape(sum(L.^2),3,[])),3)));
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
        self.evolution_cov =  (mean(f./S)*10^(self.evolution_prior_db/20))*eye(size(L,1));
    case "Reworked original"
        self.evolution_cov = time_step*(svds(L,1).^(2)/sum(L(:).^2))*10^(self.evolution_prior_db/20)*eye(size(L,1));
    end

    if isempty(self.state_transition_model_A)
        % Transition matrix is Identity matrix
        self.state_transition_model_A = eye(size(L,2));
    end

end