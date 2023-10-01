function [ edge_inds, edge_endpoints, edge_directions ] = element_edges ( self, inds )
%
% [ edge_inds, edge_endpoints, edge_directions ] = element_edges ( self, inds )
%
% Returns the directed edges of the surface triangles in this segmentation.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    triangles = self.triangles ( :, inds ) ;

    edge_inds = triangles ( self.edgeDirectionI , : ) ;

    edge_endpoints = self.nodes ( :, edge_inds ) ;

    edge_starts = edge_endpoints ( :, 1 : 2 : end ) ;

    edge_ends = edge_endpoints ( :, 2 : 2 : end ) ;

    edge_directions = edge_ends - edge_starts ;

end % function
