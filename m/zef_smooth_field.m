%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [s_field_vec] = zef_smooth_field(triangulation, field_vec, n_nodes, n_iter)

if or(isempty(n_nodes),isequal(n_nodes,0))
   n_nodes = max(triangulation,[],'all');
end
   
for i = 1 : n_iter
c_vec = zeros(n_nodes,1);
for j = 1 : size(triangulation,2)
c_vec = c_vec + accumarray(triangulation(:,j),ones(size(triangulation,1),1),[n_nodes 1]);
end
end

s_field_vec = field_vec;
for i = 1 : n_iter
s_vec = zeros(n_nodes,1);
for j = 1 : size(triangulation,2)
s_vec = s_vec + accumarray(triangulation(:,j),s_field_vec,[n_nodes 1]);
end
s_vec = s_vec./c_vec;
s_field_vec = 0;
for ell = 1 : size(triangulation,2)
s_field_vec = s_field_vec + (1/size(triangulation,2))*(s_vec(triangulation(:,ell)));
end
end

end
