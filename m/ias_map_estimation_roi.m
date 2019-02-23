%Copyright © 2018, Sampsa Pursiainen
if ismac
zef.h_ias_map_estimation = open('ias_map_estimation_roi.fig');
elseif ispc
zef.h_ias_map_estimation = open('ias_map_estimation_roi.fig');
else
zef.h_ias_map_estimation = open('ias_map_estimation_roi.fig');    
end
set(zef.h_ias_map_estimation,'Name','ZEFFIRO Interface: IAS MAP estimation ROI');
zef_init_ias_roi;
if isfield(zef,'measurements')
if iscell(zef.measurements)
    set(zef.h_inv_data_segment,'enable','on');
end
if not(iscell(zef.measurements))
    set(zef.h_inv_data_segment,'enable','off'); 
end
end
uistack(flipud([zef.h_inv_roi_mode; zef.h_inv_roi_sphere_1;  zef.h_inv_roi_sphere_2;  zef.h_inv_roi_sphere_3;  
zef.h_inv_roi_sphere_4; 
zef.h_inv_roi_threshold; zef.h_inv_hyperprior ; zef.h_inv_beta ; zef.h_inv_theta0; 
    zef.h_inv_likelihood_std ; zef.h_inv_n_map_iterations ; 
    zef.h_inv_sampling_frequency ; zef.h_inv_low_cut_frequency ; 
    zef.h_inv_high_cut_frequency ; zef.h_inv_time_1 ; zef.h_inv_time_2; 
    zef.h_number_of_frames; zef.h_inv_time_3; zef.h_inv_data_segment ; zef.h_inv_cancel ; 
    zef.h_inv_apply; zef.h_inv_start ; zef.h_inv_plot_source; zef.h_inv_rec_source_8; 
    zef.h_inv_rec_source_9  ]),'top'); 
