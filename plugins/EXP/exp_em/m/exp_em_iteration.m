%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = exp_em_iteration(void)
h = waitbar(0,['EM MAP iteration.']);

hyper_type = evalin('base','zef.exp_em_hyper_type');
n_ias_map_iter = evalin('base','zef.inv_n_map_iterations');
n_L1_iter = evalin('base','zef.inv_n_L1_iterations');
q = evalin('base','zef.exp_em_q');
beta = evalin('base','zef.exp_em_beta');
theta0 = evalin('base','zef.exp_em_theta0');
snr_val = evalin('base','zef.inv_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
number_of_frames = evalin('base','zef.number_of_frames');
source_direction_mode = evalin('base','zef.source_direction_mode');

%Saved reconstruction information:
reconstruction_information.tag = 'EXP EM';
reconstruction_information.inv_time_1 = evalin('base','zef.inv_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.inv_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.inv_time_3');
reconstruction_information.inv_sampling_frequency = evalin('base','zef.inv_sampling_frequency');
reconstruction_information.inv_high_cut_frequency = evalin('base','zef.inv_high_cut_frequency');
reconstruction_information.inv_low_cut_frequency = evalin('base','zef.inv_low_cut_frequency');
reconstruction_information.number_of_frames = evalin('base','zef.number_of_frames');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.inv_snr = evalin('base','zef.inv_snr');
reconstruction_information.exp_em_q = q;
reconstruction_information.inv_n_L1_iterations = n_L1_iter;
reconstruction_information.inv_n_map_iterations = n_ias_map_iter;

if ismember(hyper_type,[1,2])
    reconstruction_information.inv_hyperprior = evalin('base','zef.inv_hyperprior');
    reconstruction_information.pm_val = evalin('base','zef.inv_prior_over_measurement_db');
else
    reconstruction_information.exp_em_theta0 = theta0;
    reconstruction_information.exp_em_beta = beta;
end

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

if ismember(hyper_type,[1,2])
    %source_count = n_interp;
    if evalin('base','zef.normalize_data')==1
        normalize_data = 'maximum';
    else
        normalize_data = 'average';
    end

    if hyper_type == 1
        balance_spatially = 1;
    else
        balance_spatially = 0;
    end
    if evalin('base','zef.inv_hyperprior') == 1
        [beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),normalize_data,balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
    elseif evalin('base','zef.inv_hyperprior') == 2
        [beta, theta0] = zef_find_g_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),normalize_data,balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
    end
    if q == 1
        theta0 = sqrt(theta0);
    end
    reconstruction_information.exp_em_theta0 = gather(theta0(1));
    reconstruction_information.exp_em_beta = gather(beta(1));
end

if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
    L = gpuArray(L);
end

    z = cell(number_of_frames,1);
f_data = zef_getFilteredData;
n = size(L,2);

tic;
for f_ind = 1 : number_of_frames

        time_val = toc;
    if f_ind > 1
        date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400)); %what does that do?
        waitbar(100,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);

    end

    f=zef_getTimeStep(f_data, f_ind, true);

    z_vec = nan(size(L,2),1);

    if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
        f = gpuArray(f);
    end

% inversion starts here
if f_ind == 1
waitbar(0,h,['EM MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end

%__ Initialize parameters __
z_vec = zeros(n,1);
gamma =zeros(length(z_vec),1)+(beta+1/q)./theta0;

%__ Iteration Loops __
%m_max = sqrt(size(L,2));
%u = zeros(length(z_vec),1);
%z_vec = zeros(length(z_vec),1);
%d_sqrt = sqrt(theta);
%if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
%d_sqrt = gpuArray(d_sqrt);
%end
%__Set L and z_vec to their final form__
%L = L_aux.*repmat(d_sqrt',size(L,1),1);

%z_vec = d_sqrt.*(L'*((L*L' + S_mat)\f));

%__Update theta__
    if q==2
        for i = 1 : n_ias_map_iter
        %_Draw waitbar_
        if f_ind > 1;
        waitbar(i/n_ias_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        else
        waitbar(i/n_ias_map_iter,h,['EM MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
        end;
        w = 1./(gamma*std_lhood^2*max(f)^2);

        z_vec = w.*(L'*((L*(w.*L') + eye(size(L,1)))\f));
        %_ gamma update _

        %--------------------------------------------------------------------------
        gamma = (beta+1/q)./(theta0+0.5*abs(z_vec).^q);
        %--------------------------------------------------------------------------
        end
    else
        %gamma = 0.5*max((At*b));
        %betas = (alpha+1)/gamma;
        % gamma = min(gamma,0.4*norm((At*b),inf));
        x_old = zeros(n,1)+1e-10;%it seems sensitive to initialization!

        for i = 1 : n_ias_map_iter
        %_Draw waitbar_
        if f_ind > 1;
        waitbar(i/n_ias_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        else
        waitbar(i/n_ias_map_iter,h,['EM MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
        end;
        %focal activity
        z_vec = L1_optimization(L,std_lhood,f,gamma,x_old,n_L1_iter);

        gamma = (beta+1)./(theta0+0.5*abs(z_vec));
        end
    end

%end;
if evalin('base','zef.use_gpu') == 1 && gpuDeviceCount > 0
z_vec = gather(z_vec);
end

z{f_ind} = z_vec;
end;

z = zef_postProcessInverse(z, procFile);
z = zef_normalizeInverseReconstruction(z);

close(h);
end
