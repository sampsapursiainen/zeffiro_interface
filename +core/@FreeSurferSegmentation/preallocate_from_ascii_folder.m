function self = preallocate_from_ascii_folder ( self, folder )

    arguments

        self (1,1) core.FreeSurferSegmentation

        folder (1,1) string { mustBeFolder }

    end

    ascii_structs = dir ( fullfile ( folder, "*.asc" ) ) ;

    if isrow ( { ascii_structs.name } )

        ascii_names = transpose ( { ascii_structs.name } ) ;

    end

    ascii_paths = string ( fullfile ( folder, ascii_names ) ) ;

    % Collect node and triangle counts.

    node_count = 0 ;

    triangle_count = 0 ;

    file_count = 0 ;

    for ii = 1 : numel ( ascii_paths )

        ascii_path = ascii_paths ( ii ) ;

        [ n_of_nodes, n_of_triangles, is_segmentation_file ] = counts_from_file ( ascii_path ) ;

        node_count = node_count + n_of_nodes ;

        triangle_count = triangle_count + n_of_triangles ;

        if is_segmentation_file

            file_count = file_count + 1 ;

        end

    end % for

    % Preallocate arrays in self.

    self.nodes = NaN ( node_count, 3 ) ;

    self.triangles = zeros ( triangle_count, 3 ) ;

    self.labels = zeros ( triangle_count, 1 ) ;

    self.label_names = repmat ( "", file_count , 1 ) ;

end % function

function [ node_count, triangle_count, is_segmentation_file ] = counts_from_file ( fpath )

    arguments

        fpath (1,1) string { mustBeFile }

    end

    node_count = 0 ;

    triangle_count = 0 ;

    is_segmentation_file = false ;

    fid = fopen ( fpath, 'r' ) ;

    if fid == -1
        error ( "Could not open file '" + fpath + "'." ) ;
    end

    % Make sure file is closed, if it was opened.

    cleanup_obj = utilities.cleanup_via_fclose ( fid ) ;

    ERR = "ERR: " + fpath + ": " ;

    first_line = fgetl ( fid ) ;

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( first_line )
        return
    end

    first_line = string ( first_line ) ;

    % The file did not contain the expected header information

    if not ( startsWith ( first_line, "#!ascii version of" ) )
        return
    end

    % Read second line for needed array sizes.

    second_line = string ( fgetl ( fid ) );

    % The file was empty and we found an EOF character.

    if utilities.is_eof ( second_line )
        return
    end

    second_line = string ( second_line ) ;

    n_of_nodes_and_faces = string ( strsplit ( second_line, " " ) ) ;

    if numel ( n_of_nodes_and_faces ) ~= 2
        return
    end

    potential_node_count = double ( n_of_nodes_and_faces (1) );

    potential_triangle_count = double ( n_of_nodes_and_faces (2) ) ;

    if not ( utilities.float_is_int ( potential_node_count ) ) || potential_node_count < 1
        return
    end

    if not ( utilities.float_is_int ( potential_triangle_count ) ) || potential_triangle_count < 1
        return
    end

    node_count = potential_node_count ;

    triangle_count = potential_triangle_count ;

    is_segmentation_file = true ;

end
