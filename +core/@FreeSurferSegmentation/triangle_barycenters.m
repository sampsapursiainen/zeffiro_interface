function barycenters = triangle_barycenters ( self, inds )

    arguments
        self (1,1) core.FreeSurferSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    vertex_coordinates = self.vertex_coordinates ( inds ) ;

    n_of_vertex_coordinates = size ( vertex_coordinates, 1 ) ;

    barycenters = zeros ( n_of_vertex_coordinates / 3, size ( vertex_coordinates, 2 ) ) ;

    for ii = 1 : size ( barycenters, 1 )

        vi = 3 * (ii - 1) + 1 ;

        vrange = vi : vi + 2 ;

        barycenters ( ii, : ) = sum ( vertex_coordinates ( vrange ,: ) ) / 3 ;

    end % for

end % function
