%Copyright © 2018, Sampsa Pursiainen
zef.h_find_synthetic_gravity_data = open('find_synthetic_gravity_data.fig');

zef_init_find_synthetic_gravity_data;
uistack(flipud([zef.h_inv_roi_sphere_1;  zef.h_inv_roi_sphere_2;
zef.h_inv_roi_sphere_3; zef.h_inv_roi_sphere_4; zef.h_inv_roi_perturbation;
zef.h_inv_compute_data; zef.h_inv_plot_roi ]),'top');

zef.h_find_synthetic_gravity_data.Resize = 'on';
set(findobj(zef.h_find_synthetic_gravity_data.Children,'-property','FontSize'),'FontSize',zef.font_size);
set(zef.h_find_synthetic_gravity_data,'AutoResizeChildren','off');
zef.find_synthetic_gravity_data_relative_size = zef_get_relative_size(zef.h_find_synthetic_gravity_data);
set(zef.h_find_synthetic_gravity_data,'SizeChangedFcn','zef.find_synthetic_gravity_data_current_size = zef_change_size_function(zef.h_find_synthetic_gravity_data,zef.find_synthetic_gravity_data_current_size,zef.find_synthetic_gravity_data_relative_size);');
zef.find_synthetic_gravity_data_current_size = get(zef.h_find_synthetic_gravity_data,'Position');

zef.h_find_synthetic_gravity_data.Name = 'ZEFFIRO Interface: Find Synthetic Gravity Data';
