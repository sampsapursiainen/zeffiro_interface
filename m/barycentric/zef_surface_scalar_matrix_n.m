function M = zef_surface_scalar_matrix_n(nodes, tetra, n_ind, scalar_field, weighting)
%
% zef_surface_scalar_matrix_n
%
% TODO: Sampsa should document this.
%
% Inputs:
%
% - nodes
%
%   TODO: explanation.
%
% - tetra
%
%   TODO: explanation.
%
% - n_ind
%
%   TODO: explanation.
%
% - scalar_field
%
%   TODO: explanation.
%
% - weighting
%
%   TODO: explanation.
%
% Outputs:
%
% - M
%
%   TODO: explanation.
%

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(tetra);

N = size(nodes,1);
K = size(tetra,1);

if nargin < 5
weighting = 1;
end

if nargin < 4
scalar_field = ones(size(tetra,1),1);
end

if length(weighting)==1
weight_param = weighting([1 1]);
else
weight_param = weighting;
end

[n_vec,det] = zef_volume_barycentric(nodes,tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(n_vec.^2,2));
n_vec = n_vec(:,1:3);
n_vec = -n_vec./repmat(sqrt(sum(n_vec.^2,2)),1,3);

M = spalloc(N,N,0);

for i = 1 : 3

        I = sub2ind(size(tetra),t_ind,ind_m(f_ind,i));

for j = 1 : 3

        J = sub2ind(size(tetra),t_ind,ind_m(f_ind,j));

        if i == j
        entry_vec = area*weight_param(1);
        else
        entry_vec = area*weight_param(2);
        end

        M_part = sparse(tetra(I),tetra(J),scalar_field(t_ind).*entry_vec.*n_vec(:,n_ind),N,N);

        M = M + M_part;

        end

end
end
