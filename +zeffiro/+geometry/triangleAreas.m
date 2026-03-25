function areas = triangleAreas(triangles)
%
%   areas = triangleArea(triangles)
%
% Computes the area vectors of a given set of triangles.
% The input array can either be 2D or 3D, but the memory layouts in both cases need to match.
% It should be such that if the arra is a 3D one, the triangle vertices A, B and C are given
% as pages of the array.
%

    arguments
        triangles (:,:,:) double { mustBeFinite }
    end

    trianglesSize = size(triangles) ;

    triangleArrayDims = numel(trianglesSize) ;

    if triangleArrayDims == 2

        triangles = reshape(triangles, trianglesSize(1), 3, trianglesSize(2) / 3) ;

    end % if

    As = triangles(:,1,:) ;

    Bs = triangles(:,2,:) ;

    Cs = triangles(:,3,:) ;

    areas = cross(Bs - As, Cs - As) / 2 ;

end % function
