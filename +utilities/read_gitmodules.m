function submodule_structs = read_gitmodules ( gitmodules_file, kwargs )
%
% read_gitmodules ( gitmodules_file, fields )
%
% Reads the absolute and relative Git submodule paths from a given .gitmodules
% file. The outputs will of course be empty, if the given file was not a valid
% .gitmodules file.
%
% Inputs:
%
% - gitmodules_file
%
%   A path to the .gitmodules file from which the paths are to be searched from.
%
% - fields
%
%   A string array of fields that are to be read from the file. Valid ones are
%   "url", "path", "branch", and the non-standard "startupscript".
%
% Outputs:
%
% - submodule_structs
%
%   An array of structs that contain the submodule fields "path", "abspath",
%   "name", "url", "branch" and "startupscript".
%

    arguments

        gitmodules_file (1,1) string { mustBeFile }

        kwargs.required_fields (:,1) string { mustBeMember( kwargs.required_fields, [ "path", "abspath", "url", "branch", "startupscript" ] ) } = [ "path", "url", "branch", "startupscript" ]

    end

    folder = dir( gitmodules_file ).folder ;

    gitmodules_buffer = string ( fileread ( fullfile ( gitmodules_file ) ) ) ;

    gitmodules_lines = strsplit ( gitmodules_buffer, newline ) ;

    if isrow ( gitmodules_lines )
        gitmodules_lines = transpose ( gitmodules_lines ) ;
    end

    % Get rid of empty lines.

    gitmodules_lines ( find ( strtrim ( gitmodules_lines ) == "" ) ) = [] ;

    % Find lines where submodule headers occur.

    gitmodule_pattern = "\[submodule ""(?<path>[\w/]+)""\]" ;

    is_header_line = false ( numel ( gitmodules_lines ), 1 ) ;

    for ii = 1 : numel ( gitmodules_lines )

        if regexp ( gitmodules_lines ( ii ), gitmodule_pattern )
            is_header_line ( ii ) = true ;
        end

    end

    header_line_inds = find ( is_header_line ) ;

    % Construct ranges of fields.

    field_ranges = zeros ( 2, numel ( header_line_inds ) ) ;

    n_of_gitmodules_lines = numel ( gitmodules_lines ) ;

    n_of_header_lines = numel ( header_line_inds ) ;

    for ii = 1 : n_of_header_lines

        jj = 2 * ii - 1 ;

        starti =  header_line_inds ( ii ) + 1 ;

        if starti > numel ( gitmodules_lines )
            error ( "There was a supposed submodule field on line " + starti + ", but there are only " + n_of_gitmodules_lines + "in the given file " + gitmodules_file + ".")
        end

        if ii < n_of_header_lines
            endi =  header_line_inds ( ii + 1 ) - 1 ;
        else
            endi = n_of_gitmodules_lines ;
        end

        field_ranges ( jj : jj + 1 ) = [ starti ; endi ] ;

    end

    % Set up structs for storing the key-value pairs, and populate them with the keys and values.

    submodule_structs ( n_of_header_lines ) = struct ;

    for ii = 1 : numel ( submodule_structs )

        jj = 2 * ii - 1 ;

        starti = field_ranges ( jj ) ;

        endi = field_ranges ( jj + 1 ) ;

        for jj = starti : endi

            key_val = strtrim ( strsplit ( gitmodules_lines ( jj ), "=" ) ) ;

            submodule_structs ( ii ).( key_val ( 1 ) ) = key_val ( 2 ) ;

            if key_val ( 1 ) == "path"

                submodule_structs( ii ).abspath = fullfile ( folder, key_val ( 2 ) ) ;

                [folder, name, ~] = fileparts ( key_val ( 2 ) ) ;

                submodule_structs( ii ).name = name ;

            end

        end

    end

    if isrow ( submodule_structs )

        submodule_structs = transpose ( submodule_structs ) ;

    end

end % function
