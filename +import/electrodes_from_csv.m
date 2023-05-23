function [electrode_data, electrode_labels] = electrodes_from_csv(file, kwargs)
%
% electrodes_from_csv
%
% Reads a set of electrodes from a CSV file into a format that can be stored
% into the central struct of Zeffiro Interface. The CSV file should contain a
% header row with the titles
%
%   x, y, z [, label] [, inner_radius] [, outer_radius] [, impedance]
%
% where the square brackets signify that those columns are optional. In other
% words, at least the electrode positions must be given.
%
% Throws an error if the given file was invalid.
%
% Inputs:
%
% - file (1,1) string { mustBeFile }
%
%   The CSV file from which the electrodes are to be read from.
%
% - kwargs.MISSING_LABEL (1,1) string = "S"
%
%   The label that will be used as a prefix of numbered labels, of none are
%   found in the input file.
%
% Outputs:
%
% - electrode_data
%
%   The double-precision electrode positions as a N-by-3 or N-by-6 array,
%   where N is the number of electrodes. Whether there are 3 or 6 columns
%   depends on whether the input file contained the optional complete
%   electrode data or not.
%
% - electrode_labels
%
%   An N-by-1 string array of electrode labels. Again, N is the number of
%   electrodes. This will be full of "N/A", if no labels were in the file.
%

    arguments

        file (1,1) string { mustBeFile }

        kwargs.MISSING_LABEL (1,1) string = "S"

    end

    % Read CSV candidate into a table.

    electrode_table = readtable ( file ) ;

    column_titles = string ( electrode_table.Properties.VariableNames ) ;

    [ n_of_rows, ~ ] = size ( electrode_table ) ;

    % Preallocate outputs.

    electrode_data = zeros ( n_of_rows, 6 ) ;

    electrode_labels = repmat ( kwargs.MISSING_LABEL, n_of_rows, 1 ) + ( 1 : n_of_rows )' ;

    % Read other data from column names.

    if ismember ( "x", column_titles )

        electrode_data(:,1) = electrode_table.x ;

    else

        error("Electrodes should have an x-column, but the file " + file + " does not contain one. Aborting...")

    end

    if ismember ( "y", column_titles )

        electrode_data(:,2) = electrode_table.y ;

    else

        error("Electrodes should have a y-column, but the file " + file + " does not contain one. Aborting...")

    end

    if ismember ( "z", column_titles )

        electrode_data(:,3) = electrode_table.z ;

    else

        error("Electrodes should have a z-column, but the file " + file + " does not contain one. Aborting...")

    end

    if ismember ( "label", column_titles )

        electrode_labels = string ( electrode_table.label ) ;

    end

    cem_data_set = false ;

    if ismember ( "inner_radius", column_titles ) ...
    && ismember ( "outer_radius", column_titles) ...
    && ismember ( "impedance", column_titles )

        inner_radii = double ( electrode_table.inner_radius ) ;

        outer_radii = double ( electrode_table.outer_radius ) ;

        impedances = double ( electrode_table.impedance ) ;

        assert ( ( numel ( inner_radii ) == numel ( outer_radii ) ) && ( numel ( outer_radii ) == numel ( impedances ) ), "Each column in file " + file + " must contain the same number of rows. Aborting..." ) ;

        for ii = 1 : numel( inner_radii )

            if isnan ( inner_radii (ii) )

                error ( "The inner radius at row " + ii + " of file " + file + " could not be converted to double. Aborting..." ) ;

            end

            if isnan ( outer_radii (ii) )

                error ( "The outer radius at row " + ii + " of file " + file + " could not be converted to double. Aborting..." ) ;

            end

            if isnan ( impedances (ii) )

                error ( "The impedance at row " + ii + " of file " + file + " could not be converted to double. Aborting..." ) ;

            end

            if inner_radii (ii) < 0

                error ( "The inner radius at row " + ii + " of file " + file + " was less than 0. Aborting..." ) ;

            end

            if impedances (ii) < 0

                error ( "The impedance at row " + ii + " of file " + file + " was less than 0. Aborting..." ) ;

            end

            if inner_radii (ii) >= outer_radii (ii)

                error ( "The inner radius at row " + ii + " of file " + file + " was greater than or equal to the corresponding outer radius. Aborting..." ) ;

            end

        end % for

        electrode_data(:,4) = inner_radii ;

        electrode_data(:,5) = outer_radii ;

        electrode_data(:,6) = impedances ;

        cem_data_set = true ;

    else

        if ismember ( "inner_radius", column_titles ) ...
        || ismember ( "outer_radius", column_titles) ...
        || ismember ( "impedance", column_titles )

            warning ( "At least one but not all of inner_radius, outer_radius or impedance columns were found in file " + file + ", but all are required for complete electrode model data to be recorded. Ignoring..." );

        end % if

    end % if

    % Shrink numerical electrode data, if CEM columns were not found.

    if not ( cem_data_set )

        electrode_data(:, 4 : 6) = [] ;

    end

end % function
