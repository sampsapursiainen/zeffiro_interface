function [d] = zef_distance_to_resection(points, mesh_points, mesh_edges)

d=nan(size(points,1),1);
inside_index=tetra_in_compartment(mesh_points, mesh_edges, points);
not_inside=setdiff(1:size(points, 1), inside_index);
d(inside_index)=0;
[~, d(not_inside)]=knnsearch(mesh_points, points(not_inside,:));

end

