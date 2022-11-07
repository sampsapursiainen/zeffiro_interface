%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

parameters;

nodes = load([torre_dir '/system_data/nodes_' int2str(system_setting_index) '.dat']);
tetrahedra = load([torre_dir '/system_data/tetrahedra_' int2str(system_setting_index) '.dat']);
real_relative_permittivity = load([torre_dir '/system_data/real_relative_permittivity_' int2str(system_setting_index) '.dat']);
imaginary_relative_permittivity = load([torre_dir '/system_data/imaginary_relative_permittivity_' int2str(system_setting_index) '.dat']);
load([torre_dir '/system_data/signal_configuration.mat']);

orbit_interior_ind = 2;
ast_interior_ind = 1;

p_vec = real_relative_permittivity;
c_vec = 2*pi*signal_center_frequency*imaginary_relative_permittivity;

j_ind_ast = find(ismember(tetrahedra(:,5),[ast_interior_ind]));
tetra = tetrahedra(j_ind_ast,:);
j_ind_ast = unique(tetra);
j_ind_aux = zeros(size(nodes,1),1);
j_ind_aux(j_ind_ast) = [1 : length(j_ind_ast)]';
tetra_ast = j_ind_aux(tetra);
nodes_ast = nodes(j_ind_ast,:);

interp_vec = [1:size(tetrahedra,1)]';
for ref_ind = 1 : n_refinement
[nodes,tetrahedra,interp_vec_ref] = refine_mesh(nodes,tetrahedra);
interp_vec = interp_vec(interp_vec_ref);
end

p_vec = p_vec(interp_vec);
c_vec = c_vec(interp_vec);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ]; 

I_ast = find(ismember(tetrahedra(:,5),[ast_interior_ind]));
ast_ind = I_ast;
tetra = tetrahedra(I_ast,:);
I_ast = unique(tetra);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles_ast = tetra(tetra_ind);
ind_vec_ast = unique(surface_triangles_ast);

I_orbit = find(ismember(tetrahedra(:,5),[orbit_interior_ind ast_interior_ind]));
orbit_ind = I_orbit;
tetra = tetrahedra(I_orbit,:);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
orbit_triangles = tetra(tetra_ind);
orbit_tetra_ind = I_orbit(tetra_sort(I,5));
orbit_nodes = unique(orbit_triangles);
orbit_ind = orbit_nodes;
I_aux = zeros(size(nodes,1),1); 
I_aux(orbit_nodes) = [1:size(orbit_nodes,1)]';
orbit_triangles = I_aux(orbit_triangles); 
orbit_nodes = nodes(orbit_nodes,:);

N = size(nodes,1);
M = size(tetrahedra,1);

Aux_mat = [nodes(tetrahedra(:,1),:)'; nodes(tetrahedra(:,2),:)'; nodes(tetrahedra(:,3),:)'] - repmat(nodes(tetrahedra(:,4),:)',3,1); 
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
            
A = spdiags(tilavuus', 0, M, M);

ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ; 
          1 2 3 ];
      
C = spalloc(N,N,0);

for i = 1 : 4
    for j = i : 4
        
        if i == j
        entry_vec = tilavuus/10; 
        else
        entry_vec = tilavuus/20;
        end
        C_part =  sparse(tetrahedra(:,i),tetrahedra(:,j), p_vec'.*entry_vec,N,N);
        
        if i == j
        C = C + C_part; 
        else
        C = C + C_part; 
        C = C + C_part';
        end
        
    end
end

R = spalloc(N,N,0);

for i = 1 : 4
for j = i : 4

if i == j
entry_vec = tilavuus/10;
else
entry_vec = tilavuus/20;
end
R_part =  sparse(tetrahedra(:,i),tetrahedra(:,j), c_vec'.*entry_vec,N,N);
                 
if i == j
R = R + R_part;
else
R = R + R_part;
R = R + R_part';
end

end
end

t_c_vec = (1/4)*(nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:));
I_p_x = find(abs(t_c_vec(:,1))>r_p_m_layer*s_radius);
I_p_y = find(abs(t_c_vec(:,2))>r_p_m_layer*s_radius);
I_p_z = find(abs(t_c_vec(:,3))>r_p_m_layer*s_radius);
I_u = unique(tetrahedra([I_p_x ; I_p_y ; I_p_z],1:4));

save([torre_dir '/system_data/mesh_' int2str(system_setting_index) '.mat'], 'nodes', 'tetrahedra', 'I_u', 'I_p_x', 'I_p_y', 'I_p_z', 'I_ast', 'nodes_ast', 'tetra_ast', 'interp_vec', 'orbit_nodes', 'orbit_ind', 'orbit_tetra_ind', 'orbit_triangles', 'surface_triangles_ast', 'ind_vec_ast', 'ast_ind', 'n_r', 'j_ind_ast', 'source_points', 'source_orientations', 'path_data','-v7.3');
save([torre_dir '/system_data/system_data_' int2str(system_setting_index) '.mat'], 'A', 'C', 'R', 'p_vec','-v7.3');

make_interp_mat;