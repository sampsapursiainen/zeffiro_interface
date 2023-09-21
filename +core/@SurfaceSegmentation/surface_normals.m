function [ normals, norms, vertex_coords ] = surface_normals ( self, inds )
%
% [ normals, norms, vertex_coords ] = surface_normals ( self, inds )
%
% Computes the surface normals of the triangles in this segmentation. Also
% returns the norms of the normals and the vertex coordinates used in computing
% the normals.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    vertex_coords = self.vertex_coordinates ( inds ) ;

    vertex1 = vertex_coords ( 1 : 3 : end, : ) ;

    vertex2 = vertex_coords ( 2 : 3 : end, : ) ;

    vertex3 = vertex_coords ( 3 : 3 : end, : ) ;

    first_edges  = vertex2 - vertex1 ;

    second_edges = vertex3 - vertex1 ;

    normals = cross ( first_edges, second_edges ) ;

    norms = sqrt ( sum ( normals .^ 2 , 2 ) ) ;

end % function
