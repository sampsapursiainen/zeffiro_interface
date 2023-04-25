function v = zef_surface_scalar_vector_Fn(nodes, tetra, n_ind, scalar_field)
%
% zef_surface_scalar_vector_Fn
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
% Outputs:
%
% - v
%
%   TODO: explanation.
%

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(tetra);

N = size(nodes,1);

if nargin < 3
scalar_field = ones(size(tetra,1),1);
end

[~,det] = zef_volume_barycentric(nodes,tetra);
[b_vec,det] = zef_volume_barycentric(nodes,tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(b_vec(:,1:3).^2,2));
n_vec = b_vec(:,1:3);
n_vec = -n_vec./repmat(sqrt(sum(n_vec.^2,2)),1,3);

v = zeros(N,1);
weight_param = 1/3;

for i = 1 : 3

        I = sub2ind(size(tetra),t_ind,ind_m(f_ind,i));
        v_part = sparse(tetra(I),ones(size(I)),weight_param.*scalar_field(t_ind).*n_vec(:,n_ind).*area,N,1);
        v = v + full(v_part);

end

end
