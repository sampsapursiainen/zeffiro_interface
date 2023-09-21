function coords = vertex_coordinates ( self, inds )
%
% coords = vertex_coords ( self, inds )
%
% Returns the coordinates of the triangles vertices in this surface mesh.
%

    arguments
        self (1,1) core.SurfaceSegmentation
        inds (:,1) uint64 { mustBePositive } = 1 : self.triangle_count
    end

    triangles = self.triangles ( inds, : ) ;

    % This is needed because of the column major order of MATLAB matrices.

    triangles = transpose ( triangles ) ;

    coords = self.nodes ( triangles, : ) ;

end % function
