function [d] = zef_distance_to_resection(points, mesh_points, mesh_triangles)

if nargin == 2
    [~, d]=knnsearch(mesh_points, points);
else
d=nan(size(points,1),1);
inside_index=zef_tetra_in_compartment(mesh_points, mesh_triangles, points);
not_inside=setdiff(1:size(points, 1), inside_index);
d(inside_index)=0;
[~, d(not_inside)]=knnsearch(mesh_points, points(not_inside,:));
end

end
