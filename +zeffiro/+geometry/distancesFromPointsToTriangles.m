function distances = distancesFromPointsToTriangles(points,triangles)
%
%   distances = distancesFromPointsToTriangles(points,triangles)
%
% Computes distances from a given set of points to a given set of triangles, defined by triples of vertieces given in a 3D array.
% The output size is points times triangles.
%
% Algorithm is from Finite Element Mesh Generation by Daniel Lo.
%

    arguments
        points (:,:) double { mustBeFinite }
        triangles (:,:,:) double { mustBeFinite }
    end

    triangleArrayDims = numel(size(triangles)) ;

    [dimension, pointN] = size(points) ;

    % Names for the 3 different vertices of each triangle.

    if triangleArrayDims == 2

        triangles = reshape(triangles, dimension, 3, size(triangles,2) / 3) ;

    end % if

    [~,~,triangleN] = size(triangles) ;

    As = repelem(reshape(triangles(:,1,:), dimension, triangleN), 1, pointN)

    Bs = repelem(reshape(triangles(:,2,:), dimension, triangleN), 1, pointN)

    Cs = repelem(reshape(triangles(:,3,:), dimension, triangleN), 1, pointN)

    Ps = repmat(points, 1, triangleN) ;

    % Plane-defining line segments.

    ABs = Bs - As ;

    BCs = Cs - Bs ;

    CAs = As - Cs ;

    % Plane normals.

    planeNormals = cross(ABs, -CAs) ;

    planeNormalNorms = vecnorm(planeNormals) ;

    unitNormals = planeNormals ./ planeNormalNorms ;

    % Compute point--triangle combinations of projections (or rejections) Q.

    APs = Ps - As ;

    projectionScalingFactors = dot(APs, unitNormals, 1) ;

    AQs = APs - projectionScalingFactors .* unitNormals ;

    Qs = As + AQs ;

    BQs = Qs - Bs ;

    CQs = Qs - Cs ;

    % Form directed triangles from the projections Q and each triangle edge vertex pairs.
    % Then compute the signs of their normals with respect to the unit normal.

    ABQNormals = cross(ABs, AQs) ;

    BCQNormals = cross(BCs, BQs) ;

    CAQNormals = cross(CAs, CQs) ;

    ABQNormalSigns = dot(ABQNormals, unitNormals) ;

    BCQNormalSigns = dot(BCQNormals, unitNormals) ;

    CAQNormalSigns = dot(CAQNormals, unitNormals) ;

    ABQPositiveOrientationMask = ABQNormalSigns >= 0 ;

    BCQPositiveOrientationMask = BCQNormalSigns >= 0 ;

    CAQPositiveOrientationMask = CAQNormalSigns >= 0 ;

    % Now either the point projection is within a triangle or somehow outside of it.
    % There are 6 ways of being outside a triangle, totalling in 7 different masks.

    insideTriangleMask = ABQPositiveOrientationMask & BCQPositiveOrientationMask & CAQPositiveOrientationMask ;

    outsideOppositeToAMask = ABQPositiveOrientationMask & not(BCQPositiveOrientationMask) & CAQPositiveOrientationMask ;

    outsideOppositeToBMask = ABQPositiveOrientationMask & BCQPositiveOrientationMask & not(CAQPositiveOrientationMask) ;

    outsideOppositeToCMask = not(ABQPositiveOrientationMask) & BCQPositiveOrientationMask & CAQPositiveOrientationMask ;

    outsideNearAMask = not(ABQPositiveOrientationMask) & BCQPositiveOrientationMask & not(CAQPositiveOrientationMask) ;

    outsideNearBMask = not(ABQPositiveOrientationMask) & not(BCQPositiveOrientationMask) & CAQPositiveOrientationMask ;

    outsideNearCMask = ABQPositiveOrientationMask & not(BCQPositiveOrientationMask) & not(CAQPositiveOrientationMask) ;

    % Then assign the distances based on where each point is located in relation to each triangle.

    distances = inf(pointN,triangleN) ;

    distancesToAB = zeffiro.geometry.distancesFromPointsToLines(points, cat(2, triangles(:,1,:), triangles(:,2,:))) ;

    distancesToBC = zeffiro.geometry.distancesFromPointsToLines(points, cat(2, triangles(:,2,:), triangles(:,3,:))) ;

    distancesToCA = zeffiro.geometry.distancesFromPointsToLines(points, cat(2, triangles(:,3,:), triangles(:,1,:))) ;

    distancesToA = vecnorm(Ps - As) ;

    distancesToB = vecnorm(Ps - Bs) ;

    distancesToC = vecnorm(Ps - Cs) ;

    PQs = AQs - APs ;

    distances(insideTriangleMask) = vecnorm(PQs(:,insideTriangleMask)) ;

    distances(outsideOppositeToAMask) = distancesToBC(outsideOppositeToAMask) ;

    distances(outsideOppositeToBMask) = distancesToCA(outsideOppositeToBMask) ;

    distances(outsideOppositeToCMask) = distancesToAB(outsideOppositeToCMask) ;

    distances(outsideNearAMask) = distancesToA(outsideNearAMask) ;

    distances(outsideNearBMask) = distancesToB(outsideNearBMask) ;

    distances(outsideNearCMask) = distancesToC(outsideNearCMask) ;

end % function
