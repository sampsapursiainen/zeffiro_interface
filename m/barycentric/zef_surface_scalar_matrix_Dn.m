function M = zef_surface_scalar_matrix_Dn(nodes, tetra, g_i_ind, n_ind, scalar_field, weighting)

N = size(nodes,1);
K = size(tetra,1);

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(tetra);

if nargin < 6
weighting = 1;    
end

if nargin < 5
scalar_field = ones(size(tetra,1),1);
end

if length(weighting)==1
weight_param = weighting([1 1]);
else
weight_param = weighting;
end

[n_vec,det] = zef_volume_barycentric(nodes,tetra(t_ind,:),f_ind);
area = (abs(det)/2).*sqrt(sum(n_vec(:,1:3).^2,2));
n_vec = n_vec(:,1:3);
n_vec = -n_vec./repmat(sqrt(sum(n_vec.^2,2)),1,3);

[~,det] = zef_volume_barycentric(nodes,tetra);

M = spalloc(N,N,0);

for i = 1 : 3

    [g_i] = zef_volume_barycentric(nodes,tetra,i,det);

       I = sub2ind(size(tetra),t_ind,ind_m(f_ind,i));
    
    for j = i : 3    
   
       J = sub2ind(size(tetra),t_ind,ind_m(f_ind,j));

        if i == j
        entry_vec = area*weight_param(1);
        else
        entry_vec = area*weight_param(2);
        end
        M_part =  sparse(tetra(I),tetra(J),scalar_field(t_ind).*g_i(t_ind,g_i_ind).*n_vec(:,n_ind).*entry_vec,N,N);       
        if i == j
        M = M + M_part;
        else
        M = M + M_part;
        M = M + M_part';
        end 
        
    end
    
end
end