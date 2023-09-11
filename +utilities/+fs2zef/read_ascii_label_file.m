function [labels, colors] = read_ascii_label_file ( fname )
%
% read_ascii_label_file ( fname )
%
% Reads a given FreeSurfer-generated ASCII label file.
%
% Inputs:
%
% - fname
%
%   The ASCII label file.
%
% Outputs:
%
% - labels
%
%   The labels as a column vector of integers.
%
% - colors
%
%   The RGB color values of the labels as a 3-by-N double matrix.
%

    arguments

        fname (1,1) string { mustBeFile }

    end

    fid = fopen ( fname, 'r' ) ;

    if fid == -1
        error ( "Could not open file '" + fname + "'." ) ;
    end

    % Make sure file is closed, if it was opened.

    cleanup_fn = @( ff ) fclose ( ff ) ;

    cleanup_obj = onCleanup ( @() cleanup_fn ( fid ) ) ;

    ERR = "ERR: " + fname + ": " ;

    first_line = fgetl ( fid ) ;

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( first_line )
        error ( ERR + "Empty file" ) ;
    end

    first_line = string ( first_line ) ;

    % The file did not contain the expected header information

    if not ( startsWith ( first_line, "#!ascii label" ) )
        error ( ERR + "Invalid first line '" + first_line + "'" );
    end

    % Read second line for needed array sizes.

    second_line = string ( fgetl ( fid ) );

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( second_line )
        error ( ERR + "No second line" ) ;
    end

    second_line = string ( second_line ) ;

    n_of_labels = string ( strsplit ( second_line, " " ) ) ;

    if numel ( n_of_labels ) ~= 1
        error ( ERR + "Wrong 2nd line length. Should be 1." ) ;
    end

    n_of_labels = double ( n_of_labels );

    if not ( utilities.float_is_int ( n_of_labels ) ) || n_of_labels < 1
        error ( ERR + "Number of labels on 2nd line was not a positive integer" ) ;
    end

    % Then go over the actual label lines.

    labels = uint64 ( zeros ( n_of_labels , 1 ) ) ;

    colors = zeros ( 3, n_of_labels ) ;

    for ii = 1 : n_of_labels

        this_line = fgetl ( fid ) ;

        if utilities.is_eof ( this_line )
            error ( ERR + "Reached end of file before all nodes were handled" ) ;
        end

        this_line = string ( this_line ) ;

        coords = strsplit ( this_line) ;

        if numel ( coords ) ~= 5
            error ( "Wrong number of columns in a node line '" + this_line + "'" ) ;
        end

        double_line = double ( coords ) ;

        if any ( isnan ( double_line ( 1 : 4 ) ) )
            error ( ERR + "The lael or one of the color coordinates '" + this_line + "' on line " + (ii + 2) + " was not a floating point number." ) ;
        end

        labels ( ii ) = double_line ( 1 ) ;

        colors ( :, ii ) = double_line ( 2 : 4 ) ;

    end % for

end % function
