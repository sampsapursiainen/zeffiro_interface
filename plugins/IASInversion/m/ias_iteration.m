%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = ias_iteration(void)

inverse_gamma_ind = [1:4];
gamma_ind = [5:10];
h = waitbar(0,['IAS MAP iteration.']);
[s_ind_1] = unique(evalin('base','zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

ias_hyperprior = evalin('base','zef.ias_hyperprior');
snr_val = evalin('base','zef.ias_snr');
pm_val = evalin('base','zef.inv_prior_over_measurement_db');
amplitude_db = evalin('base','zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = evalin('base','zef.ias_sampling_frequency');
high_pass = evalin('base','zef.ias_low_cut_frequency');
low_pass = evalin('base','zef.ias_high_cut_frequency');
number_of_frames = evalin('base','zef.ias_number_of_frames');
source_direction_mode = evalin('base','zef.source_direction_mode');
source_directions = evalin('base','zef.source_directions');

reconstruction_information.tag = 'IAS';
reconstruction_information.inv_time_1 = evalin('base','zef.ias_time_1');
reconstruction_information.inv_time_2 = evalin('base','zef.ias_time_2');
reconstruction_information.inv_time_3 = evalin('base','zef.ias_time_3');
reconstruction_information.sampling_freq = evalin('base','zef.ias_sampling_frequency');
reconstruction_information.low_pass = evalin('base','zef.ias_high_cut_frequency');
reconstruction_information.high_pass = evalin('base','zef.ias_low_cut_frequency');
reconstruction_information.number_of_frames = evalin('base','zef.ias_number_of_frames');
reconstruction_information.source_direction_mode = evalin('base','zef.source_direction_mode');
reconstruction_information.source_directions = evalin('base','zef.source_directions');
reconstruction_information.ias_hyperprior = evalin('base','zef.ias_hyperprior');
reconstruction_information.snr_val = evalin('base','zef.ias_snr');
reconstruction_information.pm_val = evalin('base','zef.inv_prior_over_measurement_db');

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

source_count = n_interp;
if evalin('base','zef.ias_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if ias_hyperprior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end
if evalin('base','zef.inv_hyperprior') == 1
[beta, theta0] = zef_find_ig_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),evalin('base','zef.ias_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
elseif evalin('base','zef.inv_hyperprior') == 2
[beta, theta0] = zef_find_g_hyperprior(snr_val-pm_val,evalin('base','zef.inv_hyperprior_tail_length_db'),L,size(L,2),evalin('base','zef.ias_normalize_data'),balance_spatially,evalin('base','zef.inv_hyperprior_weight'));
end

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

if evalin('base','zef.inv_hyperprior') == 1
if length(theta0) > 1  || length(beta) > 1
theta = theta0./(beta-1);
else
theta = (theta0./(beta-1))*ones(size(L,2),1);
end
elseif evalin('base','zef.inv_hyperprior') == 2
if length(theta0) > 1  || length(beta) > 1
theta = theta0.*beta;
else
theta = (theta0.*beta)*ones(size(L,2),1);
end
end

[f] = zef_getTimeStep(f_data, f_ind, true);

if f_ind == 1
waitbar(0,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
end
n_ias_map_iter = evalin('base','zef.ias_n_map_iterations');

if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
f = gpuArray(f);
end

for i = 1 : n_ias_map_iter
if f_ind > 1;
waitbar(i/n_ias_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
else
waitbar(i/n_ias_map_iter,h,['IAS MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
end;
m_max = sqrt(size(L,2));
u = zeros(length(z_vec),1);
z_vec = zeros(length(z_vec),1);
d_sqrt = sqrt(theta);
if evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
d_sqrt = gpuArray(d_sqrt);
end
L = L_aux.*repmat(d_sqrt',size(L,1),1);
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

z_inverse{f_ind} = z_vec;

end;

[z] = zef_postProcessInverse(z_inverse, procFile);
[z] = zef_normalizeInverseReconstruction(z);

close(h);
