if evalin('base','zef.mesh_smoothing_on');
      

length_waitbar = 4+length(priority_vec);    

%nodes = evalin('base','zef.nodes_b');
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

tetra = tetra_aux; %evalin('base','zef.tetra_aux');

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
K = gpuArray(K);
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
electrode_is_point = evalin('base','zef.sensors'); 
if not(isempty(L))
    if size(electrode_is_point,2) == 3
    electrode_is_point = zeros(size(electrode_is_point,1),1);
    else
electrode_is_point = find(electrode_is_point(:,4)==0);
    end
    waitbar((4+length(priority_vec)+((smoothing_steps_surf+1)/(smoothing_steps_surf + 1 + smoothing_steps_vol))*20)/length_waitbar,h,'Mesh smoothing.');
    C = [];
for electrode_ind = 1 : length(L)
 waitbar(electrode_ind/length(L),h,'Electrode smoothing.');
 if not(ismember(electrode_ind,electrode_is_point))
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