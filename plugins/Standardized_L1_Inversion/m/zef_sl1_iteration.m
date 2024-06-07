%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [z,reconstruction_information] = zef_sl1_iteration(zef)

inverse_gamma_ind = [1:4];
gamma_ind = [5:10];
h = zef_waitbar(0,1,['Standardized L1 MAP iteration.']);
[s_ind_1] = unique(eval('zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

sl1_hyperprior = eval('zef.sl1_hyperprior');
snr_val = eval('zef.sl1_snr');
sl1_type = eval('zef.sl1_type');
pm_val = eval('zef.inv_prior_over_measurement_db');
amplitude_db = eval('zef.inv_amplitude_db');
pm_val = pm_val - amplitude_db;
std_lhood = 10^(-snr_val/20);
sampling_freq = eval('zef.sl1_sampling_frequency');
high_pass = eval('zef.sl1_low_cut_frequency');
low_pass = eval('zef.sl1_high_cut_frequency');
number_of_frames = eval('zef.sl1_number_of_frames');
source_direction_mode = eval('zef.source_direction_mode');
source_directions = eval('zef.source_directions');

reconstruction_information.tag = 'sl1';
reconstruction_information.inv_time_1 = eval('zef.sl1_time_1');
reconstruction_information.inv_time_2 = eval('zef.sl1_time_2');
reconstruction_information.inv_time_3 = eval('zef.sl1_time_3');
reconstruction_information.sampling_freq = eval('zef.sl1_sampling_frequency');
reconstruction_information.low_pass = eval('zef.sl1_high_cut_frequency');
reconstruction_information.high_pass = eval('zef.sl1_low_cut_frequency');
reconstruction_information.number_of_frames = eval('zef.sl1_number_of_frames');
reconstruction_information.source_direction_mode = eval('zef.source_direction_mode');
reconstruction_information.source_directions = eval('zef.source_directions');
reconstruction_information.sl1_hyperprior = eval('zef.sl1_hyperprior');
reconstruction_information.snr_val = eval('zef.sl1_snr');
reconstruction_information.pm_val = eval('zef.inv_prior_over_measurement_db');

[L,n_interp, procFile] = zef_processLeadfields(source_direction_mode);

source_count = n_interp;
if eval('zef.sl1_normalize_data')==1;
    normalize_data = 'maximum';
else
    normalize_data = 'average';
end

if sl1_hyperprior == 1
    balance_spatially = 1;
else
    balance_spatially = 0;
end

    [beta, theta0] = zef_find_ig_hyperprior((snr_val-pm_val)/2,2*eval('zef.inv_hyperprior_tail_length_db'),L,size(L,2),eval('zef.sl1_normalize_data'),balance_spatially,eval('zef.inv_hyperprior_weight'));

        options = optimoptions('quadprog');
        options = optimoptions(options, 'OptimalityTolerance', 1e-6);
        options = optimoptions(options, 'ConstraintTolerance', 1e-6);
        options = optimoptions(options, 'StepTolerance', 1e-6);
        options = optimoptions(options, 'MaxIterations', ceil(2*sqrt(size(L,2))));
        options_quad = optimoptions(options, 'Algorithm', 'interior-point-convex');

        options_lin = optimoptions('linprog');

if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
    L = gpuArray(L);
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
    z_vec = zeros(size(L,2),1);

    [f] = zef_getTimeStep(f_data, f_ind, zef);

    if f_ind == 1
        zef_waitbar(0,1,h,['Standardized L1 MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.']);
    end
    n_sl1_map_iter = eval('zef.sl1_n_map_iterations');

    if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
        f = gpuArray(f);
    end

    for i = 1 : n_sl1_map_iter

        if f_ind > 1;
            zef_waitbar(i,n_sl1_map_iter,h,['Step ' int2str(f_ind) ' of ' int2str(number_of_frames) '. Ready: ' date_str '.' ]);
        else
            zef_waitbar(i,n_sl1_map_iter,h,['Standardized L1 MAP iteration. Time step ' int2str(f_ind) ' of ' int2str(number_of_frames) '.' ]);
        end

        theta = (theta0+abs(z_vec))./beta;

        z_vec = zef_l2_l1_optimizer(L, f, std_lhood.^2./theta, options_quad);

      if isequal(sl1_type,2)
          p_vec = 0.5*abs(z_vec).*theta;
          R = (p_vec.*L')*(inv(L*(p_vec.*L') + std_lhood.^2.*eye(size(L,1)))*L);
          z_vec = sqrt(1./diag(R)).*z_vec;
      elseif isequal(sl1_type,3)
          z_vec = z_vec./(max(abs(L))');
      end 

         if eval('zef.use_gpu') == 1 & eval('zef.gpu_count') > 0
            z_vec = gather(z_vec);
        end

    z_inverse{f_ind} = z_vec;

    end

end

[z] = zef_postProcessInverse(z_inverse, procFile);
[z] = zef_normalizeInverseReconstruction(z);

close(h);


