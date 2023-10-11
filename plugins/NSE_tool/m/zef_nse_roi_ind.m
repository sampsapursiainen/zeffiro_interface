function roi_ind = zef_nse_roi_ind(zef,nse_field)

roi_ind = find(sqrt(sum((zef.source_positions - repmat([nse_field.roi_x nse_field.roi_y nse_field.roi_z],size(zef.source_positions,1),1)).^2,2))<= nse_field.roi_radius);

end