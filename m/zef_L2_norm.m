function norm = zef_L2_norm(arr, dim)

    % Calculates the L2-norm of a given array arr along a given dimension dim.
    % If the dimension is not given, calculates the norm assuming arr is a
    % vector.

    if nargin == 2
        norm = sqrt(sum(arr.^2, dim));
    else
        norm = sqrt(sum(arr.^2, 'all'));
    end

end
