function [multigrid_dec, multigrid_ind, multigrid_perm] = zef_make_multigrid_dec(center_points,n_subset,n_decs,n_levels)

multigrid_dec = cell(0);
multigrid_ind = cell(0);
c_ind = [1 : size(center_points,1)]';
multigrid_perm_1 = zeros(size(center_points,1),1);
multigrid_perm_2 = zeros(n_decs*n_levels*n_subset,1);
ind_counter = 0;

for j = 1 : n_levels

s_ind = cell(0);
for i = 1 : n_decs
randperm_vec = randperm(length(c_ind));
if j == 1
randperm_ind = randperm_vec(1:n_subset);
else
randperm_ind = randperm_vec(1:(n_subset-1)*n_subset^(j-1));
end
s_ind{i} = c_ind(randperm_ind);
multigrid_ind{i}{j} = s_ind{i};
c_ind = setdiff(c_ind, s_ind{i});
multigrid_perm_1(s_ind{i}) = [ind_counter+1:ind_counter + length(s_ind{i})]';
multigrid_perm_2(ind_counter+1:ind_counter + length(s_ind{i})) = s_ind{i};
ind_counter = ind_counter + length(s_ind{i});
end

aux_cell = cell(0);
for i = 1 : n_decs
if j == 1
aux_cell{1} = s_ind{i};
multigrid_dec{i}{j} = aux_cell;
else
MdlKDT = KDTreeSearcher(center_points(s_ind_old{i},:));
aux_ind = knnsearch(MdlKDT,center_points(s_ind{i},:));
unique_aux_ind = [1 : length(s_ind_old{i})]';
for k = 1 : length(unique_aux_ind)
aux_cell_ind = find(aux_ind == unique_aux_ind(k));
aux_cell{k} = s_ind{i}(aux_cell_ind);
end
multigrid_dec{i}{j} = aux_cell;
end
end

s_ind_old = s_ind;

end

MdlKDT = KDTreeSearcher(center_points(multigrid_perm_2,:));
multigrid_perm_3 = knnsearch(MdlKDT,center_points);

multigrid_perm = cell(0);
multigrid_perm{1} = multigrid_perm_1;
multigrid_perm{2} = multigrid_perm_2;
multigrid_perm{3} = multigrid_perm_3;

end