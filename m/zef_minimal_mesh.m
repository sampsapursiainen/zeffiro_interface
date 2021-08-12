function [nodes_new, triangles_new] = zef_minimal_mesh(nodes, triangles)

if size(triangles,1) >= 0.01*size(nodes,1)
triangles_new = triangles;
nodes_new = nodes;
else
[nodes_new,~,triangles_new] = unique(triangles); 
nodes_new = nodes(nodes_new,:);
triangles_new = reshape(triangles_new, size(triangles));
end

end