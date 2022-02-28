%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef_find_synthetic_source_window_legacy;
set(zef.h_find_synthetic_source_legacy,'Name','ZEFFIRO Interface: Find synthetic source');
set(findobj(zef.h_find_synthetic_source_legacy.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_find_synthetic_source_legacy.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_fss_legacy;
uistack(flipud([zef.h_inv_synth_source_1;  zef.h_inv_synth_source_2;  zef.h_inv_synth_source_3;
zef.h_inv_synth_source_4; zef.h_inv_synth_source_5;  zef.h_inv_synth_source_6; zef.h_inv_synth_source_7; zef.h_inv_synth_source_8;
 zef.h_inv_synth_source_9; zef.h_inv_synth_source_10  ]),'top');
