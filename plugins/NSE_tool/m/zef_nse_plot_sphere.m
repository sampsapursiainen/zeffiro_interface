function zef_nse_plot_sphere(h_axes,nse_field)

axes(h_axes); 
hold_val = ishold(h_axes);
if not(hold_val)
    hold(h_axes,'on');
end

h_sphere = findobj(h_axes.Children,'Tag','additional:nse_sphere');
delete(h_sphere);

[X,Y,Z]  = sphere(100);

for i = 1 : length(nse_field.sphere_radius)
h_surf = surf(nse_field.sphere_radius(i)*X + nse_field.sphere_x(i), nse_field.sphere_radius(i)*Y + nse_field.sphere_y(i), nse_field.sphere_radius(i)*Z + nse_field.sphere_z(i)); 

set(h_surf,'FaceColor',[0.5 0.5 0.5]);
set(h_surf,'EdgeColor','none');
set(h_surf,'FaceAlpha',1);
set(h_surf,'Tag','additional:nse_sphere');

end

if not(hold_val)
hold(h_axes,'off');
end

end