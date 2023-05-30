function figures_from_folder_without_colorbars(folder, filetypes, resolution)
%
% figures_from_folder_without_colorbars
%
% Collects the figures from a given folder, disables their colorbars and saves
% them using utilities.figure_without_colorbar_fn.
%
% Inputs:
%
% - folder (1,1) string { mustBeFolder }
%
%   The folder from which the figure files are searched from.
%
% - filetypes (:,1) string { mustBeMember(filetypes, [".pdf",".eps",".png"]) }
%
%   The file extensions that are passed to figure_without_colorbar_fn, which
%   does the actual saving.
%
% - resolution (1,1) double { mustBePositive }
%
%   The resolution the images will be save in, if PNG is used as output
%   format.
%

    arguments

        folder (1,1) string { mustBeFolder }

        filetypes (:,1) string { mustBeMember(filetypes, [".pdf",".eps",".png"]) }

        resolution (1,1) double { mustBePositive }

    end

    file_structs = dir ( fullfile ( folder, "**", "*.fig" ) ) ;

    for si = 1 : numel ( file_structs )

        file_struct = file_structs ( si ) ;

        file_path = fullfile ( folder_fn ( file_struct ), name_fn ( file_struct ) ) ;

        [stem, name, ext] = fileparts ( file_path ) ;

        path_without_ext = fullfile ( stem, name ) ;

        fig = openfig ( file_path ) ;

        cleanup_fn = @(ff) close (ff) ;

        cleanup_obj = onCleanup ( @() cleanup_fn ( fig ) ) ;

        utilities.figure_without_colorbar_fn ( fig, path_without_ext, filetypes, resolution ) ;

    end

end % function

%% Helper functions

function name = name_fn(file_struct)

    arguments

        file_struct (1,1) struct

    end

    if not ( isfield ( file_struct, "name" ) )

        error ( "The given file struct did not contain the field 'name'. Aborting..." ) ;

    end

    name = string ( file_struct.name ) ;

end % function

function folder = folder_fn(file_struct)

    arguments

        file_struct (1,1) struct

    end

    if not ( isfield ( file_struct, "folder" ) )

        error ( "The given file struct did not contain the field 'folder'. Aborting..." ) ;

    end

    folder = string ( file_struct.folder ) ;

end % function
