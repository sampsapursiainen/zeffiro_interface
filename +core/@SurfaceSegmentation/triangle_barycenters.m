function barycenters = triangle_barycenters ( self, inds )
%
% barycenters = triangle_barycenters ( self, inds )
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    vertex_coordinates = self.vertex_coordinates ( inds ) ;

    barycenters = core.geometry.shape_barycenters ( vertex_coordinates, 3 ) ;

end % function
