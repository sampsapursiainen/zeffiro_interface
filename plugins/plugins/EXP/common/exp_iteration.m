%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = exp_iteration(zef)

parameters = fields(zef.EXP.parameters);
for n = 1:length(parameters)
    eval([erase(parameters{n},'exp_'),'=',num2str(zef.EXP.parameters.(parameters{n})),';']);
end

snr_val = zef.inv_snr;
pm_val = zef.inv_prior_over_measurement_db;
amplitude_db = zef.inv_amplitude_db;
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
number_of_frames = zef.number_of_frames;
source_direction_mode = zef.source_direction_mode;

if use_multires
    weight_vec_aux = sum(n_interp./floor(n_interp*multires_sparsity_factor.^[1-multires_n_levels:0]));
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
    StartTAG = 'EXP IAS';
elseif estimation_type == 2
    StartTAG = 'EXP EM';
elseif estimation_type == 3
    StartTAG = 'EXP sLORETA';
end
reconstruction_information.tag = [StartTAG,EndTAG];
reconstruction_information.inv_time_1 = zef.inv_time_1;
reconstruction_information.inv_time_2 = zef.inv_time_2;
reconstruction_information.inv_time_3 = zef.inv_time_3;
reconstruction_information.inv_sampling_frequency = zef.inv_sampling_frequency;
reconstruction_information.inv_high_cut_frequency = zef.inv_high_cut_frequency;
reconstruction_information.inv_low_cut_frequency = zef.inv_low_cut_frequency;
reconstruction_information.number_of_frames = zef.number_of_frames;
reconstruction_information.source_direction_mode = zef.source_direction_mode;
reconstruction_information.source_directions = zef.source_directions;
reconstruction_information.inv_snr = zef.inv_snr;
reconstruction_information.exp_q = q;
reconstruction_information.exp_n_L1_iterations = n_L1_iterations;
reconstruction_information.exp_n_map_iterations = n_map_iterations;

if ismember(hypermode,[1,2])
    reconstruction_information.inv_hyperprior = zef.inv_hyperprior;
    reconstruction_information.pm_val = zef.inv_prior_over_measurement_db;
else
    reconstruction_information.exp_multires_theta0 = theta0;
    reconstruction_information.exp_multires_beta = beta;
end

reconstruction_information.exp_multires_n_decompositions = multires_n_decompositions;
reconstruction_information.exp_multires_n_levels = multires_n_levels;
reconstruction_information.exp_multires_sparsity = multires_sparsity_factor;

h = zef_waitbar(0,[reconstruction_information.tag,' MAP iteration.']);

[L,n_interp, procFile] = zef_processLeadfields(zef);
f_data = zef_getFilteredData;
S_mat = std_lhood^2*max(f_data.^2,[],'all')*eye(size(L,1));
if zef.use_gpu == 1 && gpuDeviceCount > 0
    L = gpuArray(L);
    S_mat = gpuArray(S_mat);
end

if length(n_map_iterations) < multires_n_levels
    n_map_iterations = n_map_iterations(1)*ones(1,multires_n_levels);
end

z = cell(number_of_frames,1);

tic;
for f_ind = 1 : number_of_frames
    time_val = toc;
    if f_ind > 1
        date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400)); %what does that do?
        zef_waitbar(100,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);

    end

    f=zef_getTimeStep(f_data, f_ind);
    z_vec = ones(size(L,2),1);

    if zef.use_gpu == 1 && gpuDeviceCount > 0
        f = gpuArray(f);
    end

    % inversion starts here
    z_vec_aux = zeros(size(L,2),1);

    %_ Iterations over decompositions _
    for n_rep = 1 : multires_n_decompositions

        if f_ind > 1
            zef_waitbar(n_rep/multires_n_decompositions,h,['Dec. ' int2str(n_rep) ' of ' int2str(multires_n_decompositions) ', Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        else
            zef_waitbar(n_rep/multires_n_decompositions,h,[reconstruction_information.tag,' MAP iteration. Dec. ' int2str(n_rep) ' of ' int2str(multires_n_decompositions) ', Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
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
            source_count = size(L_aux,2);

            if ismember(hypermode,[1,2])
                if zef.normalize_data==1
                    normalize_data = 'maximum';
                else
                    normalize_data = 'average';
                end

                if hypermode == 1
                    balance_spatially = 1;
                else
                    balance_spatially = 0;
                end
                %Inverse gamma of variance corresponds to gamma of penalty factors
                [beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,zef.inv_hyperprior_tail_length_db,L_aux,source_count,normalize_data,balance_spatially,zef.inv_hyperprior_weight);

                %_ Set parameters to exponentially conditional distribution _
                beta = 2*beta + 3;
                theta0 = 2*theta0;
                if q == 1
                    theta0 = sqrt(theta0);
                end
                if estimation_type == 1 || estimation_type == 3
                    reconstruction_information.exp_beta = gather(beta-1/q+1);
                elseif estimation_type == 2
                    reconstruction_information.exp_beta = gather(beta-1/q);
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

            if zef.use_gpu == 1 && gpuDeviceCount > 0
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
                    if multires_n_decompositions == 1
                        zef_waitbar(i/n_map_iterations(j),h,[StartTAG,' MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
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
                        keyboard
                    end
                    z_vec = (T_scale.*w).*(L_aux'*((L_aux*(w.*L_aux') + eye(size(L_aux,1)))\f));
                    gamma = beta./(theta0+abs(z_vec).^q);
                    if multires_n_decompositions == 1
                        zef_waitbar(i/n_map_iterations(j),h,[StartTAG,' MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
                    end
                end
            end

            if zef.use_gpu == 1 && gpuDeviceCount > 0
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
        z{f_ind} = z_vec_aux/(multires_n_decompositions*weight_vec_aux);
    else
        z{f_ind} = z_vec;
    end
end

z = zef_postProcessInverse(z, procFile);
%z = zef_normalizeInverseReconstruction(z);
close(h);
