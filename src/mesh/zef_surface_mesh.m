function [ ...
    surface_triangles, ...
    surface_nodes, ...
    tetra_ind, ...
    tetra_ind_global, ...
    tetra_ind_diff, ...
    node_ind, ...
    node_pair, ...
    face_ind] = zef_surface_mesh(tetra, nodes, I, gpu_mode)
%ZEF_SURFACE_MESH  Boundary faces of a tet mesh (or of a tet subset).
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Lists every triangular face of tetra, sorts vertex triples, and keeps
%   faces that appear once (the skin). Optional I restricts the tet set;
%   extra outputs then relate those skin faces to the complementary tets.
%   This is the workhorse for labeling, inflation, plotting, NSE boundary
%   integrals, and barycentric surface operators.
%
%   [surface_triangles, surface_nodes, tetra_ind, tetra_ind_global, ...
%       tetra_ind_diff, node_ind, node_pair, face_ind] = ...
%       zef_surface_mesh(tetra, nodes, I, gpu_mode)
%
%   Inputs
%     tetra     - T×4 1-based indices (cast to uint32).
%     nodes     - optional N×3. If given, surface_triangles are remapped
%                 into the unique skin vertices and surface_nodes is those
%                 coordinates. Needed for nargout>3 as well (the nargin>1
%                 guard).
%     I         - optional tet indices (into tetra) defining a subset.
%     gpu_mode  - 'graphics' (default) uses zef.use_gpu_graphic when the
%                 caller has zef; 'normal' uses zef.use_gpu. GPU is used
%                 only if zef.gpu_count > 0. If the caller has no zef,
%                 everything stays on CPU.
%
%   Outputs (all empty if unused)
%     surface_triangles - F×3. Winding flipped to [1 3 2] after gathering
%                         the opposite-face stencil. With nodes, indices
%                         refer to surface_nodes; without, to the original
%                         node numbering.
%     surface_nodes     - unique skin vertices (only if nodes was passed).
%     tetra_ind         - F×1 tet index in the (possibly subset) tetra
%                         that owns each skin face.
%     tetra_ind_global  - same in the original tet numbering when I was
%                         given; [] if I was empty.
%     tetra_ind_diff    - tet indices in the complement of I that share a
%                         face with the subset skin (requires nargin>2).
%     node_ind          - for those complementary tets, the vertex not on
%                         the shared face.
%     node_pair         - unique [skin_vertex, interior_vertex] edges
%                         across that interface (used by zef_inflate_surfaces).
%     face_ind          - 1..4, which local vertex of tetra_ind is opposite
%                         the skin face (barycentric surface operators).
%
%   Face stencil (row i opposite local vertex i): [2 4 3; 1 3 4; 1 4 2; 1 2 3].
%
%   See also zef_inflate_surfaces, zef_mesh_relabeling, zef_surface_scalar_matrix.


surface_triangles = [];
surface_nodes = [];
tetra_ind = [];
tetra_ind_global = [];
tetra_ind_diff = [];
node_ind = [];
node_pair = [];
face_ind = [];


tetra = uint32(tetra);


% Get nodes and indices from varargin.

if nargin < 2
    nodes = [];
end

if nargin < 3
    I = [];
end

if nargin < 4
    gpu_mode = 'graphics';
end

use_gpu = 0;
if evalin('caller', 'exist(''zef'', ''var'' )')
    zef = evalin('caller', 'zef');
    if zef.gpu_count > 0
        if isequal(gpu_mode,'normal')
            use_gpu = zef.use_gpu;
        elseif isequal(gpu_mode,'graphics')
            if zef.use_gpu
                use_gpu = zef.use_gpu_graphic;
            end
        end
    end
end

% Optional subset: work on tetra(I,:), keep a map back to global tet numbers.
I_global = [];
tetra_diff = [];
if not(isempty(I))
    I_global = [1 : size(tetra,1)]';
    if nargout > 4
        I_diff = setdiff(I_global,I);
        tetra_diff = tetra(I_diff,:);
    end
    tetra = tetra(I,:);
    I_global = I_global(I);
end

% Tetra faces (node index triples) opposite to row index node.

ind_m = [ 2 4 3 ;
    1 3 4 ;
    1 4 2 ;
    1 2 3 ];

% Find tetra indices I that share a face, by sorting and subtracting.

n_tet = size(tetra,1);
tetra_sort_1 = uint32([
    tetra(:,[2 4 3]);
    tetra(:,[1 3 4]);
    tetra(:,[1 4 2]);
    tetra(:,[1 2 3]);
    ]);

% GPU path keeps an explicit (face, tet) table because sortrows runs on
% the device. On CPU the same ids are recovered from the sort permutation:
% rows are stacked as four blocks of n_tet, block b row k -> face b, tet k.
if use_gpu
    tetra_sort_2 = uint32([
        1*ones(n_tet,1) [1:n_tet]';
        2*ones(n_tet,1) [1:n_tet]';
        3*ones(n_tet,1) [1:n_tet]';
        4*ones(n_tet,1) [1:n_tet]';
        ]);
    tetra_sort_1 = gpuArray(tetra_sort_1);
end
tetra_sort_1 = sort(tetra_sort_1,2);
[tetra_sort_1,J] = sortrows(tetra_sort_1,[1 2 3]);

tetra_ind = zeros(size(tetra_sort_1,1),1);

% Consecutive identical triples are interior faces (shared by two tets).
I = find(sum(abs(tetra_sort_1(2:end,1:3)-tetra_sort_1(1:end-1,1:3)),2)==0);
clear tetra_sort_1;
if use_gpu
    tetra_sort_2 = tetra_sort_2(J,:);
end

tetra_ind(I) = 1;
tetra_ind(I+1) = 1;

I = find(tetra_ind == 0);

if use_gpu
    tet_rows = tetra_sort_2(I,2);
    face_rows = tetra_sort_2(I,1);
    clear tetra_sort_2
else
    orig = J(I);
    face_rows = ceil(orig ./ n_tet);
    tet_rows = orig - (face_rows - 1) .* n_tet;
end
clear J

tetra_ind = sub2ind(size(tetra),repmat(tet_rows,1,3),ind_m(face_rows,:));
surface_triangles = tetra(tetra_ind);
surface_triangles = uint32(surface_triangles(:,[1 3 2]));

tetra_ind = uint32(tet_rows);
face_ind = uint32(face_rows);

if and(nargout > 4, nargin > 1)
    surface_triangles_aux = surface_triangles;
end

if not(isempty(nodes))
    if  use_gpu
        surface_triangles = gpuArray(surface_triangles);
    end
    [u_val, ~, u_ind] = unique(surface_triangles);
    surface_triangles = gather(surface_triangles);

    surface_nodes = nodes(u_val,:);
    surface_triangles = reshape(u_ind,size(surface_triangles));
end

if and(nargout > 3, nargin > 1)
    if not(isempty(I_global))
    tetra_ind_global = I_global(tetra_ind);
    else
        tetra_ind_global = [];
    end
end

if nargout > 4
    tetra_ind_diff = [];
end

if and(nargout > 4, nargin > 2)

    if use_gpu
        surface_triangles_aux = gpuArray(surface_triangles_aux);
    end

    surface_triangles_aux = sort(surface_triangles_aux,2);

    if use_gpu
        aux_vec_1 = gpuArray(tetra_diff(:,[2 4 3]));
    else
        aux_vec_1 = tetra_diff(:,[2 4 3]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    if use_gpu
        aux_vec_2 = gpuArray(aux_vec_2);
    end
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, triangle_ind_diff, tetra_ind_diff] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2;
    tetra_ind_diff = gather(I_aux(tetra_ind_diff));
    triangle_ind_diff = gather(triangle_ind_diff);

    if use_gpu
        aux_vec_1 = gpuArray(tetra_diff(:,[1 3 4]));
    else
        aux_vec_1 = tetra_diff(:,[1 3 4]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

    if use_gpu
        aux_vec_1 = gpuArray(tetra_diff(:,[1 4 2]));
    else
        aux_vec_1 = tetra_diff(:,[1 4 2]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

    if use_gpu
        aux_vec_1 = gpuArray(tetra_diff(:,[1 2 3]));
    else
        aux_vec_1 = tetra_diff(:,[1 2 3]);
    end
    aux_vec_2 = gather(sort(aux_vec_1,2));
    clear aux_vec_1;
    [I_aux, ~] = find(ismember(aux_vec_2, surface_triangles_aux));
    [I_aux, ~] = unique(ind2sub(size(aux_vec_2), I_aux));
    [~, K, I] = (intersect(surface_triangles_aux, aux_vec_2(I_aux,:),'rows'));
    clear aux_vec_2
    tetra_ind_diff = [tetra_ind_diff; gather(I_aux(I))];
    triangle_ind_diff = [triangle_ind_diff; gather(K)];

    clear surface_triangles_aux

    if and(nargout > 5, nargin > 2)

        node_ind = zeros(size(tetra_ind_diff,1),1);
        tetra_aux = tetra_diff(tetra_ind_diff,:);

        if use_gpu
            tetra_aux = gpuArray(tetra_aux);
            surface_triangles = gpuArray(surface_triangles);
        end

        [I,J] = find(not(ismember(tetra_aux,surface_triangles)));

        if use_gpu
            tetra_aux = gather(tetra_aux);
            surface_triangles = gather(surface_triangles);
        end

        I_aux_2 = sub2ind(size(tetra_aux), I, J);
        node_ind(I) = tetra_aux(I_aux_2);
        node_pair = [surface_triangles(triangle_ind_diff,1) node_ind; ...
            surface_triangles(triangle_ind_diff,2) node_ind; ...
            surface_triangles(triangle_ind_diff,3) node_ind];

        node_pair = node_pair(find(node_pair(:,2)),:);

        [~, I_aux_1] = unique(node_pair(:,1));
        node_pair = node_pair(I_aux_1,:);

    end % if

    tetra_ind_diff = I_diff(tetra_ind_diff);

end % if

end % function
