function [ edge_inds, edge_endpoints, edge_directions ] = element_edges ( self, inds )
%
% [ edge_inds, edge_endpoints, edge_directions ] = element_edges ( self, inds )
%
% Computes the directed edges of each element in the mesh.
%

    arguments
        self (1,1) core.TetraMesh
        inds (:,1) uint64 = 1 : self.element_count
    end

    elements = self.tetra ( :, inds ) ;

    edge_inds = elements ( self.edgeDirectionI , : ) ;

    edge_endpoints = self.nodes ( :, edge_inds ) ;

    edge_starts = edge_endpoints ( :, 1 : 2 : end ) ;

    edge_ends = edge_endpoints ( :, 2 : 2 : end ) ;

    edge_directions = edge_ends - edge_starts ;

end % function
