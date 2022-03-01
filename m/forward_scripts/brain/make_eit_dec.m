%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [eit_ind,eit_count] = make_eit_dec(nodes,tetrahedra,brain_ind,source_ind)

h = waitbar(0,'Field decomposition');

center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
center_points = center_points';
source_points = center_points(:,source_ind);
center_points = center_points(:,brain_ind);

MdlKDT = KDTreeSearcher(source_points');
source_interpolation_aux = knnsearch(MdlKDT,center_points');

eit_ind = source_interpolation_aux;
[aux_vec, i_a, i_c] = unique(source_interpolation_aux);
eit_count = accumarray(i_c,1);

waitbar(1,h,'Field decomposition');

close(h);

end

