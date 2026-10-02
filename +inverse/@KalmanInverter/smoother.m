function [reconstruction, self] = smoother(self, z_inverse, L, opts)
%smoother  Rauch–Tung–Striebel backward pass over stored posterior covariances.
%
%   Zeffiro Interface.
%   Copyright © 2025- Joonas Lahtinen
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Run after the frame loop when use_smoothing is true so invert stored
%   posterior_covs{f}. State transition A is self.state_transition_model_A
%   (identity if empty). Process noise Q is self.evolution_cov.
%
%   smoother_type "RTS": standard RTS, G = P / (P+Q) when A = I, then
%   m_s = m + G (m_s - A m) backward. Filter-type-specific
%   standardization is reapplied on the backward pass in the rest of this
%   file. "Sample RTS": estimates Q from consecutive filtered states.
%
%   Inputs
%     z_inverse - cell, one n_dof×1 filtered vector per frame (same order
%                 as invert).
%     L         - lead field; used when a standardized smoother rebuilds D.
%
%   Outputs
%     reconstruction - cell of smoothed frames, same length as z_inverse.
%     self           - posterior_covs still present; filter state otherwise
%                      as left by invert.

    arguments

        self (1,1) inverse.KalmanInverter

        z_inverse

        L (:,:)

        opts.use_gpu (1,1) logical = false

    end

n_frames = self.number_of_frames;
A = self.state_transition_model_A;
if isempty(A)
    A = eye(length(z_inverse{1}));
end
Q = self.evolution_cov;
on_gpu = opts.use_gpu && gpuDeviceCount > 0;
if on_gpu
    if issparse(Q)
        Q = full(Q);
    end
    Q = gpuArray(Q);
    if ~isa(L, "gpuArray")
        L = gpuArray(L);
    end
    if ~isa(self.noise_cov, "gpuArray")
        self.noise_cov = gpuArray(self.noise_cov);
    end
end

h = zef_waitbar(0,'Smoothing');
cleanup_wb = onCleanup(@() zef_close_waitbar(h));
if strcmp(self.smoother_type,"RTS")
    % RTS: P_ = A P A' + Q, G = P A' / P_, m_s = m + G (m_s - A m) backward in time.
    reconstruction = cell(0);
    for f_ind = n_frames:-1:1
        zef_waitbar(1 - f_ind/n_frames,h, ['Smoothing ' int2str(n_frames -f_ind) ' of ' int2str(n_frames) '.']);
    
        P = self.posterior_covs{f_ind};
        m = z_inverse{f_ind};
        if on_gpu
            P = gpuArray(P);
            m = gpuArray(m);
        end
        if inverse.kf.is_identity_transition(A)
            P_ = P + Q;
            m_ = m;
            G =  P / P_;
        else
            P_ = A * P * A' + Q;
            m_ = A * m;
            G =  (P * A') / P_;
        end
        if f_ind == n_frames
            m_s = m;
            P_s = P;
        else
            m_s = m + G * (m_s - m_);
            P_s = P + G * (P_s - P_) * G';
        end
        
        if strcmp(self.method_type,"Basic Kalman filter")
            reconstruction{f_ind} = m_s;
        elseif strcmp(self.method_type,"Standardized Kalman filter")
            if f_ind <= numel(self.filter_standardization_D) ...
                    && ~isempty(self.filter_standardization_D{f_ind})
                reconstruction{f_ind} = self.filter_standardization_D{f_ind} * m_s;
            elseif on_gpu
                [P_sqrtm, P_invsqrt] = inverse.kf.spd_sqrt_pair(P_);
                B = L * P_sqrtm;
                G = B' / (B * B' + self.noise_cov);
                w_t = 1 ./ (sum(G.' .* B, 1)').^self.standardization_exponent;
                reconstruction{f_ind} = w_t .* (P_invsqrt * m_s);
            else
                P_sqrtm = sqrtm(P_);
                B = L * P_sqrtm;
                G = B' / (B * B' + self.noise_cov);
                w_t = 1 ./ (sum(G.' .* B, 1)').^self.standardization_exponent;
                reconstruction{f_ind} = w_t .* (P_sqrtm\m_s);
            end
        elseif strcmp(self.method_type,"Approximated Standardized Kalman filter")
            if f_ind <= numel(self.filter_standardization_D) ...
                    && ~isempty(self.filter_standardization_D{f_ind})
                reconstruction{f_ind} = self.filter_standardization_D{f_ind} * m_s;
            else
                P_invsqrt = inverse.kf.spd_invsqrt_denman_beavers(P);
                B = L * P;
                K = B * P_invsqrt;
                G = K' / (B * L' + self.noise_cov);
                w_t = 1 ./ (sum(G.' .* K, 1)').^self.standardization_exponent;
                reconstruction{f_ind} = w_t .* (P_invsqrt * m_s);
            end
        end
        if isa(reconstruction{f_ind}, "gpuArray")
            reconstruction{f_ind} = gather(reconstruction{f_ind});
        end
    end
elseif strcmp(self.smoother_type,"Sample RTS")
    z_inverse = cell2mat(z_inverse);
    if inverse.kf.is_identity_transition(A)
        Q = cov((z_inverse(:,2:n_frames)-z_inverse(:,1:n_frames-1))');
    else
        Q = cov((z_inverse(:,2:n_frames)-A* z_inverse(:,1:n_frames-1))');
    end
    reconstruction = cell(0);
    for f_ind = n_frames:-1:1
        zef_waitbar(1 - f_ind/n_frames,h, ['Smoothing ' int2str(n_frames -f_ind) ' of ' int2str(n_frames) '.']);
    
        P = self.posterior_covs{f_ind};
        m = z_inverse(:,f_ind);
        if inverse.kf.is_identity_transition(A)
            P_ = P + Q;
            m_ = m;
            G =  P / P_;
        else
            P_ = A * P * A' + Q;
            m_ = A * m;
            G =  (P * A') / P_;
        end
        if f_ind == n_frames
            m_s = m;
            P_s = P;
        else
            m_s = m + G * (m_s - m_);
            P_s = P + G * (P_s - P_) * G';
        end
        
        reconstruction{f_ind} = m_s;
    end
else
    reconstruction = z_inverse;
end
clear cleanup_wb;

end
