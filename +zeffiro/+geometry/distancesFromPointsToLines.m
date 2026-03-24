function distances = distancesFromPointsToLines(points, lines)
%
%   distances = distancesFromPointsToLines(points, lines)
%
% Computes the distances from points to line segments defined by pairs of endpoints given in a 3D array.
% The first columns are the line segment start points and the second columns the endpoints.
% The output has a size of points times lines.
%
% Algorithm from the book Finite Element Mesh Generation by Daniel Lo.
%

    arguments
        points (:,:) double { mustBeFinite }
        lines (:,2,:) double { mustBeFinite }
    end

    [~,~,lineN] = size(lines) ;

    [dimension, pointN] = size(points) ;

    lineStartPoints = reshape(lines(:,1,:), dimension, lineN) ;

    lineEndPoints = reshape(lines(:,2,:), dimension, lineN) ;

    lineDirections = lineEndPoints - lineStartPoints ;

    lineDirectionNorms = vecnorm(lineDirections) ;

    unitLineDirections = lineDirections ./ lineDirectionNorms ;

    % Compute combinations of distances from points to lines and projetion scaling factors.

    fromLineStartsToPoints = repmat(points,1,lineN) - repelem(lineStartPoints,1,pointN) ;

    projectionScalingFactors = dot(fromLineStartsToPoints, repelem(unitLineDirections,1,pointN)) ;

    % Determine which distances to use based on sign of projection onto line.

    beforeStartPointsMask = projectionScalingFactors < 0 ;

    afterEndPointsMask = projectionScalingFactors > repmat(lineDirectionNorms,1,pointN) ;

    withinLineSegmentsMask = not(beforeStartPointsMask | afterEndPointsMask) ;

    % Generate output distance matrix.

    distances = inf(pointN, lineN) ;

    rejections = fromLineStartsToPoints - projectionScalingFactors .* repelem(unitLineDirections,1,pointN) ;

    rejectionNorms = vecnorm(rejections) ;

    distances(withinLineSegmentsMask) = rejectionNorms(withinLineSegmentsMask) ;

    fromLineStartsToPointsNorms = vecnorm(fromLineStartsToPoints) ;

    distances(beforeStartPointsMask) = fromLineStartsToPointsNorms(beforeStartPointsMask) ;

    fromLineEndsToPoints = repmat(points,1,lineN) - repelem(lineEndPoints,1,pointN) ;

    fromLineEndsToPointsNorms = vecnorm(fromLineEndsToPoints) ;

    distances(afterEndPointsMask) = fromLineEndsToPointsNorms(afterEndPointsMask) ;

end % function
