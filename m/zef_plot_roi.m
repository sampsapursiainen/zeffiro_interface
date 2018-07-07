%Copyright © 2018, Sampsa Pursiainen
zef.inv_roi_sphere = str2num(get(zef.h_inv_roi_sphere_1 ,'string')); 
zef.inv_roi_sphere = zef.inv_roi_sphere(:);
zef.inv_roi_sphere = [ zef.inv_roi_sphere ...
reshape(str2num(get(zef.h_inv_roi_sphere_2 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
reshape(str2num(get(zef.h_inv_roi_sphere_3 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
reshape(str2num(get(zef.h_inv_roi_sphere_4 ,'string')),size(zef.inv_roi_sphere,1),size(zef.inv_roi_sphere,2)) ...
];

[zef.s_x,zef.s_y,zef.s_z] = sphere(100);
hold(zef.h_axes1,'on');
if isfield(zef,'h_roi_sphere')
delete(zef.h_roi_sphere);
end

for j = 1 : size(zef.inv_roi_sphere,1)

zef.s_x_2 = zef.inv_roi_sphere(j,4)*zef.s_x + zef.inv_roi_sphere(j,1);
zef.s_y_2 = zef.inv_roi_sphere(j,4)*zef.s_y + zef.inv_roi_sphere(j,2);
zef.s_z_2 = zef.inv_roi_sphere(j,4)*zef.s_z + zef.inv_roi_sphere(j,3);

zef.h_roi_sphere(j) = surf(zef.h_axes1,zef.s_x_2,zef.s_y_2,zef.s_z_2);
set(zef.h_roi_sphere(j),'facealpha',0.6,'edgecolor','none','facecolor',[0.5 0.5 0.5]);

end


drawnow;
hold(zef.h_axes1,'off');
