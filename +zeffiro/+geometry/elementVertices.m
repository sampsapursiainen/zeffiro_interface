function vertices = elementVertices(elements, nodes)
%
%   centroids = elementVertices(elements, nodes)
%
% Computes the vertices or corner points of given elements.
% Supposes that the elements and nodes are given in a column-major order.
%

    arguments
        elements (:,:) uint64 { mustBePositive }
        nodes (:,:) double { mustBeFinite }
    end

    [vertexN, elementN] = size(elements) ;

    [dimension, nodeN] = size(nodes) ;

    vertices = reshape(nodes(:, elements), dimension, vertexN, elementN) ;

end % function
