L_1 = zef.L;
source_positions = zef.source_positions;

[dof_ind, dof_count, dof_positions] = zef_decompose_soure_space(source_count, zef.source_positions);

M = size(L_1,1);
N = size(dof_positions,1);
L_2 = zeros(M,N);

K = size(source_positions,1);

    for i = 1 : K
        L_2(:,3*(dof_ind(i)-1)+1) =  L(:,3*(dof_ind(i)-1)+1) + L_1(:,i);
        L_2(:,3*(dof_ind(i)-1)+2) =  L(:,3*(dof_ind(i)-1)+2) + L_1(:,i+1);
        L_2(:,3*(dof_ind(i)-1)+3) =  L_tes(:,3*(dof_ind(i)-1)+3) + L_1(:,i+2);
    end

    for i = 1 : M
        L(:,3*(i-1)+1) = L(:,3*(i-1)+1)/dof_count(i);
        L(:,3*(i-1)+2) = L(:,3*(i-1)+2)/dof_count(i);
        L(:,3*(i-1)+3) = L(:,3*(i-1)+3)/dof_count(i);
    end

