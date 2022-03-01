%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if ismac
zef.h_iasroi_map_estimation = open('ias_map_estimation_roi.fig');
elseif ispc
zef.h_iasroi_map_estimation = open('ias_map_estimation_roi.fig');
else
zef.h_iasroi_map_estimation = open('ias_map_estimation_roi.fig');
end
set(zef.h_iasroi_map_estimation,'Position',[ 0.5764    0.2944    0.15    0.50]);

set(zef.h_iasroi_map_estimation,'Name','ZEFFIRO Interface: IAS ROI MAP estimation');
set(findobj(zef.h_iasroi_map_estimation.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_iasroi_map_estimation.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_ias_roi;
uistack(flipud([zef.h_iasroi_roi_mode; zef.h_iasroi_roi_sphere_1;  zef.h_iasroi_roi_sphere_2;  zef.h_iasroi_roi_sphere_3;
zef.h_iasroi_roi_sphere_4;
zef.h_iasroi_roi_threshold; zef.h_iasroi_hyperprior;
    zef.h_iasroi_snr ; zef.h_iasroi_n_map_iterations ;
    zef.h_iasroi_sampling_frequency ; zef.h_iasroi_low_cut_frequency ;
    zef.h_iasroi_high_cut_frequency ; zef.h_iasroi_time_1 ; zef.h_iasroi_time_2;
    zef.h_iasroi_number_of_frames; zef.h_iasroi_time_3 ; zef.h_iasroi_cancel ;
    zef.h_iasroi_apply; zef.h_iasroi_start ; zef.h_iasroi_plot_source; zef.h_iasroi_rec_source_8;
    zef.h_iasroi_rec_source_9  ]),'top');
