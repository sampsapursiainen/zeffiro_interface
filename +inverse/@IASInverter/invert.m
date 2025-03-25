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
    % - self
    %
    %   An instance of possibly modified IASInverter with the method-specific parameters.
    %

    arguments

        self (1,1) inverse.IASInverter

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
        h = zef_waitbar(0,'IAS Reconstruction.');
        cleanup_fn = @(wb) close(wb);
        cleanup_obj = onCleanup(@() cleanup_fn(h));
    end

    % Get needed parameters from self and others.
    date_str = '';
    update_freq = floor(self.n_map_iterations/10);
    theta0 = self.theta0;
    beta = self.beta;
    d_sqrt = self.d_sqrt;
    S_mat = self.noise_cov;
    method_type = self.method_type;
    
    % Set GPU arrays
    if opts.use_gpu && gpuDeviceCount > 0
        S_mat = gpuArray(S_mat);
        L = gpuArray(L);
        f = gpuArray(f);
        d_sqrt = gpuArray(d_sqrt);
    end

    % Then start inverting.
    for i = 1:self.n_map_iterations
        if self.number_of_frames <=1
            tic;
            time_val = toc;
            date_str = display_waitbar(h,i,self.n_map_iterations,update_freq,date_str,time_val);
        end

        W = L .* repmat( d_sqrt' , size(L,1), 1);
        W = d_sqrt.*( W' * inv( W * W' + S_mat ) );
        
        if strcmp(method_type, "dSPM each step")
            dspm_vec = sum(W.^2, 2);
            dspm_vec = sqrt(dspm_vec);
            W = W./dspm_vec;
        elseif strcmp(method_type, "dSPM last step")
            if i == self.n_n_map_iterations
                dspm_vec = sum(W.^2, 2);
                dspm_vec = sqrt(dspm_vec);
                W = W./dspm_vec;
            end
        elseif strcmp(method_type, "sLORETA last step")
            if i == self.n_n_map_iterations
                sloreta_vec = sqrt(sum(W.*L', 2));
                W = W./sloreta_vec(:,ones(size(W,2),1));
            end
        end
    
        z_vec = W*f;
        
        if opts.use_gpu && gpuDeviceCount > 0
            z_vec = gather(z_vec);
        end

        if strcmp(self.hyperprior,"Inverse gamma")
            d_sqrt = sqrt((theta0+0.5*z_vec.^2)./(beta + 1.5));
        elseif strcmp(self.hyperprior,"Gamma")
            d_sqrt = sqrt(theta0.*(beta-1.5 + sqrt((1./(2.*theta0)).*z_vec.^2 + (beta+1.5).^2)));
        end

    end % ias iterations
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
end % function
