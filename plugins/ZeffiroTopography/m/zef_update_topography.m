%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.top_regularization_parameter = str2num(get(zef.h_top_regularization_parameter,'string'));
    zef.top_sampling_frequency = str2num(get(zef.h_top_sampling_frequency,'string'));
    zef.top_low_cut_frequency = str2num(get(zef.h_top_low_cut_frequency,'string'));
    zef.top_high_cut_frequency = str2num(get(zef.h_top_high_cut_frequency,'string'));
    zef.top_data_segment = str2num(get(zef.h_top_data_segment,'string'));
    zef.top_time_1 = str2num(get(zef.h_top_time_1,'string'));
    zef.top_time_2 = str2num(get(zef.h_top_time_2,'string'));
    zef.top_time_3 = str2num(get(zef.h_top_time_3,'string'));
    zef.top_number_of_frames = str2num(get(zef.h_top_number_of_frames,'string'));
    zef.top_normalize_data = get(zef.h_top_normalize_data ,'value');
