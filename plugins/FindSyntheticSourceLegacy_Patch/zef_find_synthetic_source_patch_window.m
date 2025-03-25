%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_find_synthetic_source_patch_window(zef)


zef_find_synthetic_source_patch_app;
set(zef.h_find_synthetic_source_legacy,'Name','ZEFFIRO Interface: Find synthetic source');
set(findobj(zef.h_find_synthetic_source_legacy.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_find_synthetic_source_legacy.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_fss_patch;
uistack(flipud([zef.h_inv_synth_source_1;  zef.h_inv_synth_source_2;  zef.h_inv_synth_source_3;
    zef.h_inv_synth_source_4; zef.h_inv_synth_source_5;  zef.h_inv_synth_source_6; zef.h_inv_synth_source_7; zef.h_inv_synth_source_8;
    zef.h_inv_synth_source_9; zef.h_inv_synth_source_10;  zef.h_inv_synth_source_radius; zef.h_inv_synth_source_use_volume; zef.h_inv_synth_source_norm_ori; zef.h_inv_synth_source_plot_cones; zef.h_inv_synth_source_fix_amp;zef.h_inv_synth_source_VEP_config ]),'top');

end
