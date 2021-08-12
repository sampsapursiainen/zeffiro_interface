%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [johtavuus,brain_ind,non_source_ind,nodes,tetra,johtavuus_prisms,prisms,submesh_ind] = zef_sigma(void)

tetra = [];
prisms = [];
johtavuus_prisms = [];
non_source_ind = []; 

optimizer_flag = 1;

if evalin('base','zef.sigma_bypass')
    
   johtavuus = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   non_source_ind = evalin('base','zef.non_source_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');
   johtavuus_prisms = evalin('base','zef.sigma_prisms');
   prisms = evalin('base','zef.prisms');
   submesh_ind = evalin('base','zef.submesh_ind');
   
else
    
thresh_val = evalin('base','zef.mesh_optimization_parameter');

compartment_tags = evalin('base','zef.compartment_tags');

aux_brain_ind = zeros(1,length(compartment_tags));
aux_skull_ind = [0 0];

if evalin('base','zef.import_mode')
    
   johtavuus = evalin('base','zef.sigma');
   brain_ind = evalin('base','zef.brain_ind');
   nodes = evalin('base','zef.nodes');
   tetra = evalin('base','zef.tetra');

else

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
submesh_cell = cell(0);
for k = 1 : length(compartment_tags) 
    
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_submesh_ind'];
    
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);  
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
submesh_cell{i} = evalin('base',var_3);
aux_brain_ind(k) = i;
if isequal(compartment_tags{k},'sk')
aux_skull_ind = i;
end

end
end


n_compartments = 0;
for k = 1 : evalin('base','length(zef.reuna_p)')
n_compartments = n_compartments + max(1,length(submesh_cell{k}));
end

priority_vec_aux = zeros(n_compartments,1);
compartment_counter = 0;
submesh_ind_1 = ones(n_compartments,1);
submesh_ind_2 = ones(n_compartments,1);

for i = 1 :  evalin('base','length(zef.reuna_p)')
       
for k = 1 : max(1,length(submesh_cell{i}))
    
compartment_counter = compartment_counter + 1;
priority_vec_aux(compartment_counter) = priority_vec(i);
submesh_ind_1(compartment_counter) = i;
submesh_ind_2(compartment_counter) = k;

end
end

johtavuus_ind = double(evalin('base','zef.sigma_ind'));
[priority_val priority_ind] = min(priority_vec_aux(johtavuus_ind),[],2);
priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
[johtavuus] = johtavuus_ind(priority_ind);

submesh_ind = submesh_ind_2(johtavuus);
johtavuus = submesh_ind_1(johtavuus);

johtavuus_aux = johtavuus;

brain_ind = [];
for k = 1 : length(compartment_tags)
if evalin('base',['zef.' compartment_tags{k} '_sources']) && not(evalin('base',['zef.' compartment_tags{k} '_sources'])==3)
if not(aux_brain_ind(k)==0) 
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(k))];
end
end
end
 
if sum(aux_brain_ind) == 0 
brain_ind = find(johtavuus);
end

brain_ind = brain_ind(:);
submesh_ind = submesh_ind(brain_ind);
johtavuus = sigma_vec(johtavuus);
johtavuus = johtavuus(:);

clear johtavuus_ind priority_ind;

nodes = evalin('base','zef.nodes_b');
tetra = evalin('base','zef.tetra_aux');
N = size(nodes, 1);

% nodes_b = evalin('base','zef.nodes_b');
if evalin('base','zef.mesh_smoothing_on');
    
tetra_aux = evalin('base','zef.tetra_aux');
    
length_waitbar = 4+length(priority_vec);    

nodes = evalin('base','zef.nodes_b');
sensors = evalin('base','zef.sensors');

for smoothing_repetition_ind  = 1 : evalin('base','zef.mesh_smoothing_repetitions')

h = waitbar(0,'Smoothing operators.');
N = size(nodes, 1);
L = [];

surface_triangles = [];
J = [];
for k = 1 : length(priority_vec)
waitbar(k/length_waitbar,h,'Smoothing operators.');
tetra = tetra_aux;
I = find(johtavuus_aux==k);
tetra = tetra(I,:);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ];

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
surface_triangles = [ surface_triangles ; tetra(tetra_ind)];
J = [J ; unique(surface_triangles)];
K = unique(J);
end


waitbar((1+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
surface_triangles = sort(surface_triangles,2);
surface_triangles = unique(surface_triangles,'rows');

J = setdiff(tetra(:),K);

waitbar((2+length(priority_vec))/length_waitbar,h,'Smoothing operators.');

tetra = evalin('base','zef.tetra_aux');

smoothing_ok = 0;

smoothing_param = evalin('base','zef.smoothing_strength');   
smoothing_steps_surf = evalin('base','zef.smoothing_steps_surf');   
smoothing_steps_vol =  evalin('base','zef.smoothing_steps_vol'); 
smoothing_steps_ele = evalin('base','zef.smoothing_steps_ele'); 

A = sparse(N, N, 0);
B = sparse(N, N, 0);

for i = 1 : 3
for j = i+1 : 3
A_part = sparse(surface_triangles(:,i),surface_triangles(:,j),double(ones(size(surface_triangles,1),1)),N,N);
if i == j 
A = A + A_part;
else
A = A + A_part ;
A = A + A_part';
end
end
end     


waitbar((3+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
clear surface_triangles;

clear A_part;
A = spones(A);
sum_A = full(sum(A(K,K)))';
sum_A = sum_A(:,[1 1 1]);

A_K = A(K,K);
nodes(K,:) = nodes(K,:);

if smoothing_steps_vol > 0
for i = 1 : 4
for j = i+1 : 4
B_part = sparse(tetra(:,i),tetra(:,j),ones(size(tetra,1),1),N,N);
if i == j 
B = B + B_part;
else
B = B + B_part ;
B = B + B_part';
end
end
end       
waitbar((4+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
clear B_part;
B = spones(B);
sum_B = full(sum(B))';
sum_B = sum_B(:,[1 1 1]);
end

taubin_lambda = 1;
taubin_mu = -1;

if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0
A = gpuArray(A);
A_K = gpuArray(A_K);
B = gpuArray(B); 
K = gpuArray(K)
sum_B = gpuArray(sum_B);
sum_A = gpuArray(sum_A);
end

for iter_ind_aux_1 = 1 : smoothing_steps_surf
 
if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0
nodes = gpuArray(nodes);
end
    
%nodes_old = nodes;   
waitbar(iter_ind_aux_1/smoothing_steps_surf,h,'Surface smoothing.');
nodes_aux = A_K*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_lambda*smoothing_param*nodes_aux;
nodes_aux = A_K*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_mu*smoothing_param*nodes_aux;



end


[sensors_attached_volume] = attach_sensors_volume(sensors,'mesh',nodes,tetra);
L = zef_electrode_struct(sensors_attached_volume);
if not(isempty(L))
    waitbar((4+length(priority_vec)+((smoothing_steps_surf+1)/(smoothing_steps_surf + 1 + smoothing_steps_vol))*20)/length_waitbar,h,'Mesh smoothing.');
    C = [];
for electrode_ind = 1 : length(L)
 waitbar(electrode_ind/length(L),h,'Electrode smoothing.');
 C_sparse = sparse(N, N, 0);
for i = 1 : 2
for j = i : 2
C_part = sparse(L(electrode_ind).edges(:,i),L(electrode_ind).edges(:,j),double(ones(size(L(electrode_ind).edges,1),1)),N,N);
if i == j 
C_sparse = C_sparse + C_part;
else
C_sparse = C_sparse + C_part ;
C_sparse = C_sparse + C_part';
end
end
end  
  C = full(C_sparse(L(electrode_ind).nodes,L(electrode_ind).nodes));
  C_sum = sum(C)';
  C_sum = C_sum(:,[1 1 1]);

for iter_ind_aux_3 = 1 : smoothing_steps_ele
nodes_aux = C*nodes(L(electrode_ind).nodes,:);
nodes_aux = nodes_aux./C_sum;
nodes_aux = nodes_aux - nodes(L(electrode_ind).nodes,:);
nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_lambda*smoothing_param*nodes_aux;
nodes_aux = C*nodes(L(electrode_ind).nodes,:);
nodes_aux = nodes_aux./C_sum;
nodes_aux = nodes_aux - nodes(L(electrode_ind).nodes,:);
nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_mu*smoothing_param*nodes_aux;
end
end
end


for iter_ind_aux_2 = 1 : smoothing_steps_vol
waitbar(iter_ind_aux_2/smoothing_steps_vol,h,'Volume smoothing.');
nodes_aux = B*nodes; 
nodes_aux = nodes_aux./sum_B;
nodes = nodes + smoothing_param*taubin_lambda*(nodes_aux -nodes);
nodes_aux = B*nodes; 
nodes_aux = nodes_aux./sum_B;
nodes = nodes + smoothing_param*taubin_mu*(nodes_aux -nodes);

end




nodes = gather(nodes);

close(h)

[nodes, tetra, optimizer_flag] = zef_tetra_turn(nodes, tetra, thresh_val);

tetra_aux = tetra;

end

clear nodes_aux;


if optimizer_flag == -1;
smoothing_ok = 0;
else
smoothing_ok = 1;
end

if smoothing_ok == 0
nodes = evalin('base','zef.nodes_b');
johtavuus = [johtavuus(:) johtavuus_aux(:)];
errordlg('Mesh smoothing failed.');
return;
end

clear A B;
tetra_vec = sum(ismember(tetra,J),2);    
non_source_ind = find(tetra_vec > 2); 
clear tetra_vec;

end

if evalin('base','zef.refinement_on');
    
 length_waitbar = 11;   
 h = waitbar(0,'Refinement.');      
 
 %I = find(johtavuus_aux==aux_skull_ind);
J_c = [];
 if evalin('base','zef.refinement_type') == 1 || evalin('base','zef.refinement_type') == 3 ;
tetra = evalin('base','zef.tetra_aux');
     I = find(johtavuus_aux==aux_brain_ind(1));
  I = [I ; find(johtavuus_aux==aux_brain_ind(2))];
  I = [I ; find(johtavuus_aux==aux_brain_ind(3))];
  I = [I ; find(johtavuus_aux==aux_brain_ind(4))];
  I = [I ; find(johtavuus_aux==aux_brain_ind(5))];
  I = [I ; find(johtavuus_aux==aux_brain_ind(6))];
tetra = tetra(I,:);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ];

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
surface_triangles = [ tetra(tetra_ind)];
J_c = [J_c ;  unique(surface_triangles)];
clear tetra_sort;
 end
 
  if evalin('base','zef.refinement_type') == 2 || evalin('base','zef.refinement_type') == 3 ;
      tetra = evalin('base','zef.tetra_aux'); 
  I = find(johtavuus_aux==aux_skull_ind(1));
tetra = tetra(I,:);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ];

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
surface_triangles = [ tetra(tetra_ind)];
J_c = [J_c ;  unique(surface_triangles)];
clear tetra_sort;
 end
    
tetra = evalin('base','zef.tetra_aux');

waitbar(1/length_waitbar,h,'Refinement.'); 

tetra_vec = sum(ismember(tetra,J_c),2);    
J = find(tetra_vec); 
ind_aux = unique(tetra(J,:));
J = find(sum(ismember(tetra,ind_aux),2)==4);
ind_aux = unique(tetra(J,:));
ind_aux = ismember(tetra,ind_aux);
sum_aux = sum(ind_aux,2);

J_2 = find(sum_aux==2);
J_3 = find(sum_aux==3);

clear ind_aux sum_aux tetra_vec;
waitbar(2/length_waitbar,h,'Refinement.'); 

J_aux = [J; J_2; J_3];
aux_vec = [ones(size(J)); 2*ones(size(J_2)); 3*ones(size(J_3))];

edge_ind = zeros(6*length(J_aux),6);
aux_ind = [1 2 ; 1 3 ; 1 4 ; 2 3 ; 2 4 ; 3 4];
for i = 1 : 6
edge_ind((i-1)*length(J_aux) + 1:i*length(J_aux),[1 2 3 5 6]) = [tetra(J_aux, aux_ind(i,:)) J_aux aux_vec i*ones(length(J_aux),1)];
end
clear tetra_ind_aux;
edge_ind(:,1:2) = sort(edge_ind(:,1:2),2);
edge_ind = sortrows(edge_ind,[1 2 5]);
clear edge_ind_2 nodes_new;
new_node_ind = 0;
current_edge = [0 0];

waitbar(3/length_waitbar,h,'Refinement.'); 

for i = 1 : size(edge_ind,1)
if edge_ind(i,5) == 1 
if edge_ind(i,1:2) == current_edge
edge_ind(i,4) = new_node_ind;   
else
new_node_ind = new_node_ind + 1;
current_edge = edge_ind(i,1:2);
edge_ind(i,4) = new_node_ind;  
end
else 
if edge_ind(i,1:2) == current_edge   
edge_ind(i,4) = new_node_ind;
end
end
end

waitbar(4/length_waitbar,h,'Refinement.'); 

[edge_val_aux edge_ind_2] = unique(edge_ind(:,4));
clear edge_val_aux;
edge_ind_2 = edge_ind_2(2:end,:);
nodes_new = (1/2)*(nodes(edge_ind(edge_ind_2,1),:) + nodes(edge_ind(edge_ind_2,2),:));
size_nodes = size(nodes,1);
nodes = [nodes ; nodes_new];
clear edge_ind_2 nodes_new;

waitbar(5/length_waitbar,h,'Refinement.'); 

I =find(edge_ind(:,4)); 
edge_ind(I,4) = edge_ind(I,4) + size_nodes;
edge_ind = sortrows(edge_ind,[5 3 6]);
edge_mat = reshape(edge_ind(:,4),6,length(J_aux))'; 
clear edge_ind I;

waitbar(6/length_waitbar,h,'Refinement.'); 

t_ind_1 = [  1     5     6     7
     7     9     6    10
     6     8     3    10
     2     9     8     5
     4     7    10     9
     5     6     9     8
     6     9     8    10
     7     9     5     6 ]; 
 
t_ind_2 = [tetra(J,:) edge_mat(1:length(J),:)]; 
 
tetra_new = [];

clear J_aux;
johtavuus_aux_new = [];

for i = 1 : 7
    
tetra_new = [ tetra_new ; t_ind_2(:,t_ind_1(i,:)) ];
johtavuus_aux_new = [johtavuus_aux_new ; johtavuus_aux(J,:)];

end

tetra(J,:) = [ t_ind_2(:,t_ind_1(8,:)) ];

clear t_ind_1 t_ind_2;

waitbar(7/length_waitbar,h,'Refinement.'); 

tetra = [tetra ; tetra_new ];
johtavuus_aux = [johtavuus_aux ; (johtavuus_aux_new)];

waitbar(8/length_waitbar,h,'Refinement.'); 

ind_aux = length(J) + [1 : length(J_2)]';
tetra_new = [];
johtavuus_aux_new = [];

for i = 1 : 6
    switch i
        case 1
            nodes_aux_vec = [1 2 3 4];
        case 2
            nodes_aux_vec = [1 3 2 4];
        case 3
            nodes_aux_vec = [1 4 2 3];
        case 4
            nodes_aux_vec = [2 3 1 4];
        case 5
            nodes_aux_vec = [2 4 1 3];
        case 6 
            nodes_aux_vec = [3 4 1 2];
    end
 
          
    I = find(edge_mat(ind_aux,i));
    
    tetra_new = [tetra_new ; edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,1)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];
    johtavuus_aux_new = [johtavuus_aux_new ; johtavuus_aux(J_2(I),:)];
    tetra(J_2(I),:) = [edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,2)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];
        
end


tetra = [tetra ; tetra_new];
johtavuus_aux = [johtavuus_aux ; (johtavuus_aux_new)];

waitbar(9/length_waitbar,h,'Refinement.'); 

ind_aux = length(J) + length(J_2) + [1 : length(J_3)]';
tetra_new = [];
johtavuus_aux_new = [];

for i = 1 : 4
    switch i
        case 1
            nodes_ind_aux = [1 2 3 4];
            col_ind_aux = [1 4 2];
        case 2
            nodes_ind_aux = [1 2 4 3];
            col_ind_aux = [1 5 3];
        case 3
            nodes_ind_aux = [1 3 4 2];
            col_ind_aux = [2 6 3];
        case 4
            nodes_ind_aux = [2 3 4 1];
            col_ind_aux = [4 6 5];
        end
 
          
    I = find(sum(not(edge_mat(ind_aux,col_ind_aux)),2)==0);
    
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,1))  edge_mat(ind_aux(I),col_ind_aux(1)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,2))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(1)) tetra(J_3(I),nodes_ind_aux(:,4))]; 
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,3))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))]; 
    johtavuus_aux_new = [johtavuus_aux_new ; repmat(johtavuus_aux(J_3(I),:),3,1)];
    tetra(J_3(I),:) = [edge_mat(ind_aux(I),col_ind_aux(1))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
    
end

tetra = [tetra ; tetra_new];
johtavuus_aux = [johtavuus_aux ; (johtavuus_aux_new)];

clear tetra_new_ind tetra_new_out;
 
waitbar(10/length_waitbar,h,'Refinement.'); 

Aux_mat = [nodes(tetra(:,1),:)'; nodes(tetra(:,2),:)'; nodes(tetra(:,3),:)'] - repmat(nodes(tetra(:,4),:)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = (Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
- Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
+ Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
clear Aux_mat;
I = find(tilavuus > 0);
tetra(I,:) = tetra(I,[2 1 3 4]);
clear tilavuus I;

brain_ind = []; 
for k = 1 : length(compartment_tags)
if evalin('base',['zef.' compartment_tags{k} '_sources'])
if not(aux_brain_ind(k)==0) && not(evalin('base',['zef.' compartment_tags{k} '_sources'])==3)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(k))];
end
end
end

if sum(aux_brain_ind) == 0 
brain_ind = find(johtavuus_aux);
end

johtavuus = sigma_vec(johtavuus_aux);

waitbar(1,h,'Refinement.'); 

tetra_vec = sum(ismember(tetra,J_c),2);    
J = find(tetra_vec); 
J_c = unique(tetra(J,:));
tetra_vec = sum(ismember(tetra,J_c),2);    
non_source_ind = find(tetra_vec > 2); 
non_source_ind = intersect(brain_ind, non_source_ind);


close(h)


end

johtavuus = [johtavuus(:) johtavuus_aux(:)] ;

end

%brain_ind = single(brain_ind);
%tetra = single(tetra);

end
 
end





