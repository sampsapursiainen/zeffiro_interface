function zef = zef_parcellation_roi_delete(zef)

I = [1 : size(zef.parcellation_roi_center,1)];
I = setdiff(I,zef.parcellation_roi_selected);
if not(isempty(I))
zef.parcellation_roi_center = zef.parcellation_roi_center(I,:);
zef.parcellation_roi_color = zef.parcellation_roi_color(I,:);
zef.parcellation_roi_radius = zef.parcellation_roi_radius(I);
zef.parcellation_roi_name = zef.parcellation_roi_name(I);
else
zef.parcellation_roi_center = [0 0 0];
zef.parcellation_roi_radius = [10];
zef.parcellation_roi_color = [0.56078 0.91373 1];
zef.parcellation_roi_name = [{'Used-defined ROI'}];
end
zef.parcellation_roi_selected = 1;
zef = zef_update_parcellation(zef);

end