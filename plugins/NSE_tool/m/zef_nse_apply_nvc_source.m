
h_axes = gca;
if isempty(findobj(allchild(h_axes),'Type','DataTip'))~=1
    h_datatip = findobj(allchild(h_axes),'Type','DataTip');
    zef.nse_field.nvc_source_x = [];
    zef.nse_field.nvc_source_y = [];
    zef.nse_field.nvc_source_z = [];
    for i=1:size(h_datatip)
    zef.nse_field.nvc_source_x = [zef.nse_field.nvc_source_x h_datatip(i).X];
    zef.nse_field.nvc_source_y = [zef.nse_field.nvc_source_y h_datatip(i).Y];
    zef.nse_field.nvc_source_z = [zef.nse_field.nvc_source_z h_datatip(i).Z];
    end
    zef.nse_field.h_nvc_source_x.Value = num2str(zef.nse_field.nvc_source_x);
    zef.nse_field.h_nvc_source_y.Value = num2str(zef.nse_field.nvc_source_y);
    zef.nse_field.h_nvc_source_z.Value = num2str(zef.nse_field.nvc_source_z);

end
