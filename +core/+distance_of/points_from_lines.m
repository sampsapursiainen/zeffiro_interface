function distances = points_from_lines ( points, line_starts, line_ends )
%
% distances = points_from_lines ( points, lines )
%
% Computes the distances of a given set of N-dimensional points to a set of
% N-dimensional lines.
%
% Inputs:
%
% - points
%
%   The set of points whose distances will be computed. The points are assumed
%   to be stored as the columns of a matrix.
%
% - line_starts
%
%   N-dimensional start_points of lines. Again, the coordinates are assumed to
%   be stored as the columns of a matrix, and two subsequent columns are
%   interpreted as the endpoints of a single line.
%
% - line_ends
%
%   N-dimensional endpoints of lines. Again, the coordinates are assumed to be
%   stored as the columns of a matrix, and two subsequent columns are
%   interpreted as the endpoints of a single line.
%
% Outputs:
%
% - distances
%
%   The set of distances as a vector, whose size is the product of the number
%   of points and lines. Contains the distances grouped per point, so first
%   come the distances from point 1 to all lines, then come distances from point
%   2 to all lines, and so forth.
%

    arguments
        points       (:,:) double { mustBeFinite }
        line_starts (:,:) double { mustBeFinite }
        line_ends   (:,:) double { mustBeFinite }
    end

    point_dimension = size ( points, 1 ) ;

    line_start_dimension = size ( line_starts, 1 ) ;

    line_end_dimension = size ( line_ends, 1 ) ;

    assert ( point_dimension == line_start_dimension, "Received " + point_dimension + "-dimensional points and " + line_start_dimension + "-dimensional lines. The dimensions need to be the same." ) ;

    assert ( line_start_dimension == line_end_dimension, "The start and end points of lines had the respective dimensions " + line_start_dimension + " and " + line_end_dimension + ". These need to be the same." ) ;

    n_of_points = size ( points, 2 ) ;

    n_of_lines = size ( line_starts, 2 ) ;

    distances = NaN ( n_of_points * n_of_lines, 1 ) ;

    line_directions = line_ends - line_starts ;

    % Repeat points and/or lines, so that matrix sizes match during following logical indexing.

    repeated_points = repelem ( points, 1, n_of_lines ) ;

    repeated_line_starts = repmat ( line_starts, 1, n_of_points ) ;

    repeated_line_ends = repmat ( line_ends, 1, n_of_points ) ;

    repeated_directions = repmat ( line_directions, 1, n_of_points ) ;

    repeated_line_norms = sqrt ( sum ( repeated_directions .^ 2 ) ) ;

    repeated_unit_directions = repeated_directions ./ repeated_line_norms ;

    % Compute projection coefficients of points onto the given unit lines.

    start_to_point = repeated_points - repeated_line_starts ;

    point_to_end = repeated_line_ends - repeated_points ;

    coeffs = dot ( start_to_point, repeated_unit_directions ) ;

    % Check where coefficient is negative and where it is greater than the line direction length.

    ltI = coeffs <= 0 ;

    gtI  = coeffs >= repeated_line_norms ;

    ibI  = 0 < coeffs & coeffs < repeated_line_norms ;

    % Place distances into output array.

    distances ( ltI ) = sqrt ( sum ( start_to_point ( :, ltI ) .^ 2 ) ) ;

    distances ( gtI ) = sqrt ( sum ( point_to_end ( :, gtI ) .^ 2 ) ) ;

    distances ( ibI ) = sqrt ( sum ( ( repeated_directions ( :, ibI ) - coeffs ( ibI ) .* repeated_unit_directions ( :, ibI ) ) .^ 2 ) ) ;

end % function
