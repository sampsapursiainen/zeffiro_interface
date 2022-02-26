%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_zef_mne_tool = open('zef_mne_tool.fig');
elseif ispc
zef.h_zef_mne_tool = open('zef_mne_tool.fig');
else
zef.h_zef_mne_tool = open('zef_mne_tool.fig');
end
set(zef.h_zef_mne_tool,'Name','ZEFFIRO Interface: Minimum norm estimate tool');
set(findobj(zef.h_zef_mne_tool.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zef_mne_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_mne;

uistack(flipud([zef.h_mne_type ; zef.h_mne_prior;
    zef.h_mne_sampling_frequency ; zef.h_mne_low_cut_frequency ;
    zef.h_mne_high_cut_frequency ; zef.h_mne_time_1 ; zef.h_mne_time_2; zef.h_mne_number_of_frames; zef.h_mne_time_3 ; zef.h_mne_cancel ;
    zef.h_mne_apply; zef.h_mne_start  ]),'top');
