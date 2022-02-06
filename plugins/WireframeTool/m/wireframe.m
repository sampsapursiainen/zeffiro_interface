%Asteroid wireframe modeling package for complex microwave analogue object generation.
%Copyright © 2019- Sampsa Pursiainen, Liisa-Ida Sorsa, Christelle Eyraud, Jean-Michel Geffrin.
%This function generates a wireframe corresponding to a given tetrahedral mesh.
%given as argument.
%INPUT: tetra (M-by-4), points (K-by-3), shape_param (1-by-N), overlap_param 
%(1-by-1, auxiliary argument), n_mesh_refinement (1-by-1). Here, K points and M tetrahedra 
%describe the tetrahedral mesh and shape_param the tetrahedron width. As an additional
%argument, one can give the relative overlap between the edges associated with a given 
%point. The number of uniform mesh refinements is given by n_mesh_refinement (default = 0). 
%OUTPUT: m_triangles (m-by-3), m_nodes (k-by-3). A triangular mesh with m triangles and k 
%nodes, describing the surface of the wireframe. 

function [m_triangles,m_nodes,filling_vec,w_vec,shape_vec] = wireframe(tetra,nodes,domain_labels,filling_vec,varargin)

h_w = waitbar(0,'Wireframe optimization');

    R = 4/3*pi*(0.5)^3;
    overlap_param = R^(1/3)/2;
    printer_buffer = sqrt(3);
    printer_resolution = 0;
    n_mesh_refinement = 0;
    edge_threshold = 0;
    scaling_constant = 1;
    n_iter = evalin('base','zef.wireframe_n_iter');
    filling_vec = filling_vec(:);
    
    if length(filling_vec) == 1 
        filling_vec = filling_vec*ones(size(tetra,1),1);
    elseif length(filling_vec) < size(tetra,1)
       domain_ind_vec = unique(domain_labels);
       filling_vec_aux = zeros(size(tetra,1),1);
       for i = 1 : length(domain_ind_vec)     
           I = find(tetrahedra(:,5)==domain_ind_vec(i));
           filling_vec_aux(I) = filling_vec(i);
       end
       filling_vec = filling_vec_aux;
    end
           
        
if not(isempty(varargin))
  printer_resolution = varargin{1};
  if length(varargin) > 1
      n_mesh_refinement = varargin{2};
  end
   if length(varargin) > 2
      scaling_constant = varargin{3};
      nodes = scaling_constant*nodes; 
   end
     if length(varargin) > 3
      edge_threshold = varargin{4};
  end
end

if n_mesh_refinement > 0 
    domain_ind = domain_labels;
for i = 1 : n_mesh_refinement
  [nodes,tetra,interp_vec] = refine_mesh(nodes,tetra);
  domain_ind = domain_ind(interp_vec);
  filling_vec = filling_vec(interp_vec);
end
tetra = [tetra domain_ind];
end

n_nodes = size(nodes,1);
n_tetra = size(tetra,1); 

Aux_mat = [nodes(tetra(:,1),:)'; nodes(tetra(:,2),:)'; nodes(tetra(:,3),:)'] - repmat(nodes(tetra(:,4),:)',3,1); 
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;                  

p_triangles = [ 
     4     2     1
     2     6     1
     3     4     1
     1     5     3
     1     6     5
     4     6     2
     3     6     4
     3     5     6
     ];
     
 ind_m = [ 
           1 2 ;
           1 3 ;
           1 4 ; 
           2 3 ;
           2 4 ;
           3 4
           ];

tetra_sort = [
              tetra(:,[1 2]) ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[3 4]); 
              tetra(:,[1 3]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[2 4]); 
              tetra(:,[1 4]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[2 3]); 
              tetra(:,[2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[1 4]);
              tetra(:,[2 4]) 5*ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[1 3]);
              tetra(:,[3 4]) 6*ones(size(tetra,1),1) [1:size(tetra,1)]' domain_labels tetra(:,[1 2]);
              ];
          

          
tetra_sort(:,1:2) = sort(tetra_sort(:,1:2),2);
tetra_sort = sortrows(tetra_sort,[1 2]);
tetra_ind = zeros(size(tetra_sort,1),1);
[u_aux, u_ind, u_ind_orig] = unique(tetra_sort(:,1:2),'rows');
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(u_ind,4),1,2),ind_m(tetra_sort(u_ind,3),:));
edges = [tetra(tetra_ind) tetra_sort(u_ind,3) tetra_sort(u_ind,4) tetra_sort(u_ind,5)];
n_edges = size(edges,1);

c_ind = unique(domain_labels);

d_edges = nodes(edges(:,2),:) - nodes(edges(:,1),:);

E_mat_0 = sparse(tetra_sort(:,6),u_ind_orig,ones(size(tetra_sort(:,6))),n_nodes,n_edges);
E_mat_0 = E_mat_0 + sparse(tetra_sort(:,7),u_ind_orig,ones(size(tetra_sort(:,7))),n_nodes,n_edges);
[I,J] = find(E_mat_0==1);
f_vec_aux = ones(n_edges,1);
f_vec_aux(J) = 2;

E_mat_2 = sparse(tetra_sort(:,4),u_ind_orig,tilavuus(tetra_sort(:,4)),n_tetra,n_edges);
e_vec_aux = full(sum(E_mat_2))';
e_vec_aux = e_vec_aux.*f_vec_aux;

V_mat_aux_1 = sparse(u_ind_orig,tetra_sort(:,1),ones(size(u_ind_orig,1),1),n_edges,n_nodes);
v_vec_aux_1 = full(sum(V_mat_aux_1))';
clear V_mat_aux_1;

V_mat_aux_2 = sparse(u_ind_orig,tetra_sort(:,2),ones(size(u_ind_orig,1),1),n_edges,n_nodes);
v_vec_aux_2 = full(sum(V_mat_aux_2))';
clear V_mat_aux_2;

E_mat_1 = sparse(tetra_sort(:,4),u_ind_orig,tilavuus(tetra_sort(:,4))'.*(sqrt(3)/4).*sqrt(sum(d_edges(u_ind_orig,:).^2,2))./e_vec_aux(u_ind_orig),n_tetra,n_edges);
E_mat_2 = sparse(tetra_sort(:,4),u_ind_orig,tilavuus(tetra_sort(:,4))'./((sqrt(3)/4).*sqrt(sum(d_edges(u_ind_orig,:).^2,2)).*e_vec_aux(u_ind_orig)),n_tetra,n_edges);
E_mat_3 = sparse(tetra_sort(:,4),u_ind_orig,tilavuus(tetra_sort(:,4))'.*2.*overlap_param.*(sqrt(3)/4)./(e_vec_aux(u_ind_orig)),n_tetra,n_edges);
E_mat_4 = sparse(tetra_sort(:,4),u_ind_orig,tilavuus(tetra_sort(:,4))'.*2.*overlap_param.*(sqrt(3)/4).*(1./v_vec_aux_1(tetra_sort(:,1)) + 1./v_vec_aux_2(tetra_sort(:,2)))./(e_vec_aux(u_ind_orig)),n_tetra,n_edges);

D_mat = spdiags(tilavuus',0,n_tetra,n_tetra);
D_mat_inv = spdiags(1./tilavuus',0,n_tetra,n_tetra);

%w_vec = E_mat_2'*D_mat*filling_vec;
w_vec = zeros(size(E_mat_2,2),1);



reg_param = evalin('base','zef.wireframe_regularization_parameter');
i = 0;
norm_val = norm(filling_vec - D_mat_inv*E_mat_2*w_vec)/norm(filling_vec);
bar_val = 0; 
while norm_val >= evalin('base','zef.wireframe_tolerance') && i < n_iter
    i = i + 1;
    w_vec = w_vec + reg_param*E_mat_2'*(filling_vec - D_mat_inv*E_mat_2*w_vec);
    w_vec = max(0,w_vec);
    norm_val_old = norm_val;
    norm_val = norm(filling_vec - D_mat_inv*E_mat_2*w_vec)/norm(D_mat*filling_vec);
    bar_val = max(bar_val,evalin('base','zef.wireframe_tolerance')/norm_val);
    bar_val = min(1,bar_val);
    waitbar(bar_val,h_w,'Wireframe optimization');
end


i = 0;
w_vec_old = zeros(size(w_vec));
while norm(w_vec - w_vec_old)/norm(w_vec) > 1e-8 && i < n_iter
i = i + 1;
w_vec_old = w_vec;
w_vec = sum(filling_vec)*w_vec./sum(D_mat_inv*(E_mat_1*w_vec - E_mat_3*(w_vec).^(3/2) + E_mat_4*(w_vec).^(3/2)));
I = intersect(find(sqrt(w_vec) >= edge_threshold/2),find(sqrt(w_vec) < edge_threshold));
w_vec(I) = edge_threshold.^2;
I = find(sqrt(w_vec) < edge_threshold);
w_vec(I) = 0;
end

filling_vec = D_mat_inv*(E_mat_1*w_vec - E_mat_3*(w_vec).^(3/2) + E_mat_4*(w_vec).^(3/2));
filling_vec = min(filling_vec,1);

w_vec = sqrt(w_vec + printer_buffer*printer_resolution.^2);

shape_vec = w_vec./sqrt(sum(d_edges.^2,2));

I = setdiff([1:size(w_vec,1)]',I);
w_vec = w_vec(I);
shape_vec = shape_vec(I);
edges = edges(I,:);

waitbar(1,h_w,'Wireframe optimization');

m_triangles = zeros(8*size(edges,1),3);
m_nodes = zeros(6*size(edges,1),3);

for j = 1 : size(edges,1)
    
    p_nodes = [   
   -0.5774        0-shape_vec(j)*overlap_param         0
   -0.5774    1.0000+shape_vec(j)*overlap_param          0
    0.2887         0-shape_vec(j)*overlap_param    -0.5000
    0.2887    1.0000+shape_vec(j)*overlap_param   -0.5000
    0.2887         0-shape_vec(j)*overlap_param      0.5000
    0.2887    1.0000+shape_vec(j)*overlap_param    0.5000
    ];
  

d_edge = nodes(edges(j,2),:) - nodes(edges(j,1),:);
edge_length = sqrt(sum(d_edge.^2,2));
d_edge = d_edge/edge_length;
[m_val,m_ind] = max(abs(d_edge));
n_ind = find(not(ismember([1 2 3],m_ind)));
d_cross_1(n_ind(1)) = d_edge(n_ind(2)); 
d_cross_1(n_ind(2)) = d_edge(n_ind(1)); 
d_cross_1(m_ind) = -2*d_edge(n_ind(1))*d_edge(n_ind(2))/d_edge(m_ind);
d_cross_1 = d_cross_1/sqrt(sum(d_cross_1.^2,2));
d_cross_2 = cross(d_cross_1', d_edge')';


m_triangles((j-1)*8+1:j*8,:) = p_triangles + (j-1)*6;
m_nodes((j-1)*6+1:j*6,:) = p_nodes*edge_length*[shape_vec(j)*d_cross_1 ; d_edge;  shape_vec(j)*d_cross_2] + nodes(edges(j,1)*ones(6,1),:);


end

m_triangles = m_triangles(:,[1 3 2]);                 
     


close(h_w); 

end

 function [nodes,tetra,interp_vec] = refine_mesh(nodes,tetra)

tetra_sort = [tetra(:,[1 2]); 
              tetra(:,[2 3]); 
              tetra(:,[3 1]); 
              tetra(:,[1 4]);
              tetra(:,[2 4]);
              tetra(:,[3 4]);              
              ];
         
          
          tetra_sort = sort(tetra_sort,2);
[edges,edges_ind_1,edges_ind_2] = unique(tetra_sort,'rows');
edges_ind = reshape(edges_ind_2,size(edges_ind_2,1)/6,6);

edges_ind = edges_ind + size(nodes,1);
nodes = [nodes ; 0.5*(nodes(edges(:,1),:) + nodes(edges(:,2),:))]; 

interp_vec = repmat([1:size(tetra,1)]',8,1); 



tetra  = [tetra(:,1) edges_ind(:,1) edges_ind(:,3) edges_ind(:,4)  ;
                       edges_ind(:,1)  tetra(:,2) edges_ind(:,2) edges_ind(:,5)  ; 
                        edges_ind(:,3) edges_ind(:,2) tetra(:,3) edges_ind(:,6) ;
                        edges_ind(:,4) edges_ind(:,5) edges_ind(:,6) tetra(:,4) ;
                         edges_ind(:,3) edges_ind(:,4) edges_ind(:,1) edges_ind(:,6) ; 
                         edges_ind(:,6) edges_ind(:,5) edges_ind(:,1) edges_ind(:,2) ;
                         edges_ind(:,4) edges_ind(:,1) edges_ind(:,6) edges_ind(:,5) ;
                         edges_ind(:,3) edges_ind(:,1) edges_ind(:,2) edges_ind(:,6)                       
                         ];
                                               

 end


