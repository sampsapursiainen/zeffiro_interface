%Copyright © 2018, Sampsa Pursiainen
if not(isfield(zef,'inv_sampling_frequency')); 
    zef.inv_sampling_frequency = 1025; 
end;
if not(isfield(zef,'inv_low_cut_frequency')); 
    zef.inv_low_cut_frequency = 7; 
end;
if not(isfield(zef,'inv_high_cut_frequency')); 
    zef.inv_high_cut_frequency = 9; 
end;
if not(isfield(zef,'inv_data_segment')); 
    zef.inv_data_segment = 1; 
end;
if not(isfield(zef,'normalize_data')); 
    zef.normalize_data = 1; 
end;

if not(isfield(zef,'inv_time_1')); 
    zef.inv_time_1 = 0; 
end;
if not(isfield(zef,'inv_time_2')); 
    zef.inv_time_2 = 0; 
end;


set(zef.h_inv_sampling_frequency ,'string',num2str(zef.inv_sampling_frequency));
set(zef.h_inv_low_cut_frequency ,'string',num2str(zef.inv_low_cut_frequency));
set(zef.h_inv_high_cut_frequency ,'string',num2str(zef.inv_high_cut_frequency));
set(zef.h_inv_data_segment ,'string',num2str(zef.inv_data_segment));
set(zef.h_normalize_data ,'value',zef.normalize_data);
set(zef.h_inv_time_1 ,'string',num2str(zef.inv_time_1));
set(zef.h_inv_time_2 ,'string',num2str(zef.inv_time_2));
