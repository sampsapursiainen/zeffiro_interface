%Copyright © 2019- Sampsa Pursiainen & GPU-ToRRe Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre

function [nodes,triangles,interp_vec] = zef_triangular_mesh_refinement(nodes,triangles)

eps_val = 15;

n_nodes = size(nodes,1);
n_triangles = size(triangles,1);

nodes = [nodes;
         (1/2)*(nodes(triangles(:,1),:) + nodes(triangles(:,2),:));
         (1/2)*(nodes(triangles(:,2),:) + nodes(triangles(:,3),:));
         (1/2)*(nodes(triangles(:,3),:) + nodes(triangles(:,1),:))];

interp_vec = [1:n_triangles]';
interp_vec = interp_vec(:,[1 1 1 1]);
interp_vec = interp_vec(:);

t_aux_1 = triangles(:,1);
t_aux_2 = triangles(:,2);
t_aux_3 = triangles(:,3);
t_aux_4 = n_nodes+[1:n_triangles]';
t_aux_5 = n_nodes+n_triangles+[1:n_triangles]';
t_aux_6 = n_nodes+2*n_triangles+[1:n_triangles]';

triangles = [t_aux_1 t_aux_4 t_aux_6 ;
             t_aux_4 t_aux_2 t_aux_5 ;
             t_aux_5 t_aux_3 t_aux_6;
             t_aux_4 t_aux_5 t_aux_6];

[~, unique_vec_2, unique_vec_3] = unique(round(nodes,eps_val),'rows');
nodes = nodes(unique_vec_2,:);
triangles = unique_vec_3(triangles);

end