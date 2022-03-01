%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if ismac
zef.h_find_synthetic_source = open('find_synthetic_eit_data.fig');
elseif ispc
zef.h_find_synthetic_source = open('find_synthetic_eit_data.fig');
else
zef.h_find_synthetic_source = open('find_synthetic_eit_data.fig');
end
set(zef.h_find_synthetic_source,'Name','ZEFFIRO Interface: Find synthetic EIT data');
set(findobj(zef.h_find_synthetic_source.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_find_synthetic_source.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_init_find_synthetic_eit_data;
uistack(flipud([zef.h_inv_roi_sphere_1;  zef.h_inv_roi_sphere_2;
zef.h_inv_roi_sphere_3; zef.h_inv_roi_sphere_4; zef.h_inv_roi_perturbation;
zef.h_inv_compute_data; zef.h_inv_plot_roi ]),'top');
