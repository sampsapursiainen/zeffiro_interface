function [ As, Avs ] = tetraSurfaceAreas (nodes, tetra, tI)
%
% [ As, Avs ] = tetraSurfaceAreas (nodes, tetra, tI)
%
% Computes the areas of the surface triangles of a given tetrahedral volume,
% indicated by the index set tI, which selects a subset of tetra.
%
% Output:
%
% - As
%
%   The surface areas of the surface triangles of the tetrahedral volume.
%
% - Avs
%
%   The area vectors of the surface triangles.
%

    arguments
        nodes   (:,3) double { mustBeFinite }
        tetra   (:,4) uint32 { mustBePositive }
        tI      (:,1) uint32 { mustBePositive }
    end

    % Get the surface triangles and the indices of the tetra that they belong to.

    [triangles, ~] = core.tetraSurfaceTriangles ( tetra, tI ) ;

    % Get the 3D vertex coordinates of the triangles.

    [ c1, c2, c3 ] = core.triangleVertexCoordinates ( nodes, triangles' ) ;

    % Compute area vectors as cross products of two edges, and then take their norms to find out the areas.

    Avs = 1 / 2 * cross ( c2 - c1, c3 - c1 ) ;

    As = sqrt ( sum ( Avs .^ 2, 2 ) ) ;

end % function
