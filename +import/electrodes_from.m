function [ electrode_positions, electrode_labels ] = electrodes_from(file, kwargs)
%
% electrodes_from
%
% Imports a set of electrodes and their (optional) labels from a given text
% file.
%
% Inputs:
%
% - file (1,1) string { mustBeFile }
%
%   The text file that the electrodes and their labels are to be imported
%   from. The format of the lines in the file should be
%
%       x y z [label]
%
%   where x, y and z are the coordinates of the electrode and [label] is its
%   optional label. The fields should be separated by whitespace, and no
%   whitespace is allowed within the fields.
%
% - kwargs.MISSING_LABEL (1,1) string = "N/A"
%
%   Allows one to specify the label to be used in case a line did not contain
%   a label. By default, this is "N/A".
%
% Outputs:
%
% - electrode_positions
%
%   The double-precision electrode positions as a 3-by-N array, where N is the
%   number of electrodes.
%
% - electrode_labels
%
%   An N-by-1 string array of electrode labels. Again, N is the number of
%   electrodes. Missing labels will contain the string "N/A".
%
    arguments

        file (1,1) string { mustBeFile }

        kwargs.MISSING_LABEL (1,1) string = "N/A"

    end

    % Read text lines from the given file and pre-allocate the needed output
    % arrays.

    text_lines = readlines ( file, "EmptyLineRule", "skip"  ) ;

    n_of_rows = numel ( text_lines ) ;

    electrode_positions = zeros ( n_of_rows, 3 ) ;

    electrode_labels = repmat ( kwargs.MISSING_LABEL, n_of_rows, 1 ) ;

    % Populate the output arrays with positions and labels.

    for li = 1 : numel ( text_lines)

        line_cols = split ( text_lines ( li ) ) ;

        if not ( numel ( line_cols ) == 3 || numel ( line_cols ) == 4 )

            error ( "Line " + li + " of the given electrode file does not contain 3 or 4 columns. The format of each line should be ""x y z [label]"". Aborting..." ) ;

        end

        % Read coordinates and check that they are valid.

        position = double ( line_cols ( 1 : 3 ) ) ;

        for posi = 1 : numel ( position )

            if isnan ( position ( posi ) )

                error ( "Could not convert coordinate " + posi + " of electrode position on line " + li + "to a double. Aborting..." ) ;

            end % if

        end % for

        electrode_positions ( li, : ) = position ;

        % Check what should be used as the label of this electrode.

        if numel ( line_cols ) == 4

            label = line_cols ( 4 ) ;

            if strlength ( label ) == 0

                label = kwargs.MISSING_LABEL ;

            end % if

        else

            label = kwargs.MISSING_LABEL ;

        end % if

        electrode_labels ( li ) = label ;

    end % for

end % function
