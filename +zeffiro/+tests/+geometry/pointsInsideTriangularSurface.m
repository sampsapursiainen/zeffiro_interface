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

    vertices = [ vertex1 ; vertex2 ; vertex3 ; vertex4 ]' ;

    centroid = sum(vertices, 2) / 4

    centroidIsInside2D = zeffiro.geometry.pointsInsideTriangularSurface(centroid, triangles2D)

    centroidIsInside3D = zeffiro.geometry.pointsInsideTriangularSurface(centroid, triangles3D)

    assert( ...
        all(centroidIsInside2D), ...
        "test pointsInsideTriangularSurface: the centroid of a standard tetrahedron described by a 2D array was not inside of it." ...
    )

    assert( ...
        all(centroidIsInside3D), ...
        "test pointsInsideTriangularSurface: the centroid of a standard tetrahedron described by a 3D array was not inside of it." ...
    )

    % Check vertices.

    verticesAreOutside2D = zeffiro.geometry.pointsInsideTriangularSurface(vertices, triangles2D, includeSurfacePoints=false)

    verticesAreOutside3D = zeffiro.geometry.pointsInsideTriangularSurface(vertices, triangles3D, includeSurfacePoints=false)

    verticesAreInside2D = zeffiro.geometry.pointsInsideTriangularSurface(vertices, triangles2D, includeSurfacePoints=true)

    verticesAreInside3D = zeffiro.geometry.pointsInsideTriangularSurface(vertices, triangles3D, includeSurfacePoints=true)

    assert( ...
        ~ all(verticesAreOutside2D), ...
        "test pointsInsideTriangularSurface: the vertices of a standard tetrahedron described by a 2D array were not inside of it when the named argument includeSurfacePoints=false." ...
    )

    assert( ...
        ~ all(verticesAreOutside3D), ...
        "test pointsInsideTriangularSurface: the vertices of a standard tetrahedron described by a 3D array were not outside of it when the named argument includeSurfacePoints=false." ...
    )

    assert( ...
        all(verticesAreInside2D), ...
        "test pointsInsideTriangularSurface: the vertices of a standard tetrahedron described by a 2D array were not inside of it when the named argument includeSurfacePoints=true." ...
    )

    assert( ...
        all(verticesAreInside3D), ...
        "test pointsInsideTriangularSurface: the vertices of a standard tetrahedron described by a 3D array were not inside of it when the named argument includeSurfacePoints=true." ...
    )

end % function
