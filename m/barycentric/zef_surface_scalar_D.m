function M = zef_surface_scalar_D(nodes, tetra, g_i_ind, scalar_field, weighting)

N = size(nodes,1);
K = size(tetra,1);

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

[~,~,t_ind,~,~,~,~,f_ind] = zef_surface_mesh(tetra);

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

[~,det] = zef_volume_barycentric(nodes,tetra);
volume = abs(det)/6;

M = spalloc(N,N,0);

for i = 1 : 3

    [g_i] = zef_volume_barycentric(nodes,tetra,i,det);

       I = sub2ind(size(tetra),t_ind,ind_m(f_ind,i));
    
    for j = i : 3    
   
       J = sub2ind(size(tetra),t_ind,ind_m(f_ind,j));

        if i == j
        entry_vec = volume(t_ind)*weight_param(1);
        else
        entry_vec = volume(t_ind)*weight_param(2);
        end
        M_part =  sparse(tetra(I),tetra(J),scalar_field(t_ind).*g_i(t_ind,g_i_ind).*entry_vec,N,N);       
        if i == j
        M = M + M_part;
        else
        M = M + M_part;
        M = M + M_part';
        end 
        
    end
    
end
end