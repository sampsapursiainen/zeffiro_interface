function centroids = elementCentroids(elements, nodes)
%
%   centroids = elementCentroids(elements, nodes)
%
% Computes the centroids or nodal averages of given elements.
% Supposes that the elements and nodes are given in a column-major order.
%

    arguments
        elements (:,:) uint64 { mustBePositive }
        nodes (:,:) double { mustBeFinite }
    end

    [vertexN, elementN] = size(elements) ;

    [dimension, nodeN] = size(nodes) ;

    vertices = reshape(nodes(:, elements), dimension, vertexN, elementN) ;

    centroids = sum(vertices, 2) / vertexN ;

end % function
