%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
    zef.exp_ias_q = get(zef.h_exp_ias_q,'value');
    zef.exp_ias_hyper_type = get(zef.h_exp_ias_hyper_type,'value');
    zef.exp_ias_beta = str2num(get(zef.h_exp_ias_beta,'string'));
    zef.exp_ias_theta0 = str2num(get(zef.h_exp_ias_theta0,'string'));
    zef.inv_snr = str2num(get(zef.h_exp_ias_snr,'string'));
    zef.inv_n_map_iterations = str2num(get(zef.h_exp_ias_n_map_iterations,'string'));
    zef.inv_n_L1_iterations = str2num(get(zef.h_exp_ias_n_L1_iterations,'string'));
    %zef.inv_pcg_tol = str2num(get(zef.h_exp_ias_pcg_tol,'string'));
    zef.inv_sampling_frequency = str2num(get(zef.h_exp_ias_sampling_frequency,'string'));
    zef.inv_low_cut_frequency = str2num(get(zef.h_exp_ias_low_cut_frequency,'string'));
    zef.inv_high_cut_frequency = str2num(get(zef.h_exp_ias_high_cut_frequency,'string'));
    zef.inv_data_segment = str2num(get(zef.h_exp_ias_data_segment,'string'));
    zef.inv_time_1 = str2num(get(zef.h_exp_ias_time_1,'string'));
    zef.inv_time_2 = str2num(get(zef.h_exp_ias_time_2,'string'));
    zef.inv_time_3 = str2num(get(zef.h_exp_ias_time_3,'string'));
    zef.number_of_frames = str2num(get(zef.h_exp_ias_number_of_frames,'string'));
    zef.normalize_data = get(zef.h_exp_ias_normalize_data ,'value');