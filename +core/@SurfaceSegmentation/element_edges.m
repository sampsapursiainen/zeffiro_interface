function [ edge_inds, edge_vecs ] = element_edges ( self, inds )
%
% [ edge_inds, edge_vecs ] = element_edges ( self, inds )
%
% Returns the directed edges of the surface triangles in this segmentation.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    triangles = self.triangles ( :, inds ) ;

    cursor = [ 1, 2, 2, 3, 3, 1 ] ;

    edge_inds = triangles ( cursor , : ) ;

    node_coords = self.nodes ( :, edge_inds ) ;

    edge_starts = node_coords ( :, 1 : 2 : end ) ;

    edge_ends = node_coords ( :, 2 : 2 : end ) ;

    edge_vecs = edge_ends - edge_starts ;

end % function
