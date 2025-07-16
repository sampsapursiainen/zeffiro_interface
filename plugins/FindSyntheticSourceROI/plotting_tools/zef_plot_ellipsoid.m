function h_surf = zef_plot_ellipsoid(position,a,b,c,z,color)



h_axes = gca;
hold_state = ishold(h_axes);

if not(hold_state)
    hold on;
end

 %make sure z is column vector
z = z(:)/norm(z);

if isequal(abs(z),[0 0 1]')
    x = [1 0 0]';
else
    x = 1/sqrt(z(1)^2+z(2)^2)* [z(2) -z(1) 0]';
end

y = cross(z,x);


%rotation matrix
T_ellipsoid_to_lab = [x y z];
ellipsoid = T_ellipsoid_to_lab*[[a 0 0];[0 b 0];[0 0 c]]';


[X_0,Y_0,Z_0] = sphere(50);

Aux_arr = ellipsoid*[X_0(:) Y_0(:) Z_0(:)]';
X = reshape(Aux_arr(1,:),size(X_0));
Y = reshape(Aux_arr(2,:),size(Y_0));
Z = reshape(Aux_arr(3,:),size(Z_0));

h_surf = surf(h_axes,X+position(1),Y+position(2),Z+position(3));
set(h_surf,'edgecolor','none','facecolor',color,'facealpha','0.5');

if not(hold_state)
    hold off;
end

end
