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
    %   An instance of RAMUSInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.RAMUSInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end

    if not(isprop(self,'noise_cov'))
        self.addprop('noise_cov');
    end
    
    noise_p2 = 10^(-self.signal_to_noise_ratio/10);
    self.noise_cov = noise_p2*eye(size(L,1));
end