function isInside = pointsInsideTriangularSurface(points, triangles)
%
%   isInside = pointsInsideTriangularSurface(points, triangles)
%
% Determines whether a given set of points lies inside of a (closed) surface determined by a given set of triangles.
% The triangles should be oriented such that their surface normals point outward.
%
    arguments
        points (:,:) double { mustBeFinite }
        triangles (:,:,:) double { mustBeFinite }
    end

    [dimension, pointN] = size(points) ;

    points = reshape(points, dimension,1,pointN) ;

    triangleArraySize = size(triangles) ;

    triangleArrayDims = numel(triangleArraySize) ;

    if triangleArrayDims == 2

        triangles = reshape(triangles, triangleArraySize(1), 3, triangleArraySize(2) / 3);

    end % if

    [~, ~, triangleN] = size(triangles) ;

    distancesToTriangles = zeffiro.geometry.distancesFromPointsToTriangles(points,triangles) ;

    [~, minIndices] = min(distancesToTriangles, [], 2) ;

    % Take the triangles ABC that are closest to each point P and form a tetrahedra ABCP out of these.
    % Then compute the volume of the tetra via a triple product.

    tetrahedra = cat(2, triangles(:,:,minIndices), points) ;

    relevantTriangles = triangles(:,:,minIndices) ;

    triangleCentroids = sum(relevantTriangles,2) / size(triangles,2) ;

    relativePointPositions = triangleCentroids - points ;

    triangleAreaVecs = zeffiro.geometry.triangleAreas(triangles(:,:,minIndices)) ;

    orientations = dot(triangleAreaVecs, relativePointPositions) ;

    % Positive orientations (multiples of tetra volumes) indicate points being inside
    % the surface when the surface normals of the triangles point outward.

    isInside = orientations > 0 ;

end % function
