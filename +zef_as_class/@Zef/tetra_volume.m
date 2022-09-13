function V = tetra_volume(nodes, tetra, take_absolute_value, edge_inds)

% tetra_volume
%
% Calculates a volume of the tetra contained in the instance of Zef that
% called this method.
%
% Inputs:
%
% - nodes
%
%   The nodes from which the coordinates of the tetra vertices will be
%   retrieved.
%
% - tetra
%
%   The tetra (an N × 4 index set of nodes) whose volumes we are computing.
%
% - take_absolute_value (optional)
%
%   A boolean flag for determining whether an absolute value of the volumes
%   should be taken.
%
%   default = false
%
% - edge_inds (optional)
%
%   An index array for choosing the subset of the tetra whose edges will be
%   used in the volume computation. If this is empty, all tetra will be used.
%
%   default = []
%
% Output:
%
% - V
%
%   The volumes of the tetra.

    arguments

        nodes (:,3) double

        tetra (:,4) double { mustBeInteger, mustBePositive }

        take_absolute_value (1,1) logical = false;

        edge_inds (:,1) double { mustBeInteger, mustBePositive } = [];

    end

    nodes = self.nodes;

    tetra = self.tetra;

    % Directed edges from 4th vertex of each tetrahedron.

    if isempty(edge_inds)

        edges = [
            nodes(tetra(:,1),:)';
            nodes(tetra(:,2),:)';
            nodes(tetra(:,3),:)'
        ] - repmat(nodes(tetra(:,4),:)',3,1);

    else

        edges = [
            nodes(tetra(subinds,1),:)';
            nodes(tetra(subinds,2),:)';
            nodes(tetra(subinds,3),:)'
        ] - repmat(nodes(tetra(subinds,4),:)',3,1);

    end

    % Index matrix used in the determinant calculation.

    ind_m = [1 4 7; 2 5 8 ; 3 6 9];

    % The volume itself as a determinant

    V = 1 / 6 * (                       ...
            edges(ind_m(1,1),:)       ...
            .*                          ...
            (                           ...
                edges(ind_m(2,2),:)   ...
                .*                      ...
                edges(ind_m(3,3),:)   ...
                -                       ...
                edges(ind_m(2,3),:)   ...
                .*                      ...
                edges(ind_m(3,2),:)   ...
            )                           ...
        -                               ...
            edges(ind_m(1,2),:)       ...
            .*                          ...
            (                           ...
                edges(ind_m(2,1),:)   ...
                .*                      ...
                edges(ind_m(3,3),:)   ...
                -                       ...
                edges(ind_m(2,3),:)   ...
                .*                      ...
                edges(ind_m(3,1),:)   ...
            )                           ...
        +                               ...
            edges(ind_m(1,3),:)       ...
            .*                          ...
            (                           ...
                edges(ind_m(2,1),:)   ...
                .*                      ...
                edges(ind_m(3,2),:)   ...
                -                       ...
                edges(ind_m(2,2),:)   ...
                .*                      ...
                edges(ind_m(3,1),:)   ...
            )                           ...
    );

    if take_absolute_value

        V = abs(V);

    end

end
