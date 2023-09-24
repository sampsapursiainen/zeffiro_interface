function [ edge_inds, edge_vecs ] = element_edges ( self, inds )
%
% [ edge_inds, edge_vecs ] = element_edges ( self, inds )
%
% Computes the directed edges of each element in the mesh.
%

    arguments
        self (1,1) core.TetraMesh
        inds (:,1) uint64 = 1 : self.element_count
    end

    elements = self.tetra ( :, inds ) ;

    cursor = [ 1, 2, 2, 3, 3, 1, 1, 4, 2, 4, 3, 4 ] ;

    edge_inds = elements ( cursor , : ) ;

    node_coords = self.nodes ( :, edge_inds ) ;

    edge_starts = node_coords ( :, 1 : 2 : end ) ;

    edge_ends = node_coords ( :, 2 : 2 : end ) ;

    edge_vecs = edge_ends - edge_starts ;

end % function
