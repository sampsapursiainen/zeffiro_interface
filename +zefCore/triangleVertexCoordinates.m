function [ c1, c2, c3 ] = triangleVertexCoordinates ( nodes, triangles )
%
% [ c1, c2, c3 ] = triangleVertexCoordinates ( nodes, triangles )
%
% Retrieves the vertex or corner coordinates of a given set of triangles.
%
% Inputs:
%
% - nodes (3,:) double
%
% - triangles (3,:) uint32
%

    arguments
        nodes       (3,:) double { mustBeNonNan }
        triangles   (3,:) uint32 { mustBePositive }
    end

    c1 = nodes ( : , triangles ( 1 : 3 : end )) ;
    c2 = nodes ( : , triangles ( 2 : 3 : end )) ;
    c3 = nodes ( : , triangles ( 3 : 3 : end )) ;

end % function
