%Copyright © 2018, Sampsa Pursiainen
    zef.inv_sampling_frequency = str2num(get(zef.h_inv_sampling_frequency,'string')); 
    zef.inv_low_cut_frequency = str2num(get(zef.h_inv_low_cut_frequency,'string')); 
    zef.inv_high_cut_frequency = str2num(get(zef.h_inv_high_cut_frequency,'string')); 
    zef.inv_data_segment = str2num(get(zef.h_inv_data_segment,'string')); 
    zef.inv_time_1 = str2num(get(zef.h_inv_time_1,'string')); 
    zef.inv_time_2 = str2num(get(zef.h_inv_time_2,'string')); 
    zef.normalize_data = get(zef.h_normalize_data ,'value');