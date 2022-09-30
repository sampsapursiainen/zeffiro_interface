%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
    zef.inv_sampling_frequency = str2num(get(zef.h_bf_sampling_frequency,'string'));
    zef.inv_low_cut_frequency = str2num(get(zef.h_bf_low_cut_frequency,'string'));
    zef.inv_high_cut_frequency = str2num(get(zef.h_bf_high_cut_frequency,'string'));
    zef.inv_data_segment = str2num(get(zef.h_bf_data_segment,'string'));
    zef.inv_time_1 = str2num(get(zef.h_bf_time_1,'string'));
    zef.inv_time_2 = str2num(get(zef.h_bf_time_2,'string'));
    zef.inv_normalize_data = get(zef.h_bf_normalize_data ,'value');
