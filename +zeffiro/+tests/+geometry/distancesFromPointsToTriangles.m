function distancesFromPointsToTriangles
%
% A test for zeffiro.geometry.distancesFromPointsToTriangles.
%

    arguments end

    points = [0 0 0 ; 1 0 0 ; -1 0 0 ; 1 1 0 ; -1 -1 0]'

    % Test for 2D triangle array.

    triangles2D = [0 0 0 ; 1 0 0 ; 0 1 0 ; 0 0 1 ; 1 0 1 ; 0 1 1]' ;

    triangles3D = [0 0 0 ; 1 0 0 ; 0 1 0]' ;

    triangles3D(:,:,2) = [0 0 1 ; 1 0 1 ; 0 1 1]'

    distances2D = zeffiro.geometry.distancesFromPointsToTriangles(points, triangles2D)

    distances3D = zeffiro.geometry.distancesFromPointsToTriangles(points, triangles3D)

    reference = [ 0, 0, 1, sqrt(2) / 2, sqrt(2) ; 1, 1, sqrt(2), sqrt((sqrt(2) / 2) ^ 2 + 1 ^ 2), sqrt(2 + 1) ]'

    correctDistancesMask2D = abs(distances2D - reference) < 1e-10

    correctDistancesMask3D = abs(distances3D - reference) < 1e-10

    assert( ...
        all(correctDistancesMask2D(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference with a 2D triangle array." ...
    )

    assert( ...
        all(correctDistancesMask3D(:)), ...
        "test distancesFromPointsToLines: all distances were not close to reference with a 3D triangle array." ...
    )


end % function
