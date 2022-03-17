%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'top_regularization_parameter'));
    zef.top_regularization_parameter = 5;
end;

if not(isfield(zef,'top_sampling_frequency'));
    zef.top_sampling_frequency = zef.inv_sampling_frequency;
end;
if not(isfield(zef,'top_low_cut_frequency'));
    zef.top_low_cut_frequency = zef.inv_low_cut_frequency;
end;
if not(isfield(zef,'top_high_cut_frequency'));
    zef.top_high_cut_frequency = zef.inv_high_cut_frequency ;
end;
if not(isfield(zef,'top_data_segment'));
    zef.top_data_segment = zef.inv_data_segment;
end;
if not(isfield(zef,'top_normalize_data'));
    zef.top_normalize_data = 1;
end;

if not(isfield(zef,'top_time_1'));
    zef.top_time_1 = 0;
end;
if not(isfield(zef,'top_time_2'));
    zef.top_time_2 = 0;
end;
if not(isfield(zef,'top_time_3'));
    zef.top_time_3 = 0;
end;
if not(isfield(zef,'top_number_of_frames'));
    zef.top_number_of_frames = 1;
end;

% set(zef.h_top_pcg_tol ,'string',num2str(zef.top_pcg_tol));
set(zef.h_top_regularization_parameter ,'string',num2str(zef.top_regularization_parameter));
set(zef.h_top_sampling_frequency ,'string',num2str(zef.top_sampling_frequency));
set(zef.h_top_low_cut_frequency ,'string',num2str(zef.top_low_cut_frequency));
set(zef.h_top_high_cut_frequency ,'string',num2str(zef.top_high_cut_frequency));
set(zef.h_top_data_segment ,'string',num2str(zef.top_data_segment));
set(zef.h_top_normalize_data ,'value',zef.top_normalize_data);
set(zef.h_top_time_1 ,'string',num2str(zef.top_time_1));
set(zef.h_top_time_2 ,'string',num2str(zef.top_time_2));
set(zef.h_top_time_3 ,'string',num2str(zef.top_time_3));
set(zef.h_top_number_of_frames ,'string',num2str(zef.top_number_of_frames));
