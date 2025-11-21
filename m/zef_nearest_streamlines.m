function [sl_indices, dists, sl_lengths] = zef_nearest_streamlines(points, dti_streamlines, roi_radius)

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

    sl_indices = cell(n_points,1);
    dists      = cell(n_points,1);
    sl_lengths = cell(n_points,1);

    for p = 1:n_points
        neigh_idx  = idx_cells{p};
        neigh_dist = dist_cells{p};

        if isempty(neigh_idx)
            sl_indices{p} = [];
            dists{p}      = [];
            sl_lengths{p} = [];
            continue;
        end

        best_dist   = inf(n_streams,1);
        best_p_idx  = zeros(n_streams,1);

        for t = 1:numel(neigh_idx)
            g = neigh_idx(t);
            d = neigh_dist(t);

            s = stream_id(g);
            if d < best_dist(s)
                best_dist(s)  = d;
                best_p_idx(s) = point_id(g);
            end
        end

        valid = best_p_idx > 0;
        u_s   = find(valid);
        n_u   = numel(u_s);

        sl_idx_p = zeros(n_u,1);
        dist_p   = zeros(n_u,1);
        length_p = zeros(n_u,1);

        for k = 1:n_u
            s = u_s(k);
            sl_idx_p(k) = s;
            dist_p(k)   = best_dist(s);
            length_p(k) = cum_lengths{s}(best_p_idx(s));
        end

        sl_indices{p} = sl_idx_p;
        dists{p}      = dist_p;
        sl_lengths{p} = length_p;
    end
end
