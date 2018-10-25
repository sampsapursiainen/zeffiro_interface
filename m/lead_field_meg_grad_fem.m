%Copyright © 2018, Sampsa Pursiainen
function [L_meg, dipole_locations, dipole_directions] = lead_field_eeg_fem(nodes,elements,sigma,sensors,varargin) 

N = size(nodes,1);
source_model = evalin('base','zef.source_model');

if iscell(elements)
        tetrahedra = elements{1};
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
        if length(elements)>1
        prisms = elements{2};
        waitbar_length = 10;
        end
        K3 = size(prisms,1);
    else
        tetrahedra = elements;
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
        K3 = size(prisms,1);
    end
    clear elements;
            
    if iscell(sigma)
        sigma{1} = sigma{1}';
        if size(sigma{1},1) == 1   
        sigma_tetrahedra = [repmat(sigma{1},3,1) ; zeros(3,size(sigma{1},2))];
        else
        sigma_tetrahedra = sigma{1};    
        end
        sigma_prisms = [];
        if length(sigma)>1
        sigma{2} = sigma{2}';    
        if size(sigma{2},1) == 1   
        sigma_prisms = [repmat(sigma{2},3,1) ; zeros(3,size(sigma{2},2))];
        else
        sigma_prisms = sigma{2};
        end
        end
    else
        sigma = sigma';
        if size(sigma,1) == 1   
        sigma_tetrahedra = [repmat(sigma,3,1) ; zeros(3,size(sigma,2))];
        else
        sigma_tetrahedra = sigma;
        end
        sigma_prisms = [];
    end
    clear elements;

    [min_val, min_ind] = min(sum((repmat(sensors(1,1:3),N,1) - nodes).^2,2)); 
    zero_ind = min_ind;
    sensors = sensors';
    sensors(4:6,:) = sensors(4:6,:)./repmat(sqrt(sum(sensors(4:6,:).^2)),3,1);
    sensors(7:9,:) = sensors(7:9,:)./repmat(sqrt(sum(sensors(7:9,:).^2)),3,1);
    L = size(sensors,2);
    
    tol_val = 1e-6;
    m_max = 3*floor(sqrt(N));
    precond = 'cholinc';
    permutation = 'symamd';
    direction_mode = 'face normals';
    dipole_mode = 1;
    brain_ind = [1:size(tetrahedra,1)]'; 
    source_ind = [1:size(tetrahedra,1)]';   
    cholinc_tol = 1e-3;
    
    
    n_varargin = length(varargin);
    if n_varargin >= 1
    if not(isstruct(varargin{1}))
    brain_ind = varargin{1};
    end
    end   
    if n_varargin >= 2
    if not(isstruct(varargin{2}))
    source_ind = varargin{2};
    end
    end
    if n_varargin >= 1
    if isstruct(varargin{n_varargin})
    if isfield(varargin{n_varargin},'pcg_tol');
        tol_val = varargin{n_varargin}.pcg_tol;
    end
    if  isfield(varargin{n_varargin},'maxit');
        m_max = varargin{n_varargin}.maxit;
    end
    if  isfield(varargin{n_varargin},'precond');
        precond = varargin{n_varargin}.precond;
    end
    if isfield(varargin{n_varargin},'direction_mode');
    direction_mode = varargin{n_varargin}.direction_mode;
    end
    if isfield(varargin{n_varargin},'dipole_mode');
    dipole_mode = varargin{n_varargin}.dipole_mode;
    end
    if isfield(varargin{n_varargin},'cholinc_tol')
    cholinc_tol = varargin{n_varargin}.cholinc_tol;
    end    
    if isfield(varargin{n_varargin},'permutation')
    permutation = varargin{n_varargin}.permutation;
    end  
    end
    end
    K = length(brain_ind);
   
A = spalloc(N,N,0);

Aux_mat = [nodes(tetrahedra(:,1),:)'; nodes(tetrahedra(:,2),:)'; nodes(tetrahedra(:,3),:)'] - repmat(nodes(tetrahedra(:,4),:)',3,1); 
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
clear Aux_mat;

ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ; 
          1 2 3 ];
  
h=waitbar(0,'MEG load vectors.');     
waitbar_ind = 0;

B = zeros(N,L);
tetra_c = (1/4)*(nodes(tetrahedra(:,1),:)+nodes(tetrahedra(:,2),:)+nodes(tetrahedra(:,3),:)+nodes(tetrahedra(:,4),:))';

tic;
load_vec_count = 0;
for i = 1 : 4 
    
grad_1 = cross(nodes(tetrahedra(:,ind_m(i,2)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)', nodes(tetrahedra(:,ind_m(i,3)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)')/2;  
grad_1 = repmat(sign(dot(grad_1,(nodes(tetrahedra(:,i),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)'))),3,1).*grad_1;   

for j = 1 : L

cross_mat_aux = zeros(size(tetra_c));
cross_mat_aux(1,:) = sigma_tetrahedra(1,:).*grad_1(1,:) + sigma_tetrahedra(4,:).*grad_1(2,:) + sigma_tetrahedra(5,:).*grad_1(3,:);
cross_mat_aux(2,:) = sigma_tetrahedra(4,:).*grad_1(1,:) + sigma_tetrahedra(2,:).*grad_1(2,:) + sigma_tetrahedra(6,:).*grad_1(3,:);
cross_mat_aux(3,:) = sigma_tetrahedra(5,:).*grad_1(1,:) + sigma_tetrahedra(6,:).*grad_1(2,:) + sigma_tetrahedra(3,:).*grad_1(3,:);
sensor_mat_aux = repmat(sensors(1:3,j),1,size(tetra_c,2)) - tetra_c;
sensor_mat_aux = sensor_mat_aux./repmat(sqrt(sum(sensor_mat_aux.^2)),3,1);
sensor_mat_aux_2 = repmat(sensors(7:9,j),1,size(tetra_c,2));
sensor_mat_aux = sensor_mat_aux_2 - 3*repmat(dot(sensor_mat_aux,sensor_mat_aux_2),3,1).*sensor_mat_aux;
cross_mat = cross(cross_mat_aux, sensor_mat_aux); 
power_vec = sqrt(sum(sensor_mat_aux.^2));
power_vec = (power_vec.^2).*power_vec;
dot_vec = dot(cross_mat,repmat(sensors(4:6,j),1,size(tetra_c,2)))./(3*power_vec);
b_vec = zeros(N,1);
for b_vec_ind = 1 : K2
    b_vec(tetrahedra(b_vec_ind,i)) = b_vec(tetrahedra(b_vec_ind,i))+ dot_vec(b_vec_ind);
end
    %b_vec = sparse(tetrahedra(:,i),ones(K2,1),dot_vec',N,1);
B(:,j) = B(:,j) + b_vec; 

load_vec_count = load_vec_count + 1;
if mod(load_vec_count, floor(4*L/50))==0
time_val = toc;
waitbar(load_vec_count/(4*L),h,['MEG load vectors. Ready approx: ' datestr(datevec(now+(4*L/load_vec_count - 1)*time_val/86400)) '.']);
end

end
end

time_val = toc;
waitbar(1,h,['MEG load vectors. Ready approx: ' datestr(datevec(now+(4*L/i - 1)*time_val/86400)) '.']);

close(h);
h=waitbar(0,'System matrices.')

for i = 1 : 4 
    
grad_1 = cross(nodes(tetrahedra(:,ind_m(i,2)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)', nodes(tetrahedra(:,ind_m(i,3)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)')/2;  
grad_1 = repmat(sign(dot(grad_1,(nodes(tetrahedra(:,i),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)'))),3,1).*grad_1;   



for j = i : 4
    
if i == j
grad_2 = grad_1;
else
grad_2 = cross(nodes(tetrahedra(:,ind_m(j,2)),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)', nodes(tetrahedra(:,ind_m(j,3)),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)')/2;  
grad_2 = repmat(sign(dot(grad_2,(nodes(tetrahedra(:,j),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)'))),3,1).*grad_2;
end

entry_vec = zeros(1,size(tetrahedra,1));
for k = 1 : 6
   switch k 
       case 1
           k_1 = 1;
           k_2 = 1;
       case 2
           k_1 = 2; 
           k_2 = 2;
       case 3
           k_1 = 3;
           k_2 = 3;
       case 4
           k_1 = 1;
           k_2 = 2;
       case 5
           k_1 = 1;
           k_2 = 3;
       case 6 
           k_1 = 2;
           k_2 = 3;
end

if k <= 3
entry_vec = entry_vec + sigma_tetrahedra(k,:).*grad_1(k_1,:).*grad_2(k_2,:)./(9*tilavuus);
else
entry_vec = entry_vec + sigma_tetrahedra(k,:).*(grad_1(k_1,:).*grad_2(k_2,:) + grad_1(k_2,:).*grad_2(k_1,:))./(9*tilavuus);
end

end

A_part = sparse(tetrahedra(:,i),tetrahedra(:,j), entry_vec',N,N);
clear entry_vec;

if i == j
A = A + A_part;
else
A = A + A_part ;
A = A + A_part';
end

end

waitbar_ind = waitbar_ind + 1;
waitbar(waitbar_ind/waitbar_length,h);   

end

clear A_part grad_1 grad_2 cross_mat_aux sensor_mat_aux cross_mat tetra_c dot_vec tilavuus ala sigma_tetrahedra;

if not(isempty(prisms))

ind_m = [ 4 2 3 5;
          5 3 1 6;
          6 1 2 4; 
          1 5 6 2; 
          2 6 4 3;
          3 4 5 1];
 
normal_vecs_aux = cross(nodes(prisms(:,3),:)'-nodes(prisms(:,1),:)', nodes(prisms(:,2),:)'-nodes(prisms(:,1),:)');   
ala = zeros(3,size(prisms,1));
ala(1:2,:) = [sqrt(sum((normal_vecs_aux).^2))/2; sqrt(sum((cross(nodes(prisms(:,6),:)'-nodes(prisms(:,4),:)', nodes(prisms(:,5),:)'-nodes(prisms(:,4),:)')).^2))/2];
ala(3,:) = sqrt(ala(1,:).*ala(2,:));
normal_vecs_aux = normal_vecs_aux./repmat((2*ala(1,:)),3,1);
korkeus = abs(dot(nodes(prisms(:,4),:)'-nodes(prisms(:,1),:)', normal_vecs_aux));   

int_coeffs_1 = [1/5 1/30 1/10 ; 1/20 1/20 1/15];
int_coeffs_2 = [1/18 1/18 1/18 ; 1/36 1/36 1/36];
int_coeffs_3 = [1/12 1/36 1/18];
coeff_ind_1 =            [1 1 1 2 2 2;
                          1 1 1 2 2 2;
                          1 1 1 2 2 2;
                          2 2 2 1 1 1;
                          2 2 2 1 1 1;
                          2 2 2 1 1 1];
coeff_ind_2 =            [1 2 2 1 2 2;
                          2 1 2 2 1 2;
                          2 2 1 2 2 1;
                          1 2 2 1 2 2;
                          2 1 2 2 1 2;
                          2 2 1 2 2 1];
ala_ind =                [1 1 1 2 2 2;
                          1 1 1 2 2 2;
                          1 1 1 2 2 2;
                          2 2 2 2 2 2;
                          2 2 2 2 2 2;
                          2 2 2 2 2 2];

prisms_c = (1/6)*(nodes(prisms(:,1),:)+nodes(prisms(:,2),:)+nodes(prisms(:,3),:)+nodes(prisms(:,4),:)+nodes(prisms(:,5),:)+nodes(prisms(:,6),:))';
                                         
for i = 1 : 6 
    
grad_11 = repmat(1./(dot(normal_vecs_aux,(nodes(prisms(:,i),:)'-nodes(prisms(:,ind_m(i,1)),:)'))),3,1).*normal_vecs_aux;   
grad_12 = cross(nodes(prisms(:,ind_m(i,3)),:)'-nodes(prisms(:,ind_m(i,2)),:)', nodes(prisms(:,ind_m(i,4)),:)'-nodes(prisms(:,ind_m(i,2)),:)');
grad_12 = repmat(1./dot(nodes(prisms(:,i),:)' - nodes(prisms(:,ind_m(i,2)),:)',grad_12),3,1).*grad_12;


for j = 1 : L

cross_mat_aux = zeros(size(prisms_c));
cross_mat_aux(1,:) = sigma_prisms(1,:).*grad_11(1,:) + sigma_prisms(4,:).*grad_11(2,:) + sigma_prisms(5,:).*grad_11(3,:);
cross_mat_aux(2,:) = sigma_prisms(4,:).*grad_11(1,:) + sigma_prisms(2,:).*grad_11(2,:) + sigma_prisms(6,:).*grad_11(3,:);
cross_mat_aux(3,:) = sigma_prisms(5,:).*grad_11(1,:) + sigma_prisms(6,:).*grad_11(2,:) + sigma_prisms(3,:).*grad_11(3,:);
sensor_mat_aux = repmat(sensors(1:3,j),1,size(prisms_c,2)) - prisms_c;
sensor_mat_aux = sensor_mat_aux./repmat(sqrt(sum(sensor_mat_aux.^2)),3,1);
sensor_mat_aux_2 = repmat(sensors(7:9,j),1,size(tetra_c,2));
sensor_mat_aux = sensor_mat_aux_2 - 3*repmat(dot(sensor_mat_aux,sensor_mat_aux_2),3,1).*sensor_mat_aux;
cross_mat = cross(cross_mat_aux, sensor_mat_aux);
if i <= 3  
ala_vec = (1/12)*(ala(1,:) + (ala(2,:).^2)./ala(3,:) + ala(3,:) + ala(2,:));
else
ala_vec = (1/12)*(ala(2,:) + (ala(1,:).^2)./ala(3,:) + ala(3,:) + ala(1,:));
end
power_vec = sqrt(sum(sensor_mat_aux.^2));
power_vec = (power_vec.^2).*power_vec;
dot_vec = dot(cross_mat,repmat(sensors(4:6,j),1,size(prisms_c,2))).*ala_vec.*korkeus./power_vec;  
b_vec = zeros(N,1);
for b_vec_ind = 1 : K3
    b_vec(prisms(b_vec_ind,i)) = b_vec(prisms(b_vec_ind,i))+ dot_vec(b_vec_ind);
end
%b_vec = sparse(prisms(:,i),ones(K3,1),dot_vec',N,1);
B(:,j) = B(:,j) + b_vec; 

cross_mat_aux = zeros(size(prisms_c));
cross_mat_aux(1,:) = sigma_prisms(1,:).*grad_12(1,:) + sigma_prisms(4,:).*grad_12(2,:) + sigma_prisms(5,:).*grad_12(3,:);
cross_mat_aux(2,:) = sigma_prisms(4,:).*grad_12(1,:) + sigma_prisms(2,:).*grad_12(2,:) + sigma_prisms(6,:).*grad_12(3,:);
cross_mat_aux(3,:) = sigma_prisms(5,:).*grad_12(1,:) + sigma_prisms(6,:).*grad_12(2,:) + sigma_prisms(3,:).*grad_12(3,:);
cross_mat = cross(cross_mat_aux, sensor_mat_aux);
if i <= 3
int_coeffs_4 = [3/12 1/12 2/12];   
celse
int_coeffs_4 = [1/12 3/12 2/12];   
end
ala_vec = int_coeffs_4*ala;
power_vec = sqrt(sum(sensor_mat_aux.^2));
power_vec = (power_vec.^2).*power_vec;
dot_vec = dot(cross_mat,repmat(sensors(4:6,j),1,size(prisms_c,2))).*ala_vec.*korkeus./power_vec;  
b_vec = zeros(N,1);
for b_vec_ind = 1 : K3
    b_vec(prisms(b_vec_ind,i)) = b_vec(prisms(b_vec_ind,i))+ dot_vec(b_vec_ind);
end
%b_vec = sparse(prisms(:,i),ones(K3,1),dot_vec',N,1);
B(:,j) = B(:,j) + b_vec; 
end

for j = i : 6
    
if i == j
grad_21 = grad_11;
grad_22 = grad_12;
else
grad_21 = repmat(1./(dot(normal_vecs_aux,(nodes(prisms(:,j),:)'-nodes(prisms(:,ind_m(j,1)),:)'))),3,1).*normal_vecs_aux;  
grad_22 = cross(nodes(prisms(:,ind_m(j,3)),:)'- nodes(prisms(:,ind_m(j,2)),:)', nodes(prisms(:,ind_m(j,4)),:)'-nodes(prisms(:,ind_m(j,2)),:)');
grad_22 = repmat(1./dot(nodes(prisms(:,j),:)' - nodes(prisms(:,ind_m(j,2)),:)',grad_22),3,1).*grad_22;
end

entry_vec = zeros(1,size(prisms,1));

for ell = 1 : 4
    
    grad_vec_aux = zeros(size(entry_vec));

    for k = 1 : 6
   switch k 
       case 1
           k_1 = 1;
           k_2 = 1;
       case 2
           k_1 = 2; 
           k_2 = 2;
       case 3
           k_1 = 3;
           k_2 = 3;
       case 4
           k_1 = 1;
           k_2 = 2;
       case 5
           k_1 = 1;
           k_2 = 3;
       case 6 
           k_1 = 2;
           k_2 = 3;
end

    if k <= 3
    switch ell  
        case 1
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*grad_11(k_1,:).*grad_21(k_2,:); 
        case 2
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*grad_11(k_1,:).*grad_22(k_2,:); 
        case 3
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*grad_12(k_1,:).*grad_21(k_2,:); 
        case 4
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*grad_12(k_1,:).*grad_22(k_2,:); 
    end
    else
           switch ell  
        case 1
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*(grad_11(k_1,:).*grad_21(k_2,:) + grad_11(k_2,:).*grad_21(k_1,:)); 
        case 2
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*(grad_11(k_1,:).*grad_22(k_2,:) + grad_11(k_2,:).*grad_22(k_1,:)); 
        case 3
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*(grad_12(k_1,:).*grad_21(k_2,:) + grad_12(k_2,:).*grad_21(k_1,:)); 
        case 4
           grad_vec_aux = grad_vec_aux + sigma_prisms(k,:).*(grad_12(k_1,:).*grad_22(k_2,:) + grad_12(k_2,:).*grad_22(k_1,:)); 
    end
  end  
  
end
  
      switch ell  

        case 1
           entry_vec = entry_vec + grad_vec_aux.*(int_coeffs_2(coeff_ind_2(i,j),:)*ala).*korkeus; 
        case 2
           coeff_perm = [ala_ind(1,j) mod(ala_ind(1,j),2)+1 3]; 
           entry_vec = entry_vec + grad_vec_aux.*(int_coeffs_3(coeff_perm)*ala).*korkeus; 
        case 3
           coeff_perm = [ala_ind(1,i) mod(ala_ind(1,i),2)+1 3]; 
           entry_vec = entry_vec + grad_vec_aux.*(int_coeffs_3(coeff_perm)*ala).*korkeus; 
        case 4
            coeff_perm = [ala_ind(i,j) mod(ala_ind(i,j),2)+1 3]; 
            entry_vec = entry_vec + grad_vec_aux.*(int_coeffs_1(coeff_ind_1(i,j),coeff_perm)*ala).*korkeus; 
    
      end
  
end  

A_part = sparse(prisms(:,i),prisms(:,j), entry_vec',N,N);

if i == j
A = A + A_part;
else
A = A + A_part ;
A = A + A_part';
end

end

waitbar_ind = waitbar_ind + 1;
waitbar(waitbar_ind/waitbar_length,h);   

end

clear A_part grad_11 grad_12 grad_21 grad_22 ala prisms_c cross_mat cross_mat_aux sensor_mat_aux ala_vec dot_vec korkeus prisms sigma_prisms grad_vec_aux entry_vec;

end

A(zero_ind,:) = 0;
A(:,zero_ind) = 0;
A(zero_ind,zero_ind) = 1;

if isequal(permutation,'symamd')
perm_vec = symamd(A)';
elseif isequal(permutation,'symmmd')
perm_vec = symmmd(A)';   
elseif isequal(permutation,'symrcm')
perm_vec = symrcm(A)';   
else
perm_vec = [1:N]';     
end
iperm_vec = sortrows([ perm_vec [1:N]' ]);
iperm_vec = iperm_vec(:,2);
A_aux = A(perm_vec,perm_vec);
A = A_aux;
clear A_aux;


%Form G_fi and T_fi
%*******************************
%*******************************

%An auxiliary matrix for picking up the correct nodes from tetrahedra
ind_m = [ 2 3 4 ;
    3 4 1 ;
    4 1 2 ;
    1 2 3 ];

% Next find nodes that share a face 
Ind_cell = cell(1,3);

for i = 1 : 4
    % Find the global node indices for each tetrahedra
    % that correspond to indices ind_m(i,:) and set them to increasing order 
    Ind_mat_fi_1 = sort(tetrahedra(brain_ind,ind_m(i,:)),2);
    for j = i + 1 : 4
        % The same for indices ind_m(j,:)
        Ind_mat_fi_2 = sort(tetrahedra(brain_ind,ind_m(j,:)),2);
        % Set both matrices in one variable, including element index and which node it corresponds
        Ind_mat = sortrows([ Ind_mat_fi_1 brain_ind(:) i*ones(K,1) ; Ind_mat_fi_2 brain_ind(:) j*ones(K,1) ]);
        % Find the rows that have the same node indices, i.e. share a face
        I = find(sum(abs(Ind_mat(1:end-1,1:3)-Ind_mat(2:end,1:3)),2)==0);
        Ind_cell{i}{j} = [ Ind_mat(I,4) Ind_mat(I+1,4)  Ind_mat(I,5) Ind_mat(I+1,5) ]; %% Make this better
        
    end
end

clear Ind_mat_fi_1 Ind_mat_fi_2;
% Set the node indices and element indices in one matrix
Ind_mat = [ Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; Ind_cell{2}{3} ; Ind_cell{2}{4} ; Ind_cell{3}{4} ];
clear Ind_cell;
% Drop the double and triple rows 
[Ind_mat_fi_2,I] = unique(Ind_mat(:,1:2),'rows'); 
clear Ind_mat_fi_2;
Ind_mat = Ind_mat(I,:);
% Here we check that all of the elements were from brain layer
Ind_mat = Ind_mat(find(sum(ismember(Ind_mat(:,1:2),brain_ind),2)),:);

M_fi = size(Ind_mat,1);
%D = sparse([Ind_mat(:,1) ; Ind_mat(:,2)], repmat([1:M]',2,1), [ones(M,1) ; -ones(M,1)], K2, M);

% Set nodes that share the face 
tetrahedra_aux_ind_1 = sub2ind([K2 4], Ind_mat(:,1), Ind_mat(:,3));
nodes_aux_vec_1 = nodes(tetrahedra(tetrahedra_aux_ind_1),:);
tetrahedra_aux_ind_2 = sub2ind([K2 4], Ind_mat(:,2), Ind_mat(:,4));
nodes_aux_vec_2 = nodes(tetrahedra(tetrahedra_aux_ind_2),:);

%fi_source locations, moments and directions
fi_source_directions = (nodes_aux_vec_2 - nodes_aux_vec_1);
fi_source_moments = sqrt(sum(fi_source_directions.^2,2));
fi_source_directions = fi_source_directions./repmat(sqrt(sum(fi_source_directions.^2,2)),1,3);
fi_source_locations = (1/2)*(nodes_aux_vec_1 + nodes_aux_vec_2);

clear nodes_aux_vec_1 nodes_aux_vec_2;

% Formulate matrix G
G_fi = sparse([tetrahedra(tetrahedra_aux_ind_1) ; tetrahedra(tetrahedra_aux_ind_2)], ...
    repmat([1:M_fi]',2,1),[1./fi_source_moments(:) ; -1./fi_source_moments(:)],N,M_fi);
T_fi = sparse(repmat([1:M_fi]',2,1),[Ind_mat(:,1);Ind_mat(:,2)],ones(2*M_fi,1), M_fi, K2);   

clear I tetrahedra_aux_ind_1 tetrahedra_aux_ind_2;

%Form G_ew and T_ew
if source_model == 2
%*******************************
%*******************************

for i = 1 : 4 
for j = i + 1 : 4
Ind_cell{i}{j} = [ brain_ind(:) tetrahedra(brain_ind(:),i)  tetrahedra(brain_ind(:),j) ];
end 
end

Ind_mat = [ Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; Ind_cell{2}{3} ; Ind_cell{2}{4} ; Ind_cell{3}{4} ];
clear Ind_cell;
%[Ind_mat] = unique(Ind_mat,'rows'); 
%Ind_mat = Ind_mat(find(ismember(Ind_mat(:,1),brain_ind)),:);  

Ind_mat(:,2:3) = sort(Ind_mat(:,2:3), 2);
[edge_ind, edge_ind_aux_1, edge_ind_aux_2] = unique(Ind_mat(:,2:3),'rows');

ew_source_directions = nodes(edge_ind(:,2),:) - nodes(edge_ind(:,1),:);
ew_source_moments = sqrt(sum(ew_source_directions.^2,2));
ew_source_directions = ew_source_directions./repmat(sqrt(sum(ew_source_directions.^2,2)),1,3);

ew_source_locations = (1/2)*(nodes(edge_ind(:,1),:) + nodes(edge_ind(:,2),:));

clear nodes_aux_vec_1 nodes_aux_vec_2;

ones_aux = ones(size(ew_source_moments)); 
M_ew = size(edge_ind,1);
G_ew = sparse([edge_ind(:,1)  ; edge_ind(:,2)],repmat([1:M_ew]',2,1),[1./(ew_source_moments) ; -1./(ew_source_moments)],N,M_ew);

T_ew = sparse(edge_ind_aux_2, Ind_mat(:,1), ones(length(edge_ind_aux_2),1), M_ew, K2);
clear I tetrahedra_aux_ind_1 tetrahedra_aux_ind_2;

%*******************************
%*******************************
end

L_meg_fi = zeros(L,M_fi); 
for j = 1 : L
sensor_mat_aux = cross(fi_source_directions', repmat(sensors(1:3,j),1,M_fi) - fi_source_locations'); 
sensor_mat_aux = sensor_mat_aux./repmat(sqrt(sum(sensor_mat_aux.^2)),3,1);
sensor_mat_aux_2 = repmat(sensors(7:9,j),1,size(tetra_c,2));
cross_mat = sensor_mat_aux_2 - 3*repmat(dot(sensor_mat_aux,sensor_mat_aux_2),3,1).*sensor_mat_aux;
power_vec = sqrt(sum((repmat(sensors(1:3,j),1,M_fi) - fi_source_locations').^2));
power_vec = (power_vec.^2).*power_vec;
L_meg_fi(j,:) = dot(cross_mat,repmat(sensors(4:6,j),1,M_fi))./power_vec;
end

if source_model == 2
L_meg_ew = zeros(L,M_ew); 
for j = 1 : L
sensor_mat_aux = cross(ew_source_directions', repmat(sensors(1:3,j),1,M_ew) - ew_source_locations'); 
sensor_mat_aux = sensor_mat_aux./repmat(sqrt(sum(sensor_mat_aux.^2)),3,1);
sensor_mat_aux_2 = repmat(sensors(7:9,j),1,size(tetra_c,2));
cross_mat = sensor_mat_aux_2 - 3*repmat(dot(sensor_mat_aux,sensor_mat_aux_2),3,1).*sensor_mat_aux;
power_vec = sqrt(sum((repmat(sensors(1:3,j),1,M_ew) - ew_source_locations').^2));
power_vec = (power_vec.^2).*power_vec;
L_meg_ew(j,:) = dot(cross_mat,repmat(sensors(4:6,j),1,M_ew))./power_vec;
end
end

clear cross_mat;

close(h);
h = waitbar(0,'PCG iteration.');

if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0
precond_vec = gpuArray(1./full(diag(A)));
A = gpuArray(A);

relres_vec = zeros(1,L);
tic;
for i = 1 : L
b = B(:,i);
b(zero_ind) = 0;

x = zeros(N,1);
norm_b = norm(b);
r = b(perm_vec);
p = gpuArray(r); 
m = 0;
x = gpuArray(x); 
r = gpuArray(r);
p = gpuArray(p);
norm_b = gpuArray(norm_b);

while( (norm(r)/norm_b > tol_val) & (m < m_max))
  a = A * p;
  a_dot_p = sum(a.*p);
  aux_val = sum(r.*p);
  lambda = aux_val ./ a_dot_p;
  x = x + lambda * p;
  r = r - lambda * a;
  inv_M_r = precond_vec.*r;
  aux_val = sum(inv_M_r.*a);
  gamma = aux_val ./ a_dot_p;
  p = inv_M_r - gamma * p;
  m=m+1;
end
relres_vec(i) = gather(norm(r)/norm_b);
r = gather(x(iperm_vec));
x = r;
L_meg_fi(i,:) = L_meg_fi(i,:) + x'*G_fi;
if source_model == 2
L_meg_ew(i,:) = L_meg_ew(i,:) + x'*G_ew;
end
if tol_val < relres_vec(i)
    close(h);
    'Error: PCG iteration did not converge.'
    L_meg = [];
    return
end
time_val = toc; 
waitbar(i/L,h,['PCG iteration. Ready approx: ' datestr(datevec(now+(L/i - 1)*time_val/86400)) '.']);
end

%**************************************************************************
else

if isequal(precond,'ssor');
S1 = tril(A)*spdiags(1./sqrt(diag(A)),0,N,N);
S2 = S1';
else    
S2 = ichol(A,struct('type','nofill'));
S1 = S2'; 
end

relres_vec = zeros(1,L-1);
tic;
for i = 1 : L
b = B(:,i);
b(zero_ind) = 0;
x = zeros(N,1);
norm_b = norm(b);
r = b(perm_vec);
aux_vec = S1 \ r;
p = S2 \ aux_vec;
m = 0;
while( (norm(r)/norm_b > tol_val) & (m < m_max))
  a = A * p;
  a_dot_p = sum(a.*p);
  aux_val = sum(r.*p);
  lambda = aux_val ./ a_dot_p;
  x = x + lambda * p;
  r = r - lambda * a;
  aux_vec = S1\r;
  inv_M_r = S2\aux_vec;
  aux_val = sum(inv_M_r.*a);
  gamma = aux_val ./ a_dot_p;
  p = inv_M_r - gamma * p;
  m=m+1;
end
relres_vec(i) = norm(r)/norm_b;
r = x(iperm_vec);
x = r;
L_meg_fi(i,:) = L_meg_fi(i,:) + x'*G_fi; 
if source_model == 2
L_meg_ew(i,:) = L_meg_ew(i,:) + x'*G_ew;
end 
if tol_val < relres_vec(i)
    close(h);
    'Error: PCG iteration did not converge.'
    L_meg = [];
    return
end
time_val = toc; 
waitbar(i/L,h,['PCG iteration. Ready approx: ' datestr(datevec(now+(L/i - 1)*time_val/86400)) '.']);
end
end
clear S r p x aux_vec inv_M_r a b;
close(h);

waitbar_ind = 0;

h = waitbar(waitbar_ind/waitbar_length,'Interpolation.');
Aux_mat_2 = eye(L,L) - (1/L)*ones(L,L);
L_meg_fi = Aux_mat_2*L_meg_fi/(4*pi);
if source_model == 2
L_meg_ew = Aux_mat_2*L_meg_ew/(4*pi);
end

if isequal(lower(direction_mode),'cartesian')  || isequal(lower(direction_mode),'normal')

if evalin('base','zef.surface_sources')
source_nonzero_ind = full(find(sum(T_fi)>=0))';
else
source_nonzero_ind = full(find(sum(T_fi)>=4))';
end
source_nonzero_ind = intersect(source_nonzero_ind,source_ind);
M2 = size(source_nonzero_ind,1);
else
aux_rand_perm = randperm(length(fi_source_locations));
aux_rand_perm = aux_rand_perm(1:evalin('base','zef.n_sources'));    
dipole_directions = fi_source_directions(aux_rand_perm,:);
dipole_locations = fi_source_locations(aux_rand_perm,:);
L_meg = L_meg_fi(:,aux_rand_perm);
end


if isequal(lower(direction_mode),'cartesian') || isequal(lower(direction_mode),'normal')

c_tet = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
dipole_locations = c_tet(source_nonzero_ind,:);
dipole_directions = [];
L_meg = zeros(L,3*M2);

if source_model == 2

tic;
    for i = 1 : M2

        ind_vec_aux_fi = full(find(T_fi(:,source_nonzero_ind(i))));
        ind_vec_aux_ew = full(find(T_ew(:,source_nonzero_ind(i))));
        n_coeff_fi = length(ind_vec_aux_fi);
        n_coeff_ew = length(ind_vec_aux_ew);
        n_coeff = n_coeff_fi + n_coeff_ew;
        Aux_mat_1 = [fi_source_directions(ind_vec_aux_fi,:) ; ew_source_directions(ind_vec_aux_ew,:)];
        Aux_mat_2 = [fi_source_locations(ind_vec_aux_fi,:) ; ew_source_locations(ind_vec_aux_ew,:)];
        omega_vec = sqrt(sum((Aux_mat_2 - c_tet(source_nonzero_ind(i)*ones(n_coeff,1),:)).^2,2));
        PBO_mat = [diag(omega_vec) Aux_mat_1; Aux_mat_1' zeros(3,3)];
        Coeff_mat = PBO_mat\[zeros(n_coeff,3); eye(3)];
        L_meg(:,3*(i-1)+1:3*i) = L_meg_fi(:,ind_vec_aux_fi)*Coeff_mat(1:n_coeff_fi,:) + L_meg_ew(:,ind_vec_aux_ew)*Coeff_mat(n_coeff_fi+1:n_coeff,:) ;

if mod(i,floor(M2/50))==0 
time_val = toc;
waitbar(i/M2,h,['Interpolation. Ready approx: ' datestr(datevec(now+(M2/i - 1)*time_val/86400)) '.']);
end
end
end 

if source_model == 1
tic;
    for i = 1 : M2

        ind_vec_aux_fi = full(find(T_fi(:,source_nonzero_ind(i))));
        n_coeff_fi = length(ind_vec_aux_fi);
        n_coeff = n_coeff_fi;
        Aux_mat_1 = [fi_source_directions(ind_vec_aux_fi,:)];
        Aux_mat_2 = [fi_source_locations(ind_vec_aux_fi,:)];
        omega_vec = sqrt(sum((Aux_mat_2 - c_tet(source_nonzero_ind(i)*ones(n_coeff,1),:)).^2,2));
        PBO_mat = [diag(omega_vec) Aux_mat_1; Aux_mat_1' zeros(3,3)];
        Coeff_mat = PBO_mat\[zeros(n_coeff,3); eye(3)];
        L_meg(:,3*(i-1)+1:3*i) = L_meg_fi(:,ind_vec_aux_fi)*Coeff_mat(1:n_coeff_fi,:);

if mod(i,floor(M2/50))==0 
time_val = toc;
waitbar(i/M2,h,['Interpolation. Ready approx: ' datestr(datevec(now+(M2/i - 1)*time_val/86400)) '.']);
end
end
end

end

waitbar(1,h);

close(h);


