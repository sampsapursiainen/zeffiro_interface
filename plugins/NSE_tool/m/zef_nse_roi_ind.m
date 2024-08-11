function [roi_ind_1, roi_ind_2, roi_ind_3] = zef_nse_roi_ind(zef,nse_field)

roi_ind_1 = find(sqrt(sum((zef.source_positions - repmat([nse_field.roi_x nse_field.roi_y nse_field.roi_z],size(zef.source_positions,1),1)).^2,2))<= nse_field.roi_radius);
roi_ind_2 = setdiff(roi_ind_1, find(sqrt(sum((zef.source_positions - repmat([nse_field.roi_x nse_field.roi_y nse_field.roi_z],size(zef.source_positions,1),1)).^2,2))<= nse_field.roi_radius/2));
roi_ind_3 = find(sqrt(sum((zef.source_positions - repmat([nse_field.roi_x nse_field.roi_y nse_field.roi_z],size(zef.source_positions,1),1)).^2,2))<= nse_field.roi_radius/2);

end