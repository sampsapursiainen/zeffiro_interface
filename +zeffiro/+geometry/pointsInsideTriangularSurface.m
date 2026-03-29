function isInside = pointsInsideTriangularSurface(points, triangles, kwargs)
%
%   isInside = pointsInsideTriangularSurface(points, triangles, kwargs)
%
% Determines whether a given set of points lies inside of a (closed) surface determined by a given set of triangles.
% The triangles should be oriented such that their surface normals point outward.
%
% Arguments:
%
%   points (:,:) double { mustBeFinite }
%
% The points whose inclusion into the volume bounded by given triangles we are questioning.
%
%   triangles (:,:,:) double { mustBeFinite  }
%
% The vertices of triangles that define the (closed) surface.
%
%   kwargs.includeSurfacePoints (1,1) logical = false
%
% If true, a point on a surface or at its vertex is also considered to be included into the volume.
% If false, only points truly inside the volume are allowed.
%
    arguments
        points (:,:) double { mustBeFinite }
        triangles (:,:,:) double { mustBeFinite }
        kwargs.includeSurfacePoints (1,1) logical = false
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

    relevantTriangles = triangles(:,:,minIndices) ;

    triangleCentroids = sum(relevantTriangles,2) / size(triangles,2) ;

    relativePointPositions = triangleCentroids - points ;

    triangleAreaVecs = zeffiro.geometry.triangleAreas(triangles(:,:,minIndices)) ;

    orientations = dot(triangleAreaVecs, relativePointPositions) ;

    % Positive orientations (multiples of tetra volumes) indicate points being inside
    % the surface when the surface normals of the triangles point outward.

    if kwargs.includeSurfacePoints

        isInside = orientations >= 0 ;

    else

        isInside = orientations > 0 ;

    end % if

end % function
