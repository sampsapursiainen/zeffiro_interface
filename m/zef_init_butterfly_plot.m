%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'bf_sampling_frequency'));
    zef.bf_sampling_frequency = zef.inv_sampling_frequency;
end;
if not(isfield(zef,'bf_low_cut_frequency'));
    zef.bf_low_cut_frequency = zef.inv_low_cut_frequency;
end;
if not(isfield(zef,'bf_high_cut_frequency'));
    zef.bf_high_cut_frequency = zef.inv_high_cut_frequency;
end;
if not(isfield(zef,'bf_data_segment'));
    zef.bf_data_segment =  zef.inv_data_segment;
end;
if not(isfield(zef,'bf_normalize_data'));
    zef.bf_normalize_data = zef.normalize_data;
end;

if not(isfield(zef,'bf_time_1'));
    zef.bf_time_1 = zef.inv_time_1;
end;
if not(isfield(zef,'bf_time_2'));
    zef.bf_time_2 =zef.inv_time_2;
end;

set(zef.h_bf_sampling_frequency ,'string',num2str(zef.bf_sampling_frequency));
set(zef.h_bf_low_cut_frequency ,'string',num2str(zef.bf_low_cut_frequency));
set(zef.h_bf_high_cut_frequency ,'string',num2str(zef.bf_high_cut_frequency));
set(zef.h_bf_data_segment ,'string',num2str(zef.bf_data_segment));
set(zef.h_bf_normalize_data ,'value',zef.bf_normalize_data);
set(zef.h_bf_time_1 ,'string',num2str(zef.bf_time_1));
set(zef.h_bf_time_2 ,'string',num2str(zef.bf_time_2));
