%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.ramus_multires_n_levels = str2num(get(zef.h_ramus_multires_n_levels,'string'));
zef.ramus_multires_sparsity = str2num(get(zef.h_ramus_multires_sparsity,'string'));
zef.ramus_multires_n_decompositions = str2num(get(zef.h_ramus_multires_n_decompositions,'string'));
zef.ramus_snr = str2num(get(zef.h_ramus_snr,'string'));
zef.ramus_multires_n_iter = str2num(get(zef.h_ramus_multires_n_iter,'string'));
zef.ramus_sampling_frequency = str2num(get(zef.h_ramus_sampling_frequency,'string'));
zef.ramus_low_cut_frequency = str2num(get(zef.h_ramus_low_cut_frequency,'string'));
zef.ramus_high_cut_frequency = str2num(get(zef.h_ramus_high_cut_frequency,'string'));
zef.ramus_time_1 = str2num(get(zef.h_ramus_time_1,'string'));
zef.ramus_time_2 = str2num(get(zef.h_ramus_time_2,'string'));
zef.ramus_time_3 = str2num(get(zef.h_ramus_time_3,'string'));
zef.ramus_number_of_frames = str2num(get(zef.h_ramus_number_of_frames,'string'));
zef.ramus_normalize_data = get(zef.h_ramus_normalize_data ,'value');
zef.ramus_init_guess_mode = get(zef.h_ramus_init_guess_mode ,'value');
zef.ramus_initial_guess_mode = get(zef.h_ramus_normalize_data ,'value');
zef.ramus_hyperprior = get(zef.h_ramus_hyperprior ,'value');
zef.inv_time_1 = str2num(get(zef.h_ramus_time_1,'string'));
zef.inv_time_2 = str2num(get(zef.h_ramus_time_2,'string'));
zef.inv_time_3 = str2num(get(zef.h_ramus_time_3,'string'));
zef.inv_sampling_frequency = str2num(get(zef.h_ramus_sampling_frequency,'string'));
zef.inv_low_cut_frequency = str2num(get(zef.h_ramus_low_cut_frequency,'string'));
zef.inv_high_cut_frequency = str2num(get(zef.h_ramus_high_cut_frequency,'string'));
zef.number_of_frames = str2num(get(zef.h_ramus_number_of_frames,'string'));
zef.inv_snr = zef.ramus_snr;
