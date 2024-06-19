function zef_nse_plot_roi(h_axes,zef,nse_field)

if nargin == 0
    h_axes = evalin('base','gca');
    zef = evalin('base','zef');
    nse_field = zef.nse_field;
end

axes(h_axes); 
hold_val = ishold(h_axes);
if not(hold_val)
    hold(h_axes,'on');
end

h_sphere = findobj(h_axes.Children,'Tag','additional: nse_sphere');
delete(h_sphere);

h_arrow = findobj(h_axes.Children,'Tag','additional: mean velocity in roi');
delete(h_arrow);

[X,Y,Z]  = sphere(100);

h_surf = surf(nse_field.roi_radius*X + nse_field.roi_x, nse_field.roi_radius*Y + nse_field.roi_y, nse_field.roi_radius*Z + nse_field.roi_z); 


if and(not(isempty(nse_field.bv_vessels_1)),ismember(nse_field.reconstruction_type,nse_field.reconstruction_type_list{1}))
[~,dir_vec] = zef_nse_mean_velocity_roi(zef,nse_field);
h_arrow = zef_plot_3D_arrow(nse_field.roi_x,nse_field.roi_y,nse_field.roi_z,-dir_vec(1),-dir_vec(2),-dir_vec(3),2.*nse_field.roi_radius,2,'r');
set(h_arrow,'Tag','additional: mean velocity in roi');
end

set(h_surf,'FaceColor',[0.5 0.5 0.5]);
set(h_surf,'EdgeColor','none');
set(h_surf,'FaceAlpha',0.5);
set(h_surf,'Tag','additional: nse_sphere');


if not(hold_val)
hold(h_axes,'off');
end

end