function [ coords ] = vertex_coordinates ( self, inds )
%
% vertex_coordinates ( self, inds )
%
% Returns the vertex coordinates of the tetrahedra indicated by the given indices.
%
% Inputs:
%
% - self
%
%   A tetrahedral mesh.
%
% - inds
%
%   The indices of the tetrahedra whose vertex coordinates one wishes to obtain.
%
% Output:
%
% - coords
%
%   A 3-by-(4 numel inds) matrix of node coordinates. In other words, the columns of the
%   output value contain the node coordinates of the indicated tetrahedra in groups of 4.
%

    arguments

        self (1,1) core.TetraMesh

        inds (:,1) uint64 { mustBePositive } = 1 : self.tetra_count

    end

    tetra = self.tetra ( :, inds ) ;

    coords = self.nodes ( :, tetra ) ;

end % function
