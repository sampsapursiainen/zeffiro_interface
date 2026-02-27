function tensor_array = dti_tensor_interpolate(reference_points, dti_tensor, scale_value, roi_radius, mode)
%
% tensor_array = zeffiro.dti.dti_tensor_interpolate(reference_points, dti_tensor, scale_value, roi_radius, mode)
%
% Interpolates diffusion tensor values at specified
% reference points using either nearest-neighbor or
% radius-averaged interpolation.
%
% Inputs:
%   reference_points: Nx3 matrix of coordinates where tensor values are to be interpolated.
%   dti_tensor: 4D array of size (nx, ny, nz, 6) containing diffusion tensor components.
%   scale_value: Scaling value for zero tensors (default: 1).
%   roi_radius: Radius for radius-averaged interpolation (default: 5).
%   mode: Interpolation mode, either 'nearest' or 'radius_average' (default: 'nearest').
%
% Output:
%   tensor_array: Nx6 matrix of interpolated tensor components for each reference point.
%

    arguments
        reference_points (:, 3) { mustBeNumeric, mustBeReal, mustBeFinite }
        dti_tensor (:, :, :, 6) { mustBeNumeric, mustBeReal, mustBeFinite }
        scale_value (1, 1) { mustBeNumeric, mustBeReal, mustBePositive } = 1
        roi_radius (1, 1) { mustBeNumeric, mustBeReal, mustBePositive } = 5
        mode (1, :) char { mustBeMember(mode, {'nearest', 'radius_average'}) } = 'nearest'
    end

    % Get the dimensions of the tensor
    [nx, ny, nz, ~] = size(dti_tensor);

    % Number of reference points
    N = size(reference_points, 1);

    % Initialize output array
    tensor_array = zeros(N, 6);

    % Loop over each reference point
    for i = 1:N
        % Current reference point coordinates
        c = reference_points(i, :);

        % Round coordinates to nearest voxel indices
        ix = round(c(1));
        iy = round(c(2));
        iz = round(c(3));

        % Clamp indices to valid range
        ix = min(max(ix, 1), nx);
        iy = min(max(iy, 1), ny);
        iz = min(max(iz, 1), nz);

        % Interpolate based on the specified mode
        if strcmp(mode, 'nearest')
            % Nearest-neighbor interpolation: use the tensor at the nearest voxel
            tensor_array(i, :) = squeeze(zeffiro.dti.dti_tensor(ix, iy, iz, :)).';

        elseif strcmp(mode, 'radius_average')
            % Radius-averaged interpolation: average tensors within a spherical ROI

            % Define the bounds of the ROI
            ix_min = max(1, floor(c(1) - roi_radius));
            ix_max = min(nx, ceil(c(1) + roi_radius));
            iy_min = max(1, floor(c(2) - roi_radius));
            iy_max = min(ny, ceil(c(2) + roi_radius));
            iz_min = max(1, floor(c(3) - roi_radius));
            iz_max = min(nz, ceil(c(3) + roi_radius));

            % Initialize accumulator and counter
            acc = zeros(1, 6);
            count = 0;

            % Loop over the ROI
            for xi = ix_min:ix_max
                dx = xi - c(1);
                for yi = iy_min:iy_max
                    dy = yi - c(2);
                    for zi = iz_min:iz_max
                        dz = zi - c(3);

                        % Check if the voxel is within the spherical ROI
                        if dx*dx + dy*dy + dz*dz <= roi_radius^2
                            acc = acc + squeeze(zeffiro.dti.dti_tensor(xi, yi, zi, :)).';
                            count = count + 1;
                        end
                    end
                end
            end

            % Average the tensors within the ROI
            if count > 0
                tensor_array(i, :) = acc / count;
            else
                % Fallback to nearest-neighbor if no voxels are found
                tensor_array(i, :) = squeeze(zeffiro.dti.dti_tensor(ix, iy, iz, :)).';
            end

        else
            % This should never be reached due to argument validation
            error('Unknown mode: %s (use "nearest" or "radius_average")', mode);
        end
    end

    % Replace zero tensors with scaled identity tensors
    I = find(sum(abs(tensor_array), 2) == 0);
    tensor_array(I, 1) = scale_value;
    tensor_array(I, 2) = scale_value;
    tensor_array(I, 3) = scale_value;
end
