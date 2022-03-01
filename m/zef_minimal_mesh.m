function [nodes_new, triangles_new, nodes_ind, triangles_ind] = zef_minimal_mesh(nodes, triangles)

if size(triangles,1) >= 0.01*size(nodes,1)
triangles_new = triangles;
nodes_new = nodes;
nodes_ind = [1:size(nodes,1)]';
triangles_ind = [1:size(triangles,1)]';
else
[nodes_ind,~,triangles_ind] = unique(triangles);
nodes_new = nodes(nodes_ind,:);
triangles_new = reshape(triangles_ind, size(triangles));
end

end