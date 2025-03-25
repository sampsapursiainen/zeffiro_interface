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
    %   An instance of BeamformerInverter with the method-specific parameters.
    %
    % Outputs:
    %
    % - self
    %
    %   Recursive variables initialized
    %

    arguments

        self (1,1) inverse.BeamformerInverter

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

    end
    self.computing_parameters = true;
   % Compute error covariance matrix if it is not given
   if isempty(self.error_cov)
       if size(f_data,2) > 1
           self.error_cov = (f_data-mean(f_data,2))*(f_data-mean(f_data,2))'/size(f_data,2);
       else
           self.error_cov = (f_data-mean(f_data,1))*(f_data-mean(f_data,1))';
       end
   end

end