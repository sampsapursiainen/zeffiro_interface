function zef = zef_parcellation_roi_pick_color(zef)

color_vec = uisetcolor;
if not(isequal(color_vec,0))
    color_str = num2str(color_vec);
    zef.h_parcellation_roi_color.String = color_str;
    zef.h_parcellation_roi_color.BackgroundColor = color_vec;
    zef.parcellation_roi_color(zef.parcellation_roi_selected,:) = color_vec;
end

end