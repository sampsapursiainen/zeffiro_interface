function [L,n_interp, procFile] = zef_processLeadfields(zef)
%ZEF_PROCESSLEADFIELDS  Subselect and constrain zef.L for inversion source models.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Extracts active source columns from raw zef.L using zef.source_interpolation_ind.
%   Depending on zef.source_direction_mode:
%     1 – free orientation: keep all three Cartesian blocks (s_ind_1).
%     2 – constrained normal: compute smoothed outward normals on cortical
%         triangles for nodes in s_ind_4, project lead field to normal direction.
%     3 – fixed directions: use zef.source_directions at interpolated nodes.
%   Returns procFile index maps used by inversion and post-processing.
%
%   [L, n_interp, procFile] = zef_processLeadfields()
%   [L, n_interp, procFile] = zef_processLeadfields(zef)
%
%   Inputs
%     zef - session struct; if omitted, or if a numeric sentinel is passed
%           (historical plugins passed source_direction_mode), loaded from
%           base. The numeric value is ignored; zef.source_direction_mode
%           is used.
%
%   Outputs
%     L        - lead field (n_sensors x n_columns) after mode-specific processing.
%     n_interp - number of unique interpolated source nodes (length s_ind_0).
%     procFile - struct with:
%                  source_direction_mode, source_directions,
%                  s_ind_0  unique interpolation node indices,
%                  s_ind_1  L-column indices actually kept,
%                  s_ind_2  Cartesian triplet map (mode 3 only),
%                  s_ind_3  surface-interpolation indices (mode 2),
%                  s_ind_4  subset of those nodes with Activity =
%                           Constrained field (normal-projected),
%                  n_interp, sizeL2.
%
%   Requires zef.source_interpolation_ind cell array from zef_source_interpolation.
%   Mode 2 additionally reads compartment surface meshes (reuna_p, reuna_t).
%
%   See also zef_process_inversion, zef_inverse_extract_bundle,
%            zef_postProcessInverse, zef_source_interpolation.

% nargin==0: load zef from base (docstring). A numeric first argument is
% the historical plugin sentinel (callers passed source_direction_mode);
% the numeric value is ignored and zef.source_direction_mode is used.
if nargin < 1 || isnumeric(zef)
    zef = evalin('base', 'zef');
end

source_directions = zef.source_directions;
source_direction_mode = zef.source_direction_mode;

s_ind_2=[];
s_ind_3=[];
s_ind_4=[];

if ~isfield(zef, 'source_interpolation_ind') || isempty(zef.source_interpolation_ind)
    error('zef_processLeadfields:missingSourceInterpolation', ...
        ['zef.source_interpolation_ind is missing or empty. Run forward simulation (lead field) and ' ...
        'source interpolation (zef_source_interpolation) so this field is populated before inversion.']);
end
if ~iscell(zef.source_interpolation_ind)
    error('zef_processLeadfields:invalidSourceInterpolation', ...
        ['zef.source_interpolation_ind must be a cell array from zef_source_interpolation. Found %s.'], ...
        class(zef.source_interpolation_ind));
end

[s_ind_1] = unique(eval('zef.source_interpolation_ind{1}'));
n_interp = length(s_ind_1);

% Mesh-tool Directions = Normal (source_direction_mode 2): build a smoothed
% outward normal on every active-compartment surface triangle, then later
% replace the three Cartesian L columns at Constrained-field nodes with
% that normal projection (copied into all three slots so triplet layout
% is preserved).
if source_direction_mode == 2

    [s_ind_3] = eval('zef.source_interpolation_ind{3}');

    i = 0;
    length_reuna = 0;
    sigma_vec = [];
    priority_vec = [];
    visible_vec = [];
    color_cell = cell(0);
    aux_brain_ind = [];
    aux_dir_mode = [];
    submesh_cell = cell(0);
    compartment_tags = eval('zef.compartment_tags');
    for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
        color_str = eval(['zef.' compartment_tags{k} '_color']);
        on_val = eval(var_0);
        sigma_val = eval(var_1);
        priority_val = eval(var_2);
        visible_val = eval(var_3);
        submesh_ind = eval(var_4);
        if on_val
            i = i + 1;
            sigma_vec(i,1) = sigma_val;
            priority_vec(i,1) = priority_val;
            color_cell{i} = color_str;
            visible_vec(i,1) = i*visible_val;
            submesh_cell{i} = submesh_ind;
            if eval(['zef.' compartment_tags{k} '_sources']);
                % Activity column: Constrained field (_sources==1) gets
                % aux_dir_mode 0 and is later normal-constrained; Unconstrained
                % field (2) and Active surface (3) are left Cartesian.
                aux_brain_ind = [aux_brain_ind i];
                aux_dir_mode = [aux_dir_mode eval(['zef.' compartment_tags{k} '_sources'])-1];
            end
        end
    end

    a_d_i_vec = [];
    aux_p = [];
    aux_t = [];

    for ab_ind = 1 : length(aux_brain_ind)

        aux_t = [aux_t ; size(aux_p,1) + eval(['zef.reuna_t{' int2str(aux_brain_ind(ab_ind)) '}'])];
        aux_p = [aux_p ; eval(['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}'])];
        a_d_i_vec = [a_d_i_vec ; aux_dir_mode(ab_ind)*ones(size(eval(['zef.reuna_p{' int2str(aux_brain_ind(ab_ind)) '}']),1),1)];

    end

    % Per-triangle unit normals from the stacked surface, then 7 Laplacian
    % smoothing passes and a sign flip so the field points inward (toward
    % the source space). a_d_i_vec is 0 on Constrained-field triangles.
    a_d_i_vec = a_d_i_vec(aux_t(:,1));
    n_vec_aux = cross(aux_p(aux_t(:,2),:)' - aux_p(aux_t(:,1),:)', aux_p(aux_t(:,3),:)' - aux_p(aux_t(:,1),:)')';
    n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

    n_vec_aux(:,1) = zef_smooth_field(aux_t, n_vec_aux(:,1), size(aux_p(:,1),1),7);
    n_vec_aux(:,2) = zef_smooth_field(aux_t, n_vec_aux(:,2), size(aux_p(:,1),1),7);
    n_vec_aux(:,3) = zef_smooth_field(aux_t, n_vec_aux(:,3), size(aux_p(:,1),1),7);

    n_vec_aux =  - n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);

    s_ind_4 = find(not(a_d_i_vec(s_ind_3)));
    source_directions = n_vec_aux(s_ind_3,:);

end

if source_direction_mode == 3
    source_directions = source_directions(s_ind_1,:);
end
s_ind_0=s_ind_1;

if source_direction_mode == 1  || source_direction_mode == 2
    % Expand unique node indices to the three Cartesian L-column blocks
    % (x then y then z), matching how zef_lead_field_matrix stores L.
    s_ind_1 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1]; %not triplet anymore
end
if  source_direction_mode == 3
    s_ind_2 = [3*s_ind_1-2 ; 3*s_ind_1-1 ; 3*s_ind_1];
end

s_ind_1 = s_ind_1(:);

L = eval('zef.L');
L = L(:,s_ind_1);

if source_direction_mode == 2

    L_1 = L(:,1:n_interp);
    L_2 = L(:,n_interp+1:2*n_interp);
    L_3 = L(:,2*n_interp+1:3*n_interp);
    s_1 = source_directions(:,1)';
    s_2 = source_directions(:,2)';
    s_3 = source_directions(:,3)';
    ones_vec = ones(size(L,1),1);
    % L_0 = n_x L_x + n_y L_y + n_z L_z at Constrained-field nodes.
    % The same scalar column is written into all three Cartesian slots so
    % later code that still indexes triplets does not drop those sources.
    L_0 = L_1(:,s_ind_4).*s_1(ones_vec,s_ind_4) + L_2(:,s_ind_4).*s_2(ones_vec,s_ind_4) + L_3(:,s_ind_4).*s_3(ones_vec,s_ind_4); %normal matrix
    L(:,s_ind_4) = L_0;
    L(:,n_interp+s_ind_4) = L_0;
    L(:,2*n_interp+s_ind_4) = L_0;
    clear L_0 L_1 L_2 L_3 s_1 s_2 s_3;

end

procFile.source_direction_mode=source_direction_mode;
procFile.source_directions=source_directions;
procFile.s_ind_1=s_ind_1;
procFile.s_ind_2=s_ind_2;
procFile.s_ind_3=s_ind_3;
procFile.s_ind_4=s_ind_4;
procFile.n_interp=n_interp;
procFile.sizeL2=size(L,2);
procFile.s_ind_0=s_ind_0;

end
