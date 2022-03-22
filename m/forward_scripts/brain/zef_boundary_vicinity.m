function [vicinity_set] = zef_boundary_vicinity(tetrahedra,nodes,sub_ind,vicinity_distance)

tetrahedra = tetrahedra(sub_ind,:);

[b_t, b_n] = zef_surface_mesh(tetrahedra,nodes);

t_c = 0.25*(nodes(tetrahedra(:,1),:)+nodes(tetrahedra(:,2),:)+nodes(tetrahedra(:,3),:)+nodes(tetrahedra(:,4),:));

MdlKDT = KDTreeSearcher(b_n);
nearest_point = knnsearch(MdlKDT,t_c,'K',1);

nearest_distance = sqrt(sum((b_n(nearest_point,:) - t_c).^2,2));
vicinity_set = find(nearest_distance <= vicinity_distance);

vininity_set = sub_ind(vicinity_set);

end