function [ electrode_data, electrode_labels ] = electrodes_from_dat(file, kwargs)
%
% electrodes_from_dat
%
% Imports a set of electrodes and their (optional) labels from a given text
% file. Throws an error if the given file could not be read.
%
% Inputs:
%
% - file (1,1) string { mustBeFile }
%
%   The text file that the electrodes and their labels are to be imported
%   from. The format of the lines in the file should be
%
%       x y z [label inner_radius outer_radius impedance]
%
%   where x, y and z are the coordinates of the electrode and label is its
%   optional label. The last 3 columns are what the names imply, and if any of
%   them are present, then all must be. The fields should be separated by
%   whitespace, and no whitespace is allowed within the fields.
%
% - kwargs.MISSING_LABEL (1,1) string = "S"
%
%   Allows one to specify the label to be used as a prefix of numbered labels,
%   in case a line did not contain a label. By default, this is "S".
%
% Outputs:
%
% - electrode_data
%
%   The double-precision electrode positions as a N-by-3 or N-by-6 array,
%   where N is the number of electrodes. Whether there are 3 or 6 columns
%   depends on whether the input file contained 4 or 7 columns.
%
% - electrode_labels
%
%   An N-by-1 string array of electrode labels. Again, N is the number of
%   electrodes. Missing labels will contain the string "N/A".
%
    arguments

        file (1,1) string { mustBeFile }

        kwargs.MISSING_LABEL (1,1) string = "S"

    end

    % Read text lines from the given file and pre-allocate the needed output
    % arrays.

    text_lines = readlines ( file, "EmptyLineRule", "skip"  ) ;

    n_of_rows = numel ( text_lines ) ;

    electrode_data = zeros ( n_of_rows, 6 ) ;

    electrode_labels = repmat ( kwargs.MISSING_LABEL, n_of_rows, 1 ) + ( 1 : n_of_rows )' ;

    % Populate the output arrays with positions and labels.

    for li = 1 : numel ( text_lines)

        line_cols = split ( strtrim ( text_lines ( li ) ) ) ;

        n_of_cols = numel ( line_cols ) ;

        if not ( n_of_cols == 3 || n_of_cols == 4 || n_of_cols == 6 || n_of_cols == 7 )

            error ( "Line " + li + " of the given electrode file does not contain 3, 4, 6 or 7 columns. The format of each line should be ""x y z [label inner_radius outer_radius impedance]"". Aborting..." ) ;

        end

        % Read coordinates and check that they are valid.

        position = double ( line_cols ( 1 : 3 ) ) ;

        for posi = 1 : numel ( position )

            if isnan ( position ( posi ) )

                error ( "Could not convert coordinate " + posi + " of electrode position on line " + li + "to a double. Aborting..." ) ;

            end % if

        end % for

        electrode_data ( li, 1 : 3 ) = position ;

        % Read labels in case there are 4 or 7 columns.

        if n_of_cols == 4 || n_of_cols == 7

            label = line_cols ( 4 ) ;

            if strlength ( label ) == 0

                label = electrode_labels ( li ) ;

            end % if

        else

            label = electrode_labels ( li ) ;

        end % if

        electrode_labels ( li ) = label ;

        % If there is complete electrode model (CEM) information available,
        % read it in. But first set the indices from which it can be found.

        if n_of_cols == 6

            iri = 4 ; % Inner radius index.
            ori = 5 ; % Outer radius index.
            ii  = 6 ; % Impedance index.

        elseif n_of_cols == 7

            iri = 5 ; % Inner radius index.
            ori = 6 ; % Outer radius index.
            ii  = 7 ; % Impedance index.

        else

            % Do nothing.

        end

        % Read CEM data.

        if n_of_cols == 6 || n_of_cols == 7

            inner_radius = double ( line_cols ( iri ) ) ;

            if isnan ( inner_radius )

                error ( "Could not convert electrode inner radius (column " + iri + ") on line " + li + " of file " + file + " into a double. Aborting..." ) ;

            end % if

            if inner_radius < 0

                error ( "The radius of an electrode inner radius (column " + iri + ") cannot be less than 0 on line " + li + " of file " + file + ". Aborting..." )

            end % if

            outer_radius = double ( line_cols ( ori) ) ;

            if isnan ( outer_radius )

                error ( "Could not convert electrode outer radius (column " + ori + ") on line " + li + " of file " + file + " into a double. Aborting..." ) ;

            end % if

            if inner_radius >= outer_radius

                error ( "The inner radius (column " + iri + ") of a given electrode was the same or greater than its outer radius (column " + ori + ") on line " + li + " of " + file + ". Aborting..." ) ;

            end % if

            impedance = double ( line_cols ( ii ) ) ;

            if isnan ( impedance )

                error ( "Could not convert electrode impedance (column " + ii + ") on line " + li + " of file " + file + " into a double. Aborting..." ) ;

            end % if

            if impedance <= 0

                error ( "The impedance (column " + ii + ") of a complete electrode on line " + li + " of file " + file + " cannot be 0 or negative. Aborting..." ) ;

            end % if

            electrode_data (li, 4) = inner_radius;

            electrode_data (li, 5) = outer_radius;

            electrode_data (li, 6) = impedance;

        end % if

    end % for

    % Reduce size of electrode data matrix, if nothing was written to the
    % complete electrode model columns.

    cem_cols = 4 : 6 ;

    last_3_cols = electrode_data ( : , cem_cols ) ;

    last_3_cols = last_3_cols(:);

    if all ( last_3_cols == 0 )

        electrode_data(:, cem_cols ) = [] ;

    end

end % function
