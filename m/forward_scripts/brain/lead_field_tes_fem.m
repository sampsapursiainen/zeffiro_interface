% %%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [L_tes, S_tes, dof_positions, dof_directions, dof_ind, dof_count] = lead_field_tes_fem(nodes,elements,sigma,electrodes,varargin)
% 17.6.2020
% Sentence used:
%
% source_ind = randperm(size(zef.brain_ind,1)); source_ind = source_ind(1:zef.n_sources);
% sensors = zef_attach_sensors_volume(zef.sensors);
% var_arg.impedances = 1000;
% [L_tes, S_tes, dof_ind, dof_count] = lead_field_tes_fem(zef.nodes,zef.tetra,zef.sigma(:,1),sensors,zef.brain_ind,source_ind,var_arg);
% zef.reconstruction = reshape(L_tes(:,50)',3,2000);
%
% function [L_eeg, source_locations, source_directions] = lead_field_eeg_fem(nodes,elements,sigma,electrodes,brain_ind,source_ind,additional_options)
%
% Input:
% ------
% - nodes              = N x 3
% - elements           = M x 4
% - sigma              = M x 1 (or M x 6, one row: sigma_11 sigma_22 sigma_33 sigma_12 sigma_13 sigma_23)
% - electrodes         = L x 3
% - brain_ind          = P x 1 (The set of elements that potentially contain source currents, by default contains all elements)
% - source_ind         = R x 1 (The set of elements that are allowed to contain source currents, a subset of brain_ind, by default equal to brain_ind)
% - additional_options = Struct, see below
%
% Fields of additional_options:
% -----------------------------
%
% - additional_options.direction_mode: Source directions; Values: 'mesh based' (default) or 'Cartesian' (optional).
%   Note: If Cartesian directions are used, the columns of the lead field matrix correspond
%   to directions x y z x y z x y z ..., respectively.
% - additional_options.precond: Preconditioner type; Values: 'cholinc' (Incomplete Cholesky, default) or 'ssor' (SSOR, optional)
% - additional_options.cholinc_tol: Tolerance of the Incomplete Cholesky; Values: Numeric (default is 0.001) or '0' (complete Cholesky)
% - additional_options.pcg_tol: Tolerance of the PCG iteration; Values: Numeric (default is 1e-6)
% - additional_options.maxit: Maximum number of PCG iteration steps; Values: Numeric (default is 3*floor(sqrt(N)))
% - additional_options.dipole_mode: Element-wise source direction mode; Values: '1' (direction of the dipole moment, default) or '2' (line segment between nodes 4 and 5 with the numbering given in Pursiainen et al 2011)
% - additional_options.permutation: Permutation of the linear system; Values: 'symamd' (default), 'symmmd' (optional), 'symrcm' (optional), or 'none' (optional)
%
% Output:
% -------
% - L_eeg              = L x K
% - source_locations   = K x 3 (or K/3 x 3, if Cartesian are used)
% - source_directions  = K x 3
%N
N = size(nodes,1);
source_model = evalin('base','zef.source_model');

% ifcell - elements part
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

% ifcell - sigma part
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

% CEM or PEM part
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
    impedance_inf = 1;%%
    impedance_vec = ones(size(electrodes,1),1);%%

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

% struct of
if n_varargin >= 1
    if isstruct(varargin{n_varargin})
        if isfield(varargin{n_varargin},'pcg_tol')
            tol_val = varargin{n_varargin}.pcg_tol;
        end

        if  isfield(varargin{n_varargin},'maxit')
            m_max = varargin{n_varargin}.maxit;
        end

        if isfield(varargin{n_varargin},'precond')
            precond = varargin{n_varargin}.precond;
        end

        if isfield(varargin{n_varargin},'direction_mode')
            direction_mode = varargin{n_varargin}.direction_mode;
        end

        if isfield(varargin{n_varargin},'dipole_mode')
            dipole_mode = varargin{n_varargin}.dipole_mode;
        end

        if isfield(varargin{n_varargin},'impedances') && size(electrodes,2) == 4
            if length(varargin{n_varargin}.impedances) == 1
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

% K
K = length(brain_ind);
K3 = length(source_ind);
clear electrodes;

% A
A = spalloc(N,N,0);

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);

clear Aux_mat;

h = waitbar(0,'System matrices.');
waitbar_ind = 0;

for i = 1 : 4
    grad_1 = zef_volume_gradient(nodes, tetrahedra, i);
    for j = i : 4
        if i == j
            grad_2 = grad_1;
        else
            grad_2 = zef_volume_gradient(nodes, tetrahedra, j);
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
clear A_part grad_1 grad_2 ala;

% coefficients
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
    % korkeus = height

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

    I_triangles = find(ele_ind(:,4)>0);
    ala = zeros(1,size(ele_ind,1));
    ala(I_triangles) = sqrt(sum(cross(nodes(ele_ind(I_triangles,3),:)'-nodes(ele_ind(I_triangles,2),:)', nodes(ele_ind(I_triangles,4),:)'-nodes(ele_ind(I_triangles,2),:)').^2))/2;

    B = spalloc(N,L,0);
    C = spalloc(L,L,0);

      for ele_loop_ind  = 1 : L
        I = find(ele_ind(:,1) == ele_loop_ind);
        sum_ala = sum(ala(I));
        if sum_ala > 0
        impedance_vec(ele_loop_ind) = impedance_vec(ele_loop_ind)*sum_ala;
        else
         for i = 1 : length(I)
             B(ele_ind(I(i),2), ele_ind(I(i),1)) = B(ele_ind(I(i),2), ele_ind(I(i),1)) +ele_ind(I(i),3)./impedance_vec(ele_loop_ind);  %
            for j = 1 : length(I)
                    A(ele_ind(I(i),2),ele_ind(I(j),2)) = A(ele_ind(I(i),2),ele_ind(I(j),2)) + ele_ind(I(i),3)*ele_ind(I(j),3)./impedance_vec(ele_loop_ind);
            end
         end
        C(ele_loop_ind, ele_loop_ind) = 1./impedance_vec(ele_loop_ind);
        end
       end

    entry_vec = (1./impedance_vec(ele_ind(I_triangles,1))).*ala(I_triangles)';
    for i = 1 : 3
        B = B + sparse(ele_ind(I_triangles,i+1), ele_ind(I_triangles,1), +(1/3)*entry_vec, N, L);
    end
    if impedance_inf == 0
        for i = 1 : 3
            for j = i : 3
                if i == j
                    A_part = sparse(ele_ind(I_triangles,i+1),ele_ind(I_triangles,j+1),(1/6)*entry_vec,N,N);
                    A = A + A_part;
                else
                    A_part = sparse(ele_ind(I_triangles,i+1),ele_ind(I_triangles,j+1),(1/12)*entry_vec,N,N);
                    A = A + A_part;
                    A = A + A_part';
                end
            end
        end
    else

        'Cannot use infinite impedance for stimulation'
        return
    end

    C = C + sparse(ele_ind(I_triangles,1), ele_ind(I_triangles,1), entry_vec, L, L);

end

% 22.06.2020 Start
if isequal(electrode_model,'PEM')

    if impedance_inf == 0

    % B and C
    B = spalloc(N,L,0);
    C = spalloc(L,L,0);
    entry_vec = (1./impedance_vec(ele_ind(:,1)));
     for i = 1 : L
    B(ele_ind(i),i) = entry_vec;
    A(ele_ind(i),ele_ind(i)) = A(ele_ind(i),ele_ind(i)) + entry_vec;
     end
    C = sparse(ele_ind(:,1), ele_ind(:,1), entry_vec, L, L);

    else

    B = spalloc(N,L,0);
    C = spalloc(L,L,0);
     for i = 1 : L
    B(ele_ind(i),i) = 1;
     end
%Dirichlet boundary condition for a single node.
    A(ele_ind(1),:) = 0;
    A(:,ele_ind(1)) = 0;
    A(ele_ind(1),ele_ind(1)) = 1;
    C = eye(L);

    end
end

% 23.06.2020 - Start
Grad_1 = spalloc(K,N,0);
Grad_2 = spalloc(K,N,0);
Grad_3 = spalloc(K,N,0);

ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ;
          1 2 3 ];

 for i = 1 : 4

    grad_1 = cross(nodes(tetrahedra(brain_ind,ind_m(i,2)),:)'-nodes(tetrahedra(brain_ind,ind_m(i,1)),:)', nodes(tetrahedra(brain_ind,ind_m(i,3)),:)'-nodes(tetrahedra(brain_ind,ind_m(i,1)),:)')/6;
    grad_1 = repmat(sign(dot(grad_1,(nodes(tetrahedra(brain_ind,i),:)'-nodes(tetrahedra(brain_ind,ind_m(i,1)),:)'))),3,1).*grad_1;
    grad_1 = grad_1 ./ tilavuus(brain_ind);

    entry_vec_1 = zeros(1,size(brain_ind,1));
    entry_vec_2 = zeros(1,size(brain_ind,1));
    entry_vec_3 = zeros(1,size(brain_ind,1));
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
            switch k_1
                case 1
                    entry_vec_1 = entry_vec_1 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
                case 2
                    entry_vec_2 = entry_vec_2 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
                case 3
                    entry_vec_3 = entry_vec_3 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
            end
        else
            switch k_1
                case 1
                    entry_vec_1 = entry_vec_1 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
                case 2
                    entry_vec_2 = entry_vec_2 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
                case 3
                    entry_vec_3 = entry_vec_3 + sigma_tetrahedra(k,brain_ind).*grad_1(k_2,:);
            end
            switch k_2
                case 1
                    entry_vec_1 = entry_vec_1 + sigma_tetrahedra(k,brain_ind).*grad_1(k_1,:);
                case 2
                    entry_vec_2 = entry_vec_2 + sigma_tetrahedra(k,brain_ind).*grad_1(k_1,:);
                case 3
                    entry_vec_3 = entry_vec_3 + sigma_tetrahedra(k,brain_ind).*grad_1(k_1,:);
            end
        end
    end
    Grad_1 = Grad_1 + sparse([1:K]',tetrahedra(brain_ind,i), entry_vec_1,K,N);
    Grad_2 = Grad_2 + sparse([1:K]',tetrahedra(brain_ind,i), entry_vec_2,K,N);
    Grad_3 = Grad_3 + sparse([1:K]',tetrahedra(brain_ind,i), entry_vec_3,K,N);
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

waitbar(0,h,'PCG iteration.');

if evalin('base','zef.use_gpu')==1 && gpuDeviceCount > 0
    precond_vec = gpuArray(1./full(diag(A)));
    A = gpuArray(A);

%   if isequal(electrode_model,'CEM')
        Aux_mat = zeros(L);
        tol_val_eff = tol_val;
        relres_vec = gpuArray(zeros(1,L));
%   else
%       relres_vec = gpuArray(zeros(1,L-1));
%   end
    R_tes = zeros(size(B,1),L);
%     if source_model == 2
%         L_eeg_ew = zeros(L,M_ew);
%     end
    tic;

    for i = 1 : L
%        if isequal(electrode_model,'PEM')
%            if i == L
%                break
%            end
%           b = zeros(length(A),1);
%           b(ele_ind(i+1)) = 1;
%        end

        %if isequal(electrode_model,'CEM')

              b = full(B(:,i));
          if  isequal(electrode_model,'PEM') & impedance_inf == 1 & i==1
              b = zeros(size(b));
          end

            tol_val = min(impedance_vec(i),1)*tol_val_eff;
        %end

        x = zeros(N,1);
        norm_b = norm(b);
        r = b(perm_vec);
        p = gpuArray(r);
        m = 0;
        x = gpuArray(x);
        r = gpuArray(r);
        p = gpuArray(p);
        norm_b = gpuArray(norm_b);

        while( (norm(r)/norm_b > tol_val) && (m < m_max))
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
              m = m+1;
        end
        relres_vec(i) = gather(norm(r)/norm_b);
        r = gather(x(iperm_vec));
        x = r;
        R_tes(:,i) =  x;
%        if isequal(electrode_model,'PEM')
%           L_eeg_fi(i+1,:) = - x'*G_fi;
%           R_tes(:,i) = - x;
%           if source_model == 2
%               L_eeg_ew(i+1,:) = - x'*G_ew;
%           end
%        end

%        if isequal(electrode_model,'CEM')
%           L_eeg_fi(i,:) = - x'*G_fi;
%            R_tes(:,i) = - x;
%           if source_model == 2
%               L_eeg_ew(i,:) = - x'*G_ew;
%           end
%        end

%        if isequal(electrode_model,'CEM')
            if impedance_inf == 0
                Aux_mat(:,i) = C(:,i)-B'*x ;
            else
                Aux_mat(:,i) = C(:,i);
            end
%        end

        if tol_val < relres_vec(i)
            close(h);
            'Error: PCG iteration did not converge.'
            R_tes = [];
            return
        end

        time_val = toc;

%        if isequal(electrode_model,'CEM')
            waitbar(i/L,h,['PCG iteration. Ready: ' datestr(datevec(now+(L/i - 1)*time_val/86400)) '.']);
%        end
    end
%******************************************
else

    %******************************************************
%PCG CPU start
%******************************************************
%Define preconditioner
if isequal(precond,'ssor');
S1 = tril(A)*spdiags(1./sqrt(diag(A)),0,N,N);
S2 = S1';
else
S2 = ichol(A,struct('type','nofill'));
S1 = S2';
end

Aux_mat = zeros(L);
tol_val_eff = tol_val;

    R_tes = zeros(size(B,1),L);

%Define block size
delete(gcp('nocreate'))
parallel_processes = evalin('base','zef.parallel_processes');
parpool(parallel_processes);
processes_per_core = evalin('base','zef.processes_per_core');
tic;
block_size =  parallel_processes*processes_per_core;
for i = 1 : block_size : L
block_ind = [i : min(L,i+block_size-1)];

%Define right hand side
b = full(B(:,block_ind));
tol_val = min(impedance_vec(block_ind),1)*tol_val_eff;

if  isequal(electrode_model,'PEM') & impedance_inf == 1 & i==1
              b = zeros(size(b));
 end

%Iterate
x_block_cell = cell(0);
relres_cell = cell(0);
x_block = zeros(N,length(block_ind));
relres_vec = zeros(1,length(block_ind));
tol_val = tol_val(:)';
norm_b = sqrt(sum(b.^2));
block_iter_end = block_ind(end)-block_ind(1)+1;
[block_iter_ind] = [1 : processes_per_core : block_iter_end];
parfor block_iter = 1 : length(block_iter_ind)
 block_iter_sub = [block_iter_ind(block_iter) : min(block_iter_end,block_iter_ind(block_iter)+processes_per_core-1)];
 x = zeros(N,length(block_iter_sub));
r = b(perm_vec,block_iter_sub);
aux_vec = S1 \ r;
p = S2 \ aux_vec;
m = 0;
while( not(isempty(find(sqrt(sum(r.^2))./norm_b(block_iter_sub) > tol_val(block_iter_sub)))) & (m < m_max) )
    a = A * p;
  a_dot_p = sum(a.*p);
  aux_val = sum(r.*p);
  lambda = aux_val ./ a_dot_p;
  x = x + lambda .* p;
  r = r - lambda .* a;
  aux_vec = S1\r;
  inv_M_r = S2\aux_vec;
  aux_val = sum(inv_M_r.*a);
  gamma = aux_val ./ a_dot_p;
  p = inv_M_r - gamma .* p;
  m=m+1;
end
x_block_cell{block_iter} = x(iperm_vec,:);
relres_cell{block_iter} = sqrt(sum(r.^2))./norm_b(block_iter_sub);
end

for block_iter = 1 : length(block_iter_ind)
 block_iter_sub = [block_iter_ind(block_iter) : min(block_iter_end,block_iter_ind(block_iter)+processes_per_core-1)];
x_block(:,block_iter_sub) = x_block_cell{block_iter};
relres_vec(block_iter_sub) = relres_cell{block_iter};
end

%Substitute matrices
 R_tes(:,block_ind) =  x_block;

if impedance_inf == 0
Aux_mat(:,block_ind) = C(:,block_ind) - B'*x_block ;
else
Aux_mat(:,block_ind) = C(:,block_ind);
end

if not(isempty(find(tol_val < relres_vec)))
    close(h);
    'Error: PCG iteration did not converge.'
    R_tes = [];
    return
end
time_val = toc;

waitbar((i+length(block_ind)-1)/L,h,['PCG iteration. Ready: ' datestr(datevec(now+(L/(i+length(block_ind)-1) - 1)*time_val/86400)) '.']);

end

%******************************************************
%PCG CPU end
%******************************************************

end

if not(impedance_inf == 0)

    R_tes = R_tes - mean(R_tes,2);

end

clear S r p x aux_vec inv_M_r a b;
% waitbar(0,h,'Interpolation.');

%if isequal(electrode_model,'CEM')
    Aux_mat = inv(Aux_mat);
    R_tes = R_tes*Aux_mat;

    % S_tes
    J = eye(size(B'*R_tes));
    S_tes = ( (eye(L)-(1/L)*ones(L,L)) ) * (inv(C) * (J+(B'*R_tes))) * J;

    if isfield(evalin('base','zef'),'redo_eit_dec')
        if evalin('base','zef.redo_eit_dec') == 1
            [dof_ind, dof_count, dof_positions] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,source_ind);
        else
            dof_ind   = evalin('base','zef.dof_ind');
            dof_count = evalin('base','zef.dof_count');
            dof_positions = evalin('base','zef.source_positions');
        end
    else
        [dof_ind, dof_count, dof_positions] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,source_ind);
    end

    R_tes_1 = -Grad_1*R_tes;
    R_tes_2 = -Grad_2*R_tes;
    R_tes_3 = -Grad_3*R_tes;

    clear R_tes;

    L_tes = zeros(3*K3,L);

% 25.06.2020
    for i = 1 : K
        L_tes(3*(dof_ind(i)-1)+1,:) =  L_tes(3*(dof_ind(i)-1)+1,:) + R_tes_1(i,:);
        L_tes(3*(dof_ind(i)-1)+2,:) =  L_tes(3*(dof_ind(i)-1)+2,:) + R_tes_2(i,:);
        L_tes(3*(dof_ind(i)-1)+3,:) =  L_tes(3*(dof_ind(i)-1)+3,:) + R_tes_3(i,:);
    end

    for i = 1 : K3
        L_tes(3*(i-1)+1,:) = L_tes(3*(i-1)+1,:)/dof_count(i);
        L_tes(3*(i-1)+2,:) = L_tes(3*(i-1)+2,:)/dof_count(i);
        L_tes(3*(i-1)+3,:) = L_tes(3*(i-1)+3,:)/dof_count(i);
    end

    clear R_tes_1 R_tes_2 R_tes_3;

    dof_directions = ones(size(dof_positions));

    L_tes = L_tes';
    S_tes = S_tes';

waitbar(1,h);
close(h);
