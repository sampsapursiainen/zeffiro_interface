function centroids = elementCentroids(elementVertices)
%
%   centroids = elementCentroids(elementVertices)
%
% Computes the centroids or nodal averages of given elements.
% Supposes that the elements and nodes are given in a column-major order.
%

    arguments
        elementVertices (:,:,:) double { mustBeFinite }
    end

    [dimension,vertexN,elementN] = size(elementVertices) ;

    centroids = reshape(sum(elementVertices, 2) / vertexN, dimension, elementN) ;

end % function
