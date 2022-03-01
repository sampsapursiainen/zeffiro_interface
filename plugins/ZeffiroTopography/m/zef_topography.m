%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_topography= open('zeffiro_interface_topography.fig');
elseif ispc
zef.h_topography= open('zeffiro_interface_topography.fig');
else
zef.h_topography = open('zeffiro_interface_topography.fig');
end
set(zef.h_topography,'Name','ZEFFIRO Interface: Topography tool');
set(findobj(zef.h_topography.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_topography.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_topography;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_top_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_top_data_segment,'enable','off');
end
end
uistack(flipud([ zef.h_top_sampling_frequency ; zef.h_top_low_cut_frequency ;
    zef.h_top_high_cut_frequency ; zef.h_top_time_1 ; zef.h_top_time_2; zef.h_top_number_of_frames; zef.h_top_time_3; zef.h_top_data_segment ; zef.h_top_normalize_data ; zef.h_top_cancel ;
    zef.h_top_apply; zef.h_top_start  ]),'top');
