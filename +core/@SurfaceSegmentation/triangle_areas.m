function areas = triangle_areas ( self, inds )
%
% areas = triangle_areas ( self, inds )
%
% Computes the areas of the triangles indicated by the given inds in this
% surface segmentation.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    normals = self.surface_normals ( inds ) ;

    norms = sqrt ( sum ( normals .^ 2 , 2 ) ) ;

    areas = normals ./ norms / 2 ;

end % function
