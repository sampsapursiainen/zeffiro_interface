function [G, interpolation_positions] = zef_hdiv_interpolation( ...
    p_nodes, ...
    p_tetrahedra, ...
    p_brain_inds, ...
    p_intended_source_inds ...
)

    % Produces a lead field interpolation matrix G with position-based
    % optimization (PBO), based on the H(div) (face-intersecting + edgewise)
    % source model. Also returns the related interpolation positions.

    arguments
        p_nodes (:,3) double {mustBeNonNan}
        p_tetrahedra (:,4) double {mustBeInteger, mustBeNonnegative}
        p_brain_inds (:,1) double {mustBeInteger, mustBeNonnegative}
        p_intended_source_inds (:,1) double {mustBeInteger, mustBeNonnegative}
    end

    G = [];

    % Open up a waitbar.

    wbtitle = 'Lead field H(div) interpolation';
    wb = waitbar(0, wbtitle);

    % Define cleanup operations, in case of an interruption.

    cleanupfn = @(wb) close(wb);
    cleanupobj = onCleanup(@() cleanupfn(wb));

    % Dipoles and their adjacency and weight matrices T and G.

    [T_fi, G_fi, ~, fi_source_directions, fi_source_positions, ~] = zef_fi_dipoles( ...
        p_nodes, ...
        p_tetrahedra, ...
        p_brain_inds ...
    );

    [T_ew, G_ew, ~, ew_source_directions, ew_source_positions, ~] = zef_ew_dipoles( ...
        p_nodes, ...
        p_tetrahedra, ...
        p_brain_inds ...
    );

    % Form local environment indices based on adjacency matrix T_fi. TODO:
    % change this to use some other condition than .

    valid_source_inds = full(find(sum(T_fi) >= 4))';
    valid_source_inds = intersect(valid_source_inds, p_intended_source_inds);

    % Restrict stensils to intended source positions.

    T_fi = T_fi(:, valid_source_inds);
    T_ew = T_ew(:, valid_source_inds);

    % Form interpolation positions (barycenters of tetrahedra).

    source_tetra = p_tetrahedra(valid_source_inds,:);
    interpolation_positions = zef_tetra_barycentra(p_nodes, source_tetra);

    % Form initial values based on given nodes, tetrahedra and lead field.

    n_of_iterations = size(valid_source_inds, 1);

    print_interval = ceil(n_of_iterations / 100);

    % Initialize weight matrix.

    G_rows = size(p_nodes, 1);
    G_cols = 3 * size(interpolation_positions, 1);

    G = sparse(G_rows, G_cols, 0);

    % Start iteration over the source positions of interest.

    tic;

    %% Generate coefficient matrix indices and values before allocating space
    %  for G. Start by storing the actual coefficient values and their
    %  corresponding rows and columns in the adjacency matrices T into cell
    %  arrays or tuples.

    fi_coeff_row_col_val = cell(0);
    ew_coeff_row_col_val = cell(0);

    for i = 1 : n_of_iterations

        % Find local neighbour indices.

        fi_neighbour_inds = full(find(T_fi(:,i)));
        ew_neighbour_inds = full(find(T_ew(:,i)));

        % N of non-zero object function coefficients.

        n_coeff_fi = numel(fi_neighbour_inds);
        n_coeff_ew = numel(ew_neighbour_inds);
        n_coeff = n_coeff_fi + n_coeff_ew;

        % Dipole locations and directions.

        dir_mat = [ ...
            fi_source_directions(fi_neighbour_inds,:) ; ...
            ew_source_directions(ew_neighbour_inds,:) ...
        ];

        loc_mat = [ ...
            fi_source_positions(fi_neighbour_inds,:) ; ...
            ew_source_positions(ew_neighbour_inds,:) ...
        ];

        % PBO weigth coefficients from differences between barycentra
        % (interpolation positions) and dipole positions.

        interp_pos = interpolation_positions(i, :);
        interp_pos = repmat(interp_pos, n_coeff, 1);

        pos_diffs = loc_mat - interp_pos;

        weight_coefs = zef_L2_norm(pos_diffs, 2);

        % Position-based optimization matrix.

        PBO_mat = [                     ...
            diag(weight_coefs) dir_mat; ...
            dir_mat' zeros(3,3)         ...
        ];

        % Solve for Lagrangian multipliers.

        Coeff_mat = PBO_mat \ [zeros(n_coeff,3); eye(3)];

        % Row indices (repeated because there are multiple values per row)

        fi_coeff_row_col_val{i,1} = repmat(fi_neighbour_inds, 1, size(Coeff_mat,2));
        ew_coeff_row_col_val{i,1} = repmat(ew_neighbour_inds, 1, size(Coeff_mat,2));

        % Column indices (again repeated for the same reasons as above)

        col_inds = (3 * (i-1) + 1 : 3 * i)';

        fi_coeff_row_col_val{i,2} = repmat(col_inds, 1, length(fi_neighbour_inds))';
        ew_coeff_row_col_val{i,2} = repmat(col_inds, 1, length(ew_neighbour_inds))';

        % Values

        fi_coeff_row_col_val{i,3} = Coeff_mat(1 : n_coeff_fi, :);
        ew_coeff_row_col_val{i,3} = Coeff_mat(n_coeff_fi+1 : n_coeff, :);

        % Update waitbar.

        if mod(i, print_interval) == 0

            time_val = toc;

            waitbar( ...
                i/n_of_iterations, ...
                wb, ...
                [ ...
                    wbtitle, ...
                    ' (', ...
                    num2str(i), ...
                    ' / ', ...
                    num2str(n_of_iterations), ...
                    '). Ready: ' datestr(datevec(now+(n_of_iterations/i - 1)*time_val/86400)) '.' ...
                ] ...
            );

        end
    end

    % Number of needed indices in the sparse matrix G from how many
    % coefficients were found during above iteration.

    entry_counter_fi = 0;
    entry_counter_ew = 0;

    for i = 1 : n_of_iterations

        n_of_fi_vals = numel(fi_coeff_row_col_val{i, 3});
        n_of_ew_vals = numel(ew_coeff_row_col_val{i, 3});

        entry_counter_fi = entry_counter_fi + n_of_fi_vals;
        entry_counter_ew = entry_counter_ew + n_of_ew_vals;

    end

    n_of_entries_fi = entry_counter_fi;
    n_of_entries_ew = entry_counter_ew;

    % Construct the row I, column J and coeff value K vectors needed to
    % instantiate interpolation matrix G with sparse.

    entry_counter_fi = 0;
    entry_counter_ew = 0;

    I_fi = zeros(n_of_entries_fi,1);
    J_fi = zeros(n_of_entries_fi,1);
    K_fi = zeros(n_of_entries_fi,1);

    I_ew = zeros(n_of_entries_ew,1);
    J_ew = zeros(n_of_entries_ew,1);
    K_ew = zeros(n_of_entries_ew,1);

    % Fill in the index and value vectors.

    for i = 1 : n_of_iterations

        fi_row_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 1);
        fi_col_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 2);
        fi_val_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 3);

        I_fi(fi_row_inds) = fi_coeff_row_col_val{i,1}(:);
        J_fi(fi_col_inds) = fi_coeff_row_col_val{i,2}(:);
        K_fi(fi_val_inds) = fi_coeff_row_col_val{i,3}(:);

        entry_counter_fi = entry_counter_fi + numel(fi_coeff_row_col_val{i,1});

        ew_row_inds = row_col_val_inds_fn(entry_counter_ew, ew_coeff_row_col_val, i, 1);
        ew_col_inds = row_col_val_inds_fn(entry_counter_ew, ew_coeff_row_col_val, i, 2);
        ew_val_inds = row_col_val_inds_fn(entry_counter_ew, ew_coeff_row_col_val, i, 3);

        I_ew(ew_row_inds) = ew_coeff_row_col_val{i,1}(:);
        J_ew(ew_col_inds) = ew_coeff_row_col_val{i,2}(:);
        K_ew(ew_val_inds) = ew_coeff_row_col_val{i,3}(:);

        entry_counter_ew = entry_counter_ew + numel(ew_coeff_row_col_val{i,1});

    end

    % Finally, allocate and instantiate building blocks of G only once.

    S_fi = sparse(I_fi, J_fi, K_fi, size(G_fi,2), G_cols);
    S_ew = sparse(I_ew, J_ew, K_ew, size(G_ew,2), G_cols);

    G = G_fi * S_fi + G_ew * S_ew;

    waitbar(1, wb);

end

%% Helper functions

function inds = row_col_val_inds_fn(entry_counter, rows_cols_vals, iter_ind, selector_ind)

    % A helper function for cleaning up above index selection code.
    %
    % Input
    %
    % - entry_counter: keeps track of how manu coefficient values there were
    %   per transfer matrix column.
    %
    % - rows_cols_vals: a tuple (cell array) of PBO coefficient
    %   (rows,cols,vals) arrays.
    %
    % - iter_ind: a valid source tetra index.
    %
    % - selector_ind: in {1,2,3}. Used to choose either rows (1), columns (2)
    %   or values (3) from rows_cols_and_vals.
    %
    % Output:
    %
    % - the row-, column- or value indices in coeff_rows_cols_vals

    arguments
        entry_counter
        rows_cols_vals
        iter_ind
        selector_ind
    end

    begini = entry_counter + 1;
    endi = entry_counter + numel(rows_cols_vals{iter_ind, selector_ind});

    inds = begini : endi;

end
