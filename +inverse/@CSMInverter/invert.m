%% Copyright © 2025- Joonas Lahtinen 
function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)

    %
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the CSM method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of CSMInverter with the method-specific parameters.
    %
    % - f
    %
    %   Some vector.
    %
    % - L
    %
    %   The lead field that is being inverted.
    %
    % - procFile
    %
    %   A struct with source space indices.
    %
    % - source_direction_mode
    %
    %   The way the orientations of the sources should be interpreted.
    %
    % - opts.use_gpu = false
    %
    %   A logical flag for choosing whether a GPU will be used in
    %   computations, if available.
    %
    % Outputs:
    %
    % - reconstruction
    %
    %   The reconstrution of the dipoles.
    %

    arguments

        self (1,1) inverse.CSMInverter

        f (:,1) {mustBeA(f,["double","gpuArray"])}

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        procFile (1,1) struct

        source_direction_mode

        source_positions

        opts.use_gpu (1,1) logical = false

        opts.normalize_data (1,1) double = 1

    end

    % Initialize waitbar with a cleanup object that automatically closes the
    % waitbar, if there is an interruption with Ctrl + C or when this function
    % exits.

    if self.number_of_frames <= 1
        h = zef_waitbar(0,'CSM Reconstruction.');
        cleanup_fn = @(wb) close(wb);
        cleanup_obj = onCleanup(@() cleanup_fn(h));
    end

    % Get needed parameters from self and others.

    number_of_frames = self.number_of_frames;
    std_lhood = 10^(-self.signal_to_noise_ratio/20);
    n_interp = length(procFile.s_ind_0);

    % Then start inverting.

    theta0 = self.theta0;
    %[theta0] = zef_find_gaussian_prior(snr_val-pm_val,L,size(L,2),self.data_normalization_method,0);

    if ismember(self.method_type, ["dSPM" ; "sLORETA" ; "sLORETA 3D"])

        S_mat = (std_lhood^2/theta0)*eye(size(L,1));

        if opts.use_gpu && gpuDeviceCount > 0

            S_mat = gpuArray(S_mat);

        end

        %__ dSPM __
        %Source covariance

        P = L'/(L*L'+S_mat);

        if self.method_type == "dSPM"

            %d = 1./sqrt(diag(P*S_mat*P'));
            d = 1./sqrt(sum(((P*S_mat).*P),2));
            z_vec = d.*P*f;

        elseif self.method_type == "sLORETA"

            %__ sLORETA __
            %d = 1./sqrt(diag(P*L));
            d = 1./sqrt(sum(P.'.*L,1))';
            z_vec = d.*P*f/sqrt(theta0);

        else

            if number_of_frames <=1
                tic;
                time_val = toc;
            end

            z_vec = P * f;

            if opts.use_gpu && gpuDeviceCount > 0
                P = gather(P);
                L = gather(L);
                z_vec = gather(z_vec);
            end

            if source_direction_mode == 2

                r_ind = setdiff(1:n_interp,procFile.s_ind_4);
                surf_ind = procFile.s_ind_4+[0,n_interp,2*n_interp];
                surf_ind=surf_ind(:);
                M = 1./sqrt(sum(P(surf_ind,:).'.*L(:,surf_ind),1))';
                z_vec(surf_ind) = M.*z_vec(surf_ind);

                for i = 1:length(r_ind)

                    if number_of_frames <= 1 && i > 1
                        date_str = datestr(datevec(now+(n_interp/(i-1) - 1)*time_val/86400)); %what does that do?
                    end

                    ind = r_ind(i)+[0,n_interp,2*n_interp];
                    M = sqrtm(P(ind,:)*L(:,ind));
                    z_vec(ind) = (M\z_vec(ind));

                    if number_of_frames <= 1 && i > 1
                        zef_waitbar(i/n_interp,h,['Step ' int2str(i) ' of ' int2str(n_interp) '. Ready: ' date_str '.' ]);
                    end

                end % for

                z_vec = z_vec/sqrt(theta0);

            else

                for i = 1:n_interp

                    if number_of_frames <= 1 && i > 1
                        date_str = datestr(datevec(now+(n_interp/(i-1) - 1)*time_val/86400)); %what does that do?
                    end

                    ind = [i,i+n_interp,i+2*n_interp];
                    M = sqrtm(P(ind,:)*L(:,ind));
                    z_vec(ind) = M\z_vec(ind);

                    if number_of_frames <= 1 && i > 1
                        zef_waitbar(i/n_interp,h,['Step ' int2str(i) ' of ' int2str(n_interp) '. Ready: ' date_str '.' ]);
                    end
                end

                z_vec = z_vec/sqrt(theta0);

            end % if

        end % if

    elseif self.method_type == "SBL"

        S_mat = (std_lhood^2)*eye(size(L,1));

        if opts.use_gpu && gpuDeviceCount > 0
            S_mat = gpuArray(S_mat);
        end

        %__ Sparse Bayesian Learning _
        n_iter = self.SBL_number_of_iterations;
        C_data = cov(f');

        if det(C_data) < eps
            C_data = C_data + 0.05*trace(C_data)*eye(size(C_data,1))/size(C_data,1);
        end

        inv_sqrt_C = inv(sqrtm(gather(C_data)));
        gamma = ones(size(L,2),1);
        const = zeros(size(L,2),1);

        if opts.use_gpu & gpuDeviceCount > 0
            const = gather(const);
            L = gather(L);
        end

        for i = 1:size(L,2)
            const(i) = 1/(rank(L(:,i)*L(:,i)')*size(f,2));
        end

        if opts.use_gpu && gpuDeviceCount > 0
            const = gpuArray(const);
            gamma = gpuArray(gamma);
            L = gpuArray(L);
        end

        for i = 1:n_iter
            f_aux = inv_sqrt_C*f;
            L_aux = inv_sqrt_C*L;
            gamma = const.*gamma.*sum((L_aux'*f_aux).^2,2)./(size(L,2)-gamma.*sum(L_aux.^2,1)');
            C_data = L*(gamma.*L')+S_mat;
            inv_sqrt_C = inv(sqrtm(gather(C_data)));
        end

        z_vec = real(gamma.*(L'*(C_data\f)));

    end

    if opts.use_gpu && gpuDeviceCount > 0
        z_vec = gather(z_vec);
    end

end % function
