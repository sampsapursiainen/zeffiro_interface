%Copyright © 2018, Sampsa Pursiainen
if  ismac
zef.h_butterfly_plot = open('zeffiro_interface_butterfly_plot.fig');
elseif ispc 
zef.h_butterfly_plot = open('zeffiro_interface_butterfly_plot.fig');
else
zef.h_butterfly_plot = open('zeffiro_interface_butterfly_plot.fig');
end
set(zef.h_butterfly_plot,'Name','ZEFFIRO Interface: Butterfly_plot');
zef_init_butterfly_plot;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_inv_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_inv_data_segment,'enable','off'); 
end
end
uistack(flipud([zef.h_inv_sampling_frequency ; zef.h_inv_low_cut_frequency ; 
    zef.h_inv_high_cut_frequency ; zef.h_inv_time_1 ; zef.h_inv_time_2; zef.h_inv_data_segment ; zef.h_inv_cancel ; 
    zef.h_inv_apply; zef.h_inv_plot  ]),'top'); 
