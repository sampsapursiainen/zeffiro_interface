if isempty(findobj(allchild(zef.h_axes1),'Type','DataTip'))~=1
    zef.h_datatip = findobj(allchild(zef.h_axes1),'Type','DataTip');
    zef.nse_field.roi_x = [];
    zef.nse_field.roi_y = [];
    zef.nse_field.roi_z = [];
    for i=1:size(zef.h_datatip,1)
    zef.nse_field.roi_x = [zef.nse_field.roi_x h_datatip(i).X];
    zef.nse_field.roi_y = [zef.nse_field.roi_y h_datatip(i).Y];
    zef.nse_field.roi_z = [zef.nse_field.roi_z h_datatip(i).Z];
    end
    zef.nse_field.h_roi_x.Value = num2str(zef.nse_field.roi_x);
    zef.nse_field.h_roi_y.Value = num2str(zef.nse_field.roi_y);
    zef.nse_field.h_roi_z.Value = num2str(zef.nse_field.roi_z);

end

