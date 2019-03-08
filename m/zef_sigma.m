%Copyright © 2018, Sampsa Pursiainen
 function [johtavuus,brain_ind,non_source_ind,nodes,tetra,johtavuus_prisms,prisms] = zef_sigma(void)

tetra = [];
prisms = [];
johtavuus_prisms = [];
non_source_ind = []; 

aux_brain_ind = [0 0 0 0 0 0];
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
for k = 1 : 18  
switch k
    case 1
        var_0 = 'zef.d1_on';
        var_1 = 'zef.d1_sigma';
        var_2 = 'zef.d1_priority';
     case 2
        var_0 = 'zef.d2_on';
        var_1 = 'zef.d2_sigma';   
        var_2 = 'zef.d2_priority';
     case 3
        var_0 = 'zef.d3_on';
        var_1 = 'zef.d3_sigma';   
        var_2 = 'zef.d3_priority';
     case 4
        var_0 = 'zef.d4_on';
        var_1 = 'zef.d4_sigma';   
        var_2 = 'zef.d4_priority';
  case 5
        var_0 = 'zef.d5_on';
        var_1 = 'zef.d5_sigma';
        var_2 = 'zef.d5_priority';
     case 6
        var_0 = 'zef.d6_on';
        var_1 = 'zef.d6_sigma';   
        var_2 = 'zef.d6_priority';
     case 7
        var_0 = 'zef.d7_on';
        var_1 = 'zef.d7_sigma';   
        var_2 = 'zef.d7_priority';
     case 8
        var_0 = 'zef.d8_on';
        var_1 = 'zef.d8_sigma';   
        var_2 = 'zef.d8_priority';
    case 9
        var_0 = 'zef.d9_on';
        var_1 = 'zef.d9_sigma';
        var_2 = 'zef.d9_priority';
     case 10
        var_0 = 'zef.d10_on';
        var_1 = 'zef.d10_sigma';   
        var_2 = 'zef.d10_priority';
     case 11
        var_0 = 'zef.d11_on';
        var_1 = 'zef.d11_sigma';   
        var_2 = 'zef.d11_priority';
     case 12
        var_0 = 'zef.d12_on';
        var_1 = 'zef.d12_sigma';   
        var_2 = 'zef.d12_priority';
      case 13
        var_0 = 'zef.d13_on';
        var_1 = 'zef.d13_sigma';   
        var_2 = 'zef.d13_priority';
    case 14
        var_0 = 'zef.w_on';
        var_1 = 'zef.w_sigma';    
        var_2 = 'zef.w_priority';
    case 15
        var_0 = 'zef.g_on';
        var_1 = 'zef.g_sigma';
        var_2 = 'zef.g_priority';
    case 16
        var_0 = 'zef.c_on';
        var_1 = 'zef.c_sigma';
        var_2 = 'zef.c_priority';
     case 17
        var_0 = 'zef.sk_on';
        var_1 = 'zef.sk_sigma';
        var_2 = 'zef.sk_priority';
     case 18
        var_0 = 'zef.sc_on';
        var_1 = 'zef.sc_sigma';
        var_2 = 'zef.sc_priority';
     end
on_val = evalin('base',var_0);      
sigma_val = evalin('base',var_1);  
priority_val = evalin('base',var_2);  
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
if k == 1;
    aux_brain_ind(3) = i;
end
if k == 2;
    aux_brain_ind(4) = i;
end
if k == 3;
    aux_brain_ind(5) = i;
end
if k == 4;
    aux_brain_ind(6) = i;
end
if k == 5;
    aux_brain_ind(7) = i;
end
if k == 6;
    aux_brain_ind(8) = i;
end
if k == 7;
    aux_brain_ind(9) = i;
end
if k == 8;
    aux_brain_ind(10) = i;
end
if k == 9;
    aux_brain_ind(11) = i;
end
if k == 10;
    aux_brain_ind(12) = i;
end
if k == 11;
    aux_brain_ind(13) = i;
end
if k == 12;
    aux_brain_ind(14) = i;
end
if k == 13;
    aux_brain_ind(15) = i;
end
if k == 14;
    aux_brain_ind(1) = i;
end
if k == 15;
    aux_brain_ind(2) = i;
end
if k == 16;
    aux_brain_ind(16) = i;
end
if k == 17;
    aux_brain_ind(17) = i;
end
if k == 18;
    aux_brain_ind(18) = i;
end
if k == 17;
    aux_skull_ind = i;
end
end
end

johtavuus_ind = double(evalin('base','zef.sigma_ind'));
[priority_val priority_ind] = min(priority_vec(johtavuus_ind),[],2);
priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
[johtavuus] = johtavuus_ind(priority_ind);
johtavuus_aux = johtavuus;
brain_ind = [];
if evalin('base','zef.wm_sources')
if not(aux_brain_ind(1)==0) && not(aux_brain_ind(1)==3)
[brain_ind]= find(johtavuus==aux_brain_ind(1));
end
end
if evalin('base','zef.g_sources')
if not(aux_brain_ind(2)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(2))];
end
end
if evalin('base','zef.d1_sources')
if not(aux_brain_ind(3)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(3))];
end
end
if evalin('base','zef.d2_sources')
if not(aux_brain_ind(4)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(4))];
end
end
if evalin('base','zef.d3_sources')
if not(aux_brain_ind(5)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(5))];
end
end
if evalin('base','zef.d4_sources')
if not(aux_brain_ind(6)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(6))];
end
end
if evalin('base','zef.d5_sources')
if not(aux_brain_ind(7)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(7))];
end
end
if evalin('base','zef.d6_sources')
if not(aux_brain_ind(8)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(8))];
end
end
if evalin('base','zef.d7_sources')
if not(aux_brain_ind(9)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(9))];
end
end
if evalin('base','zef.d8_sources')
if not(aux_brain_ind(10)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(10))];
end
end
if evalin('base','zef.d9_sources')
if not(aux_brain_ind(11)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(11))];
end
end
if evalin('base','zef.d10_sources')
if not(aux_brain_ind(12)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(12))];
end
end
if evalin('base','zef.d11_sources')
if not(aux_brain_ind(13)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(13))];
end
end
if evalin('base','zef.d12_sources')
if not(aux_brain_ind(14)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(14))];
end
end
if evalin('base','zef.d13_sources')
if not(aux_brain_ind(15)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(15))];
end
end
if evalin('base','zef.c_sources')
if not(aux_brain_ind(16)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(16))];
end
end
if evalin('base','zef.sk_sources')
if not(aux_brain_ind(17)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(17))];
end
end
if evalin('base','zef.sc_sources')
if not(aux_brain_ind(18)==0)
[brain_ind]= [brain_ind ; find(johtavuus==aux_brain_ind(18))];
end
end
if sum(aux_brain_ind) == 0 
brain_ind = find(johtavuus);
end

brain_ind = brain_ind(:);
johtavuus = sigma_vec(johtavuus);
johtavuus = johtavuus(:);

clear johtavuus_ind priority_ind;


nodes = evalin('base','zef.nodes_b');
tetra = evalin('base','zef.tetra_aux');
N = size(nodes, 1);


% nodes_b = evalin('base','zef.nodes_b');
if evalin('base','zef.mesh_smoothing_on');

length_waitbar = 5+length(priority_vec)+evalin('base','zef.smoothing_steps_surf')/5;    
h = waitbar(0,'Mesh smoothing.');
N = size(nodes, 1);

surface_triangles = [];
J = [];
for k = 1 : length(priority_vec)
waitbar(k/length_waitbar,h,'Mesh smoothing.');
tetra = evalin('base','zef.tetra_aux');
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
J = [ J ; unique(surface_triangles)];
end
waitbar((1+length(priority_vec))/length_waitbar,h,'Mesh smoothing.');
surface_triangles = sort(surface_triangles,2);
surface_triangles = unique(surface_triangles,'rows');
K = unique(J);
J = setdiff(tetra(:),K);

waitbar((2+length(priority_vec))/length_waitbar,h,'Mesh smoothing.');

tetra = evalin('base','zef.tetra_aux');

smoothing_ok = 0;

nodes = evalin('base','zef.nodes_b');
smoothing_param = evalin('base','zef.smoothing_strength');   
smoothing_steps_surf = evalin('base','zef.smoothing_steps_surf');   
smoothing_steps_vol =  evalin('base','zef.smoothing_steps_vol'); 

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
waitbar((3+length(priority_vec))/length_waitbar,h,'Mesh smoothing.');
clear surface_triangles;

clear A_part;
A = spones(A);
sum_A = full(sum(A(K,K)))';

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
waitbar((4+length(priority_vec))/length_waitbar,h,'Mesh smoothing.');
clear B_part;
B = spones(B);
sum_B = full(sum(B))';
end

sum_A = sum_A(:,[1 1 1]);
sum_B = sum_B(:,[1 1 1]);
taubin_lambda = 1;
taubin_mu = -1;



for iter_ind_aux_1 = 1 : smoothing_steps_surf
 %nodes_old = nodes;   
waitbar((4+length(priority_vec)+iter_ind_aux_1/5)/length_waitbar,h,'Mesh smoothing.');
nodes_aux = A(K,K)*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_lambda*smoothing_param*nodes_aux;
nodes_aux = A(K,K)*nodes(K,:);
nodes_aux = nodes_aux./sum_A;
nodes_aux = nodes_aux - nodes(K,:);
nodes(K,:) =  nodes(K,:) + taubin_mu*smoothing_param*nodes_aux;

for iter_ind_aux_2 = 1 : smoothing_steps_vol
nodes_aux = B*nodes; 
nodes_aux = nodes_aux./sum_B;
nodes(J,:) = nodes(J,:) + smoothing_param*(nodes_aux(J,:)-nodes(J,:));
end

%Aux_mat = [nodes(tetra(:,1),:)'; nodes(tetra(:,2),:)'; nodes(tetra(:,3),:)'] - repmat(nodes(tetra(:,4),:)',3,1);
%ind_m = [1 4 7; 2 5 8 ; 3 6 9];
%tilavuus = (Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
%- Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
%+ Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
%clear Aux_mat;

%unique_ind = (tetra(find(tilavuus/min(tilavuus) < 0.000001),:))
%unique_ind = unique(unique_ind);
%nodes(unique_ind,:) = nodes_old(unique_ind,:);

end

waitbar((5+length(priority_vec)+smoothing_steps_surf/5)/length_waitbar,h,'Mesh smoothing.');

clear nodes_aux;

Aux_mat = [nodes(tetra(:,1),:)'; nodes(tetra(:,2),:)'; nodes(tetra(:,3),:)'] - repmat(nodes(tetra(:,4),:)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = (Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
- Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
+ Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
clear Aux_mat;


if max(tilavuus)/min(tilavuus) < 0.0000001 
smoothing_ok = 0;
else
smoothing_ok = 1;
end
% smoothing_ok = 1
% max(tilavuus)
% figure
% hist((tilavuus),100)
close(h);

if smoothing_ok == 0
nodes = evalin('base','zef.nodes_b');
johtavuus = [johtavuus(:) johtavuus_aux(:)] ;
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
if evalin('base','zef.wm_sources')
if not(aux_brain_ind(1)==0)
[brain_ind]= find(johtavuus_aux==aux_brain_ind(1));
end
end
if evalin('base','zef.g_sources')
if not(aux_brain_ind(2)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(2))];
end
end
if evalin('base','zef.d1_sources')
if not(aux_brain_ind(3)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(3))];
end
end
if evalin('base','zef.d2_sources')
if not(aux_brain_ind(4)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(4))];
end
end
if evalin('base','zef.d3_sources')
if not(aux_brain_ind(5)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(5))];
end
end
if evalin('base','zef.d4_sources')
if not(aux_brain_ind(6)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(6))];
end
end
if evalin('base','zef.d5_sources')
if not(aux_brain_ind(7)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(7))];
end
end
if evalin('base','zef.d6_sources')
if not(aux_brain_ind(8)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(8))];
end
end
if evalin('base','zef.d7_sources')
if not(aux_brain_ind(9)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(9))];
end
end
if evalin('base','zef.d8_sources')
if not(aux_brain_ind(10)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(10))];
end
end
if evalin('base','zef.d9_sources')
if not(aux_brain_ind(11)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(11))];
end
end
if evalin('base','zef.d10_sources')
if not(aux_brain_ind(12)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(12))];
end
end
if evalin('base','zef.d11_sources')
if not(aux_brain_ind(13)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(13))];
end
end
if evalin('base','zef.d12_sources')
if not(aux_brain_ind(14)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(14))];
end
end
if evalin('base','zef.d13_sources')
if not(aux_brain_ind(15)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(15))];
end
end
if evalin('base','zef.c_sources')
if not(aux_brain_ind(16)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(16))];
end
end
if evalin('base','zef.sk_sources')
if not(aux_brain_ind(17)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(17))];
end
end
if evalin('base','zef.sc_sources')
if not(aux_brain_ind(18)==0)
[brain_ind]= [brain_ind ; find(johtavuus_aux==aux_brain_ind(18))];
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


% if evalin('base','zef.mesh_smoothing_on');
% 
% N = size(nodes,1);    
% B = sparse(N,N,0); 
% 
% h = waitbar(0,'Mesh smoothing.');
% 
% J_c = unique(tetra(brain_ind,:));
% tetra_vec = sum(ismember(tetra,J_c),2);    
% K = find(tetra_vec); 
% 
% %*******************************************************************
%  ind_m = [ 2 4 3 ;
%            1 3 4 ;
%            1 4 2 ; 
%            1 2 3 ];
% 
% tetra_sort = [tetra(K,[2 4 3]) ones(size(K,1),1) [1:size(K,1)]'; 
%               tetra(K,[1 3 4]) 2*ones(size(K,1),1) [1:size(K,1)]'; 
%               tetra(K,[1 4 2]) 3*ones(size(K,1),1) [1:size(K,1)]'; 
%               tetra(K,[1 2 3]) 4*ones(size(K,1),1) [1:size(K,1)]';];
% tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
% tetra_sort = sortrows(tetra_sort,[1 2 3]);
% tetra_ind = zeros(size(tetra_sort,1),1);
% I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
% tetra_ind(I) = 1;
% tetra_ind(I+1) = 1;
% I = find(tetra_ind == 0);
% tetra_ind = sub2ind([size(K,1) 4],repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
% tetra_aux = tetra(K,:);
% surface_triangles = [ tetra_aux];
% J_2 = unique(surface_triangles);
% clear tetra_aux tetra_sort tetra_ind I surface_triangles;
% %*******************************************************************
% clear tetra_vec J_c;
% J = unique(tetra(K,:));
% J = setdiff(J,J_2);
% 
% waitbar(1/3,h,'Mesh smoothing.');
% 
% for i = 1 : 4
% for j = i : 4
% B_part = sparse(tetra(K,i),tetra(K,j),ones(size(K,1),1),N,N);
% if i == j 
% B = B + B_part;
% else
% B = B + B_part ;
% B = B + B_part';
% end
% end
% end
% 
% nodes_2 = nodes;
% 
% waitbar(2/3,h,'Mesh smoothing.');
% 
% clear B_part;
% 
% B = spones(B);
% sum_B = full(sum(B))'+smoothing_param;
% 
% for iter_ind_aux_2 = 1 : smoothing_steps_vol
% 
% nodes_aux = B(J,:)*nodes;   
% nodes(J,:) = nodes_aux + smoothing_param*nodes(J,:);
% nodes(J,:) = nodes(J,:)./(sum_B(J,[1 1 1]));
% 
% end
% 
% waitbar(1,h,'Mesh smoothing.');
% 
% clear B J nodes_aux;
% 
% Aux_mat = [nodes(tetra(:,1),:)'; nodes(tetra(:,2),:)'; nodes(tetra(:,3),:)'] - repmat(nodes(tetra(:,4),:)',3,1);
% ind_m = [1 4 7; 2 5 8 ; 3 6 9];
% tilavuus = (Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
% - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
% + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
% clear Aux_mat;
% 
% if 6*max(tilavuus)/(evalin('base','zef.mesh_resolution')^3) > -0.005/10000
% smoothing_ok = 0;
% else
% smoothing_ok = 1;
% end
% 
% close(h);
% 
% if smoothing_ok == 0
% nodes = nodes_2;    
% errordlg('Mesh smoothing failed.');
% end
% 
% end


end

johtavuus = [johtavuus(:) johtavuus_aux(:)] ;

end

%brain_ind = single(brain_ind);
%tetra = single(tetra);

 end





