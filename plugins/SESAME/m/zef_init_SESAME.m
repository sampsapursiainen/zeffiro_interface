%Copyright © 2018- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'SESAME_n_sampler'));
    zef.SESAME_n_sampler = [10];
end;
if not(isfield(zef,'SESAME_snr'));
    zef.SESAME_snr = 40;
end;
if not(isfield(zef,'SESAME_pcg_tol'));
    zef.SESAME_pcg_tol = 1e-8;
end;
if not(isfield(zef,'SESAME_sampling_frequency'));
    zef.SESAME_sampling_frequency = 1025;
end;
if not(isfield(zef,'SESAME_low_cut_frequency'));
    zef.SESAME_low_cut_frequency = 7;
end;
if not(isfield(zef,'SESAME_high_cut_frequency'));
    zef.SESAME_high_cut_frequency = 9;
end;
if not(isfield(zef,'SESAME_data_segment'));
    zef.SESAME_data_segment = 1;
end;
if not(isfield(zef,'SESAME_normalize_data'));
    zef.SESAME_normalize_data = 1;
end;

if not(isfield(zef,'SESAME_time_1'));
    zef.SESAME_time_1 = 0;
end;
if not(isfield(zef,'SESAME_time_2'));
    zef.SESAME_time_2 = 0;
end;
if not(isfield(zef,'SESAME_time_3'));
    zef.SESAME_time_3 = 0;
end;
if not(isfield(zef,'SESAME_number_of_frames'));
    zef.SESAME_number_of_frames = 1;
end;
if not(isfield(zef,'inv_rec_source'))
    zef.inv_rec_source = zeros(1,9);
    zef.inv_rec_source(1,8) = 3;
    zef.inv_rec_source(1,9) = 1;
end

set(zef.SESAME_App.h_SESAME_snr ,'value',num2str(zef.SESAME_snr));
set(zef.SESAME_App.h_SESAME_n_sampler ,'value',num2str(zef.SESAME_n_sampler));
set(zef.SESAME_App.h_SESAME_sampling_frequency ,'value',num2str(zef.SESAME_sampling_frequency));
set(zef.SESAME_App.h_SESAME_low_cut_frequency ,'value',num2str(zef.SESAME_low_cut_frequency));
set(zef.SESAME_App.h_SESAME_high_cut_frequency ,'value',num2str(zef.SESAME_high_cut_frequency));
set(zef.SESAME_App.h_SESAME_data_segment ,'value',num2str(zef.SESAME_data_segment));
zef.SESAME_App.h_SESAME_normalize_data.Value = zef.SESAME_App.h_SESAME_normalize_data.ItemsData{zef.SESAME_normalize_data};
set(zef.SESAME_App.h_SESAME_time_1 ,'value',num2str(zef.SESAME_time_1));
set(zef.SESAME_App.h_SESAME_time_2 ,'value',num2str(zef.SESAME_time_2));
set(zef.SESAME_App.h_SESAME_time_3 ,'value',num2str(zef.SESAME_time_3));
set(zef.SESAME_App.h_SESAME_number_of_frames ,'value',num2str(zef.SESAME_number_of_frames));
zef.SESAME_App.h_inv_rec_source_8.Value = num2str(zef.inv_rec_source(1,8));
zef.SESAME_App.h_inv_rec_source_9.Value = zef.SESAME_App.h_inv_rec_source_9.ItemsData{zef.inv_rec_source(1,9)};
