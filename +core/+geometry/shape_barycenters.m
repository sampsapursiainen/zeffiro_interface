function barycenters = shape_barycenters ( elements, shape_size )
%
% centers = shape_barycenters ( shapes, shape_size )
%
% Computes the barycenters of a uniform set of linear elements, when given the
% vertex points and the number of vertices in the elements.
%

    arguments
        elements   (:,:) double { mustBeFinite }
        shape_size (1,1) double { mustBePositive, mustBeInteger }
    end

    n_of_vertex_coordinates = size ( elements, 2 ) ;

    barycenters = zeros ( 3 , n_of_vertex_coordinates / shape_size ) ;

    for ii = 1 : size ( barycenters, 2 )

        vi = shape_size * (ii - 1) + 1 ;

        vrange = vi : vi + shape_size - 1 ;

        barycenters (:,ii) = sum ( elements ( :, vrange ), 2 ) / shape_size ;

    end % for

end % function
