function [sl_indices, sl_dists, sl_lengths] = zef_dti_nearest_streamlines(points, dti_streamlines, roi_radius)

    n_points  = size(points,1);
    n_streams = numel(dti_streamlines);

    total_pts = 0;
    for s = 1:n_streams
        sl = dti_streamlines{s};
        if ~isempty(sl)
            total_pts = total_pts + size(sl,1);
        end
    end

    P_all       = zeros(total_pts, 3);
    stream_id   = zeros(total_pts, 1);
    point_id    = zeros(total_pts, 1);
    stream_start = zeros(n_streams,1);
    stream_end   = zeros(n_streams,1);
    cum_lengths = cell(n_streams,1);

    offset = 0;
    for s = 1:n_streams
        sl = dti_streamlines{s};
        if isempty(sl)
            cum_lengths{s} = [];
            stream_start(s) = offset + 1;
            stream_end(s)   = offset;
            continue;
        end

        m = size(sl,1);
        idx = offset + (1:m);

        P_all(idx,:)   = sl;
        stream_id(idx) = s;
        point_id(idx)  = (1:m).';

        ds = sqrt(sum(diff(sl,1,1).^2,2));
        cum_lengths{s} = [0; cumsum(ds)];

        stream_start(s) = offset + 1;
        stream_end(s)   = offset + m;

        offset = offset + m;
    end

    tree = createns(P_all, 'NSMethod','kdtree');

    [idx_cells, dist_cells] = rangesearch(tree, points, roi_radius);

    sl_indices = zeros(n_points,1);
    sl_dists      = zeros(n_points,1);
    sl_lengths = zeros(n_points,1);

    for p = 1:n_points

        if isempty(idx_cells{p})
            continue;
        end

[min_dist, min_idx] = min(dist_cells{p});
min_point_idx = point_id(idx_cells{p}(min_idx));
min_stream_idx = stream_id(idx_cells{p}(min_idx));
min_cum_length = cum_lengths{min_stream_idx}(min_point_idx);


        sl_indices(p) = min_stream_idx;
        sl_dists(p)      = min_dist;
        sl_lengths(p) = min_cum_length;
    end
end
