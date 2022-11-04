%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

function [p] = B_prod(u,entry_ind,n,t,gpu_extended_memory)

u = gpuArray(single(u));
n = gpuArray(n);
t = gpuArray(t);

v_ind = gpuArray([1 2 3 4; 2 3 1 4; 3 4 1 2; 4 1 3 2]);

size_n = [size(n,1) 1];

if entry_ind == 1
entry_ind_vec = [2 3];
elseif entry_ind == 2
entry_ind_vec = [3 1];
elseif entry_ind == 3
entry_ind_vec = [1 2];
end

u = u/6;

for i = 1 : 4

%u_perm = u(t(:,i),:);

aux_vec = n(t(:,v_ind(i,2)),entry_ind_vec);
v1 = n(t(:,v_ind(i,4)),entry_ind_vec);
v1 = v1 - aux_vec;
v2 = n(t(:,v_ind(i,3)),entry_ind_vec);
v2 = v2 - aux_vec;  

aux_vec = v1(:,1).*v2(:,2);
aux_vec = aux_vec - v1(:,2).*v2(:,1);

clear v1 v2;

for k = 1 : 3

u_perm = u(t(:,i),k);

if i == 1

if k == 1
p_1 = u_perm.*aux_vec;
elseif k == 2
p_2 = u_perm.*aux_vec;
elseif k == 3
p_3 = u_perm.*aux_vec;
end

else

if k == 1
p_1 = p_1 + u_perm.*aux_vec;
elseif k == 2
p_2 = p_2 + u_perm.*aux_vec;
elseif k == 3
p_3 = p_3 + u_perm.*aux_vec;
end

end

end

end


if ismember(gpu_extended_memory,[0 1])
p = gather([p_1 p_2 p_3]);
else
p = [p_1 p_2 p_3];
end

end
