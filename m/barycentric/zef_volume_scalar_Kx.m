function [y, b_coord, volume] = zef_volume_scalar_Kx(nodes, tetra, h, x, u_field, b_coord, volume)

if nargin < 6
        [b_coord{1},det] = zef_volume_barycentric(nodes,tetra,1);
        for i = 2 : 4
            [b_coord{i}] = zef_volume_barycentric(nodes,tetra,i,det);
        end
         volume = abs(det)/6;    
end

weight_param = zef_barycentric_weighting('FF');
y = zeros(size(nodes,1),1);

for i = 1 : 4     
    for j = 1 : 4  
        for k = 1 : 4
        if i == k
        entry_vec = weight_param(1).*x(tetra(:,j)).*u_field(tetra(:,k)).*b_coord{j}(:,h).*volume;
        else
        entry_vec = weight_param(2).*x(tetra(:,j)).*u_field(tetra(:,k)).*b_coord{j}(:,h).*volume;
        end
        
        y = y + accumarray(tetra(:,i),entry_vec,size(y));
        
        end
    end
end

end