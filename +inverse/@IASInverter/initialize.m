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
    %   An instance of IASInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.IASInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end

    if not(isprop(self,'theta0'))
        self.addprop('theta0');
    end
    if not(isprop(self,'beta'))
        self.addprop('beta');
    end
    if not(isprop(self,'d_sqrt'))
        self.addprop('d_sqrt');
    end
    if not(isprop(self,'noise_cov'))
        self.addprop('noise_cov');
    end
    
    if strcmp(self.hyperprior_mode,"Balanced")
        balance_spatially = 1;
    else
        balance_spatially = 0;
    end
    
    if strcmp(self.data_normalization_method,"Maximum entry")
        normalize_data = 'maximum entry';
    else
        normalize_data = 'something else';
    end
    
    modified_SNR = self.signal_to_noise_ratio-self.prior_over_measurement_db + self.amplitude_db;
    
    if strcmp(self.hyperprior,"Inverse gamma")
        [self.beta, self.theta0] = zef_find_ig_hyperprior(modified_SNR,...
            self.hyperprior_tail_length_db,L,size(L,2),normalize_data,balance_spatially,self.hyperprior_weight);
        self.d_sqrt = self.theta0./(self.beta-1);
    elseif strcmp(self.hyperprior,"Gamma")
        [self.beta, self.theta0] = zef_find_g_hyperprior(modified_SNR,...
            self.hyperprior_tail_length_db,L,size(L,2),normalize_data,balance_spatially,self.hyperprior_weight);
        self.d_sqrt = self.theta0.*self.beta;
    end


    noise_p2 = 10^(-self.signal_to_noise_ratio/10);
    self.noise_cov = noise_p2*eye(size(L,1));




end