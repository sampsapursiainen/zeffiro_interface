%% Copyright © 2025- Joonas Lahtinen
function [reconstruction, self] = smoother(self, z_inverse, L)
    %
    % smoother
    %
    % Computes the desired smoother for Kalman filter solution
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of KalmanInverter with the method-specific parameters.
    %
    % - z_inverse
    %
    %   The cell structure having all the reconstructions for each time
    %   step
    %
    %
    % Outputs:
    %
    % - reconstruction
    %
    %   The smoothed reconstrution of the dipoles.
    %

    arguments

        self (1,1) inverse.UKFNMMInverter

        z_inverse 

        L (:,:)

    end

A = eye(size(self.reconstruction,1));
Q = self.evolution_cov;

h = zef_waitbar(0,'Smoothing');
if strcmp(self.smoother_type,"RTS")
    %P_s_store = cell(0);
    reconstruction = zeros(size(L,2),self.number_of_frames);
    %G_store = cell(0);
    for f_ind = self.number_of_frames:-1:1
        zef_waitbar(1 - f_ind/self.number_of_frames,h, ['Smoothing ' int2str(self.number_of_frames -f_ind) ' of ' int2str(self.number_of_frames) '.']);
    
        P = self.posterior_covs{f_ind};
        m = self.reconstruction(:,f_ind);
        % if A is Identity
        if (isdiag(A) && all(diag(A) - 1) < eps)
            P_ = P + Q;
            m_ = m;
            G =  P / P_;
        else
            P_ = A * P * A' + Q;
            m_ = A * m;
            G =  (P * A') / P_;
        end
        if f_ind == number_of_frames
            m_s = m;
            P_s = P;
        else
            m_s = m + G * (m_s - m_);
            P_s = P + G * (P_s - P_) * G';
        end
        
        reconstruction(:,f_ind) = m_s;
    end
elseif strcmp(self.smoother_type,"Sample RTS")
    if (isdiag(A) && all(diag(A) - 1) < eps)
        Q = cov((self.reconstruction(:,2:self.number_of_frames)-self.reconstruction(:,1:self.number_of_frames-1))');
    else
        Q = cov((self.reconstruction(:,2:self.number_of_frames)-A* self.reconstruction(:,1:self.number_of_frames-1))');
    end
    reconstruction = zeros(size(L,2),self.number_of_frames);
    for f_ind = self.number_of_frames:-1:1
        zef_waitbar(1 - f_ind/self.number_of_frames,h, ['Smoothing ' int2str(self.number_of_frames -f_ind) ' of ' int2str(self.number_of_frames) '.']);
    
        P = self.posterior_covs{f_ind};
        m = self.reconstruction(:,f_ind);
        % if A is Identity
        if (isdiag(A) && all(diag(A) - 1) < eps)
            P_ = P + Q;
            m_ = m;
            G =  P / P_;
        else
            P_ = A * P * A' + Q;
            m_ = A * m;
            G =  (P * A') / P_;
        end
        if f_ind == number_of_frames
            m_s = m;
            P_s = P;
        else
            m_s = m + G * (m_s - m_);
            P_s = P + G * (P_s - P_) * G';
        end
        
        reconstruction(:,f_ind) = m_s;
    end
else
    reconstruction = self.reconstruction;
end
close(h);

[reconstruction,self.time_series] = self.UKF_estimate_NMM_parameters(L);

reconstruction = mat2cell(reconstruction,size(reconstruction,1),ones(1,size(reconstruction,2)));

end