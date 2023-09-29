function edge_midpoints = edge_midpoints ( self, inds )
%
% midpoints = edge_midpoints ( self, inds )
%
% Computes the midpoints of the edges in this mesh.
%

    arguments
        self (1,1) core.TetraMesh
        inds (:,1) uint64 { mustBePositive } = 1 : self.element_count
    end

    [ ~, edge_endpoints, ~ ] = self . element_edges ( inds ) ;

    edge_starts = edge_endpoints ( : , 1 : 2 : end ) ;

    edge_ends = edge_endpoints ( :, 2 : 2 : end ) ;

    edge_midpoints =  ( edge_ends + edge_starts ) / 2 ;

end % function
