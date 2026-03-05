function [G, interpolation_positions] = whitneyInterpolation( ...
    p_nodes, ...
    p_tetrahedra, ...
    p_brain_inds, ...
    p_intended_source_inds, ...
    p_nearest_neighbour_inds, ...
    p_optimization_system_type ...
    )
%
% [G, interpolation_positions] = whitneyInterpolation( ...
%   p_nodes, ...
%   p_tetrahedra, ...
%   p_brain_inds, ...
%   p_intended_source_inds, ...
%   p_nearest_neighbour_inds, ...
%   p_optimization_system_type ...
% )
%
% Produces a lead field interpolation matrix G with position-based
% optimization (PBO), based on the Whitney (face-intersecting) source
% model. Also returns the related interpolation positions.
%
% Input:
%
% - p_nodes
%
%   The nodes that form the tetrahedral mesh.
%
% - p_tetrahedra
%
%   The tetrahedra (4-tuples of node indices) that are formed from
%   p_nodes.
%
% - p_brain_inds
%
%   The indices of the tetrahedra where sources can be placed in the first
%   place. In other words, these tetra form the gray matter.
%
% - p_intended_source_inds
%
%   These are the subset of the tetrahedral indices which indicate where
%   dipolar sources are to be placed in, not just where they can be
%   placed.
%
% - p_nearest_neighbour_inds
%
%   Used by the continuous source models to determine which neighbours of
%   neighbours of each central source tetrahedron are to be included in
%   the interpolation. If this is empty, the source model is interpreted
%   as being discrete.
%
% Output:
%
% - G
%
%   Interpolation matrix that is to be multiplied by the transpose of the
%   transfer matrix in the lead field routines.
%
% - interpolation_positions
%
%   The positions at which sources are the be placed after interpolation.
%

arguments
    p_nodes (:,3) double {mustBeNonNan}
    p_tetrahedra (:,4) double {mustBeInteger, mustBePositive}
    p_brain_inds (:,1) double {mustBeInteger, mustBePositive}
    p_intended_source_inds (:,1) double {mustBeInteger, mustBePositive}
    p_nearest_neighbour_inds (:,1) double {mustBeInteger, mustBePositive}
    p_optimization_system_type { ...
        mustBeText, ...
        mustBeMember(p_optimization_system_type,{'pbo','mpo'}) ...
        }
end

G = [];

% Dipoles and their adjacency and weight matrices T and G.

[T_fi, G_fi, ~, fi_source_directions, fi_source_positions, ~] = zefCore.faceIntersectingDipoles ( ...
    p_nodes, ...
    p_tetrahedra, ...
    p_brain_inds ...
    );

% Form local environment indices based on adjacency matrix T_fi.

valid_source_inds = p_intended_source_inds;

% Form interpolation positions (barycenters of tetrahedra).

source_tetra = p_tetrahedra ( valid_source_inds, : );

interpolation_positions = zefCore.tetraCentroids ( p_nodes, source_tetra ) ;

% Form initial values based on given nodes, tetrahedra and lead field.

n_of_iterations = size(valid_source_inds, 1);

% Initialize weight matrix.

G_rows = size(p_nodes, 1);
G_cols = 3 * size(interpolation_positions, 1);

G = sparse(G_rows, G_cols, 0);

%% Generate coefficient matrix indices and values before allocating space
%  for G. Start by storing the actual coefficient values and their
%  corresponding rows and columns in the adjacency matrices T into cell
%  arrays or tuples.

fi_coeff_row_col_val = cell(0);

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    % Get global source index.

    source_ind = valid_source_inds(i);

    % Find local neighbour indices.

    if isempty(p_nearest_neighbour_inds)

        fi_neighbour_inds = full(find(T_fi(:,source_ind)));

    else

        % Gather continuous environment around current source ind.

        i_locations_in_nearest_neighbour_inds = find(p_nearest_neighbour_inds == i);

        env_inds = [source_ind ; p_brain_inds(i_locations_in_nearest_neighbour_inds)];

        % Use cell arrays to store neighbour source inds per column.

        env_size = numel(env_inds);

        fi_ind_cell = cell(1, env_size);

        for ii = 1 : env_size

            fi_ind_cell{ii} = full(find(T_fi(:,env_inds(ii))))';

        end

        % Set the neighbour indices to be used in optimization.

        fi_neighbour_inds = unique([fi_ind_cell{:}]');

    end

    % N of non-zero object function coefficients.

    n_coeff_fi = numel(fi_neighbour_inds);
    n_coeff = n_coeff_fi;

    % Dipole locations and directions.

    dir_mat = [ ...
        fi_source_directions(fi_neighbour_inds,:) ...
        ];

    loc_mat = [ ...
        fi_source_positions(fi_neighbour_inds,:) ...
        ];

    % Interpolation coefficients.

    if strcmp(p_optimization_system_type, 'pbo')

        Coeff_mat = zef_pbo_system( ...
            loc_mat, ...
            dir_mat, ...
            interpolation_positions, ...
            i, ...
            n_coeff ...
            );

    elseif strcmp(p_optimization_system_type, 'mpo')

        Coeff_mat = zef_mpo_system( ...
            loc_mat, ...
            dir_mat, ...
            interpolation_positions, ...
            i, ...
            n_coeff ...
            );

    else
        error('To interpolate, one must optimize with either a PBO or an MPO system.')
    end

    % Row indices (repeated because there are multiple values per row)

    fi_coeff_row_col_val{i,1} = repmat(fi_neighbour_inds, 1, size(Coeff_mat,2));

    % Column indices (again repeated for the same reasons as above)

    col_inds = (3 * (i-1) + 1 : 3 * i)';

    fi_coeff_row_col_val{i,2} = repmat(col_inds, 1, length(fi_neighbour_inds))';

    % Values

    fi_coeff_row_col_val{i,3} = Coeff_mat(1 : n_coeff_fi, :);

end

% Number of needed indices in the sparse matrix G from how many
% coefficients were found during above iteration.

entry_counter_fi = 0;

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    n_of_fi_vals = numel(fi_coeff_row_col_val{i, 3});

    entry_counter_fi = entry_counter_fi + n_of_fi_vals;

end

n_of_entries_fi = entry_counter_fi;

% Construct the row I, column J and coeff value K vectors needed to
% instantiate interpolation matrix G with sparse.

entry_counter_fi = 0;

I_fi = zeros(n_of_entries_fi,1);
J_fi = zeros(n_of_entries_fi,1);
K_fi = zeros(n_of_entries_fi,1);

% Fill in the index and value vectors.

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    fi_row_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 1);
    fi_col_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 2);
    fi_val_inds = row_col_val_inds_fn(entry_counter_fi, fi_coeff_row_col_val, i, 3);

    I_fi(fi_row_inds) = fi_coeff_row_col_val{i,1}(:);
    J_fi(fi_col_inds) = fi_coeff_row_col_val{i,2}(:);
    K_fi(fi_val_inds) = fi_coeff_row_col_val{i,3}(:);

    entry_counter_fi = entry_counter_fi + numel(fi_coeff_row_col_val{i,1});

end

% Finally, allocate and instantiate building blocks of G only once.

S_fi = sparse(I_fi, J_fi, K_fi, size(G_fi,2), G_cols);

G = G_fi * S_fi;

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
