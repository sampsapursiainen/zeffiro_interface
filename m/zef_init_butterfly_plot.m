%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'bf_sampling_frequency')); 
    zef.bf_sampling_frequency = 1025; 
end;
if not(isfield(zef,'bf_low_cut_frequency')); 
    zef.bf_low_cut_frequency = 7; 
end;
if not(isfield(zef,'bf_high_cut_frequency')); 
    zef.bf_high_cut_frequency = 9; 
end;
if not(isfield(zef,'bf_data_segment')); 
    zef.bf_data_segment = 1; 
end;
if not(isfield(zef,'normalize_data')); 
    zef.normalize_data = 1; 
end;

if not(isfield(zef,'bf_time_1')); 
    zef.bf_time_1 = 0; 
end;
if not(isfield(zef,'bf_time_2')); 
    zef.bf_time_2 = 0; 
end;


set(zef.h_bf_sampling_frequency ,'string',num2str(zef.bf_sampling_frequency));
set(zef.h_bf_low_cut_frequency ,'string',num2str(zef.bf_low_cut_frequency));
set(zef.h_bf_high_cut_frequency ,'string',num2str(zef.bf_high_cut_frequency));
set(zef.h_bf_data_segment ,'string',num2str(zef.bf_data_segment));
set(zef.h_normalize_data ,'value',zef.normalize_data);
set(zef.h_bf_time_1 ,'string',num2str(zef.bf_time_1));
set(zef.h_bf_time_2 ,'string',num2str(zef.bf_time_2));
