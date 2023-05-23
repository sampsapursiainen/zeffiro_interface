%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.inv_hyperprior = get(zef.h_mcmc_hyperprior ,'value');
zef.inv_snr = str2num(get(zef.h_mcmc_snr,'string'));
zef.inv_n_burn_in = str2num(get(zef.h_mcmc_n_burn_in,'string'));
zef.inv_sample_size = str2num(get(zef.h_mcmc_sample_size,'string'));
zef.inv_sampling_frequency = str2num(get(zef.h_mcmc_sampling_frequency,'string'));
zef.inv_low_cut_frequency = str2num(get(zef.h_mcmc_low_cut_frequency,'string'));
zef.inv_high_cut_frequency = str2num(get(zef.h_mcmc_high_cut_frequency,'string'));
zef.inv_time_1 = str2num(get(zef.h_mcmc_time_1,'string'));
zef.inv_time_2 = str2num(get(zef.h_mcmc_time_2,'string'));
zef.inv_time_3 = str2num(get(zef.h_mcmc_time_3,'string'));
zef.inv_number_of_frames = str2num(get(zef.h_mcmc_number_of_frames,'string'));
zef.inv_normalize_data = get(zef.h_mcmc_normalize_data ,'value');
zef.inv_time_1 = str2num(get(zef.h_mcmc_time_1,'string'));
zef.inv_time_2 = str2num(get(zef.h_mcmc_time_2,'string'));
zef.inv_time_3 = str2num(get(zef.h_mcmc_time_3,'string'));
zef.inv_low_cut_frequency = str2num(get(zef.h_mcmc_low_cut_frequency,'string'));
zef.inv_high_cut_frequency = str2num(get(zef.h_mcmc_high_cut_frequency,'string'));
zef.inv_sampling_frequency = str2num(get(zef.h_mcmc_sampling_frequency,'string'));
zef.number_of_frames = str2num(get(zef.h_mcmc_number_of_frames,'string'));

