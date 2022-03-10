%Copyright © 2018, Sampsa Pursiainen
function [eit_data_vec] = compute_eit_data(nodes,elements,rho,electrodes,varargin)

N = size(nodes,1);
L = size(electrodes,1);

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
     K = size(tetrahedra,1);
    K3 = length(source_ind);
    clear electrodes;
    A = spalloc(N,N,0);
    D_A = zeros(K,10);

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);

roi_ind_vec = [];

roi_sphere = evalin('base', 'zef.inv_roi_sphere');
roi_perturbation = evalin('base', 'zef.inv_roi_perturbation');
center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
r_roi = (roi_sphere(:,4));%/1000);
c_roi = (roi_sphere(:,1:3))';%/1000)';

for j = 1 : size(roi_sphere,1)

r_aux = find(sqrt(sum((center_points'-c_roi(:,j*ones(1,size(center_points,1)))).^2))<=r_roi(j));
rho_tetrahedra(1:3,r_aux) =  rho_tetrahedra(1:3,r_aux) + roi_perturbation(j);

end

ind_m = [ 2 3 4 ;
          3 4 1 ;
          4 1 2 ;
          1 2 3 ];

%center_points = 0.25*(nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:) + nodes(tetrahedra(:,4),:));

sensors = evalin('base','zef.sensors(:,1:3)');

h = waitbar(0,'Interpolation.');

if evalin('base','zef.imaging_method') == 4
eit_data_vec = zeros(3*L, 1);
%tilavuus_vec_aux = zeros(1, 1);

 for i = 1 : K

r_vec_aux = tilavuus(brain_ind(i))*rho_tetrahedra(1,brain_ind(i))./sum((repmat(center_points(brain_ind(i),:),L,1) - sensors).^3,2);
aux_vec = (repmat(center_points(brain_ind(i),:),L,1) - sensors).*repmat(r_vec_aux,1,3);
eit_data_vec  = eit_data_vec + aux_vec(:);

%tilavuus_vec_aux  = tilavuus_vec_aux + tilavuus(brain_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Interpolation. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

elseif evalin('base','zef.imaging_method') == 3

eit_data_vec = zeros(L, 1);
%tilavuus_vec_aux = zeros(1, 1);

 for i = 1 : K

aux_vec = tilavuus(brain_ind(i))*rho_tetrahedra(1,brain_ind(i))./sum((repmat(center_points(brain_ind(i),:),L,1) - sensors).^2,2);
eit_data_vec  = eit_data_vec + aux_vec(:);

%tilavuus_vec_aux  = tilavuus_vec_aux + tilavuus(brain_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Interpolation. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

elseif evalin('base','zef.imaging_method') == 2
eit_data_vec = zeros(3*L, 1);
%tilavuus_vec_aux = zeros(1, 1);

directions = evalin('base','zef.sensors(:,4:6)');
directions = directions./repmat(sqrt(sum(directions.^2,2)),1,3);

 for i = 1 : K

diff_vec_aux = repmat(center_points(brain_ind(i),:),L,1) - sensors;
r_aux_vec = -tilavuus(brain_ind(i)).*sum(directions.*diff_vec_aux,2)./(sqrt(sum(diff_vec_aux.^2,2)).^5);
aux_vec = diff_vec_aux.*repmat(r_aux_vec,1,3);
eit_data_vec = eit_data_vec + rho_tetrahedra(1,brain_ind(i))*aux_vec(:);
r_aux_vec = -tilavuus(brain_ind(i))./(sqrt(sum(diff_vec_aux.^2,2)).^3);
aux_vec = (directions - repmat(sum(directions.*diff_vec_aux,2),1,3).*directions).*repmat(r_aux_vec,1,3);
eit_data_vec = eit_data_vec + rho_tetrahedra(1,brain_ind(i))*aux_vec(:);

%tilavuus_vec_aux  = tilavuus_vec_aux + tilavuus(brain_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Interpolation. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

elseif evalin('base','zef.imaging_method') == 1

eit_data_vec = zeros(L, 1);
%tilavuus_vec_aux = zeros(1, 1);

directions = evalin('base','zef.sensors(:,4:6)');
directions = directions./repmat(sqrt(sum(directions.^2,2)),1,3);

 for i = 1 : K

diff_vec_aux = repmat(center_points(brain_ind(i),:),L,1) - sensors;
aux_vec = tilavuus(brain_ind(i)).*sum(directions.*diff_vec_aux,2)./(sqrt(sum(diff_vec_aux.^2,2)).^4);
eit_data_vec = eit_data_vec + rho_tetrahedra(1,brain_ind(i))*aux_vec(:);

%tilavuus_vec_aux  = tilavuus_vec_aux + tilavuus(brain_ind(i));

if mod(i,floor(K/50))==0
time_val = toc;
waitbar(i/K,h,['Interpolation. Ready approx: ' datestr(datevec(now+(K/i - 1)*time_val/86400)) '.']);
end
 end

end

waitbar(1,h);

close(h);

%eit_data_vec = eit_data_vec/tilavuus_vec_aux;
eit_data_vec = (6.67408E-11)*eit_data_vec;
eit_data_vec = eit_data_vec - evalin('base','zef.inv_bg_data');
eit_noise = evalin('base','zef.inv_eit_noise');
eit_data_vec = eit_data_vec + eit_noise*randn(size(eit_data_vec));

