%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'ias_hyperprior'));
    zef.ias_hyperprior = 1;
end;
if not(isfield(zef,'ias_n_map_iterations'));
    zef.ias_n_map_iterations = 25;
end;
if not(isfield(zef,'ias_pcg_tol'));
    zef.ias_pcg_tol = 1e-8;
end;

zef.ias_sampling_frequency = zef.inv_sampling_frequency;
zef.ias_low_cut_frequency = zef.inv_low_cut_frequency;
zef.ias_high_cut_frequency = zef.inv_high_cut_frequency;

if not(isfield(zef,'ias_normalize_data'));
    zef.ias_normalize_data = 1;
end;


    zef.ias_time_1 = zef.inv_time_1;
    zef.ias_time_2 = zef.inv_time_2;
    zef.ias_time_3 = zef.inv_time_3;
    zef.ias_number_of_frames = zef.number_of_frames;

if not(isfield(zef,'ias_data_segment'));
    zef.ias_data_segment = 1;
end;

zef.ias_snr = zef.inv_snr;

set(zef.h_ias_hyperprior ,'value',zef.ias_hyperprior);
set(zef.h_ias_snr ,'string',num2str(zef.ias_snr));
set(zef.h_ias_n_map_iterations ,'string',num2str(zef.ias_n_map_iterations));
set(zef.h_ias_sampling_frequency ,'string',num2str(zef.ias_sampling_frequency));
set(zef.h_ias_low_cut_frequency ,'string',num2str(zef.ias_low_cut_frequency));
set(zef.h_ias_high_cut_frequency ,'string',num2str(zef.ias_high_cut_frequency));
set(zef.h_ias_normalize_data ,'value',zef.ias_normalize_data);
set(zef.h_ias_time_1 ,'string',num2str(zef.ias_time_1));
set(zef.h_ias_time_2 ,'string',num2str(zef.ias_time_2));
set(zef.h_ias_time_3 ,'string',num2str(zef.ias_time_3));
set(zef.h_ias_number_of_frames ,'string',num2str(zef.ias_number_of_frames));
