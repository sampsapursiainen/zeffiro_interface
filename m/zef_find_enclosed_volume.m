function volume_val = zef_find_enclosed_volume(nodes, triangles)

c_t = (1/3)*(nodes(triangles(:,1),:) + nodes(triangles(:,2),:) + nodes(triangles(:,3),:));
n_t = cross(nodes(triangles(:,3),:)'-nodes(triangles(:,1),:)', nodes(triangles(:,2),:)'-nodes(triangles(:,1),:)');
ala = sqrt(sum(n_t.^2))/2;
volume_val = abs((1/3)*sum(dot(c_t',n_t).*ala));

end
