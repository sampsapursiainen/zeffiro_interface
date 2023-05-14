%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_exp_em_map_estimation_multires = open('exp_em_map_estimation_multires.fig');
elseif ispc
zef.h_exp_em_map_estimation_multires = open('exp_em_map_estimation_multires.fig');
else
zef.h_exp_em_map_estimation_multires = open('exp_em_map_estimation_multires.fig');
end
set(zef.h_exp_em_map_estimation_multires,'Name','ZEFFIRO Interface: EM MAP multiresolution (RAMUS) for EP');
set(findobj(zef.h_exp_em_map_estimation_multires.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_exp_em_map_estimation_multires.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_exp_em_multires;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_exp_em_multires_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_exp_em_multires_data_segment,'enable','off');
end
end
uistack(flipud([zef.h_exp_em_multires_n_levels; zef.h_exp_em_multires_sparsity; zef.h_exp_em_multires_q ; zef.h_exp_em_multires_beta ; zef.h_exp_em_multires_theta0;
    zef.h_exp_em_multires_snr ; zef.h_exp_em_multires_n_iter ; zef.h_exp_em_multires_n_L1_iterations ;
    zef.h_exp_em_multires_sampling_frequency ; zef.h_exp_em_multires_low_cut_frequency ;
    zef.h_exp_em_multires_high_cut_frequency ; zef.h_exp_em_multires_time_1 ; zef.h_exp_em_multires_time_2; zef.h_exp_em_multires_number_of_frames; zef.h_exp_em_multires_time_3; zef.h_exp_em_multires_data_segment ; zef.h_exp_em_multires_cancel ;
    zef.h_exp_em_multires_apply; zef.h_exp_em_multires_start  ]),'top');
