%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [iasroi_roi_sphere,h_roi_sphere] = zef_iasroi_plot_roi
h_iasroi_roi_sphere_1 = evalin('base','zef.h_iasroi_roi_sphere_1');
h_iasroi_roi_sphere_2 = evalin('base','zef.h_iasroi_roi_sphere_2');
h_iasroi_roi_sphere_3 = evalin('base','zef.h_iasroi_roi_sphere_3');
h_iasroi_roi_sphere_4 = evalin('base','zef.h_iasroi_roi_sphere_4');
iasroi_roi_sphere = str2num(get(h_iasroi_roi_sphere_1 ,'string'));
iasroi_roi_sphere = iasroi_roi_sphere(:);
iasroi_roi_sphere = [ iasroi_roi_sphere ...
reshape(str2num(get(h_iasroi_roi_sphere_2 ,'string')),size(iasroi_roi_sphere,1),size(iasroi_roi_sphere,2)) ...
reshape(str2num(get(h_iasroi_roi_sphere_3 ,'string')),size(iasroi_roi_sphere,1),size(iasroi_roi_sphere,2)) ...
reshape(str2num(get(h_iasroi_roi_sphere_4 ,'string')),size(iasroi_roi_sphere,1),size(iasroi_roi_sphere,2)) ...
];

[s_x,s_y,s_z] = sphere(100);
h_axes1 = evalin('base','zef.h_axes1');
hold(h_axes1,'on');
if isfield(evalin('base','zef'),'h_roi_sphere')
h_roi_sphere = evalin('base','zef.h_roi_sphere');
if ishandle(h_roi_sphere)
delete(h_roi_sphere);
end
end

h_roi_sphere = zeros(size(iasroi_roi_sphere,1),1);

for j = 1 : size(iasroi_roi_sphere,1)

s_x_2 = iasroi_roi_sphere(j,4)*s_x + iasroi_roi_sphere(j,1);
s_y_2 = iasroi_roi_sphere(j,4)*s_y + iasroi_roi_sphere(j,2);
s_z_2 = iasroi_roi_sphere(j,4)*s_z + iasroi_roi_sphere(j,3);

h_roi_sphere(j) = surf(h_axes1,s_x_2,s_y_2,s_z_2);
set(h_roi_sphere(j),'facealpha',0.6,'edgecolor','none','facecolor',[0.5 0.5 0.5]);

end

drawnow;
hold(h_axes1,'off');

end
