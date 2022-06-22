%%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [L_eeg, dipole_locations, dipole_directions] = lead_field_eeg_fem(nodes,elements,sigma,electrodes,varargin)
% function [L_eeg, source_locations, source_directions] = lead_field_eeg_fem(nodes,elements,sigma,electrodes,brain_ind,source_ind,additional_options)
%
% Input:
% ------
% - nodes              = n_of_nodes x 3
% - elements           = M x 4
% - sigma              = M x 1 (or M x 6, one row: sigma_11 sigma_22 sigma_33 sigma_12 sigma_13 sigma_23)
% - electrodes         = n_of_electrodes x 3
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
% - additional_options.maxit: Maximum number of PCG iteration steps; Values: Numeric (default is 3*floor(sqrt(n_of_nodes)))
% - additional_options.dipole_mode: Element-wise source direction mode; Values: '1' (direction of the dipole moment, default) or '2' (line segment between nodes 4 and 5 with the numbering given in Pursiainen et al 2011)
% - additional_options.permutation: Permutation of the linear system; Values: 'symamd' (default), 'symmmd' (optional), 'symrcm' (optional), or 'none' (optional)
%
% Output:
% -------
% - L_eeg              = n_of_electrodes x K
% - source_locations   = K x 3 (or K/3 x 3, if Cartesian are used)
% - source_directions  = K x 3
%

n_of_nodes = size(nodes,1);
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
    m_max = 3*floor(sqrt(n_of_nodes));
    precond = 'cholinc';
    permutation = 'symamd';
    direction_mode = 'mesh based';
    dipole_mode = 1;
    brain_ind = [1:size(tetrahedra,1)]';
    source_ind = [1:size(tetrahedra,1)]';
    cholinc_tol = 1e-3;

    impedance_inf = 1;

    if size(electrodes,2) == 4
        electrode_model = 'CEM';
        n_of_electrodes = max(electrodes(:,1));
        ele_ind = electrodes;
        impedance_vec = ones(max(electrodes(:,1)),1);
    else
        electrode_model = 'PEM';
        n_of_electrodes = size(electrodes,1);
        ele_ind = zeros(n_of_electrodes,1);
        for i = 1 : n_of_electrodes
            [min_val, min_ind] = min(sum((repmat(electrodes(i,:),n_of_nodes,1)' - nodes').^2));
            ele_ind(i) = min_ind;
        end
        impedance_vec = ones(length(electrodes(:, 1)), 1);
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

    if not(isequal(lower(direction_mode),'cartesian') || isequal(lower(direction_mode),'normal'))
source_model = 1;
end

% Convert source model to new format.

source_model = ZefSourceModel.from(source_model);

% Volume

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);

% Stiffness matrix calculation

A = zef_stiffness_matrix(nodes, tetrahedra, tilavuus, sigma_tetrahedra);

% Build electrode matrices B and C based on A

[A, B, C] = zef_build_electrodes( ...
    nodes, ...
    electrode_model, ...
    impedance_vec, ...
    impedance_inf, ...
    ele_ind, ...
    A ...
);

% Transfer matrix T with preconditioned conjugate gradient (PCG) iteration

if impedance_inf == 0
    Schur_expression = @(Tcol, ind) B'* Tcol - C(:,ind);
else
    Schur_expression = @(Tcol, ind) - C(:,ind);
end

[T, Schur_complement, ~] = zef_transfer_matrix( ...
    A                                           ...
,                                               ...
    B                                           ...
,                                               ...
    C                                           ...
,                                               ...
    n_of_nodes                                  ...
,                                               ...
    n_of_electrodes                             ...
,                                               ...
    electrode_model                             ...
,                                               ...
    permutation                                 ...
,                                               ...
    precond                                     ...
,                                               ...
    impedance_vec                               ...
,                                               ...
    impedance_inf                               ...
,                                               ...
    tol_val                                     ...
,                                               ...
    m_max                                       ...
,                                               ...
    Schur_expression                            ...
);

% Interpolation.

if isequal(lower(direction_mode),'cartesian') || isequal(lower(direction_mode),'normal')

dipole_locations = [];
dipole_directions = [];

% Set regularization parameter based on literature.
% TODO: allow passing this in as a parameter.

regparam = 1e-6;

[G, dipole_locations] = zef_lead_field_interpolation( ...
    nodes, ...
    tetrahedra, ...
    brain_ind, ...
    source_model, ...
    source_ind, ...
    regparam ...
);

% Construct lead field with transfer matrix, Schur complement and
% interpolation matrix G.

L_eeg = Schur_complement * T' * G;

% Set "correct" zero potential level. Corresponds to multiplying L_eeg with
% restriction matrix R, seen in relevant articles such as
% <https://iopscience.iop.org/article/10.1088/0031-9155/57/4/999/pdf>.

L_eeg = L_eeg - mean(L_eeg, 1);

end % if
end % function
