function [ ...
    surface_triangles, ...
    surface_nodes, ...
    tetra_ind, ...
    tetra_ind_global, ...
    tetra_ind_diff, ...
    node_ind, ...
    node_pair ...
] = zef_surface_mesh(tetra, varargin)

    % TODO Documentation
    %
    % The basic idea is that this function returns the surface triangles of a
    % given tetrahedral volume in different formats, depending on the
    % combination of input and output arguments.
    %
    % Input:
    %
    % - tetra: the set of volume tetrahedra whose surface is to be constructed (?)
    %
    % - varargin{1}: the nodes that constitute the tetrahedra (?)
    %
    % - varargin{2}: the indices that denote which tetrahedra are to be chosen
    %   as a part of the volume from the given ones (?)
    %
    % Output:
    %
    % - surface_triangles: Triples of node indices that make up the surface
    %   triangles
    %
    % - surface_nodes: the nodes that constitute the surface triangles.
    %
    % - tetra_ind: the indices of the tetrahedra that have the surface
    %   triangles as a face.
    %
    % - tetra_ind_global: TODO
    %
    % - tetra_ind_diff: TODO
    %
    % - node_ind: TODO
    %
    % - node_pair: TODO: pairs of neigbouring nodes on different sides of the
    %   triangular surface.

I = [];
surface_nodes = [];
nodes = [];

% Get nodes and indices from varargin.

if not(isempty(varargin))
    nodes = varargin{1};
    if length(varargin) > 1
        I = varargin{2};
    end
end

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

tetra_sort = [
    tetra(:,[2 4 3]) 1*ones(size(tetra,1),1) [1:size(tetra,1)]';
    tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]';
    tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]';
    tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';
];

tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);

tetra_ind = zeros(size(tetra_sort,1),1);

I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);

tetra_ind(I) = 1;
tetra_ind(I+1) = 1;

I = find(tetra_ind == 0);

tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles = tetra(tetra_ind);
surface_triangles = surface_triangles(:,[1 3 2]);

tetra_ind = tetra_sort(I,5);

if nargout > 4
    surface_triangles_aux = surface_triangles;
end

if not(isempty(nodes))
    [u_val, ~, u_ind] = unique(surface_triangles);
    surface_nodes = nodes(u_val,:);
    surface_triangles = reshape(u_ind,size(surface_triangles));
end

if nargout > 3
    tetra_ind_global = I_global(tetra_ind);
end

if nargout > 4
    tetra_ind_diff = [];
end

if nargout > 4 && nargin > 2

    surface_triangles_aux = sort(surface_triangles_aux,2);

    [~, tetra_ind_diff] = ismember(surface_triangles_aux, sort(tetra_diff(:,[2 4 3]),2),'rows');

    [~, I] = ismember(surface_triangles_aux, sort(tetra_diff(:,[1 3 4]),2),'rows');

    tetra_ind_diff = tetra_ind_diff + I;

    [~, I] = ismember(surface_triangles_aux, sort(tetra_diff(:,[1 4 2]),2),'rows');

    tetra_ind_diff = tetra_ind_diff + I;

    [~, I] = ismember(surface_triangles_aux, sort(tetra_diff(:,[1 2 3]),2),'rows');

    tetra_ind_diff = tetra_ind_diff + I;

    if nargout > 5 && nargin > 2

        node_ind = zeros(size(tetra_ind_diff,1),1);

        I_aux_1 = find(tetra_ind_diff);

        tetra_aux = tetra_diff(tetra_ind_diff(I_aux_1),:);

        [I,J] = find(not(ismember(tetra_aux,surface_triangles)));

        I_aux_2 = sub2ind(size(tetra_aux), I, J);

        node_ind(I_aux_1(I)) = tetra_aux(I_aux_2);

        node_pair = [surface_triangles(:,1) node_ind; ...
                    surface_triangles(:,2) node_ind; ...
                    surface_triangles(:,3) node_ind];

        node_pair = node_pair(find(node_pair(:,2)),:);

        [~, I_aux_1] = unique(node_pair(:,1));

        node_pair = node_pair(I_aux_1,:);

    end % if

    I = find(tetra_ind_diff);

    tetra_ind_diff(I) = I_diff(tetra_ind_diff(I));

end % if

end % function
