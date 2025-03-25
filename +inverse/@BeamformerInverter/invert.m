function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)

    %
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the selected beamforming method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of BeamformerInverter with the method-specific parameters.
    %
    % - f
    %
    %   measurement vector.
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
    %   An instance of possibly modified BeamformerInverter with the method-specific parameters.
    %

    arguments

        self (1,1) inverse.BeamformerInverter

        f (:,1) {mustBeA(f,["double","gpuArray"])}

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        procFile (1,1) struct

        source_direction_mode

        source_positions

        opts.use_gpu (1,1) logical = false

        opts.normalize_data (1,1) double = 1

    end
    self.computing_parameters = false;
    % Initialize waitbar with a cleanup object that automatically closes the
    % waitbar, if there is an interruption with Ctrl + C or when this function
    % exits.
    if self.number_of_frames <= 1
        h = zef_waitbar(0,'Beamforming reconstruction.');
        cleanup_fn = @(wb) close(wb);
        cleanup_obj = onCleanup(@() cleanup_fn(h));
    end

    % Get needed parameters from self and others.
    lambda_cov = self.cov_reg_parameter;
    lambda_LF = self.leadfield_reg_parameter;
    date_str = NaN;
    LF_normalization = 1;

    %Modify to compensate Mahlanobis distance used instead of L2-norm when
   %noise covariance exists
    if not(isempty(self.error_cov))
        C = self.error_cov;
        C = C + lambda_cov*trace(C)*eye(size(C))/size(f,1);
        L_modified = C\L;
    end

    fixed_orientation_source_inds = procFile.s_ind_4;
    free_orientation_source_inds=setdiff(1:length(procFile.s_ind_0), procFile.s_ind_4);
    free_orientation_source_num = length(free_orientation_source_inds);
    waitbar_update_freq = floor(free_orientation_source_num/10);
    
    %Gather the lead field to make the script faster
    if opts.use_gpu
        L = gather(L);
        L_modified = gather(L_modified);
    end

    z_vec = zeros(size(L,2),1);
    
    % Then start inverting.

    %Compute fixed orientation cases first
    for i = 1:length(fixed_orientation_source_inds)
        ind3D = 3*fixed_orientation_source_inds(i) - [2,1,0];
        LF = L(:,3*fixed_orientation_source_inds(i));
        LF_modified = L_modified(:,3*fixed_orientation_source_inds(i));

        %Lead field normalization
        switch self.leadfield_normalization
            case "Matrix norm"
                LF_normalization = norm(LF);
            case "Column norm"
                LF_normalization = sqrt(sum(LF.^2,1));
            case "Row norm"
                LF_normalization = sqrt(sum(LF.^2,2));
        end
        %Lead field regularization 
        switch self.leadfield_reg_type
            case "Basic"
                invLF = inv(LF'*LF_modified+lambda_LF);
            case "Pseudoinverse"
                invLF = 1/(LF'*LF_modified);
        end

        switch self.method_type
            case "Linearly constrained minimum variance (LCMV) beamformer"
                Weights = 1;
            otherwise
                Weights = (LF'*LF_modified)/sqrt(sum(LF_modified.^2));
        end

        z_vec(ind3D) = Weights*invLF*(LF_modified.*LF_normalization)'*f;

    end

    %Free orientation case
    for i = 1:length(free_orientation_source_inds)
        %------- Waitbar computations -------
        if self.number_of_frames <=1
            tic;
            time_val = toc;
            date_str = display_waitbar(h,i,free_orientation_source_num,waitbar_update_freq,date_str,time_val);
        end

        ind3D = 3*free_orientation_source_inds(i) - [2,1,0];
        LF = L(:,ind3D);
        LF_modified = L_modified(:,ind3D);
        if strcmp(self.method_type,"Unit-gain constrained beamformer")
            %Optimal orientation is the one producing the strongest signal
            %Computed using Rayleigh-Ritz formula
            [optimal_orientation,~] = eigs(LF'*LF,1,'largestabs');
            optimal_orientation = optimal_orientation/sqrt(sum(optimal_orientation.^2));
            LF = LF*optimal_orientation;
            LF_modified = LF_modified*optimal_orientation;
        end

        %Lead field normalization
        switch self.leadfield_normalization
            case "Matrix norm"
                LF_normalization = norm(LF);
            case "Column norm"
                LF_normalization = sqrt(sum(LF.^2,1));
            case "Row norm"
                LF_normalization = sqrt(sum(LF.^2,2));
        end
        %Lead field regularization 
        switch self.leadfield_reg_type
            case "Basic"
                invLF = inv(LF'*LF_modified+lambda_LF*eye(size(LF,2)));
            case "Pseudoinverse"
                invLF = pinv(LF'*LF_modified);
        end

        switch self.method_type
            case "Linearly constrained minimum variance (LCMV) beamformer"
                Weights = 1;
            case "Unit noise gain (UNG) beamformer"
               Weights = sqrtm(LF_modified'*LF_modified)\(LF'*LF_modified);
            case "Unit-gain constrained beamformer"
                Weights = (LF'*LF_modified)/sqrt(sum(LF_modified.^2));
        end

        z_vec(ind3D) = Weights*invLF*(LF_modified.*LF_normalization)'*f;
        if strcmp(self.method_type,"Unit-gain constrained beamformer")
            %sqrt(s^2+s^2+s^2) = sqrt(3)*|s|
            z_vec(ind3D) = z_vec(ind3D).*optimal_orientation/sqrt(3);
        end
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