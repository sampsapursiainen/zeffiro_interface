%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_exp_em_map_estimation = open('exp_em_map_estimation.fig');
elseif ispc
zef.h_exp_em_map_estimation = open('exp_em_map_estimation.fig');
else
zef.h_exp_em_map_estimation = open('exp_em_map_estimation.fig');
end
set(zef.h_exp_em_map_estimation,'Name','ZEFFIRO Interface: EM MAP estimation');
set(findobj(zef.h_exp_em_map_estimation.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_exp_em_map_estimation.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_exp_em;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_exp_em_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_exp_em_data_segment,'enable','off');
end
end
uistack(flipud([zef.h_exp_em_beta ; zef.h_exp_em_theta0;
    zef.h_exp_em_snr ; zef.h_exp_em_n_map_iterations ; zef.h_exp_em_n_L1_iterations ;
    zef.h_exp_em_sampling_frequency ; zef.h_exp_em_low_cut_frequency ;
    zef.h_exp_em_high_cut_frequency ; zef.h_exp_em_time_1 ; zef.h_exp_em_time_2; zef.h_exp_em_number_of_frames; zef.h_exp_em_time_3; zef.h_exp_em_data_segment ; zef.h_exp_em_cancel ;
    zef.h_exp_em_apply; zef.h_exp_em_start  ]),'top');