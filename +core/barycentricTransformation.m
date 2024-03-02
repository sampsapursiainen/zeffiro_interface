function [ T, vertexCoords ] = barycentricTransformation ( nodes, elements )
%
% T = barycentricTransformation ( nodes, elements )
%
% Returns a linear mapping T that maps points from a Cartesian coordinate
% system to a barycentric one.
%

    arguments
        nodes    (:,:) double { mustBeFinite }
        elements (:,:) uint64 { mustBePositive }
    end

    % Get the number of dimensions, vertices in a single element and the number
    % of elements.

    Nd = size ( nodes, 1 ) ;

    Nv = size ( elements, 1 ) ;

    Ne = size ( elements, 2 ) ;

    % First, get the vertex coordinates of each element in groups of as many
    % columns as there are vertices in a single element, taking into account
    % the column-major ordering of MATLAB arrays.

    vertexCoords = nodes ( :, elements ) ;

    % Reshape it such that the vertex coordinates of each element are as pages
    % of a 3D array.

    vertexCoords = reshape ( vertexCoords, Nd, Nv, Ne ) ;

    % Compute differences between the last vertex of each element and its other
    % vertices. These give the basis of the coordinate system defined by each
    % element in a 3D array T.

    T = vertexCoords ( :, 1:end-1 ,: ) - vertexCoords ( :, end, : ) ;

end % function
