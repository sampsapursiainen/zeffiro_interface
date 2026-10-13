%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_find_synthetic_source_ROI_window(zef)


zef_find_synthetic_source_ROI_app;
set(zef.h_find_synthetic_source_ROI,'Name','ZEFFIRO Interface: Find synthetic source ROI');
set(findobj(zef.h_find_synthetic_source_ROI.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_find_synthetic_source_ROI.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_fss_ROI;
uistack(flipud([zef.h_synth_source_ROI_style;zef.h_synth_source_ROI_radius;zef.h_synth_source_ROI_width; ...
    zef.h_synth_source_ROI_curvature;zef.h_synth_source_ROI_ori_settings;    zef.h_synth_source_ROI_ori_x; ...
    zef.h_synth_source_ROI_ori_y;zef.h_synth_source_ROI_ori_z;     zef.h_synth_source_ROI_x;  ...
    zef.h_synth_source_ROI_y;      zef.h_synth_source_ROI_z; zef.h_synth_source_ROI_dipOri_style; ...
    zef.h_synth_source_ROI_dipOri_x; zef.h_synth_source_ROI_dipOri_y;    zef.h_synth_source_ROI_dipOri_z; ...
    zef.h_synth_source_ROI_amp ;zef.h_synth_source_ROI_noise; ...
    zef.h_synth_source_ROI_plot_style ;zef.h_synth_source_ROI_color; zef.h_synth_source_ROI_length]),'top');

zef = zef_disable_box_ROIsource(zef);
end
