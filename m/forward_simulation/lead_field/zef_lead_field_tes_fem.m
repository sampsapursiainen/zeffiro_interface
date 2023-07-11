% %%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [L_tes, S_tes, dof_positions, dof_directions, dof_ind, dof_count] = lead_field_tes_fem( ...
    zef, ...
    nodes, ...
    elements, ...
    sigma, ...
    electrodes, ...
    p_nearest_neighbour_inds, ...
    varargin ...
    )
% 17.6.2020
% Sentence used:
%
% source_ind = randperm(size(zef.brain_ind,1)); source_ind = source_ind(1:zef.n_sources);
% sensors = zef_attach_sensors_volume(zef,zef.sensors);
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
source_model = eval('zef.source_model');

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

clear electrodes;

% Get the total volume tilavuus of the domain Ω.

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);

% Calculate stiffness matrix A

A = zef_stiffness_matrix(nodes, tetrahedra, tilavuus, sigma_tetrahedra);

% Sampsa 28.3.2022: zef_massmatrix_2d zef_diagonal_matrix zef_boundary_integral
% TODO START Tässä kannattaisi rakentaa kolme matriisia. Massamatriisi kertaa
% diagonaali painotettuna impedanssidiagonaalilla ja reunaintegraalimatriisi
% painotettuna impedanssidiagonaalilla. Huom massamatriisista on sekä piste-
% että pinta-alaan perustuvat versiot

% Calculate electrode matrices B and C based on A

[A, B, C] = zef_build_electrodes( ...
    nodes, ...
    electrode_model, ...
    impedance_vec, ...
    impedance_inf, ...
    ele_ind, ...
    A ...
    );

% Sampsa 28.3.2022: zef_massmatrix_2d zef_diagonal_matrix zef_boundary_integral END TODO

% Calculate gradient field

[Grad_1, Grad_2, Grad_3] = zef_tetra_gradient_field(nodes, tetrahedra, tilavuus, sigma_tetrahedra, brain_ind, K, N);

% Calculate transfer matrix R_tes based on A

if impedance_inf == 0
    Schur_expression = @(Tcol, ind) C(:,ind) - B'* Tcol;
else
    Schur_expression = @(Tcol, ind) C(:,ind);
end

[R_tes, Aux_mat, A] = zef_transfer_matrix( ...
    zef                                    ...
    ,                                          ...
    A                                      ...
    ,                                          ...
    B                                      ...
    ,                                          ...
    C                                      ...
    ,                                          ...
    N                                      ...
    ,                                          ...
    L                                      ...
    ,                                          ...
    electrode_model                        ...
    ,                                          ...
    permutation                            ...
    ,                                          ...
    precond                                ...
    ,                                          ...
    impedance_vec                          ...
    ,                                          ...
    impedance_inf                          ...
    ,                                          ...
    tol_val                                ...
    ,                                          ...
    m_max                                  ...
    ,                                          ...
    Schur_expression                       ...
    );

% Initialize progress bar

h = zef_waitbar(0,1,'Form L_tes from transfer matrix R_tes.');
waitbar_ind = 0;

% Modify transfer matrix R_tes for lead field L_tes calculation

if not(impedance_inf == 0)

    R_tes = R_tes - mean(R_tes,2);

end

clear S r p x aux_vec inv_M_r a b;
% zef_waitbar(0,1,h,'Interpolation.');

%if isequal(electrode_model,'CEM')
Aux_mat = inv(Aux_mat);
R_tes = R_tes*Aux_mat;

% S_tes
J = eye(size(B'*R_tes));
S_tes = ( (eye(L)-(1/L)*ones(L,L)) ) * (inv(C) * (J+(B'*R_tes))) * J;

if isfield(zef,'redo_eit_dec')
    if eval('zef.redo_eit_dec') == 1
        [dof_ind, dof_count, dof_positions] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,source_ind);
    else
        dof_ind   = eval('zef.dof_ind');
        dof_count = eval('zef.dof_count');
        dof_positions = eval('zef.source_positions');
    end
else
    [dof_ind, dof_count, dof_positions] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,source_ind);
end

R_tes_1 = -Grad_1*R_tes;
R_tes_2 = -Grad_2*R_tes;
R_tes_3 = -Grad_3*R_tes;

clear R_tes;

K3 = length(dof_count);
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

zef_waitbar(1,1,h);
close(h);
