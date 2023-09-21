function [ areas, normals, norms, vertex_coordinates ] = triangle_areas ( self, inds )
%
% [ areas, normals, norms, vertex_coordinates ] = triangle_areas ( self, inds )
%
% Computes the areas of the triangles indicated by the given inds in this
% surface segmentation. Also returns the surface normals, their norms and
% vertex coordinates used to compute the normals.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    [ normals, norms, vertex_coordinates ] = self.surface_normals ( inds ) ;

    norms = sqrt ( sum ( normals .^ 2 , 2 ) ) ;

    areas = norms / 2 ;

end % function
