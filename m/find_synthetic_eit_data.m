%Copyright © 2018, Sampsa Pursiainen
if ismac
zef.h_find_synthetic_source = open('find_synthetic_eit_data_alt.fig');
elseif ispc
zef.h_find_synthetic_source = open('find_synthetic_eit_data_alt2.fig');
else
zef.h_find_synthetic_source = open('find_synthetic_eit_data.fig');
end
zef_init_find_synthetic_eit_data;
uistack(flipud([zef.h_inv_roi_sphere_1;  zef.h_inv_roi_sphere_2;  
zef.h_inv_roi_sphere_3; zef.h_inv_roi_sphere_4; zef.h_inv_roi_perturbation; 
zef.h_inv_compute_data; zef.h_inv_plot_roi ]),'top'); 
