function [ A, Av ] = triangleAreas ( nodes, triangles )
%
% [ A, Av ] = triangleAreas ( nodes, triangles )
%
% Returns the areas A and area vectors Av of a given set of triangles,
% based on their vertex coordinates in the given nodes.
%

    arguments
        nodes     (:,3) double { mustBeFinite }
        triangles (3,:) uint32 { mustBePositive }
    end

    [ c1, c2, c3 ] = core.triangleVertexCoordinates ( nodes, triangles ) ;

    Av = 1 / 2 * cross ( c2 - c1, c3 - c1 ) ;

    A = sqrt ( sum ( Av .^ 2, 2 ) ) ;

end % function
