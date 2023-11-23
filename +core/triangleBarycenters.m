function C = triangleBarycenters ( nodes, triangles )
%
% C = triangleBarycenters ( nodes, triangles )
%
% Computes the barycenters or arithemtic means of vertex points of the given
% triangles in the coordinate system of the nodes.
%
% - nodes (:,3) double
%
%   The finite element node coordinates.
%
% - triangles (3,:) uint32
%
%   Triples of node indices, indicating which nodes form triangles.
%

    arguments
        nodes     (:,3) double { mustBeFinite }
        triangles (3,:) uint32 { mustBePositive }
    end

    [ c1, c2, c3 ] = core.triangleVertexCoordinates ( nodes, triangles ) ;

    C =  ( c1 + c2 + c3 ) ./ 3 ;

end % function
