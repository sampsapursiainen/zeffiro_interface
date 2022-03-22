%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_exp_ias_map_estimation = open('exp_ias_map_estimation.fig');
elseif ispc
zef.h_exp_ias_map_estimation = open('exp_ias_map_estimation.fig');
else
zef.h_exp_ias_map_estimation = open('exp_ias_map_estimation.fig');
end
set(zef.h_exp_ias_map_estimation,'Name','ZEFFIRO Interface: IAS MAP estimation for EP');
set(findobj(zef.h_exp_ias_map_estimation.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_exp_ias_map_estimation.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_exp_ias;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_exp_ias_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_exp_ias_data_segment,'enable','off');
end
end
uistack(flipud([zef.h_exp_ias_beta ; zef.h_exp_ias_theta0;
    zef.h_exp_ias_snr ; zef.h_exp_ias_n_map_iterations ;
    zef.h_exp_ias_sampling_frequency ; zef.h_exp_ias_low_cut_frequency ;
    zef.h_exp_ias_high_cut_frequency ; zef.h_exp_ias_time_1 ; zef.h_exp_ias_time_2; zef.h_exp_ias_number_of_frames; zef.h_exp_ias_time_3; zef.h_exp_ias_data_segment ; zef.h_exp_ias_cancel ;
    zef.h_exp_ias_apply; zef.h_exp_ias_start  ]),'top');
