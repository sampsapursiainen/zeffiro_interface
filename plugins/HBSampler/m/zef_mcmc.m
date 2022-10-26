%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = zef_mcmc(zef)

inverse_gamma_ind = [1:4];
gamma_ind = [5:10];
h = zef_waitbar(0,['MCMC sampling.']);
[s_ind_1] = unique(eval('zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

ias_hyperprior = eval('zef.inv_hyperprior');
snr_val = eval('zef.inv_snr');
n_burn_in = eval('zef.inv_n_burn_in');
pm_val = eval('zef.inv_prior_over_measurement_db');
amplitude_db = eval('zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = eval('zef.inv_sampling_frequency');
high_pass = eval('zef.inv_low_cut_frequency');
low_pass = eval('zef.inv_high_cut_frequency');
number_of_frames = eval('zef.inv_number_of_frames');
source_direction_mode = eval('zef.source_direction_mode');
source_directions = eval('zef.source_directions');

reconstruction_information.tag = 'MCMC';
reconstruction_information.n_burn_in = eval('zef.inv_n_burn_in');
reconstruction_information.n_sample_size = eval('zef.inv_sample_size');
reconstruction_information.inv_time_1 = eval('zef.inv_time_1');
reconstruction_information.inv_time_2 = eval('zef.inv_time_2');
reconstruction_information.inv_time_3 = eval('zef.inv_time_3');
reconstruction_information.sampling_freq = eval('zef.inv_sampling_frequency');
reconstruction_information.low_pass = eval('zef.inv_high_cut_frequency');
reconstruction_information.high_pass = eval('zef.inv_low_cut_frequency');
reconstruction_information.number_of_frames = eval('zef.inv_number_of_frames');
reconstruction_information.source_direction_mode = eval('zef.source_direction_mode');
reconstruction_information.source_directions = eval('zef.source_directions');
reconstruction_information.ias_hyperprior = eval('zef.inv_hyperprior');
reconstruction_information.snr_val = eval('zef.inv_snr');
reconstruction_information.pm_val = eval('zef.inv_prior_over_measurement_db');

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

source_count = n_interp;
if eval('zef.inv_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if ias_hyperprior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end
if eval('zef.inv_hyperprior') == 1
[beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,eval('zef.inv_hyperprior_tail_length_db'),L,size(L,2),eval('zef.inv_normalize_data'),balance_spatially,eval('zef.inv_hyperprior_weight'));
elseif eval('zef.inv_hyperprior') == 2
[beta, theta0] = zef_find_g_hyperprior(snr_val-pm_val,eval('zef.inv_hyperprior_tail_length_db'),L,size(L,2),eval('zef.inv_normalize_data'),balance_spatially,eval('zef.inv_hyperprior_weight'));
end

if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
L = gpuArray(L);
end
L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));
if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
S_mat = gpuArray(S_mat);
end

[f_data] = zef_getFilteredData;

tic;

z_inverse = cell(0);

for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if ismember(source_direction_mode,[1,2])
z_aux = zeros(size(L,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L,2),1);
end
z_vec = ones(size(L,2),1);

if eval('zef.inv_hyperprior') == 1
if length(theta0) > 1  || length(beta) > 1
theta = theta0./(beta-1);
else
theta = (theta0./(beta-1))*ones(size(L,2),1);
end
elseif eval('zef.inv_hyperprior') == 2
if length(theta0) > 1  || length(beta) > 1
theta = theta0.*beta;
else
theta = (theta0.*beta).*ones(size(L,2),1);
end
end

[f] = zef_getTimeStep(f_data, f_ind, zef);

if f_ind == 1
zef_waitbar(0,h,['MCMC sampling. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_iter = eval('zef.inv_sample_size');

if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
f = gpuArray(f);
end

if zef.inv_hyperprior == 1
hypermodel = 'InverseGamma';
elseif zef.inv_hyperprior == 2
hypermodel = 'Gamma';    
end

decay_val_hyperprior = 7; 
nbins_hyperprior = 20;
source_direction_mode = zef.source_direction_mode;

parallel_processes = zef.parallel_processes;
n_iter_process = ceil(n_iter/parallel_processes);

x = cell(0);
theta = cell(0);
for j = 1 : parallel_processes
x{j} = zeros(size(L,2),1);
theta{j} = theta0.*ones(size(L,2),1);
end

z_vec = zeros(size(L,2),1);


h = zef_waitbar(0,'Gibbs sampler.');

   if isempty(gcp('nocreate'))
        parpool(parallel_processes);
    else
        h_pool = gcp;
        if not(isequal(h_pool.NumWorkers,parallel_processes))
            delete(h_pool)
            parpool(parallel_processes);
        end
    end

for i =  1 : n_iter_process

    if mod(i,ceil(n_iter_process/100))==0
zef_waitbar(i/n_iter_process,h,['Gibbs sampler: ' num2str(parallel_processes) ' parallel chains.']);
    end
    parfor j = 1 : parallel_processes
[x{j}, theta{j}] = zef_gibbs_sampler_step(L, f, x{j}, theta{j}, theta0, beta, std_lhood, hypermodel, decay_val_hyperprior, nbins_hyperprior, source_direction_mode);
    end
    
if i > n_burn_in
    for j = 1 : parallel_processes
z_vec = z_vec + x{j};
    end
end
end

z_vec = z_vec/(n_iter_process*parallel_processes - n_burn_in);

close(h)

z_inverse{f_ind} = z_vec;

end

[z] = zef_postProcessInverse(z_inverse, procFile);
[z] = zef_normalizeInverseReconstruction(z);

close(h);

end
