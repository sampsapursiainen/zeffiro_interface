%Copyright © 2018, Sampsa Pursiainen
function [L_gravity,  bg_data, source_locations, source_directions] = lead_field_gravity(nodes,elements,rho,sensors,varargin)
% function [L_eeg, source_locations, source_directions] = lead_field_gravity(nodes,elements,rho,sensors,gravity_ind,source_ind,additional_options)
%
% Input:
% ------
% - nodes              = N x 3
% - elements          = M x 4
% - rho              = M x 1 (or M x 6, one row: rho_11 rho_22 rho_33 rho_12 rho_13 rho_23)
% - sensors            = L x 3
% - gravity_ind          = P x 1 (The set of elements that potentially contain source currents, by default contains all elements)
% - source_ind         = R x 1 (The set of elements that are allowed to contain source currents, a subset of gravity_ind, by default equal to gravity_ind)
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
% - additional_options.source_mode: Element-wise source direction mode; Values: '1' (direction of the source moment, default) or '2' (line segment between nodes 4 and 5 with the numbering given in Pursiainen et al 2011)
% - additional_options.permutation: Permutation of the linear system; Values: 'symamd' (default), 'symmmd' (optional), 'symrcm' (optional), or 'none' (optional)
%
% Output:
% -------
% - L_gravity             = L x K
% - source_locations   = K x 3 (or K/3 x 3, if Cartesian are used)
% - source_directions  = K x 3
%

L = size(sensors,1);

N = size(nodes,1);
source_model = evalin('base','zef.source_model');

% Convert source model to new format.

source_model = ZefSourceModel.from(source_model);

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

    if iscell(rho)
        rho{1} = rho{1}';
        if size(rho{1},1) == 1
        rho_tetrahedra = [repmat(rho{1},3,1) ; zeros(3,size(rho{1},2))];
        else
        rho_tetrahedra = rho{1};
        end
        rho_prisms = [];
        if length(rho)>1
        rho{2} = rho{2}';
        if size(rho{2},1) == 1
        rho_prisms = [repmat(rho{2},3,1) ; zeros(3,size(rho{2},2))];
        else
        rho_prisms = rho{2};
        end
        end
    else
        rho = rho';
        if size(rho,1) == 1
        rho_tetrahedra = [repmat(rho,3,1) ; zeros(3,size(rho,2))];
        else
        rho_tetrahedra = rho;
        end
        rho_prisms = [];
    end
    clear elements;

    tol_val = 1e-6;
    m_max = 3*floor(sqrt(N));
    precond = 'cholinc';
    permutation = 'symamd';
    direction_mode = 'mesh based';
    source_mode = 1;
    gravity_ind = [1:size(tetrahedra,1)]';
    source_ind = [1:size(tetrahedra,1)]';
    cholinc_tol = 1e-3;

    n_varargin = length(varargin);
    if n_varargin >= 1
    if not(isstruct(varargin{1}))
    gravity_ind = varargin{1};
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
    if isfield(varargin{n_varargin},'source_mode');
    source_mode = varargin{n_varargin}.source_mode;
    end

    if isfield(varargin{n_varargin},'cholinc_tol')
    cholinc_tol = varargin{n_varargin}.cholinc_tol;
    end
    if isfield(varargin{n_varargin},'permutation')
    permutation = varargin{n_varargin}.permutation;
    end
    end
    end
    K = size(tetrahedra,1);
    K3 = length(source_ind);
    K4 = length(gravity_ind);

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);

c_tet = 0.25*(nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:) + nodes(tetrahedra(:,4),:));

[eit_ind, eit_count] = make_gravity_dec(nodes,tetrahedra,gravity_ind,source_ind);

h = waitbar(0,'Lead field.');

if evalin('base','zef.gravity_field_type') == 4

L_gravity = zeros(3*L, K3);
%tilavuus_vec_aux = zeros(1, K3);
bg_data = zeros(3*L,1);

 for i = 1 : K4

r_aux_vec = tilavuus(gravity_ind(i))./sum((repmat(c_tet(gravity_ind(i),:),L,1) - sensors).^3,2);
aux_vec = (repmat(c_tet(gravity_ind(i),:),L,1) - sensors).*repmat(r_aux_vec,1,3);
L_gravity(:,eit_ind(i)) = L_gravity(:,eit_ind(i)) + aux_vec(:);

%tilavuus_vec_aux(eit_ind(i)) = tilavuus_vec_aux(eit_ind(i)) + tilavuus(gravity_ind(i))*eit_count(eit_ind(i));

if mod(i,floor(K4/50))==0
time_val = toc;
waitbar(i/K4,h,['Lead field. Ready approx: ' datestr(datevec(now+(K4/i - 1)*time_val/86400)) '.']);
end
 end

 for i = 1 : K

r_aux_vec = tilavuus(i)./sum((repmat(c_tet(i,:),L,1) - sensors).^3,2);
aux_vec = (repmat(c_tet(i,:),L,1) - sensors).*repmat(r_aux_vec,1,3);
bg_data = bg_data + rho_tetrahedra(1,i)*aux_vec(:);

%tilavuus_vec_aux(eit_ind(i)) = tilavuus_vec_aux(eit_ind(i)) + tilavuus(gravity_ind(i))*eit_count(eit_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Background. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

 elseif evalin('base','zef.gravity_field_type') == 3

L_gravity = zeros(L, K3);
%tilavuus_vec_aux = zeros(1, K3);
sensors = evalin('base','zef.sensors(:,1:3)');
bg_data = zeros(L,1);

 for i = 1 : K4

aux_vec = tilavuus(gravity_ind(i))./sum((repmat(c_tet(gravity_ind(i),:),L,1) - sensors).^2,2);
L_gravity(:,eit_ind(i)) = L_gravity(:,eit_ind(i)) + aux_vec(:);

%tilavuus_vec_aux(eit_ind(i)) = tilavuus_vec_aux(eit_ind(i)) + tilavuus(gravity_ind(i))*eit_count(eit_ind(i));

if mod(i,floor(K4/50))==0
time_val = toc;
waitbar(i/K4,h,['Lead field. Ready approx: ' datestr(datevec(now+(K4/i - 1)*time_val/86400)) '.']);
end
 end

for i = 1 : K

aux_vec = tilavuus(i)./sum((repmat(c_tet(i,:),L,1) - sensors).^2,2);
bg_data = bg_data + rho_tetrahedra(1,i)*aux_vec(:);

%tilavuus_vec_aux(eit_ind(i)) = tilavuus_vec_aux(eit_ind(i)) + tilavuus(gravity_ind(i))*eit_count(eit_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Background. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

end

close(h);

L_gravity = (6.67408E-11)*L_gravity;
bg_data = (6.67408E-11)*bg_data;

%for i = length(source_ind)
%L_gravity_aux(:,i) = L_gravity_aux(:,i); %/tilavuus_vec_aux(i);
%end

 source_locations = (nodes(tetrahedra(source_ind,1),:) + nodes(tetrahedra(source_ind,2),:) + nodes(tetrahedra(source_ind,3),:)+ nodes(tetrahedra(source_ind,4),:))/4;
source_directions = ones(size(source_locations));
