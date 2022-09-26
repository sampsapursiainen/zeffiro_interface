function [b_coord, det] = zef_volume_barycentric(nodes,tetra,p_ind,det)

b_coord = [];
I = [1 2 3 4];

if nargin == 2
    p_ind = []; 
end

if nargin > 2

if isequal(p_ind,4)
    I = [4 1 2 3];
end

if nargin < 4
    det = [];
end

p_val = [0 0 0 0];
p_val(p_ind) = 1;
p_val(1:3) = p_val(1:3);
p_val = p_val(ones(size(tetra,1),1),:);

end

if nargin == 2
[~,~,~,det] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3));    
else
if isempty(det)  
[x,y,z,det] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3),...
                           p_val(:,I(1:3)));
else
[x,y,z,det] = zef_3by3_solver(reshape(nodes(tetra(:,I(1:3)),1)-nodes(tetra(:,I([4 4 4])),1),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),2)-nodes(tetra(:,I([4 4 4])),2),size(tetra,1),3),...
                           reshape(nodes(tetra(:,I(1:3)),3)-nodes(tetra(:,I([4 4 4])),3),size(tetra,1),3),...
                           p_val(:,I(1:3)),det);
end 
b_coord = [x y z p_val(:,I(4))-x.*nodes(tetra(:,I(4)),1)-y.*nodes(tetra(:,I(4)),2)-z.*nodes(tetra(:,I(4)),3)];
end

end