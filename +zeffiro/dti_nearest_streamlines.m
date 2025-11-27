function [sl_indices, sl_dists, sl_lengths] = dti_nearest_streamlines(points, dti_streamlines, roi_radius)
%
% [sl_indices, sl_dists, sl_lengths] = dti_nearest_streamlines(points, dti_streamlines, roi_radius)
%
% Finds the nearest streamline points to a set of query points within a specified radius.
%
% Inputs:
%   points: Nx3 matrix of query points.
%   dti_streamlines: Cell array of streamlines, where each streamline is an Mx3 matrix.
%   roi_radius: Search radius for nearest neighbor search (default: 15).
%
% Outputs:
%   sl_indices: Nx1 vector of indices of the nearest streamlines for each query point.
%   sl_dists: Nx1 vector of distances to the nearest streamline points.
%   sl_lengths: Nx1 vector of cumulative lengths along the streamlines to the nearest points.
%

    arguments
        points (:, 3) {mustBeNumeric, mustBeReal}
        dti_streamlines (:, 1) cell
        roi_radius (1, 1) {mustBeNumeric, mustBeReal, mustBePositive} = 15
    end

    % Number of query points
    n_points = size(points, 1);

    % Number of streamlines
    n_streams = numel(dti_streamlines);

    % Calculate the total number of points across all streamlines
    total_pts = 0;
    for s = 1:n_streams
        sl = dti_streamlines{s};
        if ~isempty(sl)
            total_pts = total_pts + size(sl, 1);
        end
    end

    % Initialize arrays to store all streamline points and their metadata

    P_all = zeros(total_pts, 3); % All streamline points
    stream_id = zeros(total_pts, 1); % Streamline index for each point
    point_id = zeros(total_pts, 1); % Point index within each streamline
    stream_start = zeros(n_streams, 1); % Start index of each streamline in P_all
    stream_end = zeros(n_streams, 1); % End index of each streamline in P_all
    cum_lengths = cell(n_streams, 1); % Cumulative lengths along each streamline

    % Populate P_all, stream_id, point_id, and cum_lengths
    offset = 0;
    for s = 1:n_streams
        sl = dti_streamlines{s};
        if isempty(sl)
            cum_lengths{s} = [];
            stream_start(s) = offset + 1;
            stream_end(s) = offset;
            continue;
        end

        % Number of points in the current streamline
        m = size(sl, 1);

        % Indices for the current streamline in P_all
        idx = offset + (1:m);

        % Store streamline points and metadata
        P_all(idx, :) = sl;
        stream_id(idx) = s;
        point_id(idx) = (1:m).';

        % Calculate cumulative lengths along the streamline
        ds = sqrt(sum(diff(sl, 1, 1).^2, 2));
        cum_lengths{s} = [0; cumsum(ds)];

        % Update stream start and end indices
        stream_start(s) = offset + 1;
        stream_end(s) = offset + m;

        % Update offset for the next streamline
        offset = offset + m;
    end

    % Create a KD-tree for nearest neighbor search
    tree = createns(P_all, 'NSMethod', 'kdtree');

    % Find all points within roi_radius of each query point
    [idx_cells, dist_cells] = rangesearch(tree, points, roi_radius);

    % Initialize output arrays
    sl_indices = zeros(n_points, 1);
    sl_dists = zeros(n_points, 1);
    sl_lengths = zeros(n_points, 1);

    % For each query point, find the nearest streamline point

    for p = 1:n_points

        if isempty(idx_cells{p})
            continue; % No streamline points found within roi_radius
        end

        % Find the nearest point among those within roi_radius
        [min_dist, min_idx] = min(dist_cells{p});

        % Get the streamline and point indices of the nearest point
        min_point_idx = point_id(idx_cells{p}(min_idx));
        min_stream_idx = stream_id(idx_cells{p}(min_idx));

        % Get the cumulative length to the nearest point
        min_cum_length = cum_lengths{min_stream_idx}(min_point_idx);

        % Store results
        sl_indices(p) = min_stream_idx;
        sl_dists(p) = min_dist;
        sl_lengths(p) = min_cum_length;

    end % for

end % function
