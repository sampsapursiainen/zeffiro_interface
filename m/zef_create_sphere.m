function [nodes, triangles] = zef_create_sphere(radius, centre_point, n_faces)

warning off;
[x, y, z] = sphere(ceil(sqrt(8*n_faces)));
tr = delaunayTriangulation([x(:) y(:) z(:)]);
fe = freeBoundary(tr);
p = reducepatch(patch('Faces',fe,'Vertices',tr.Points),4*n_faces);
p = reducepatch(patch('Faces',p.faces,'Vertices',p.vertices),2*n_faces);
p = reducepatch(patch('Faces',p.faces,'Vertices',p.vertices),n_faces);
warning on;
nodes = p.vertices;
triangles = p.faces;

nodes(:,1) = radius*nodes(:,1) + centre_point(1);
nodes(:,2) = radius*nodes(:,2) + centre_point(2);
nodes(:,3) = radius*nodes(:,3) + centre_point(3);

end
