function zef = zef_parcellation_roi_pick_center(zef)

if isempty(findobj(allchild(zef.h_axes1),'Type','DataTip'))~=1
    zef.h_datatip = findobj(allchild(zef.h_axes1),'Type','DataTip');
    zef.parcellation_roi_center(zef.parcellation_roi_selected,:) = [h_datatip(1).X h_datatip(1).Y h_datatip(1).Z];
    zef.h_parcellation_roi_center.String = num2str(zef.parcellation_roi_center(zef.parcellation_roi_selected,:));
end

end