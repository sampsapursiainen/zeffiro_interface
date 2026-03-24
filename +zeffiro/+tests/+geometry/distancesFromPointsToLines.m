function distancesFromPointsToLines
%
% A test for zeffiro.geometry.distancedFromPointsToLines.
%

    arguments end

    points = [0 0 0 ; 1 0 0 ; -1 0 0 ; 1 1 0 ; -1 -1 0]'

    lines = [0 0 0 ; 1 0 0 ; 1 0 0 ; 2 0 0]' ;

    lines = reshape(lines, size(lines,1), 2, size(lines,2) / 2)

    distances = zeffiro.geometry.distancesFromPointsToLines(points, lines)

    reference = [ 0 0 1 1 sqrt(2) ; 1 0 2 1 sqrt(2^2 + 1^2) ]'

    correctDistancesMask = abs(distances - reference) < 1e-10

    assert( ...
        all(correctDistancesMask(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference" ...
    )

end % function
