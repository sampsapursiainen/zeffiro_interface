%% Copyright © 2025- Joonas Lahtinen and Alexandra Koulouri 
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
        %   An instance of GroupLassoInverter with the method-specific parameters.
        %
        % - L
        % The lead field matrix
        %
        % - f_data 
        % The measurement vector that is in the matrix format 
        % <# of challels> x <# of time steps>
        % 
        %
        % Outputs:
        %
        % - self
        %
        %   Recursive variables initialized
        %
    
        arguments
    
            self (1,1) inverse.GroupLassoInverter
    
            L (:,:) {mustBeA(L,["double","gpuArray"])}
    
            f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}
    
        end

        if not(isprop(self,'SNR_variable'))
            self.addprop('SNR_variable');
        end

        noise_p2 = 10^(-self.signal_to_noise_ratio/10);

        if isempty(self.noise_cov)
            if size(f_data,2) > 1
                self.noise_cov = cov(f_data');
            else
                self.noise_cov = noise_p2 * mean(f_data.^2) * eye(size(L,1));
            end
        end
        
        self.SNR_variable = (1-noise_p2)*10.^(self.initial_prior_steering_db/10)*mean(var(f_data,0,2));
end