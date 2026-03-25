function pointsInsideTriangularSurface
%
% A test set for zeffiro.tests.geometry.pointsInsideTriangularSurface.
%

    arguments end

    % A surface of a standard tetrahedron.

    triangles3D = [ 0 0 0 ; 1 0 0 ; 0 0 1 ]' ;

    triangles3D(:,:,2) = [ 0 0 0 ; 1 0 0 ; 0 1 0 ]' ;

    triangles3D(:,:,3) = [ 0 0 0 ; 0 0 1 ; 0 1 0 ]' ;

    triangles3D(:,:,4) = [ 1 0 0 ; 0 1 0 ; 0 0 1 ]' ;

    % Centroid of a standard tetrahedron.

    centroid = sum([ 0 0 0 ; 1 0 0 ; 0 1 0 ; 0 0 1 ]', 2) / 4

    isInside = zeffiro.geometry.pointsInsideTriangularSurface(centroid, triangles3D)

    assert( ...
        all(isInside), ...
        "test pointsInsideTriangularSurface: the centroid of a standard tetrahedron was not inside of it." ...
    )

end % function
