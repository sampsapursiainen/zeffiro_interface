function barycenters = triangle_barycenters ( self, inds )
%
% barycenters = triangle_barycenters ( self, inds )
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    vertex_coordinates = self.vertex_coordinates ( inds ) ;

    n_of_vertex_coordinates = size ( vertex_coordinates, 2 ) ;

    barycenters = zeros ( 3 , n_of_vertex_coordinates / 3 ) ;

    for ii = 1 : size ( barycenters, 2 )

        vi = 3 * (ii - 1) + 1 ;

        vrange = vi : vi + 2 ;

        barycenters (:,ii) = sum ( vertex_coordinates ( :, vrange ), 2 ) / 3 ;

    end % for

end % function
