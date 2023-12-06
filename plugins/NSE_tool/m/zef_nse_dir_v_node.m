h_axes = gca;
if isempty(findobj(allchild(h_axes),'Type','DataTip'))~=1
    h_datatip = findobj(allchild(h_axes),'Type','DataTip');
    zef.nse_field.dir_v_x = [];
    zef.nse_field.dir_v_y = [];
    zef.nse_field.dir_v_z = [];
    for i=1:size(h_datatip,1)
    zef.nse_field.dir_v_x = [zef.nse_field.dir_v_x h_datatip(i).X];
    zef.nse_field.dir_v_y = [zef.nse_field.dir_v_y h_datatip(i).Y];
    zef.nse_field.dir_v_z = [zef.nse_field.dir_v_z h_datatip(i).Z];
    end
    zef.nse_field.h_dir_v_x.Value = num2str(zef.nse_field.dir_v_x);
    zef.nse_field.h_dir_v_y.Value = num2str(zef.nse_field.dir_v_y);
    zef.nse_field.h_dir_v_z.Value = num2str(zef.nse_field.dir_v_z);

end
