%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_topography(zef)

if nargin == 0
zef = evalin('base','zef');
end

zef_topography_app;

set(zef.h_topography,'Name','ZEFFIRO Interface: Topography tool');
set(findobj(zef.h_topography.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_topography.Children,'-property','FontSize'),'FontSize',9);
zef_init_topography;
if isfield(zef,'measurements')
    if iscell(zef.measurements)
        set(zef.h_top_data_segment,'enable','on');
    end
    if not(iscell(zef.measurements))
        set(zef.h_top_data_segment,'enable','off');
    end
end
uistack(flipud([zef.h_top_regularization_parameter ; zef.h_top_sampling_frequency ; zef.h_top_low_cut_frequency ;
    zef.h_top_high_cut_frequency ; zef.h_top_time_1 ; zef.h_top_time_2; zef.h_top_number_of_frames; zef.h_top_time_3; zef.h_top_data_segment ; zef.h_top_cancel ; zef.h_top_normalize_data;
    zef.h_top_apply; zef.h_top_start  ]),'top');

if nargout == 0
assignin('base','zef',zef);
end

end