%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if  ismac
zef.h_ias_map_estimation = open('ias_map_estimation.fig');
elseif ispc
zef.h_ias_map_estimation = open('ias_map_estimation.fig');
else
zef.h_ias_map_estimation = open('ias_map_estimation.fig');
end

set(zef.h_ias_map_estimation,'Position',[ 0.5764    0.2944    0.15    0.40]);

set(zef.h_ias_map_estimation,'Name','ZEFFIRO Interface: IAS MAP estimation');
set(findobj(zef.h_ias_map_estimation.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_ias_map_estimation.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_ias_start,'Callback','zef_update_ias; [zef.reconstruction, zef.reconstruction_information] = ias_iteration([]);');

zef_init_ias;

uistack(flipud([zef.h_ias_hyperprior ;
    zef.h_ias_snr ; zef.h_ias_n_map_iterations ;
    zef.h_ias_sampling_frequency ; zef.h_ias_low_cut_frequency ;
    zef.h_ias_high_cut_frequency ; zef.h_ias_time_1 ; zef.h_ias_time_2; zef.h_ias_number_of_frames; zef.h_ias_time_3 ; zef.h_ias_cancel ;
    zef.h_ias_apply; zef.h_ias_start  ]),'top');
