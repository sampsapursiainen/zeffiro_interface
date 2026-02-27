function dti_streamlines = dti_streamlines(dti_directions, dti_anisotropy, seed_point, roi_radius, n_dir, step_size, max_steps, fa_thresh)
%
% dti_streamlines = zeffiro.dti.dti_streamlines(dti_directions, dti_anisotropy, seed_point, roi_radius, n_dir, step_size, max_steps, fa_thresh)
%
% Trace streamlines from a seed point using principal diffusion directions and fractional anisotropy.
%
% Inputs:
%   dti_directions: 4D array of size (nx, ny, nz, 3) containing the principal diffusion directions.
%   dti_anisotropy: 3D array of size (nx, ny, nz) containing fractional anisotropy values.
%   seed_point: 1x3 vector specifying the starting point for streamline tracing.
%   roi_radius: Radius of the region of interest for initial directions (default: 15).
%   n_dir: Number of initial directions to generate (default: 10000).
%   step_size: Step size for streamline tracing (default: 1).
%   max_steps: Maximum number of steps for each streamline (default: 1000).
%   fa_thresh: Threshold for fractional anisotropy to continue tracing (default: 0.15).
%
% Output:
%   dti_streamlines: Cell array containing the traced streamlines.

    arguments
        dti_directions (:, :, :, 3) {mustBeNumeric, mustBeReal}
        dti_anisotropy (:, :, :) {mustBeNumeric, mustBeReal}
        seed_point (1, 3) {mustBeNumeric, mustBeReal}
        roi_radius (1, 1) {mustBePositive} = 15
        n_dir (1, 1) {mustBePositive, mustBeInteger} = 10000
        step_size (1, 1) {mustBePositive} = 1
        max_steps (1, 1) {mustBePositive, mustBeInteger} = 1000
        fa_thresh (1, 1) {mustBePositive, mustBeLessThanOrEqual(fa_thresh, 1)} = 0.15
    end

    % Get the dimensions of the tensor
    nx = size(dti_directions, 1);
    ny = size(dti_directions, 2);
    nz = size(dti_directions, 3);

    % Generate initial directions on a sphere
    dirs = generate_sphere_directions(n_dir, roi_radius);

    % Initialize cell array to store streamlines
    dti_streamlines = cell(n_dir, 1);

    % Trace streamlines for each initial direction
    for k = 1:n_dir
        init_dir = dirs(k, :);
        stream = trace_streamline(seed_point, dti_directions, dti_anisotropy, step_size, max_steps, fa_thresh, init_dir);
        dti_streamlines{k} = stream;
    end

end % function

function dirs = generate_sphere_directions(N, roi_radius)
%
% dirs = generate_sphere_directions(N, roi_radius)
%
% Generate N evenly distributed directions on a sphere using the Fibonacci spiral method.
%
% Inputs:
%   N: Number of directions to generate.
%   roi_radius: Radius of the sphere.
%
% Output:
%   dirs: Nx3 matrix of directions.

    dirs = zeros(N, 3);
    phi = (1 + sqrt(5)) / 2; % Golden ratio

    % Generate directions using the Fibonacci spiral method

    for k = 0:N-1
        z = 1 - 2 * (k + 0.5) / N;
        r = sqrt(max(0, 1 - z^2));
        theta = 2 * pi * k / phi;
        x = r * cos(theta);
        y = r * sin(theta);
        dirs(k+1, :) = roi_radius * [x, y, z];
    end
end

function xyz = trace_streamline(seed_point, dti_directions, dti_anisotropy, step_size, max_steps, fa_thresh, init_dir)
%
% xyz = trace_streamline(seed_point, dti_directions, dti_anisotropy, step_size, max_steps, fa_thresh, init_dir)
%
% Trace a single streamline from a seed point using principal diffusion directions and fractional anisotropy.
%
% Inputs:
%   seed_point: 1x3 vector specifying the starting point.
%   dti_directions: 4D array of principal diffusion directions.
%   dti_anisotropy: 3D array of fractional anisotropy values.
%   step_size: Step size for tracing.
%   max_steps: Maximum number of steps.
%   fa_thresh: Threshold for fractional anisotropy.
%   init_dir: Initial direction vector.
%
% Output:
%   xyz: mx3 matrix of streamline coordinates.

    % Get the dimensions of the tensor
    [nx, ny, nz, ~] = size(dti_directions);

    % Initialize position and streamline
    pos = double(seed_point(:)');
    xyz = zeros(max_steps, 3);
    xyz(1, :) = pos;

    % Set initial direction
    d0 = init_dir(:)';
    pos = pos + d0;
    xyz(2, :) = pos;

    % Initialize previous direction and step counter
    prev_dir = d0;
    k = 2;

    % Trace the streamline

    while k < max_steps

        % Round position to nearest voxel indices

        ix = round(pos(1));
        iy = round(pos(2));
        iz = round(pos(3));

        % Check if position is outside the volume

        if ix < 1 || ix > nx || iy < 1 || iy > ny || iz < 1 || iz > nz
            xyz = xyz(1:k, :);
            return;
        end

        % Get the principal direction and FA at the current voxel

        v = squeeze(zeffiro.dti.dti_directions(ix, iy, iz, :)).';

        fa = zeffiro.dti.dti_anisotropy(ix, iy, iz);

        % Check if the direction is valid and FA is above threshold

        nrm = norm(v);

        if nrm == 0 || fa < fa_thresh
            xyz = xyz(1:k, :);
            return;
        end

        % Normalize the direction vector

        v = v / nrm;

        % Ensure the direction is consistent with the previous step

        if dot(v, prev_dir) < 0
            v = -v;
        end
        prev_dir = v;

        % Update position and store in streamline

        pos = pos + step_size * v;
        k = k + 1;
        xyz(k, :) = pos;

    end % while

    % Trim the streamline to the actual number of steps
    xyz = xyz(1:k, :);
end
