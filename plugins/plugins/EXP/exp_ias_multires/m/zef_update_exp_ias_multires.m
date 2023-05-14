%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
    zef.exp_multires_n_levels = str2num(get(zef.h_exp_ias_multires_n_levels,'string'));
    zef.exp_multires_sparsity = str2num(get(zef.h_exp_ias_multires_sparsity,'string'));
    zef.exp_multires_n_decompositions = str2num(get(zef.h_exp_ias_multires_n_decompositions,'string'));
    zef.exp_ias_multires_q = get(zef.h_exp_ias_multires_q,'value');
    zef.exp_ias_multires_hyper_type = get(zef.h_exp_ias_multires_hyper_type,'value');
    zef.exp_ias_multires_beta = str2num(get(zef.h_exp_ias_multires_beta,'string'));
    zef.exp_ias_multires_theta0 = str2num(get(zef.h_exp_ias_multires_theta0,'string'));
    zef.inv_snr = str2num(get(zef.h_exp_ias_multires_snr,'string'));
    zef.exp_multires_n_iter = str2num(get(zef.h_exp_ias_multires_n_iter,'string'));
    zef.inv_n_L1_iterations = str2num(get(zef.h_exp_ias_multires_n_L1_iterations,'string'));
    zef.inv_sampling_frequency = str2num(get(zef.h_exp_ias_multires_sampling_frequency,'string'));
    zef.inv_low_cut_frequency = str2num(get(zef.h_exp_ias_multires_low_cut_frequency,'string'));
    zef.inv_high_cut_frequency = str2num(get(zef.h_exp_ias_multires_high_cut_frequency,'string'));
    zef.inv_data_segment = str2num(get(zef.h_exp_ias_multires_data_segment,'string'));
    zef.inv_time_1 = str2num(get(zef.h_exp_ias_multires_time_1,'string'));
    zef.inv_time_2 = str2num(get(zef.h_exp_ias_multires_time_2,'string'));
    zef.inv_time_3 = str2num(get(zef.h_exp_ias_multires_time_3,'string'));
    zef.number_of_frames = str2num(get(zef.h_exp_ias_multires_number_of_frames,'string'));
    zef.normalize_data = get(zef.h_exp_ias_multires_normalize_data ,'value');
