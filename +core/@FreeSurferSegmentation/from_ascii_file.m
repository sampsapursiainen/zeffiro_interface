function self = from_ascii_file ( self, fname )
%
% from_ascii_file ( self, fname )
%
% Reads in a segmentation file line by line and extracts the information from within it. Throws an
% exception if the given file does not conform to the expected format.
%
% Inputs:
%
% - fname
%
%   The file name of a FreeSurfer-generated ASCII segmentation file from which
%   nodes and faces are to be extracted.
%
% Outputs:
%
% - self
%
%   A modified instance of self, with the fields self.nodes and self.triangles set to the data
%   found in the file.
%

    arguments

        self (1,1) core.FreeSurferSegmentation

        fname (1,1) string { mustBeFile }

    end

    fid = fopen ( fname, 'r' ) ;

    if fid == -1
        error ( "Could not open file '" + fname + "'." ) ;
    end

    cleanup_obj = onCleanup ( @() cleanup_fn ( fid ) ) ; % Make sure file is closed, if it was opened.

    ERR = "ERR: " + fname + ": " ;

    first_line = fgetl ( fid ) ;

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( first_line )
        error ( ERR + "Empty file" ) ;
    end

    first_line = string ( first_line ) ;

    % The file did not contain the expected header information

    if not ( startsWith ( first_line, "#!ascii version of" ) )
        error ( ERR + "Invalid first line '" + first_line + "'" );
    end

    % Read second line for needed array sizes.

    second_line = string ( fgetl ( fid ) );

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( second_line )
        error ( ERR + "No second line" ) ;
    end

    second_line = string ( second_line ) ;

    n_of_nodes_and_faces = string ( strsplit ( second_line, " " ) ) ;

    if numel ( n_of_nodes_and_faces ) ~= 2
        error ( ERR + "Wrong 2nd line length" ) ;
    end

    n_of_nodes = double ( n_of_nodes_and_faces (1) );

    n_of_faces = double ( n_of_nodes_and_faces (2) ) ;

    if not ( utilities.float_is_int ( n_of_nodes ) ) || n_of_nodes < 1
        error ( ERR + "Number of nodes on 2nd line was not a positive integer" ) ;
    end

    if not ( utilities.float_is_int ( n_of_faces ) ) || n_of_faces < 1
        error ( ERR + "Number of faces on 2nd line was not a positive integer" ) ;
    end

    % Then go over the nodes and store them in the array...

    nodes = zeros ( 3, n_of_nodes ) ;

    SEP = " " ;

    for ii = 1 : n_of_nodes

        this_line = fgetl ( fid ) ;

        if utilities.is_eof ( this_line )
            error ( ERR + "Reached end of file before all nodes were handled" ) ;
        end

        this_line = string ( this_line ) ;

        coords = strsplit ( this_line, SEP ) ;

        if numel ( coords ) ~= 4
            error ( "Wrong number of columns in a node line '" + this_line + "'" ) ;
        end

        node = double ( coords ) ;

        if any ( isnan ( node ( 1 : 3 ) ) )
            error ( ERR + "One of the node coordinates '" + this_line + "' on line " + (ii + 1) + " was not a floating point number." ) ;
        end

        nodes (:,ii) = node ( 1 : 3 ) ;

    end % for

    % ... and then do the same for the faces.

    faces = uint64 ( zeros ( 3, n_of_faces ) ) ;

    for ii = 1 : n_of_faces

        linenum = n_of_nodes + ii + 2 ;

        this_line = fgetl ( fid ) ;

        if utilities.is_eof ( this_line )
            error ( ERR + "Reached end of file before all faces were handled" ) ;
        end

        this_line = string ( this_line ) ;

        coords = strsplit ( this_line, SEP ) ;

        if numel ( coords ) ~= 4
            error ( ERR + "Wrong number of columns in a face line" + this_line + "'" ) ;
        end

        face = double ( coords ) ;

        if not ( utilities.float_is_int ( face ( 1 : 3 ) ) )
            error ( ERR + "One of the face coordinates '" + this_line + "' on line " + linenum + " was not an integer." ) ;
        end

        if any ( face ( 1 : 3 ) < 0 )
            error ("Line " + linenum + " of file " + fname + " contained a negative array index.")
        end

        faces (:,ii) = face ( 1 : 3 ) ;

    end % for

    if any ( n_of_nodes < max ( faces ( : ) ) )
        error ( "Found faces with indices greater than the number of nodes in '" + fname + "'." )
    end

    % We got to the end, so expand fields in self.

    node_range = ( self.node_count : self.node_count + n_of_nodes - 1 ) + 1 ;

    triangle_range = ( self.triangle_count : self.triangle_count + n_of_faces - 1 ) + 1 ;

    self.nodes ( : , node_range ) = nodes ;

    self.triangles ( : , triangle_range ) = faces + 1 ;

    largest_label = max ( self.labels ) ;

    if isempty ( largest_label )

        largest_label = 0 ;

    end

    labels = ( largest_label + 1 ) * uint64 ( ones ( n_of_faces, 1 ) ) ;

    self.labels ( triangle_range ) = labels ;

end % function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cleanup_fn ( fid )

    fclose ( fid ) ;

end
