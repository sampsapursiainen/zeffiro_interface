function distancesFromPointsToTriangles
%
% A test for zeffiro.geometry.distancesFromPointsToTriangles.
%

    arguments end

    points = [0 0 0 ; 1 0 0 ; -1 0 0 ; 1 1 0 ; -1 -1 0]'

    triangles = [0 0 0 ; 1 0 0 ; 0 1 0]' ;

    triangles(:,:,2) = [0 0 1 ; 1 0 1 ; 0 1 1]'

    distances = zeffiro.geometry.distancesFromPointsToTriangles(points, triangles)

    reference = [ 0, 0, 1, sqrt(2) / 2, sqrt(2) ; 1, 1, sqrt(2), sqrt((sqrt(2) / 2) ^ 2 + 1 ^ 2), sqrt(2 + 1) ]'

    correctDistancesMask = abs(distances - reference) < 1e-10

    assert( ...
        all(correctDistancesMask(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference" ...
    )


end % function
