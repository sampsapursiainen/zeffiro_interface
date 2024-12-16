function zef = zef_parcellation_roi_add(zef)

zef.parcellation_roi_selected = 1;
zef.parcellation_roi_center = [0 0 0; zef.parcellation_roi_center];
zef.parcellation_roi_radius = [10 zef.parcellation_roi_radius];
zef.parcellation_roi_color = [0.56078 0.91373 1; zef.parcellation_roi_color];
zef.parcellation_roi_name = [{'Used-defined ROI'} zef.parcellation_roi_name];
zef = zef_update_parcellation(zef);

end