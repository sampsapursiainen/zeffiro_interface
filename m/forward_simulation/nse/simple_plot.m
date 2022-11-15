figure(100);
clf
surface_triangles = zef_surface_mesh(tetra);
u_amp = sqrt(u_1_plot.^2 + u_2_plot.^2 + u_3_plot.^2);
hold on;
for time_point_ind = 1 : size(u_1_plot,2)
    time_point_ind
    u_amp_aux = u_amp(:,time_point_ind);
plot_field = db(mean(u_amp_aux(surface_triangles),2));
if time_point_ind > 1
    delete(h_m)
end
h_m = trisurf(surface_triangles,nodes(:,1),nodes(:,2),nodes(:,3),plot_field);
view(-70,20)
colormap(turbo)
h_m.EdgeColor = 'none';
lighting phong
if time_point_ind == 1
    colorbar
    axis equal
h_a = gca; 
h_a.CLim = [-1000 0];
h_a.Visible = 'off';
camlight right
camlight headlight
end
pause;
end
hold off

figure(101);
clf
surface_triangles = zef_surface_mesh(tetra);
hold on;
for time_point_ind = 1 : size(u_1_plot,2)
time_point_ind
p_aux = p_plot(:,time_point_ind);
plot_field = db(mean(p_aux(surface_triangles),2));
if time_point_ind > 1
delete(h_m)
end
h_m = trisurf(surface_triangles,nodes(:,1),nodes(:,2),nodes(:,3),plot_field);
view(-70,20)
colormap(turbo)
h_m.EdgeColor = 'none';
lighting phong
pause(0.01);
if time_point_ind == 1
colorbar
axis equal
h_a = gca; 
h_a.CLim = [-1000 0];
h_a.Visible = 'off';
camlight right
camlight headlight
end
end
hold off