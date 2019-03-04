%Copyright © 2018, Sampsa Pursiainen
zef.inv_roi_mode = get(zef.h_inv_roi_mode ,'value'); 
zef.inv_roi_sphere = str2num(get(zef.h_inv_roi_sphere_1 ,'string')); 
zef.inv_roi_sphere = zef.inv_roi_sphere(:);
zef.inv_roi_sphere = [ zef.inv_roi_sphere ...
reshape(str2num(get(zef.h_inv_roi_sphere_2 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
reshape(str2num(get(zef.h_inv_roi_sphere_3 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
reshape(str2num(get(zef.h_inv_roi_sphere_4 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
];
zef.inv_roi_threshold = str2num(get(zef.h_inv_roi_threshold ,'string'));
    zef.inv_hyperprior = get(zef.h_inv_hyperprior ,'value'); 
    zef.inv_beta = str2num(get(zef.h_inv_beta,'string')); 
    zef.inv_theta0 = str2num(get(zef.h_inv_theta0,'string')); 
    zef.inv_likelihood_std = str2num(get(zef.h_inv_likelihood_std,'string')); 
    zef.inv_n_sampler = str2num(get(zef.h_inv_n_sampler,'string'));
    zef.inv_n_burn_in = str2num(get(zef.h_inv_n_burn_in,'string')); 
    %zef.inv_pcg_tol = str2num(get(zef.h_inv_pcg_tol,'string')); 
    zef.inv_sampling_frequency = str2num(get(zef.h_inv_sampling_frequency,'string')); 
    zef.inv_low_cut_frequency = str2num(get(zef.h_inv_low_cut_frequency,'string')); 
    zef.inv_high_cut_frequency = str2num(get(zef.h_inv_high_cut_frequency,'string')); 
    zef.inv_data_segment = str2num(get(zef.h_inv_data_segment,'string')); 
    zef.inv_time_1 = str2num(get(zef.h_inv_time_1,'string')); 
    zef.inv_time_2 = str2num(get(zef.h_inv_time_2,'string')); 
    zef.inv_time_3 = str2num(get(zef.h_inv_time_3,'string')); 
    zef.number_of_frames = str2num(get(zef.h_number_of_frames,'string')); 
    zef.normalize_data = get(zef.h_normalize_data ,'value');

  if not(size(zef.inv_rec_source,1) == size(zef.inv_roi_sphere,1)) 
   zef.inv_rec_source = zeros(size(zef.inv_roi_sphere,1),9);
    end
    zef.inv_rec_source(:,8) = str2num(get(zef.h_inv_rec_source_8,'string')); 
    zef.inv_rec_source(:,9) = get(zef.h_inv_rec_source_9,'value');
