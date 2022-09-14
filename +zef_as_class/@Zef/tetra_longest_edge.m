function longest_edge = tetra_longest_edge(nodes, tetra)

% tetra_longest_edge
%
% Computes the longest edge in the finite element mesh.
%
% Inputs:
%
% - nodes
%
%   The nodes in the finite element mesh.
%
% - tetra
%
%   The node index quadruplets in the finite element mesh.
%
% Output:
%
% - longest_edge
%
%   The longest edge in the finite element mesh.

    arguments

        nodes (:,3) double

        tetra (:,4) double { mustBeInteger, mustBePositive }

    end

    longest_edge = max( ...
        sqrt([ ...
            sum((nodes(tetra(:,4),:) - nodes(tetra(:,1),:)).^2,2), ...
            sum((nodes(tetra(:,4),:) - nodes(tetra(:,2),:)).^2,2), ...
            sum((nodes(tetra(:,4),:) - nodes(tetra(:,3),:)).^2,2), ...
            sum((nodes(tetra(:,3),:) - nodes(tetra(:,1),:)).^2,2), ...
            sum((nodes(tetra(:,3),:) - nodes(tetra(:,2),:)).^2,2), ...
            sum((nodes(tetra(:,2),:) - nodes(tetra(:,1),:)).^2,2)  ...
        ]) ...
    , ...
        [] ...
    , ...
        2 ...
    );

end
