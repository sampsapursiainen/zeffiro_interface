function zef_nse_plot_sphere(h_axes,nse_field)

axes(h_axes); 
hold_val = ishold(h_axes);
if not(hold_val)
    hold(h_axes,'on');
end

h_sphere = findobj(h_axes.Children,'Tag','nse_sphere');
delete(h_sphere);

[X,Y,Z]  = sphere(20);
h_surf = surf(nse_field.sphere_radius*X + nse_field.sphere_x, nse_field.sphere_radius*Y + nse_field.sphere_y, nse_field.sphere_radius*Z + nse_field.sphere_z); 

set(h_surf,'FaceColor',[0.5 0.5 0.5]);
set(h_surf,'EdgeColor','none');
set(h_surf,'FaceAlpha',0.5);
set(h_surf,'Tag','nse_sphere');

if not(hold_val)
hold(h_axes,'off');
end

end