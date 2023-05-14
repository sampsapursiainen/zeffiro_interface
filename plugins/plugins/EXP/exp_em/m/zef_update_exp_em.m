%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
    zef.exp_em_q = get(zef.h_exp_em_q,'value');
    zef.exp_em_hyper_type = get(zef.h_exp_em_hyper_type,'value');
    zef.exp_em_beta = str2num(get(zef.h_exp_em_beta,'string'));
    zef.exp_em_theta0 = str2num(get(zef.h_exp_em_theta0,'string'));
    zef.inv_snr = str2num(get(zef.h_exp_em_snr,'string'));
    zef.inv_n_map_iterations = str2num(get(zef.h_exp_em_n_map_iterations,'string'));
    zef.inv_n_L1_iterations = str2num(get(zef.h_exp_em_n_L1_iterations,'string'));
    %zef.inv_pcg_tol = str2num(get(zef.h_exp_em_pcg_tol,'string'));
    zef.inv_sampling_frequency = str2num(get(zef.h_exp_em_sampling_frequency,'string'));
    zef.inv_low_cut_frequency = str2num(get(zef.h_exp_em_low_cut_frequency,'string'));
    zef.inv_high_cut_frequency = str2num(get(zef.h_exp_em_high_cut_frequency,'string'));
    zef.inv_data_segment = str2num(get(zef.h_exp_em_data_segment,'string'));
    zef.inv_time_1 = str2num(get(zef.h_exp_em_time_1,'string'));
    zef.inv_time_2 = str2num(get(zef.h_exp_em_time_2,'string'));
    zef.inv_time_3 = str2num(get(zef.h_exp_em_time_3,'string'));
    zef.number_of_frames = str2num(get(zef.h_exp_em_number_of_frames,'string'));
    zef.normalize_data = get(zef.h_exp_em_normalize_data ,'value');
