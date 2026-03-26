function pointsInsideTriangularSurface
%
% A test set for zeffiro.tests.geometry.pointsInsideTriangularSurface.
%

    arguments end

    % A surface of a standard tetrahedron.

    vertex1 = [ 0 0 0 ] ;

    vertex2 = [ 1 0 0 ] ;

    vertex3 = [ 0 1 0 ] ;

    vertex4 = [ 0 0 1 ] ;

    triangles2D = [ vertex1 ; vertex2 ; vertex4 ; vertex1 ; vertex2 ; vertex3 ; vertex1 ; vertex4 ; vertex3 ;  vertex2 ; vertex3 ; vertex4 ]' ;

    triangles3D = [ vertex1 ; vertex2 ; vertex4 ]' ;

    triangles3D(:,:,2) = [ vertex1 ; vertex2 ; vertex3 ]' ;

    triangles3D(:,:,3) = [ vertex1 ; vertex4 ; vertex3 ]' ;

    triangles3D(:,:,4) = [ vertex2 ; vertex3 ; vertex4 ]' ;

    % Centroid of a standard tetrahedron.

    centroid = sum([ vertex1 ; vertex2 ; vertex3 ; vertex4 ]', 2) / 4

    isInside2D = zeffiro.geometry.pointsInsideTriangularSurface(centroid, triangles2D)

    isInside3D = zeffiro.geometry.pointsInsideTriangularSurface(centroid, triangles3D)

    assert( ...
        all(isInside2D), ...
        "test pointsInsideTriangularSurface: the centroid of a standard tetrahedron described by a 2D array was not inside of it." ...
    )

    assert( ...
        all(isInside3D), ...
        "test pointsInsideTriangularSurface: the centroid of a standard tetrahedron described by a 3D array was not inside of it." ...
    )

end % function
