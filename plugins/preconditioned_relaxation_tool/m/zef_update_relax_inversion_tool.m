%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.relax_iteration_type = get(zef.h_relax_iteration_type,'value');
zef.relax_preconditioner_type = get(zef.h_relax_preconditioner_type,'value');
zef.relax_db = str2num(get(zef.h_relax_db ,'value'));
zef.relax_tolerance = str2num(get(zef.h_relax_tolerance ,'value'));
    zef.relax_multires_n_levels = str2num(get(zef.h_relax_multires_n_levels,'value'));
    zef.relax_multires_sparsity = str2num(get(zef.h_relax_multires_sparsity,'value'));
    zef.relax_multires_n_decompositions = str2num(get(zef.h_relax_multires_n_decompositions,'value'));
    zef.relax_snr = str2num(get(zef.h_relax_snr,'value'));
    zef.relax_multires_n_iter = str2num(get(zef.h_relax_multires_n_iter,'value'));
    zef.relax_sampling_frequency = str2num(get(zef.h_relax_sampling_frequency,'value'));
    zef.relax_low_cut_frequency = str2num(get(zef.h_relax_low_cut_frequency,'value'));
    zef.relax_high_cut_frequency = str2num(get(zef.h_relax_high_cut_frequency,'value'));
    zef.relax_time_1 = str2num(get(zef.h_relax_time_1,'value'));
    zef.relax_time_2 = str2num(get(zef.h_relax_time_2,'value'));
    zef.relax_time_3 = str2num(get(zef.h_relax_time_3,'value'));
    zef.relax_number_of_frames = str2num(get(zef.h_relax_number_of_frames,'value'));
    zef.relax_normalize_data = get(zef.h_relax_normalize_data ,'value');
    zef.relax_initial_guess_mode = get(zef.h_relax_normalize_data ,'value');
    zef.inv_time_1 = str2num(get(zef.h_relax_time_1,'value'));
    zef.inv_time_2 = str2num(get(zef.h_relax_time_2,'value'));
    zef.inv_time_3 = str2num(get(zef.h_relax_time_3,'value'));
    zef.inv_sampling_frequency = str2num(get(zef.h_relax_sampling_frequency,'value'));
    zef.inv_low_cut_frequency = str2num(get(zef.h_relax_low_cut_frequency,'value'));
    zef.inv_high_cut_frequency = str2num(get(zef.h_relax_high_cut_frequency,'value'));
    zef.number_of_frames = str2num(get(zef.h_relax_number_of_frames,'value'));
    zef.inv_snr = zef.relax_snr;
