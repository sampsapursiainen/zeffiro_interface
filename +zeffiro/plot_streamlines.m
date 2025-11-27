figure;
hold on;

for k = 1:length(dti_streamlines)
    st = dti_streamlines{k};
    if size(st,1) < 2
        continue;
    end
    plot3(st(:,1), st(:,2), st(:,3), 'LineWidth', 1);
end

xlabel('x (voxel)');
ylabel('y (voxel)');
zlabel('z (voxel)');
axis equal tight;
view(3);
grid on;

hold off;