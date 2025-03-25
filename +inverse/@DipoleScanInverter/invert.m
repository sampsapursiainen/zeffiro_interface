function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)

    %
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the Dipole Scanning method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of DipoleScanInverter with the method-specific parameters.
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
    % - self
    %
    %   An instance of possibly modified DipoleScanInverter with the method-specific parameters.
    %

    arguments

        self (1,1) inverse.DipoleScanInverter

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
        h = zef_waitbar(0,'Dipole Scan reconstruction.');
        cleanup_fn = @(wb) close(wb);
        cleanup_obj = onCleanup(@() cleanup_fn(h));
    end

    % Get needed parameters from self and others.

    date_str = NaN;

    %Modify to compensate Mahlanobis distance used instead of L2-norm when
   %noise covariance exists
   Chalf = sqrtm(self.noise_cov);
   L = Chalf\L;
   f = Chalf\f;
   clear Chalf;

    fixed_orientation_source_inds = procFile.s_ind_4;
    free_orientation_source_inds=setdiff(1:length(procFile.s_ind_0), procFile.s_ind_4);
    free_orientation_source_num = length(free_orientation_source_inds);
    waitbar_update_freq = floor(free_orientation_source_num/10);
    data_norm_sqr = sum(f.^2);

    %Gather the lead field to make the script faster
    if opts.use_gpu && gpuDeviceCount > 0
        L = gather(L);
    end

    z_vec = zeros(size(L,2),1);
    
    % Then start inverting.

    %Compute fixed orientation cases first
    for i = 1:length(fixed_orientation_source_inds)
        LF = L(:,3*fixed_orientation_source_inds(i));
        switch self.method_type
            case "SVD"
                [U,S,V] = svd(LF,'econ');
                source_est = V*(S\(U'*f));

            case "Pseudoinverse"
                source_est = pinv(LF)*f;
        end

        %Recularization of the lead field
        if not(strcmp(self.reg_type,"None"))
            [U,S,V] = svd(LF,'econ');
            LF = U*(S+self.reg_parameter*eye(size(S)))*V';
        end

        %Set goodness of fit (GoF) measure result to reconstruction
        z_vec(3*fixed_orientation_source_inds(i)-[2,1,0]) = 1 - sum((f-LF*source_est).^2)/data_norm_sqr;

    end



    %Free orientation scanning
    for i = 1:length(free_orientation_source_inds)
        %------- Waitbar computations -------
        if self.number_of_frames <=1
            tic;
            time_val = toc;
            date_str = display_waitbar(h,i,free_orientation_source_num,waitbar_update_freq,date_str,time_val);
        end

        ind3D = 3*free_orientation_source_inds(i) - [2,1,0];
        LF = L(:,ind3D);

        %Recularization of the lead field
        if not(strcmp(self.reg_type,"None"))
            [U,S,V] = svd(LF,'econ');
            LF = U*(S+self.reg_parameter*eye(size(S)))*V';
        end

        switch self.method_type
            case "SVD"
                [U,S,V] = svd(LF,'econ');
                source_est = V*(S\(U'*f));

            case "Pseudoinverse"
                source_est = pinv(LF)*f;
        end
        
        %Set goodness of fit (GoF) measure result to reconstruction
        z_vec(ind3D) = 1 - sum((f-LF*source_est).^2)/data_norm_sqr;
        %set direction based on the source direction
        source_est = source_est/sqrt(sum(source_est.^2));
        %sqrt(s^2+s^2+s^2) = sqrt(3)*|s|
        z_vec(ind3D) = z_vec(ind3D).*source_est/sqrt(3);
    end

end % function

%%

function date_str = display_waitbar(h,index,max_iter,update_frequency,date_str,time_val)
if index > 1
    if mod(index,update_frequency) == update_frequency - 1
        date_str = char(datetime(datevec(now+(max_iter/(index-1) - 1)*time_val/86400)));
    end

    if mod(index,update_frequency) == 0
        zef_waitbar(index/max_iter,h,['Step ' int2str(index) ' of ' int2str(max_iter) '. Ready: ' date_str '.' ]);
    end
end

end