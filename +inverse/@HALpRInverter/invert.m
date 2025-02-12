%% Copyright © 2025- Joonas Lahtinen
function [z_vec, self] = invert(self, f_data, L, procFile, source_direction_mode, source_positions, opts)
%
    % invert
    %
    % Builds a reconstruction of source dipoles from a given lead field with
    % the HALpR method.
    %
    % Inputs:
    %
    % - self
    %
    %   An instance of HALpRInverter with the method-specific parameters.
    %
    % - f_data
    %  A matrix containing the time serial measurement data in the format
    %  <channels>x<time steps>
    %
    % - L
    %
    %   The lead field that is being inverted.
    %
    % - procFile
    %
    %   A struct with source space indices.
    %
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

        self (1,1) inverse.HALpRInverter

        f_data (:,:) {mustBeA(f_data,["double","gpuArray"])}

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
    h = zef_waitbar(0,'HALpR Reconstruction.');
    cleanup_fn = @(wb) close(wb);
    cleanup_obj = onCleanup(@() cleanup_fn(h));
end

estimation_type = self.estimation_type;
if strcmp(estimation_type,"IAS")
    estimation_type = 1;
elseif strcmp(estimation_type,"EM")
    estimation_type = 2;
elseif strcmp(estimation_type,"Standardized")
    estimation_type = 3;
end
n_map_iterations = self.n_map_iterations;
n_L1_iterations = self.n_L1_iterations;
hypermode = self.hyperprior_mode;
beta = self.beta;
theta0 = self.theta0;
q = self.q;
snr_val = self.signal_to_noise_ratio;
std_lhood = 10^(-snr_val/20);
use_multires = self.use_multiresolution;
multires_n_levels = self.multiresolution_levels_number;
multires_n_decompositions = self.multiresolution_decomposition_number;
multires_sparsity_factor = self.multiresolution_sparsity_factor;

if use_multires
    weight_vec_aux = sum(procFile.n_interp./floor(procFile.n_interp*multires_sparsity_factor.^[1-multires_n_levels:0]));
else
    multires_n_decompositions = 1;
    multires_n_levels = 1;
    weight_vec_aux = 1;
end

%Saved reconstruction information:
if use_multires
    EndTAG = ' Multiresolution';
else
    EndTAG = '';
end
if estimation_type == 1
    StartTAG = 'HALpR IAS';
elseif estimation_type == 2
    StartTAG = 'HALpR EM';
elseif estimation_type == 3
    StartTAG = 'SHALpR';
end
self.tag = [StartTAG,EndTAG];

q = double(q);

S_mat = self.noise_cov;
if opts.use_gpu == 1 && gpuDeviceCount > 0
    L = gpuArray(L);
    S_mat = gpuArray(S_mat);
end

if length(n_map_iterations) < multires_n_levels
    n_map_iterations = n_map_iterations(1)*ones(1,multires_n_levels);
end

    z_vec = ones(size(L,2),1);

    if opts.use_gpu == 1 && gpuDeviceCount > 0
        f = gpuArray(f_data);
    end

    % inversion starts here
    z_vec_aux = zeros(size(L,2),1);

%_ Iterations over decompositions _
for n_rep = 1 : multires_n_decompositions
  if self.number_of_frames <= 1
    zef_waitbar(n_rep/multires_n_decompositions,h,[self.tag,' MAP iteration. Dec. ' int2str(n_rep) ' of ' int2str(multires_n_decompositions)]);
  end

%_ Iterations over multiresolution levels _
for j = 1 : multires_n_levels

    if use_multires
        n_mr_dec = length(multires_dec{n_rep}{j});

        if source_direction_mode == 1 || source_direction_mode == 2
            mr_dec = [multires_dec{n_rep}{j}; multires_dec{n_rep}{j}+n_interp ; multires_dec{n_rep}{j} + 2*n_interp];
            mr_dec = mr_dec(:);
            mr_ind = [multires_ind{n_rep}{j} ; multires_ind{n_rep}{j} + n_mr_dec ; multires_ind{n_rep}{j} + 2*n_mr_dec];
            mr_ind = mr_ind(:);
            %--- New Stuff ---
            mr_count =  [multires_count{n_rep}{j}; multires_count{n_rep}{j} ; multires_count{n_rep}{j}];
            mr_count = mr_count(mr_ind);
            %-----------------
        end

        if source_direction_mode == 3
            mr_dec = multires_dec{n_rep}{j};
            mr_dec = mr_dec(:);
            mr_ind = multires_ind{n_rep}{j};
            mr_ind = mr_ind(:);
            %--- New Stuff ---
            mr_count =  multires_count{n_rep}{j}(mr_ind);
            %-----------------
        end

        if n_map_iterations(j) > 0
            L_aux = L(:,mr_dec);
            gamma = gamma(mr_dec);
            %theta0 = sparsity_factor^((n_multires-j))*theta0_0;
        end
    else
        L_aux = L;
    end
    source_count = size(L_aux,2)/3;

    if strcmp(hypermode,"Sensitivity weighted")
        switch q
            case 1
                %We use sensitivity weighting and optimality condition for
                %data that is completely noise to arrive the conclusion

                %Optimality constraint as E[ |L^T*(C\f)| ]
                c = sum(L_aux.^2,1)*0.6366;
                sens = 2*repelem(sum(reshape(sum(L_aux.^2),3,[])),3)./self.SNR_variable;
                root = sqrt(c+8*sens);
                sqrtc = sqrt(c);
                ind = 3*sqrtc-root>0;
                n_ind = not(ind);
                beta(ind) = 4*sqrtc(ind)./(3*sqrtc(ind)-root(ind));

                beta(n_ind) = 4*sqrtc(n_ind)./(root(n_ind)+3*sqrtc(n_ind));
                theta0 = (beta./sqrtc)';
                theta0(beta<2) = sqrt(3.75./sens)';
                beta(beta<2) = 3.5;  %D.C. 
                beta = beta';

            case 2
                %There is no optimization algorithm for beta, so we set it
                %as
                %beta = 3.5; %Following the D. Calvetti et al. paper
                %"Brain Activity Mapping from MEG Data via a Hierarchical Bayesian
                %Algorithm with Automatic Depth Weighting", Brain Topography (2019) 32:363–393
                c = transpose((2*self.SNR_variable)./repelem(sum(reshape(sum(L_aux.^2),3,[])),3));
                beta = 1;
                theta0 = c;
        end
    else
        %=== Initialize the leadfield model and parameters based on the exp type ===
        beta = beta + 1/q;
        if estimation_type == 1
            beta = beta - 1;
        end
    end
    
    gamma = zeros(length(z_vec),1)+beta./theta0;
%-----------------------------------------------------------------------------------

%__ Initialization __
n = size(L_aux,2);
%L_aux = 1/std_lhood*L_aux_2;

if opts.use_gpu == 1 && gpuDeviceCount > 0
z_vec = gather(z_vec);
end
if q == 1
    x_old = ones(n,1);
    for i = 1 : n_map_iterations(j)
        z_vec = L1_optimization(L_aux,std_lhood,f,gamma,x_old,n_L1_iterations,estimation_type);
        if sum(isnan(z_vec))>0
            disp(i)
            z_vec(isnan(z_vec))=mean(abs(z_vec(not(isnan(z_vec)))));
        end
        gamma = beta./(theta0+abs(z_vec));

        x_old = z_vec;
        if multires_n_decompositions == 1 && self.number_of_frames <= 1
            if i/n_map_iterations(j) < 1
                zef_waitbar(i/n_map_iterations(j),h,[StartTAG,' MAP iteration.']);
            end
        end
    end
else
    for i = 1 : n_map_iterations(j)
        if estimation_type == 3
            P = 1./gamma;
            L_aux2 = L_aux.*P';
            R = L_aux2'/(L_aux2*L_aux'+S_mat);
            R = sum(R.'.*L,1);
            %T_scale_inv = P_sqrt.*sqrt(R)';    %strictly Pascual-Marqui
            T_scale = 1./sqrt(R)';             %losely Pascual-Marqui
            clear R P L_aux2
        else
            T_scale = 1;
        end
        
        w = 1./(gamma*std_lhood^2*max(f)^2);
        if sum(isnan(z_vec))>0
            z_vec(isnan(z_vec)) = 0;
        end
        z_vec = (T_scale.*w).*(L_aux'*((L_aux*(w.*L_aux') + eye(size(L_aux,1)))\f));
        gamma = beta./(theta0+abs(z_vec).^q);
        if multires_n_decompositions == 1 && self.number_of_frames <= 1
            zef_waitbar(i/n_map_iterations(j),h,[StartTAG,' MAP iteration.']);
        end
    end
end

if opts.use_gpu == 1 && gpuDeviceCount > 0
z_vec = gather(z_vec);
end

if use_multires
    if n_map_iterations(j) > 0
    gamma = gamma(mr_ind);
    z_vec = z_vec(mr_ind);
    %theta = theta(mr_ind)./mr_count;
    %z_vec = z_vec(mr_ind)./mr_count;
    end
    z_vec_aux = z_vec_aux + z_vec;
end

end
end

if use_multires
    z_vec = z_vec_aux/(multires_n_decompositions*weight_vec_aux);
end

if self.number_of_frames <= 1
    close(h);
end
end