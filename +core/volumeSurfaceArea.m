function [A, As, Ads] = volumeSurfaceArea(nodes, tetra, tI)
%
% [A, As, Ads] = volumeSurfaceArea(nodes, tetra, tI)
%
% Computes the total surface area of a given tetrahedral volume. Also returns
% the individual areas and area vectors of the surface triangles.
%

    arguments
        nodes (:,3) double { mustBeFinite }
        tetra (:,4) uint32 { mustBePositive }
        tI    (:,1) uint32 { mustBePositive }
    end

    [As, Ads] = core.tetraSurfaceAreas (nodes, tetra, tI) ;

    A = sum ( As ) ;

end % function
