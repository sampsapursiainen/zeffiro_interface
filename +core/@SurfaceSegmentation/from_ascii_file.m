function self = from_ascii_file ( self, fname, io_descriptor )
%
% self = from_ascii_file ( self, fname, io_descriptor )
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
% - io_descriptor
%
%   The text file the logs will be written to. By default, this is the null device, so printing is
%   discarded.
%
% Outputs:
%
% - self
%
%   A modified instance of self, with the fields self.nodes and self.triangles set to the data
%   found in the file.
%

    arguments

        self (1,1) core.SurfaceSegmentation

        fname (1,1) string { mustBeFile }

        io_descriptor (1,1) double { mustBePositive, mustBeInteger } = utilities.fopen_devnull

    end

    fprintf ( io_descriptor, "Reading " + fname + "..." + newline ) ;

    fcontents = string ( fileread ( fname ) ) ;

    flines = split ( fcontents, newline ) ;

    ERR = "ERR: " + fname + ": " ;

    first_line = flines ( 1 ) ;

    % The file did not contain the expected header information

    if not ( startsWith ( first_line, "#!ascii version of" ) )
        return % error ( ERR + "Invalid first line '" + first_line + "'" );
    end

    % Read second line for needed array sizes.

    second_line = flines ( 2 ) ;

    n_of_nodes_and_faces = string ( strsplit ( second_line, " " ) ) ;

    if numel ( n_of_nodes_and_faces ) ~= 2
        return % error ( ERR + "Wrong 2nd line length" ) ;
    end

    n_of_nodes = double ( n_of_nodes_and_faces (1) );

    n_of_faces = double ( n_of_nodes_and_faces (2) ) ;

    if not ( utilities.float_is_int ( n_of_nodes ) ) || n_of_nodes < 1
        return % error ( ERR + "Number of nodes on 2nd line was not a positive integer" ) ;
    end

    if not ( utilities.float_is_int ( n_of_faces ) ) || n_of_faces < 1
        return % error ( ERR + "Number of faces on 2nd line was not a positive integer" ) ;
    end

    % Then go over the nodes and store them in the array...

    nodes = zeros ( n_of_nodes, 3 ) ;

    SEP = " " ;

    for ii = 1 : n_of_nodes

        this_line = flines ( 2 + ii ) ;

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

        nodes (ii,:) = node ( 1 : 3 ) ;

    end % for

    % ... and then do the same for the faces.

    faces = uint64 ( zeros ( n_of_faces, 3 ) ) ;

    for ii = 1 : n_of_faces

        linenum = n_of_nodes + ii + 2 ;

        this_line = flines ( linenum ) ;

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

        faces (ii,:) = face ( 1 : 3 ) ;

    end % for

    if any ( n_of_nodes < max ( faces ( : ) ) )
        error ( "Found faces with indices greater than the number of nodes in '" + fname + "'." )
    end

    % We got to the end, so expand fields in self in a way that is compatible with pre-allocation.

    if isempty ( self.nodes ) || all ( isnan ( self.nodes (:) ) )
        node_start_pos = 1 ;
    else
        node_start_pos = max ( find ( any ( not ( isnan ( self.nodes ) ), 2 ) ) ) + 1 ;
    end

    if isempty ( self.triangles ) || all ( self.triangles (:) == 0 )
        face_start_pos = 1 ;
    else
        face_start_pos = max ( find ( any ( self.triangles ~= 0, 2 ) ) ) + 1 ;
    end

    node_range = ( node_start_pos : node_start_pos + n_of_nodes - 1 ) ;

    triangle_range = ( face_start_pos : face_start_pos + n_of_faces - 1 ) ;

    self.nodes ( node_range, : ) = nodes ;

    self.triangles ( triangle_range, : ) = faces + node_range(1) ;

    largest_label = max ( self.labels ) ;

    if isempty ( largest_label )

        largest_label = 0 ;

    end

    labels = ( largest_label + 1 ) * uint64 ( ones ( n_of_faces, 1 ) ) ;

    self.labels ( triangle_range ) = labels ;

    [ ~, name, ~ ] = fileparts ( fname ) ;

    name = string ( name ) ;

    if isempty ( self.label_names ) || all ( self.label_names == "" )

        name_ind = 1 ;

    else

        name_ind = max ( find ( self.label_names ~= "" ) ) + 1;

    end

    self.label_names ( name_ind ) = name ;

end % function