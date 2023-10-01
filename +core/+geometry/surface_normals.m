function normals = surface_normals ( triangles )
%
% normals = surface_normals ( triangles )
%
% Computes the surface normals of a given set of triangles, or triples of
% vertex points.
%

    arguments
        triangles (3,:) double { mustBeFinite }
    end

    vertex1 = triangles ( :, 1 : 3 : end ) ;

    vertex2 = triangles ( :, 2 : 3 : end ) ;

    vertex3 = triangles ( :, 3 : 3 : end ) ;

    first_edges  = vertex2 - vertex1 ;

    second_edges = vertex3 - vertex1 ;

    normals = cross ( first_edges, second_edges, 1 ) ;

end % function
