function [z_vec, self] = invert(self, f, L, procFile, source_direction_mode, source_positions, opts)

    %
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the IAS RAMUS method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of RAMUSInverter with the method-specific parameters.
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
    %   An instance of possibly modified RAMUSInverter with the method-specific parameters.

    arguments

        self (1,1) inverse.RAMUSInverter

        f (:,1) {mustBeA(f,["double","gpuArray"])}

        L (:,:) {mustBeA(L,["double","gpuArray"])}

        procFile (1,1) struct

        source_direction_mode

        source_positions

        opts.use_gpu (1,1) logical = false

        opts.normalize_data (1,1) double = 1

    end

    if isempty(self.multiresolution_dec)
        error("There is no multiresolution decomposition calculated. Obtain one using make_multires_dec class function.")
    end
    % Initialize waitbar with a cleanup object that automatically closes the
    % waitbar, if there is an interruption with Ctrl + C or when this function
    % exits.

    if self.number_of_frames <= 1
        h = zef_waitbar(0,'RAMUS Reconstruction.');
        cleanup_fn = @(wb) close(wb);
        cleanup_obj = onCleanup(@() cleanup_fn(h));
    end

    % Get needed parameters from self and others.
    date_str = '';
    S_mat = self.noise_cov;
    method_type = self.method_type;
    scaling_vec = (self.sparsity_factor.^[0:self.number_of_multiresolution_levels-1]');
    if length(self.n_map_iterations) < self.number_of_multiresolution_levels
        self.n_map_iterations = [self.n_map_iterations,...
            repmat(self.n_map_iterations(end),1,self.number_of_multiresolution_levels-length(self.n_map_iterations))];
    end
    % Set GPU arrays
    if opts.use_gpu && gpuDeviceCount > 0
        S_mat = gpuArray(S_mat);
        f = gpuArray(f);
    end

    %Set hyperprior selection variables
    if strcmp(self.hyperprior_mode,"Balanced")
        balance_spatially = 1;
    else
        balance_spatially = 0;
    end
    
    if strcmp(self.data_normalization_method,"Maximum entry")
        normalize_data = 'maximum entry';
    else
        normalize_data = 'something else';
    end    
    modified_SNR = self.signal_to_noise_ratio-self.prior_over_measurement_db + self.amplitude_db;

    % Then start inverting.
    z_vec = zeros(size(L,2),1);
    for dec_ind = 1:self.number_of_decompositions
    for mr_ind = 1:self.number_of_multiresolution_levels
        if self.number_of_frames <=1
            tic;
            time_val = toc;
            date_str = display_waitbar(h,[dec_ind mr_ind],...
                [self.number_of_decompositions self.number_of_multiresolution_levels],...
                1,date_str,time_val);
        end
        multires_dec = 3*self.multiresolution_dec{dec_ind}{mr_ind};
        multires_dec = [multires_dec-2,multires_dec-1,multires_dec]';
        multires_dec = multires_dec(:);
        multires_ind = 3*self.multiresolution_ind{dec_ind}{mr_ind};
        multires_ind = [multires_ind-2,multires_ind-1,multires_ind]';
        multires_ind = multires_ind(:);
        L_sub = L(:,multires_dec);
        
        if dec_ind == 1
        if strcmp(self.hyperprior,"Inverse gamma")
            [beta, theta0] = zef_find_ig_hyperprior(modified_SNR,...
            self.hyperprior_tail_length_db,L_sub,size(L_sub,2),normalize_data,balance_spatially,self.hyperprior_weight);
            d_sqrt = theta0./(beta-1);
        elseif strcmp(self.hyperprior,"Gamma")
            [beta, theta0] = zef_find_g_hyperprior(modified_SNR,...
            self.hyperprior_tail_length_db,L_sub,size(L_sub,2),normalize_data,balance_spatially,self.hyperprior_weight);
            d_sqrt = theta0.*beta;
        end
        else
            d_sqrt = d_sqrt(multires_dec);
        end

        for i = 1:self.n_map_iterations(mr_ind)
    
            W = L_sub .* repmat( d_sqrt' , size(L_sub,1), 1);
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
            elseif strcmp(method_type, "sLORETA each step")
                sloreta_vec = sqrt(sum(W.*L_sub', 2));
                W = W./sloreta_vec(:,ones(size(W,2),1));
            elseif strcmp(method_type, "sLORETA last step")
                if i == self.n_n_map_iterations
                    sloreta_vec = sqrt(sum(W.*L_sub', 2));
                    W = W./sloreta_vec(:,ones(size(W,2),1));
                end
            end
        
            z_vec_sub = W*f;
            
            if opts.use_gpu && gpuDeviceCount > 0
                z_vec_sub = gather(z_vec_sub);
            end
    
            if strcmp(self.hyperprior,"Inverse gamma")
                d_sqrt = sqrt((theta0+0.5*z_vec_sub.^2)./(beta + 1.5));
            elseif strcmp(self.hyperprior,"Gamma")
                d_sqrt = sqrt(theta0.*(beta-1.5 + sqrt((1./(2.*theta0)).*z_vec_sub.^2 + (beta+1.5).^2)));
            end
    
        end % ias iterations 
        d_sqrt = d_sqrt(multires_ind);
        z_vec = z_vec + z_vec_sub(multires_ind);
    end %multires loop
    end % dec loop
    z_vec = z_vec/(double(self.number_of_decompositions*self.number_of_multiresolution_levels)*sum(scaling_vec));
end % function

%%

function date_str = display_waitbar(h,index,max_iter,update_frequency,date_str,time_val)
if index(1) > 1
    if mod(index,update_frequency) == update_frequency - 1
        date_str = char(datetime(datevec(now+(double(max_iter(1))/(double(index(1))-1) - 1)*time_val/86400)));
    end

    if mod(index,update_frequency) == 0
        zef_waitbar(index,max_iter,h,['Dec ' int2str(index(1)) ' of ' int2str(max_iter(1)) '. Ready: ' date_str '.' ]);
    end
end
end % function
