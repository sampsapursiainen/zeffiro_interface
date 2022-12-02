function reconstruction = reconstruction_from_edf_fn(path_to_file)

    %
    % reconstruction_from_edf_fn
    %
    % Reads an EDF or European Data Format file into a reconstruction
    % compatible with Zeffiro Interface. Supposes that the sampling rate of
    % each measurement has been constant, meaning each cell in the EDF table
    % contains the same number of samples.
    %

    arguments

        path_to_file (1,1) string { mustBeFile }

    end

    % First read the EDF file into a Matlab timetable.

    timetable = edfread(path_to_file);

    % Compute the needed size for the reconstruction matrix.

    [n_of_rows, n_of_cols] = size(timetable);

    upper_left_corner_cell = timetable{1,1};

    upper_left_corner_series = upper_left_corner_cell{1,1};

    cell_size = numel(upper_left_corner_series);

    % Preallocate the reconstruction, with the idea that the timetable will be
    % transposed.

    reconstruction = zeros(n_of_cols, n_of_rows * cell_size);

    % Then build the reconstruction by iterating over the timetable columns.

    for col = 1 : n_of_cols

        col_of_cells = timetable{:,col};

        col_as_matrix = [col_of_cells{:}];

        matrix_as_vector = col_as_matrix(:);

        reconstruction(col,:) = matrix_as_vector;

    end % for

end % function
