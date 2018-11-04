%Copyright © 2018, Sampsa Pursiainen
function [eit_data_vec] = compute_eit_data(nodes,elements,sigma,electrodes,varargin) 

N = size(nodes,1);

if iscell(elements)
        tetrahedra = elements{1};
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
        if length(elements)>1
        prisms = elements{2};
        waitbar_length = 10;
        end
    else
        tetrahedra = elements;
        prisms = [];
        K2 = size(tetrahedra,1);
        waitbar_length = 4;
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

    tol_val = 1e-6;
    m_max = 3*floor(sqrt(N));
    precond = 'cholinc';
    permutation = 'symamd';
    direction_mode = 'mesh based';
    dipole_mode = 1;
    brain_ind = [1:size(tetrahedra,1)]'; 
    source_ind = [1:size(tetrahedra,1)]';   
    cholinc_tol = 1e-3;
    if size(electrodes,2) == 4
    electrode_model = 'CEM';    
    L = max(electrodes(:,1));
    ele_ind = electrodes;
    impedance_vec = ones(max(electrodes(:,1)),1);
    impedance_inf = 1;
    else 
    electrode_model = 'PEM';
    L = size(electrodes,1);
    ele_ind = zeros(L,1);
    for i = 1 : L
    [min_val, min_ind] = min(sum((repmat(electrodes(i,:),N,1)' - nodes').^2));   
    ele_ind(i) = min_ind; 
    end      
    end
    
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
    if isfield(varargin{n_varargin},'impedances') & size(electrodes,2) == 4;
    if length(varargin{n_varargin}.impedances)==1;
    impedance_vec = varargin{n_varargin}.impedances*ones(max(electrodes(:,1)),1);
    impedance_inf = 0;
    else
    impedance_vec = varargin{n_varargin}.impedances;   
    impedance_inf = 0;
    end
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
    K3 = length(source_ind);
    clear electrodes;
    A = spalloc(N,N,0);
    D_A = zeros(K,10);

Aux_mat = [nodes(tetrahedra(:,1),:)'; nodes(tetrahedra(:,2),:)'; nodes(tetrahedra(:,3),:)'] - repmat(nodes(tetrahedra(:,4),:)',3,1); 
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;
clear Aux_mat;
      
roi_ind_vec = [];
  
roi_sphere = evalin('base', 'zef.inv_roi_sphere');
roi_perturbation = evalin('base', 'zef.inv_roi_perturbation');
center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
r_roi = (roi_sphere(:,4)/1000); 
c_roi = (roi_sphere(:,1:3)/1000)';

for j = 1 : size(roi_sphere,1)

r_aux = find(sqrt(sum((center_points'-c_roi(:,j*ones(1,size(center_points,1)))).^2))<=r_roi(j));
sigma_tetrahedra(1:3,r_aux) =  sigma_tetrahedra(1:3,r_aux) + roi_perturbation(j);

end

ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ; 
          1 2 3 ];

h=waitbar(0,'System matrices.');     
waitbar_ind = 0;

D_A_count = 0;
for i = 1 : 4 
    
grad_1 = cross(nodes(tetrahedra(:,ind_m(i,2)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)', nodes(tetrahedra(:,ind_m(i,3)),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)')/2;  
grad_1 = repmat(sign(dot(grad_1,(nodes(tetrahedra(:,i),:)'-nodes(tetrahedra(:,ind_m(i,1)),:)'))),3,1).*grad_1;   

for j = i : 4
    
D_A_count = D_A_count + 1;    
    
if i == j
grad_2 = grad_1;
else
grad_2 = cross(nodes(tetrahedra(:,ind_m(j,2)),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)', nodes(tetrahedra(:,ind_m(j,3)),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)')/2;  
grad_2 = repmat(sign(dot(grad_2,(nodes(tetrahedra(:,j),:)'-nodes(tetrahedra(:,ind_m(j,1)),:)'))),3,1).*grad_2;
end

entry_vec = zeros(1,size(tetrahedra,1));
entry_vec_2 = zeros(1,size(tetrahedra,1));
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
entry_vec_2 = entry_vec_2 + grad_1(k_1,:).*grad_2(k_2,:)./(9*tilavuus);

else
entry_vec = entry_vec + sigma_tetrahedra(k,:).*(grad_1(k_1,:).*grad_2(k_2,:) + grad_1(k_2,:).*grad_2(k_1,:))./(9*tilavuus);
entry_vec_2 = entry_vec_2 + grad_1(k_1,:).*grad_2(k_2,:)./(9*tilavuus);
end

end

D_A(:, D_A_count) = D_A(:, D_A_count) + entry_vec_2(brain_ind)'; 

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

clear A_part grad_1 grad_2 tilavuus ala sigma_tetrahedra;

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

for i = 1 : 6 
    
grad_11 = repmat(1./(dot(normal_vecs_aux,(nodes(prisms(:,i),:)'-nodes(prisms(:,ind_m(i,1)),:)'))),3,1).*normal_vecs_aux;   
grad_12 = cross(nodes(prisms(:,ind_m(i,3)),:)'-nodes(prisms(:,ind_m(i,2)),:)', nodes(prisms(:,ind_m(i,4)),:)'-nodes(prisms(:,ind_m(i,2)),:)');
grad_12 = repmat(1./dot(nodes(prisms(:,i),:)' - nodes(prisms(:,ind_m(i,2)),:)',grad_12),3,1).*grad_12;

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

clear A_part grad_11 grad_12 grad_21 grad_22 ala korkeus prisms sigma_prisms grad_vec_aux entry_vec;

end

if isequal(electrode_model,'CEM')

ala = sqrt(sum(cross(nodes(ele_ind(:,3),:)'-nodes(ele_ind(:,2),:)', nodes(ele_ind(:,4),:)'-nodes(ele_ind(:,2),:)').^2))/2;

for i  = 1 : L    
I = find(ele_ind(:,1) == i);
impedance_vec(i)= i*sum(ala(I)); 
end    

B = spalloc(N,L,0);    
C = spalloc(L,L,0); 

entry_vec = (1./impedance_vec(ele_ind(:,1))).*ala';

for i = 1 : 3

B = B + sparse(ele_ind(:,i+1), ele_ind(:,1), -(1/3)*entry_vec, N, L);         

end

if impedance_inf == 0
for  i = 1 : 3   
for j = i : 3 
if i == j
A_part = sparse(ele_ind(:,i+1),ele_ind(:,j+1),(1/6)*entry_vec,N,N);
A = A + A_part; 
else
A_part = sparse(ele_ind(:,i+1),ele_ind(:,j+1),(1/12)*entry_vec,N,N);
A = A + A_part;
A = A + A_part';
end
end
end
else 
    
ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ; 
          1 2 3 ];    
      
I_aux_1 = ele_ind(find(ele_ind(:,1) == 1),2:4);
I_aux_2 = find(sum(ismember(tetrahedra,I_aux_1),2));
faces_aux_1 = sort([tetrahedra(I_aux_2,ind_m(1,:)) ; tetrahedra(I_aux_2,ind_m(2,:)); tetrahedra(I_aux_2,ind_m(3,:));tetrahedra(I_aux_2,ind_m(4,:))],2);
I_aux_2 = find(sum(ismember(prisms,I_aux_1),2));
faces_aux_2 = [];
if not(isempty(prisms))
faces_aux_2 = sort([prisms(I_aux_2,[1 2 3]) ; prisms(I_aux_2,[4 5 6])],2);
end
faces_aux = sortrows([faces_aux_1 ; faces_aux_2]);
faces_aux = faces_aux(find(sum(ismember(faces_aux,I_aux_1),2)),:);
I_aux_2 = find(sum(faces_aux(1:end-1,:)-faces_aux(2:end,:),2)==0);
faces_aux_2 = setdiff(faces_aux,faces_aux(I_aux_2,:),'rows');
I_aux_1 = setdiff(reshape(faces_aux,size(faces_aux,1)*3,1),reshape(ele_ind(:,2:4),size(ele_ind,1)*3,1));
zero_ind = I_aux_1(1);

clear I_aux_1 I_aux_2 faces_aux_1 faces_aux_2 faces_aux;

A(:,zero_ind) = 0;
A(zero_ind,:) = 0;
A(zero_ind,zero_ind) =  1; 

end

C = sparse(ele_ind(:,1), ele_ind(:,1), entry_vec, L, L);

end 

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
clear A_aux A_part;

close(h);
h = waitbar(0,'PCG iteration.');

if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0
gpuDevice(evalin('base','zef.gpu_num'));
precond_vec = gpuArray(1./full(diag(A)));
A = gpuArray(A);

if isequal(electrode_model,'CEM')
Aux_mat = zeros(L); 
tol_val_eff = tol_val;
relres_vec = gpuArray(zeros(1,L));
else
relres_vec = gpuArray(zeros(1,L-1));
end

L_eit = zeros(L,N);

tic;

for i = 1 : L
if isequal(electrode_model,'CEM')    
b = full(B(:,i));
tol_val = min(impedance_vec(i),1)*tol_val_eff;
end

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

if isequal(electrode_model,'CEM')
L_eit(i,:) = - x;
end
if isequal(electrode_model,'CEM')
if impedance_inf == 0
Aux_mat(:,i) = C(:,i) - B'*x;
else
Aux_mat(:,i) = C(:,i);
end
end
if tol_val < relres_vec(i)
    close(h);
    'Error: PCG iteration did not converge.'
    L_eit = [];
    return
end
time_val = toc; 
if isequal(electrode_model,'PEM')
waitbar(i/(L-1),h,['PCG iteration. Ready approx: ' datestr(datevec(now+((L-1)/i - 1)*time_val/86400)) '.']);
end
if isequal(electrode_model,'CEM')
waitbar(i/L,h,['PCG iteration. Ready approx: ' datestr(datevec(now+(L/i - 1)*time_val/86400)) '.']);
end
end

%******************************************
else

if isequal(precond,'ssor');
S1 = tril(A)*spdiags(1./sqrt(diag(A)),0,N,N);
S2 = S1';
else    
S2 = ichol(A,struct('type','nofill'));
S1 = S2'; 
end
if isequal(electrode_model,'CEM')
Aux_mat = zeros(L); 
tol_val_eff = tol_val;
relres_vec = zeros(1,L);
else
relres_vec = zeros(1,L-1);
end

L_eit = zeros(L,N);

tic;
for i = 1 : L
if isequal(electrode_model,'CEM')    
b = full(B(:,i));
tol_val = min(impedance_vec(i),1)*tol_val_eff;
end

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
if isequal(electrode_model,'CEM')
L_eit(i,:) = x';
end
if isequal(electrode_model,'CEM')
if impedance_inf == 0
Aux_mat(:,i) = C(:,i) - B'*x;
else
Aux_mat(:,i) = C(:,i);    
end
end
if tol_val < relres_vec(i)
    close(h);
    'Error: PCG iteration did not converge.'
    L_eit = [];
    return
end
time_val = toc; 
if isequal(electrode_model,'PEM')
waitbar(i/(L-1),h,['PCG iteration. Ready approx: ' datestr(datevec(now+((L-1)/i - 1)*time_val/86400)) '.']);
end
if isequal(electrode_model,'CEM')
waitbar(i/L,h,['PCG iteration. Ready approx: ' datestr(datevec(now+(L/i - 1)*time_val/86400)) '.']);
end
end

end

clear S r p x aux_vec inv_M_r a b;
close(h);

Current_pattern = evalin('base','zef.current_pattern');

if isequal(electrode_model,'CEM')
eit_data_vec = Aux_mat \ Current_pattern;
end

Aux_mat_2 = eye(L,L) - (1/L)*ones(L,L);
eit_data_vec = Aux_mat_2 * eit_data_vec;

eit_data_vec = eit_data_vec(:);
bg_data = evalin('base','zef.inv_bg_data'); 
eit_data_vec = eit_data_vec - bg_data;
eit_noise = evalin('base','zef.inv_eit_noise');
eit_data_vec = eit_data_vec + eit_noise*randn(size(eit_data_vec));

end