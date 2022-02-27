function [M, multigrid_perm_output] = zef_block_diagonal_preconditioner(L, multigrid_dec, multigrid_ind, multigrid_perm,varargin)

if not(isempty(varargin))
    reg_param = varargin{1};
end

multigrid_perm_output = cell(0);

n_sources_aux = length(multigrid_perm{1});
n_system_aux  = length(multigrid_perm{2});
n_system = 3*n_system_aux;
M = sparse(n_system, n_system, 0);

multigrid_perm_output{1} = [multigrid_perm{2}'; multigrid_perm{2}' + n_sources_aux; multigrid_perm{2}' + 2*n_sources_aux];
multigrid_perm_output{1} = multigrid_perm_output{1}(:);
L = L(:,multigrid_perm_output{1});
n_levels = size(multigrid_dec{1},2);
n_decs = size(multigrid_dec,2);

for j = 1 : n_levels
for i = 1 : n_decs
for k = 1 : length(multigrid_dec{i}{j})
ind_aux_1 = multigrid_dec{i}{j}{k};
ind_aux_2 = multigrid_perm{1}(ind_aux_1);
ind_aux_2 = [3*(ind_aux_2'-1)+1; 3*(ind_aux_2'-1)+2; 3*ind_aux_2'];
ind_aux_2 = ind_aux_2(:);
LTL = L(:,ind_aux_2)'*L(:,ind_aux_2);
M(ind_aux_2,ind_aux_2) = M(ind_aux_2,ind_aux_2) + LTL;
end
end
end

eig_max = eigs(M,1);
delta_val = reg_param^2*eig_max;
M = M + delta_val*speye(size(M,1));

multigrid_perm_output{2} = [3*(multigrid_perm{3}-1)+1;3*(multigrid_perm{3}-1)+2; 3*multigrid_perm{3}];
multigrid_perm_output{2} = multigrid_perm_output{2}(:);

end

