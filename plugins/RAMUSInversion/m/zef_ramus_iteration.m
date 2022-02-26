%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = zef_ramus_iteration(void)

h = waitbar([0 0 0],['RAMUS iteration.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);
n_multires = evalin('base','zef.ramus_multires_n_levels');
ramus_hyperprior = evalin('base','zef.ramus_hyperprior');
sparsity_factor = evalin('base','zef.ramus_multires_sparsity');
snr_val = evalin('base','zef.ramus_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
sampling_freq = evalin('base','zef.ramus_sampling_frequency');
high_pass = evalin('base','zef.ramus_low_cut_frequency');
low_pass = evalin('base','zef.ramus_high_cut_frequency');
number_of_frames = evalin('base','zef.ramus_number_of_frames');
time_step = evalin('base','zef.ramus_time_3');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');
n_decompositions = evalin('base','zef.ramus_multires_n_decompositions');
weight_vec_aux = (sparsity_factor.^[0:n_multires-1]');

std_lhood = 10^(-snr_val/20);

reconstruction_information.tag = 'RAMUS';
reconstruction_information.inv_time_1 = evalin('base','zef.ramus_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.ramus_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.ramus_time_3');
reconstruction_information.sampling_freq = evalin('base','zef.ramus_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.ramus_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.ramus_low_cut_frequency');
reconstruction_information.number_of_frames = evalin('base','zef.ramus_number_of_frames');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.ias_hyperprior = evalin('base','zef.ramus_hyperprior');
reconstruction_information.snr_val = evalin('base','zef.ramus_snr');
reconstruction_information.pm_val = evalin('base','zef.inv_prior_over_measurement_db');

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
L = gpuArray(L);
end
L_aux = L;
S_mat = std_lhood^2*eye(size(L,1));
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
S_mat = gpuArray(S_mat);
end

[f_data] = zef_getFilteredData;

tic;

z_inverse = cell(0);

tic;
for f_ind = 1 : number_of_frames
time_val = toc;
if f_ind > 1;
date_str = datestr(datevec(now+(number_of_frames/(f_ind-1) - 1)*time_val/86400));
end;

if source_direction_mode == 1 || source_direction_mode == 2
z_aux = zeros(size(L_aux,2),1);
end
if source_direction_mode == 3
z_aux = zeros(3*size(L_aux,2),1);
end
z_vec = ones(size(L_aux,2),1);

[f] = zef_getTimeStep(f_data, f_ind, true);

if f_ind == 1
waitbar([0 0 0],h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_ias_map_iter = evalin('base','zef.ramus_n_map_iterations');

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

multires_dec =  evalin('base','zef.ramus_multires_dec');
multires_ind =  evalin('base','zef.ramus_multires_ind');
multires_count = evalin('base','zef.ramus_multires_count');
n_iter = evalin('base','zef.ramus_multires_n_iter');
if length(n_iter) < n_multires
    n_iter = n_iter(1)*ones(1,n_multires);
end
mr_sparsity = evalin('base','zef.ramus_multires_sparsity');

z_vec_aux = zeros(size(L_aux,2),1);
iter_ind = 0;
source_count_aux = 0;

for n_rep = 1 : n_decompositions

for j = 1 : n_multires

iter_ind = iter_ind + 1;

n_mr_dec = length(multires_dec{n_rep}{j});

if source_direction_mode == 1 || source_direction_mode == 2
mr_dec = [multires_dec{n_rep}{j}; multires_dec{n_rep}{j}+n_interp ; multires_dec{n_rep}{j} + 2*n_interp];
mr_dec = mr_dec(:);
mr_ind = [multires_ind{n_rep}{j} ; multires_ind{n_rep}{j} + n_mr_dec ; multires_ind{n_rep}{j} + 2*n_mr_dec];
mr_ind = mr_ind(:);
end

if source_direction_mode == 3
mr_dec = multires_dec{n_rep}{j};
mr_dec = mr_dec(:);
mr_ind = multires_ind{n_rep}{j};
mr_ind = mr_ind(:);
end

if n_iter(j) > 0
L_aux_2 = L_aux(:,mr_dec);
if source_count_aux == 0
source_count = size(L_aux_2,2);
source_count_aux = 1;
end
if evalin('base','zef.ramus_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if ramus_hyperprior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end
if evalin('base','zef.inv_hyperprior') == 1
[beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L_aux_2,source_count,evalin('base','zef.ramus_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
elseif evalin('base','zef.inv_hyperprior') == 2
[beta, theta0] = zef_find_g_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L_aux_2,source_count,evalin('base','zef.ramus_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
end

if n_rep == 1 || evalin('base','zef.ramus_init_guess_mode') == 2
if evalin('base','zef.inv_hyperprior') == 1
if length(theta0) > 1  || length(beta) > 1
theta = theta0./(beta-1);
else
theta = (theta0./(beta-1))*ones(size(L_aux_2,2),1);
end
elseif evalin('base','zef.inv_hyperprior') == 2
if length(theta0) > 1  || length(beta) > 1
theta = theta0.*beta;
else
theta = (theta0.*beta)*ones(size(L_aux_2,2),1);
end
end
else
theta = theta(mr_dec);
end

for i = 1 : n_iter(j)
if f_ind > 1;
waitbar([i/n_iter(j) j/n_multires n_rep/n_decompositions],h,['Dec. ' int2str(n_rep) ' of ' int2str(n_decompositions) ', Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar([i/n_iter(j) j/n_multires n_rep/n_decompositions],h,['IAS MAP iteration. Dec. ' int2str(n_rep) ' of ' int2str(n_decompositions) ', Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;
d_sqrt = sqrt(theta);
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
d_sqrt = gpuArray(d_sqrt);
end
L = L_aux_2.*repmat(d_sqrt',size(L,1),1);
z_vec = d_sqrt.*(L'*((L*L' + S_mat)\f));

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
z_vec = gather(z_vec);
end

if evalin('base','zef.inv_hyperprior') == 1
theta = (theta0+0.5*z_vec.^2)./(beta + 1.5);
elseif evalin('base','zef.inv_hyperprior') == 2
theta = theta0.*(beta-1.5 + sqrt((1./(2.*theta0)).*z_vec.^2 + (beta+1.5).^2));
end

end;

if length(theta0) > 1
theta0 = theta0(mr_ind);
end
if length(beta) > 1
beta = beta(mr_ind);
end
theta = theta(mr_ind);
z_vec = z_vec(mr_ind);
else
    z_vec = zeros(length(mr_ind),1);
    weight_vec_aux(j) = 0;
end

z_vec_aux = z_vec_aux + z_vec;

end
end

z_vec = z_vec_aux/(n_multires*n_decompositions*sum(weight_vec_aux));
z_inverse{f_ind} = z_vec;

end;

[z] = zef_postProcessInverse(z_inverse, procFile);
[z] = zef_normalizeInverseReconstruction(z);

close(h);

end

