%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.bf_sampling_frequency = str2num(get(zef.h_bf_sampling_frequency,'string'));
zef.bf_low_cut_frequency = str2num(get(zef.h_bf_low_cut_frequency,'string'));
zef.bf_high_cut_frequency = str2num(get(zef.h_bf_high_cut_frequency,'string'));
zef.bf_data_segment = str2num(get(zef.h_bf_data_segment,'string'));
zef.bf_time_1 = str2num(get(zef.h_bf_time_1,'string'));
zef.bf_time_2 = str2num(get(zef.h_bf_time_2,'string'));
zef.bf_normalize_data = get(zef.h_bf_normalize_data ,'value');
