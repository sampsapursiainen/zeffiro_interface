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
    %   An instance of DipoleScanInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.DipoleScanInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end
   if isempty(self.noise_cov)
       noise_p2 = 10^(-self.signal_to_noise_ratio/10);
       self.noise_cov = noise_p2*mean(f_data(:).^2)*eye(size(L,1));
   end

end