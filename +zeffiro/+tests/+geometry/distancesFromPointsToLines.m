function distancesFromPointsToLines
%
% A test for zeffiro.geometry.distancedFromPointsToLines.
%

    arguments end

    points = [0 0 0 ; 1 0 0 ; -1 0 0 ; 1 1 0 ; -1 -1 0]'

    lines2D = [0 0 0 ; 1 0 0 ; 1 0 0 ; 2 0 0]' ;

    lines3D = reshape(lines2D, size(lines2D,1), 2, size(lines2D,2) / 2)

    distances2D = zeffiro.geometry.distancesFromPointsToLines(points, lines2D)

    distances3D = zeffiro.geometry.distancesFromPointsToLines(points, lines3D)

    reference = [ 0 0 1 1 sqrt(2) ; 1 0 2 1 sqrt(2^2 + 1^2) ]'

    correctDistancesMask2D = abs(distances2D - reference) < 1e-10

    correctDistancesMask3D = abs(distances3D - reference) < 1e-10

    assert( ...
        all(correctDistancesMask2D(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference with a 2D line array." ...
    )

    assert( ...
        all(correctDistancesMask3D(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference with a 3D line array." ...
    )

end % function
