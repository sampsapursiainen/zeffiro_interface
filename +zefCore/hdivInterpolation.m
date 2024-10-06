function G = hdivInterpolation( ...
    p_intended_source_inds, ...
    sourcePos, ...
    p_optimization_system_type, ...
    T_fi, ...
    G_fi, ...
    fi_source_directions, ...
    fi_source_positions, ...
    T_ew, ...
    G_ew, ...
    ew_source_directions, ...
    ew_source_positions ...
)
%
% G = hdivInterpolation( ...
%     p_intended_source_inds, ...
%     p_optimization_system_type, ...
%     sourcePos, ...
%     T_fi, ...
%     G_fi, ...
%     fi_source_directions, ...
%     fi_source_positions, ...
%     T_ew, ...
%     G_ew, ...
%     ew_source_directions, ...
%     ew_source_positions ...
% )
%
% Produces a lead field interpolation matrix G with position-based
% optimization (PBO), based on the H(div) (face-intersecting + edgewise)
% source model. Also returns the related interpolation positions.
%
% Input:
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
% - T_fi
%
%   A facenum × tetranum adjacency matrix, which tells which tetra share a face.
%
% - G_fi
%
%   A sign matrix, which tells the polarity of the ends of tetra that might
%   form a face-intersecting dipole according to T_fi.
%
% - fi_source_directions
%
%   Face-intersecting source directions.
%
% - fi_source_positions
%
%   Face-intersecting source positions.
%
% - T_ew
%
%   A edgenum × tetranum adjacency matrix, which tells which tetra share a face.
%
% - G_ew
%
%   A sign matrix, which tells the polarity of the ends of edges that might
%   form a edgewise dipole according to T_ew.
%
% - ew_source_directions
%
%   Edgewise source directions.
%
% - ew_source_positions
%
%   Edgewise source positions.
%
% Output:
%
% - G
%
%   Interpolation matrix that is to be multiplied by the transpose of the
%   transfer matrix in the lead field routines.
%

arguments
    p_intended_source_inds (:,1) double {mustBeInteger, mustBePositive}
    sourcePos (:,3) double { mustBeFinite }
    p_optimization_system_type (1,1) string { mustBeMember(p_optimization_system_type,["pbo","mpo"]) }
    T_fi (:,:) double { mustBeFinite }
    G_fi (:,:) double { mustBeFinite }
    fi_source_directions (:,3) double { mustBeFinite }
    fi_source_positions (:,3) double { mustBeFinite }
    T_ew (:,:) double { mustBeFinite }
    G_ew (:,:) double { mustBeFinite }
    ew_source_directions (:,3) double { mustBeFinite }
    ew_source_positions (:,3) double { mustBeFinite }
end

% Form initial values based on given nodes, tetrahedra and lead field.

n_of_iterations = size (sourcePos, 1) ;

print_interval = ceil (n_of_iterations / 100);

% Initialize weight matrix.

Ncols = 3 * size (sourcePos, 1);

NrowsFI = size (G_fi,2) ;
NrowsEW = size (G_ew,2) ;

% Generate coefficient matrix indices and values before allocating space for G.
% Start by storing the actual coefficient values and their corresponding rows
% and columns in the adjacency matrices T into cell arrays or tuples.

fi_coeff_row_col_val = cell(0);
ew_coeff_row_col_val = cell(0);

disp (newline + "Solving H(div) with " + p_optimization_system_type + "..." + newline) ;

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    % Get global source index.

    source_ind = p_intended_source_inds(i);

    % Find local neighbour indices.

    fi_neighbour_inds = full ( find ( T_fi (:,source_ind) ) );
    ew_neighbour_inds = full ( find ( T_ew (:,source_ind) ) );

    % N of non-zero object function coefficients.

    n_coeff_fi = numel (fi_neighbour_inds);
    n_coeff_ew = numel (ew_neighbour_inds);
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

    % Interpolation coefficients.

    if p_optimization_system_type == "pbo"

        Coeff_mat = zefCore.pboSystem ( ...
            loc_mat, ...
            dir_mat, ...
            sourcePos (i,:), ...
            n_coeff ...
        );

    elseif p_optimization_system_type == "mpo"

        Coeff_mat = zefCore.mpoSystem ( ...
            loc_mat, ...
            dir_mat, ...
            sourcePos (i,:), ...
            n_coeff ...
        );

    else

        error('To interpolate, one must optimize with either a PBO or an MPO system.')

    end % if

    % Row indices (repeated because there are multiple values per row)

    fi_coeff_row_col_val{i,1} = repmat (fi_neighbour_inds, 1, size (Coeff_mat,2) );
    ew_coeff_row_col_val{i,1} = repmat (ew_neighbour_inds, 1, size (Coeff_mat,2) );

    % Column indices (again repeated for the same reasons as above)

    col_inds = (3 * (i-1) + 1 : 3 * i)';

    fi_coeff_row_col_val{i,2} = repmat (col_inds, 1, length (fi_neighbour_inds) )';
    ew_coeff_row_col_val{i,2} = repmat (col_inds, 1, length (ew_neighbour_inds) )';

    % Values

    fi_coeff_row_col_val{i,3} = Coeff_mat (1 : n_coeff_fi, :);
    ew_coeff_row_col_val{i,3} = Coeff_mat (n_coeff_fi+1 : n_coeff, :);

end % for

% Number of needed indices in the sparse matrix G from how many
% coefficients were found during above iteration.

entry_counter_fi = 0;
entry_counter_ew = 0;

disp (newline + "Counting required number interpolation matrix entries..." + newline) ;

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    n_of_fi_vals = numel (fi_coeff_row_col_val{i, 3}) ;
    n_of_ew_vals = numel (ew_coeff_row_col_val{i, 3}) ;

    entry_counter_fi = entry_counter_fi + n_of_fi_vals ;
    entry_counter_ew = entry_counter_ew + n_of_ew_vals ;

end % for

n_of_entries_fi = entry_counter_fi ;
n_of_entries_ew = entry_counter_ew ;

% Construct the row I, column J and coeff value K vectors needed to
% instantiate interpolation matrix G with sparse.

entry_counter_fi = 0;
entry_counter_ew = 0;

I_fi = zeros (n_of_entries_fi,1) ;
J_fi = zeros (n_of_entries_fi,1) ;
K_fi = zeros (n_of_entries_fi,1) ;

I_ew = zeros (n_of_entries_ew,1) ;
J_ew = zeros (n_of_entries_ew,1) ;
K_ew = zeros (n_of_entries_ew,1) ;

% Fill in the index and value vectors.

disp (newline + "Generating interpolation matrix initialization vectors..." + newline)

for i = 1 : n_of_iterations

    zefCore.dispProgress (i, n_of_iterations) ;

    fi_row_inds = row_col_val_inds_fn (entry_counter_fi, fi_coeff_row_col_val, i, 1 ) ;
    fi_col_inds = row_col_val_inds_fn (entry_counter_fi, fi_coeff_row_col_val, i, 2 ) ;
    fi_val_inds = row_col_val_inds_fn (entry_counter_fi, fi_coeff_row_col_val, i, 3 ) ;

    I_fi(fi_row_inds) = fi_coeff_row_col_val {i,1} (:) ;
    J_fi(fi_col_inds) = fi_coeff_row_col_val {i,2} (:) ;
    K_fi(fi_val_inds) = fi_coeff_row_col_val {i,3} (:) ;

    entry_counter_fi = entry_counter_fi + numel (fi_coeff_row_col_val {i,1}) ;

    ew_row_inds = row_col_val_inds_fn (entry_counter_ew, ew_coeff_row_col_val, i, 1) ;
    ew_col_inds = row_col_val_inds_fn (entry_counter_ew, ew_coeff_row_col_val, i, 2) ;
    ew_val_inds = row_col_val_inds_fn (entry_counter_ew, ew_coeff_row_col_val, i, 3) ;

    I_ew(ew_row_inds) = ew_coeff_row_col_val {i,1} (:) ;
    J_ew(ew_col_inds) = ew_coeff_row_col_val {i,2} (:) ;
    K_ew(ew_val_inds) = ew_coeff_row_col_val {i,3} (:) ;

    entry_counter_ew = entry_counter_ew + numel (ew_coeff_row_col_val {i,1}) ;

end % for

% Finally, allocate and instantiate building blocks of G only once.

S_fi = sparse (I_fi, J_fi, K_fi, NrowsFI, Ncols) ;
S_ew = sparse (I_ew, J_ew, K_ew, NrowsEW, Ncols) ;

G = G_fi * S_fi + G_ew * S_ew ;

end % function

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
