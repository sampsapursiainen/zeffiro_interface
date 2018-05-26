%Copyright © 2018, Sampsa Pursiainen
function [s_field_vec] = smooth_field(surface_triangles, field_vec, n_nodes, n_iter)

for i = 1 : n_iter
c_vec = zeros(n_nodes,1);
for j = 1 : 3
c_vec = c_vec + accumarray(surface_triangles(:,j),ones(size(surface_triangles,1),1),[n_nodes 1]);
end
end

s_field_vec = field_vec;
for i = 1 : n_iter
s_vec = zeros(n_nodes,1);
for j = 1 : 3
s_vec = s_vec + accumarray(surface_triangles(:,j),s_field_vec,[n_nodes 1]);
end
s_vec = s_vec./c_vec;
s_field_vec = (1/3)*(s_vec(surface_triangles(:,1)) + s_vec(surface_triangles(:,2)) + s_vec(surface_triangles(:,3)));
end
