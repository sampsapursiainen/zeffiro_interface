function h_surf = zef_plot_sphere(position,radius,color)



h_axes = gca;
hold_state = ishold(h_axes);

if not(hold_state)
    hold on;
end

[X,Y,Z] = sphere;
X = X*radius;
Y = Y*radius;
Z = Z*radius;
h_surf = surf(h_axes,X+position(1),Y+position(2),Z+position(3));
set(h_surf,'edgecolor','none','facecolor',color,'facealpha','0.5');

if not(hold_state)
    hold off;
end

end
