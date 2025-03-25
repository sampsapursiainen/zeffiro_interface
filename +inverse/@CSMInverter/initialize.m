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
    %   An instance of CSMInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.CSMInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end

    noise_p2 = 10^(-self.signal_to_noise_ratio/10);
    self.theta0 = gather((1-noise_p2)*sum(f_data.^2,'all')/sum(L.^2,'all'));
end