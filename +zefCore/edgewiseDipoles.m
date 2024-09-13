function [stensil, signs, source_moments, source_directions, source_locations, n_of_adj_nodes] = edgewiseDipoles( nodes, tetrahedra, brain_ind )
%
% [stensil, signs, source_moments, source_directions, source_locations, n_of_adj_nodes] = edgewiseDipoles( nodes, tetrahedra, brain_ind )
%
% Generates the vectors related to edgewise dipoles in the tetrahedral mesh:
% locations, directions and dipole moments. Also returns the adjacent node
% pairs that form the dipoles.
%

% Matrix sizes

n_of_nodes = size(nodes, 1);
n_of_tetra = size(tetrahedra, 1);

% Find nodes that share an edge

for i = 1 : 4

    for j = i + 1 : 4

        Ind_cell{i}{j} = [ brain_ind(:) tetrahedra(brain_ind(:),i)  tetrahedra(brain_ind(:),j) ];

    end
end

% Adjacent node pairs

adjacent_nodes = [
    Ind_cell{1}{2} ; Ind_cell{1}{3} ; Ind_cell{1}{4} ; ...
    Ind_cell{2}{3} ; Ind_cell{2}{4} ;                  ...
    Ind_cell{3}{4}
];

adjacent_nodes(:,2:3) = sort(adjacent_nodes(:, 2:3), 2);

% Remove duplicates

[edge_ind, edge_ind_aux_1, edge_ind_aux_2] = unique(adjacent_nodes(:, 2:3),'rows');

% Edgewise source dipole vectors

source_directions = nodes(edge_ind(:,2),:) - nodes(edge_ind(:,1),:);
source_moments = sqrt(sum(source_directions.^2,2));
source_directions = source_directions ./ repmat(sqrt(sum(source_directions.^2,2)),1,3);
source_locations = (1/2) * (nodes(edge_ind(:,1),:) + nodes(edge_ind(:,2),:));

% Dipole sign matrix

n_of_adj_nodes = size(edge_ind,1);

signs = sparse( ...
    [edge_ind(:,1) ; edge_ind(:,2)] , ...
    repmat([1:n_of_adj_nodes]', 2, 1) , ...
    [1./(source_moments) ; -1./(source_moments)] , ...
    n_of_nodes , ...
    n_of_adj_nodes ...
);

% Dipole arrangement tensil

stensil = sparse( ...
    edge_ind_aux_2 , ...
    adjacent_nodes(:,1) , ...
    ones(length(edge_ind_aux_2), 1) , ...
    n_of_adj_nodes , ...
    n_of_tetra ...
);

end
