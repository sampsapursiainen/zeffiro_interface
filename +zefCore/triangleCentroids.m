function [ C, c1, c2, c3 ] = triangleCentroids ( nodes, triangles )
%
% [ C, c1, c2, c3 ] = triangleCentroids ( nodes, triangles )
%
% Computes the arithemtic means of vertex points of the given triangles in the
% coordinate system of the given nodes.
%
% Inputs:
%
% - nodes (:,3) double
%
%   The finite element node coordinates.
%
% - triangles (3,:) uint32
%
%   Triples of node indices, indicating which nodes form triangles.
%
% Outputs:
%
% - C
%
%   The triangle centroids
%
% - c1, c2 and c3
%
%   The vertices from which the centroids were computed.
%

    arguments
        nodes     (3,:) double { mustBeFinite }
        triangles (3,:) uint32 { mustBePositive }
    end

    [ c1, c2, c3 ] = zefCore.triangleVertexCoordinates ( nodes, triangles ) ;

    C =  ( c1 + c2 + c3 ) ./ 3 ;

end % function
