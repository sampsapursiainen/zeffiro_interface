function barycenters = element_barycenters ( self, inds )
%
% barycenters = element_barycenters ( self, inds )
%
% Computes the barycenters of the subset of elements in this mesh, indicated by
% the given indices.
%

    arguments
        self (1,1) core.TetraMesh
        inds (1,:) uint64 { mustBePositive } = 1 : self.element_count
    end

    vc = self.vertex_coordinates ( inds ) ;

    barycenters = core.geometry.shape_barycenters ( vc, size ( self.tetra, 1 ) ) ;

end % function
