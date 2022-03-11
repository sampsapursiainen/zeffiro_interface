function [faces, faces_count] = zef_validate_faces(tetra)

faces = [[sort(tetra(:,[2 4 3]),2) ones(size(tetra,1),1) [1:size(tetra,1)]'];
[sort(tetra(:,[1 3 4]),2) 2*ones(size(tetra,1),1)  [1:size(tetra,1)]'];
[sort(tetra(:,[1 4 2]),2) 3*ones(size(tetra,1),1)  [1:size(tetra,1)]'];
[sort(tetra(:,[1 2 3]),2) 4*ones(size(tetra,1),1)  [1:size(tetra,1)]']];

[faces_unique, faces_ind_1, faces_ind_2] = unique(faces(:,1:3),'rows');

faces = [faces_unique faces(faces_ind_1,4)];

faces_count = accumarray(faces_ind_2,ones(size(faces_ind_2,1),1),size(faces_ind_1));

end
