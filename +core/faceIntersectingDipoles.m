function [stensil, signs, source_moments, source_directions, source_locations, n_of_adj_tetra] = faceIntersectingDipoles( nodes, tetrahedra , brain_ind )
%
% [stensil, signs, source_moments, source_directions, source_locations, n_of_adj_tetra] = faceIntersectingDipoles( nodes, tetrahedra , brain_ind )
%
% Generates the information related to face-intersecting dipoles in the
% tetrahedral mesh.
%
% Input:
%
% - nodes: the nodes from which the tetrahedral elements are built from.
%
% - tetrahedra: node index quadruplets that tell which nodes form the
%   tetrahedra
%
% - brain_ind: a set of indices telling which tetrahedra are actually
%   within the brain.
%
% Output:
%
% - stensil: an adjacency matrix telling which tetrahedra are next to each
%   other
%
% - signs: an n_of_nodes × n_of_sources sparse matrix that maps rows (node
%   index) and columns (corresponding source index) to the signed moment pairs.
%
% - source_moments: a vector of source moments.
%
% - source_directions: a row matrix of source directions.
%
% - source_locations: a row matrix of source locations.
%
% - n_of_adjacent tetra: the number of tetrahedral pairs that form sources.

% Matrix sizes

n_of_nodes = size(nodes, 1);
n_of_tetra_in_brain = length(brain_ind);
n_of_tetra = size(tetrahedra, 1);

% Iterate to find nodes that share a face. But first initialize a storage
% tuple that can be arranged later.

Ind_cell = cell(1,3);

for node_i = 1 : 4

    % From the tetra in the brain, take faces (node index triples)
    % constructed from the neighbours of node node_i in the same tetrahedron
    % and sort the node indices in increasing order.

    tetra_faces_1 = sort(tetrahedra(brain_ind, tetra_face_opposite_to(node_i)), 2);

    for node_j = node_i + 1 : 4

        % Take another face (node index triplet) from the same tetrahedra
        % and perform a similar sorting operation.

        tetra_faces_2 = sort(tetrahedra(brain_ind, tetra_face_opposite_to(node_j)), 2);

        % Sort faces starting from the leftmost column, so that any
        % identical faces (node index triples) end up at the same row
        % index, with the help of brain_indices and vectors of node
        % indices.

        % matrix of (face (triple), corresponding tetrahedron index, extremal node)

        sorted_tetra_faces = sortrows([ ...
            tetra_faces_1 brain_ind(:) node_i*ones(n_of_tetra_in_brain,1) ; ...
            tetra_faces_2 brain_ind(:) node_j*ones(n_of_tetra_in_brain,1) ...
        ]);

        % Find the rows that have the same node triplets, i.e. share a
        % face by subtracting and finding zeros.

        I = find ( ...
            0 == sum ( ...
                abs ( ...
                    sorted_tetra_faces(1:end-1,1:3) ...
                    - ...
                    sorted_tetra_faces(2:end,1:3) ...
                ) , ...
                2 ...
            ) ...
        );

        % Feed the indices into storage tuple.

        Ind_cell{node_i}{node_j} = [  ...
            sorted_tetra_faces(I,4)   ...
            sorted_tetra_faces(I+1,4) ...
            sorted_tetra_faces(I,5)   ...
            sorted_tetra_faces(I+1,5) ...
        ];

    end % for

end % for

% Set the node and element indices in one matrix.

sorted_tetra_faces = [
    Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; ...
    Ind_cell{2}{3} ; Ind_cell{2}{4} ;                  ...
    Ind_cell{3}{4}
];

% Drop the double and triple rows.

[~, I] = unique(sorted_tetra_faces(:,1:2),'rows');

sorted_tetra_faces = sorted_tetra_faces(I,:);

% Check that all of the elements were from a brain layer.

sorted_tetra_faces = sorted_tetra_faces(find(sum(ismember(sorted_tetra_faces(:,1:2),brain_ind),2)),:);

% Set node pairs that share a face.

tetra_end_1_ind = sub2ind(size(tetrahedra), sorted_tetra_faces(:,1), sorted_tetra_faces(:,3));

tetra_end_1 = nodes(tetrahedra(tetra_end_1_ind),:);

tetra_end_2_ind = sub2ind(size(tetrahedra), sorted_tetra_faces(:,2), sorted_tetra_faces(:,4));

tetra_end_2 = nodes(tetrahedra(tetra_end_2_ind),:);

% FI source locations, moments and directions

source_directions = (tetra_end_2 - tetra_end_1);
source_moments = sqrt(sum(source_directions.^2,2));
source_directions = source_directions ./ repmat(source_moments, 1, 3);
source_locations = (1/2) * (tetra_end_1 + tetra_end_2);

% Dipole sign matrix G. Maps rows(node indices)moments and their negatives to each end of
% the node pairs that form the FI dipoles.

n_of_adj_tetra = size(sorted_tetra_faces,1);

signs = sparse ( ...
    [tetrahedra(tetra_end_1_ind) ; tetrahedra(tetra_end_2_ind)] , ...
    repmat((1:n_of_adj_tetra)', 2, 1) , ...
    [1./source_moments(:) ; -1./source_moments(:)] , ...
    n_of_nodes , ...
    n_of_adj_tetra ...
);

% Dipole arrangement stensil T.

stensil = sparse ( ...
    repmat ( (1:n_of_adj_tetra)', 2, 1 ) , ...
    [sorted_tetra_faces(:,1) ; sorted_tetra_faces(:,2)] , ...
    ones(2*n_of_adj_tetra, 1) , ...
    n_of_adj_tetra , ...
    n_of_tetra ...
);

end

function face = tetra_face_opposite_to(node_ind)
%
% Returns the node index triple corresponding to the face opposite to the given
% node index.
%

    arguments
        node_ind (1,1) double { mustBeInteger, mustBePositive }
    end

    all_node_inds = [1, 2, 3, 4];

    if not(ismember(node_ind, all_node_inds))
        error('Tetrahedra only have node indices from 1 to 4.');
    end

    face = setdiff(all_node_inds, node_ind);

end % function
