function [y_1, y_2, y_3, b_coord, volume] = zef_volume_scalar_uFG(nodes, tetra, h, x_1, x_2, x_3, u_field, scalar_field, b_coord, volume)

if nargin < 9
         b_coord = zeros(size(tetra,1),size(tetra,2),4);
        [b_coord(:,:,1),det] = zef_volume_barycentric(nodes,tetra,1);
        for i = 2 : 4
        [b_coord(:,:,i)] = zef_volume_barycentric(nodes,tetra,i,det);
        end
         volume = abs(det)/6;    
end

weight_param = zef_barycentric_weighting('uFG');
y_1 = zeros(size(nodes,1),1);
y_2 = zeros(size(nodes,1),1);
y_3 = zeros(size(nodes,1),1);

for i = 1 : 4     
    for j = 1 : 4  
        for k = 1 : 4
        if i == k
        aux_vec = weight_param(1).*u_field(tetra(:,k)).*b_coord(:,h,j).*scalar_field.*volume;
        entry_vec_1 = x_1(tetra(:,j)).*aux_vec;
        entry_vec_2 = x_2(tetra(:,j)).*aux_vec;
        entry_vec_3 = x_3(tetra(:,j)).*aux_vec;
        else
        aux_vec = weight_param(2).*u_field(tetra(:,k)).*b_coord(:,h,j).*scalar_field.*volume;
        entry_vec_1 = x_1(tetra(:,j)).*aux_vec;
        entry_vec_2 = x_2(tetra(:,j)).*aux_vec;
        entry_vec_3 = x_3(tetra(:,j)).*aux_vec;
        end
        
        y_1 = y_1 + accumarray(tetra(:,i),entry_vec_1,size(y_1));
        y_2 = y_2 + accumarray(tetra(:,i),entry_vec_2,size(y_2));
        y_3 = y_3 + accumarray(tetra(:,i),entry_vec_3,size(y_3));
        
        end
    end
end

end