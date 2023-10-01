function coords = shape_vertex_coordinates ( nodes, shapes )
%
% coords = shape_vertex_coordinates ( nodes, shapes )
%
% Returns the coordinates of the linear shape vertices in this surface mesh,
% grouped per shape.
%

    arguments
        nodes  (:,:) double { mustBeFinite }
        shapes (:,:) uint64 { mustBePositive }
    end

    coords = nodes ( :, shapes ) ;

end % function
