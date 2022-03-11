function [nodes, triangles] = zef_triangulate_surface(X, Y, Z, varargin)

max_faces = 0;
if not(isempty(varargin))
    max_faces = varargin{1};
end

patch_data = surf2patch(X,Y,Z,'triangles');
if max_faces > 0
    patch_data = reducepatch(patch_data,max_faces);
end
nodes = patch_data.vertices;
triangles = patch_data.faces;

end
