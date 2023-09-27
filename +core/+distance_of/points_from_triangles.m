function distances = points_from_triangles ( points, vertices )
%
% distances = points_from_triangles ( points, vertices )
%
% Computes the distances of the given points from the given triangles.
%
% Inputs:
%
% - points
%
%   The points whose distance from the triangles in being computed.
%
% - vertices
%
%   The coordinates of the triangle vertices.
%
% - triangles
%
%   The index set which determines
%

    arguments
        points   (3,:) double { mustBeFinite }
        vertices (3,:) double { mustBeFinite }
    end

    % Compute edges and then normals.

    A = vertices ( :, 1 : 3 : end ) ;

    B = vertices ( :, 2 : 3 : end ) ;

    C = vertices ( :, 3 : 3 : end ) ;

    E1 = B - A ;

    E2 = C - A ;

    normals = cross ( E1, E2, 1 ) ;

    % Create all combinations of points and vertices, to allow for vectorized operations.

    n_of_P = size ( points, 2 ) ;

    n_of_A = size ( A, 2 ) ;

    repeated_points = repelem ( points, 1, n_of_A ) ;

    repeated_A = repmat ( A, 1, n_of_P ) ;
    repeated_B = repmat ( B, 1, n_of_P ) ;
    repeated_C = repmat ( C, 1, n_of_P ) ;

    AP = repeated_points - repeated_A ;
    BP = repeated_points - repeated_B ;
    CP = repeated_points - repeated_C ;

    repeated_normals = repmat ( normals, 1, n_of_P ) ;

    coeffs = dot ( AP, repeated_normals, 1 ) ;

    % Projections Q of all points onto all triangles, grouped by points.

    AQ = AP - coeffs .* repeated_normals ;

    Q = repeated_A + AQ ;

    n_of_Q = size ( Q, 2 ) ;

    % Express Q as a linear combination of the triangle vertex coordinate
    % vectors A, B, C, as in a solve the linear system
    %
    %   Q = aA + bB + cC = [A B C] * [a;b;c]
    %
    % for a, b and c for all point--triangle combinations.

    abc = NaN ( 3, n_of_Q ) ;

    triangle = zeros ( 3,3 ) ;

    for ii = 1 : n_of_Q

        triangle (:,1) = repeated_A ( : , ii ) ;

        triangle (:,2) = repeated_B ( : , ii ) ;

        triangle (:,3) = repeated_C ( : , ii ) ;

        abc ( :, ii ) = triangle \ Q ( :, ii ) ;

    end % for

    % Determine distances from barycentric coordinates a, b and c of Q.

    distances = NaN ( 1, n_of_Q ) ;

    I = abc (1,:) >= 0 & abc (2,:) >= 0 & abc (3,:) >= 0 & isnan ( distances ) ;

    if any ( I )

        distances ( I ) = coeffs ( I ) ;

    end

    I = abc (1,:) < 0 & abc (2,:) >= 0 & abc (3,:) >= 0 & isnan ( distances ) ;

    if any ( I ) && all ( isnan ( distances ( I ) ) )

        dd = core.distance_of.points_from_lines ( points, B, C ) ;

        distances ( I ) = dd ( I ) ;

    end

    I = abc (1,:) >= 0 & abc (2,:) < 0 & abc (3,:) >= 0 & isnan ( distances ) ;

    if any ( I )

        dd = core.distance_of.points_from_lines ( points, C, A ) ;

        distances ( I ) = dd ( I ) ;

    end

    I = abc (1,:) >= 0 & abc (2,:) >= 0 & abc (3,:) < 0 & isnan ( distances ) ;

    if any ( I )

        dd = core.distance_of.points_from_lines ( points, A, B ) ;

        distances ( I ) = dd ( I ) ;

    end

    I = abc (1,:) < 0 & abc (2,:) < 0 & abc (3,:) >= 0 & isnan ( distances ) ;

    if any ( I )

        distances ( I ) = abs ( CP ( I ) ) ;

    end

    I = abc (1,:) >= 0 & abc (2,:) < 0 & abc (3,:) < 0 & isnan ( distances ) ;

    if any ( I )

        distances ( I ) = abs ( AP ( I ) ) ;

    end

    I = abc (1,:) < 0 & abc (2,:) >= 0 & abc (3,:) < 0 & isnan ( distances ) ;

    if any ( I )

        distances ( I ) = abs ( BP ( I ) ) ;

    end

    if any ( isnan ( distances ) )

        error ( "Some distances were not set properly." ) ;

    end

end % function
