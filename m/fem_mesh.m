%Copyright © 2018, Sampsa Pursiainen
function [nodes,nodes_b,tetra,johtavuus_ind,surface_triangles] = fem_mesh(void)

h = waitbar(0,'Initial mesh.');

mesh_res = evalin('base','zef.mesh_resolution');
reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');
sensors = evalin('base','zef.sensors');

i = 0;
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
if k == 6;
    aux_brain_ind = i;
end
end
end

n_compartments = length(reuna_p);

x_lim = [min(reuna_p{end}(:,1)) max(reuna_p{end}(:,1))];
y_lim = [min(reuna_p{end}(:,2)) max(reuna_p{end}(:,2))];
z_lim = [min(reuna_p{end}(:,3)) max(reuna_p{end}(:,3))];

x_vec = [x_lim(1):mesh_res:x_lim(2)];
y_vec = [y_lim(1):mesh_res:y_lim(2)];
z_vec = [z_lim(1):mesh_res:z_lim(2)];

[X, Y, Z] = meshgrid(x_vec,y_vec,z_vec);

size_xyz = size(X);

n_cubes = (length(x_vec)-1)*(length(y_vec)-1)*(length(z_vec)-1);

cubes = zeros(n_cubes,8);

ind_mat_1 = [     3     4     1     7 ;
                  2     3     1     7 ;
                  1     2     7     6 ;
                  7     1     6     5 ; 
                  7     4     1     8 ;
                  7     8     1     5  ];

tetra = zeros(6*n_cubes,4);             
johtavuus_ind = zeros(6*n_cubes,8);
i = 1;              


for i_x = 1 : length(x_vec) - 1
waitbar(i_x/(length(x_vec)-1),h,'Initial mesh.');    
for i_y = 1 : length(y_vec) - 1
for i_z = 1 : length(z_vec) - 1

x_ind = [i_x i_x+1 i_x+1 i_x i_x i_x+1 i_x+1 i_x]';  
y_ind = [i_y i_y i_y+1 i_y+1 i_y i_y i_y+1 i_y+1]';    
z_ind = [i_z i_z i_z i_z i_z+1 i_z+1 i_z+1 i_z+1]';    
ind_mat_2 = sub2ind(size_xyz,y_ind,x_ind,z_ind);   

tetra(i:i+5,:) = ind_mat_2(ind_mat_1);
johtavuus_ind(i:i+5,:) = ind_mat_2(:,ones(6,1))'; 
i = i + 6;
        
end
end
end    
    

%tetra = uint32(tetra);
johtavuus_ind = uint32(johtavuus_ind);
%nodes(reuna_ind:end,:) = [X(:) Y(:) Z(:)];
nodes = [X(:) Y(:) Z(:)];
%nodes = nodes + (mesh_res/4)*(rand(size(nodes)) - 0.5);
clear X Y Z;

I = zeros(size(nodes,1), 1);
I_2 = [1 : length(I)]';

close(h);

for i = 1 : n_compartments
   
I_1 = tetra_in_compartment(reuna_p{i},reuna_t{i},nodes(I_2,:),[i n_compartments]);
I(I_2(I_1)) = i; 
I_2 = find(I==0);

end

I_1 = find(sum(sign(I(johtavuus_ind)),2)==8);
tetra = tetra(I_1,:);
johtavuus_ind = johtavuus_ind(I_1,:);
johtavuus_ind = I(johtavuus_ind);
%[priority_val priority_ind] = min(priority_vec(johtavuus_ind),[],2);
%priority_ind = sub2ind(size(johtavuus_ind),[1:size(johtavuus_ind,1)]',priority_ind);
%[johtavuus] = johtavuus_ind(priority_ind);
%[brain_ind]= find(johtavuus==aux_brain_ind);
%johtavuus = sigma_vec(johtavuus);
%johtavuus = johtavuus(:);

I_1 = unique(tetra);
nodes = nodes(I_1,:);
I_2 = zeros(size(nodes,1),1);
I_2(I_1) = [1 : length(I_1)];
tetra = I_2(tetra);
%tetra = uint32(tetra);

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
surface_triangles = tetra(tetra_ind);

nodes_b = nodes;

%tetra = single(tetra);
%johtavuus_ind = single(johtavuus_ind);

%tetra = uint32(tetra);

% trep = TriRep(zef.tetra, zef.nodes);
% surface_triangles = freeBoundary(trep);
% clear trep;


% h = waitbar(1/8,['Finalization.']);    
% 
% tetra_ind = [1:size(tetra,1)]';
% K = length(tetra_ind);
% 
% ind_m = [ 2 4 3 ;
%           1 3 4 ;
%           1 4 2 ; 
%           1 2 3 ];
% k = 1;
% for i = 1 : 4
% for j = i + 1 : 4
% 
% Ind_mat_1 = sort(tetra(tetra_ind,ind_m(i,:)),2); 
% Ind_mat_2 = sort(tetra(tetra_ind,ind_m(j,:)),2);
% 
% Ind_mat = sortrows([ Ind_mat_1 tetra_ind(:) i*ones(K,1) ; Ind_mat_2 tetra_ind(:) j*ones(K,1) ]);
% I = find(sum(abs(Ind_mat(1:end-1,1:3)-Ind_mat(2:end,1:3)),2)==0);
% Ind_cell{i}{j} = [ Ind_mat(I,4) Ind_mat(I,5) ; Ind_mat(I+1,4) Ind_mat(I+1,5)];
% 
% k = k + 1;
% waitbar(k/8,h,['Finalization.']);
% 
% 
% end 
% end
% 
% clear Ind_mat_1 Ind_mat_2;
% 
% 
% Ind_mat = [ Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; Ind_cell{2}{3} ; Ind_cell{2}{4} ; Ind_cell{3}{4} ];
% clear Ind_cell;
% Ind_mat_2 = [tetra_ind ones(size(tetra_ind)) ; tetra_ind 2*ones(size(tetra_ind)) ; tetra_ind 3*ones(size(tetra_ind)) ; tetra_ind 4*ones(size(tetra_ind))];
% I = find(not(ismember(Ind_mat_2,Ind_mat,'rows')));
% Ind_mat = Ind_mat_2(I,:);
% 
% clear Ind_mat_2;
% 
% waitbar(8/8,h,['Finalization.']); 
% 
% tetra_aux = tetra(Ind_mat(:,1),:);
% I = sub2ind(size(tetra_aux),repmat([1:size(tetra_aux,1)]',1,3),ind_m(Ind_mat(:,2),:));
% surface_triangles = tetra_aux(I);
%     
% close(h);
