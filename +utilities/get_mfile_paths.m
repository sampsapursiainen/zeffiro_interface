function mfiles = get_mfile_paths(folder)
%
% get_mfile_paths
%
% Returns a list of Matlab code file paths in a given folder and its
% subdirectories.
%
% Inputs:
%
% - folder
%
%   The root folder from which the m-files are to be searched from.
%
% Outputs:
%
% - mfiles
%
%   The paths to the located m-files.
%

    arguments

        folder (1,1) string { mustBeFolder }

    end

    m_file_structs = dir ( fullfile ( folder, '**/*.m' ) ) ;

    mfiles = string ( arrayfun ( @path_fn, m_file_structs, UniformOutput=false ) ) ;

end % function

%% Helper functions

function name = path_fn(file_struct)

    arguments

        file_struct (1,1) struct

    end

    name = string ( fullfile ( file_struct.folder, file_struct.name ) ) ;

end % function
