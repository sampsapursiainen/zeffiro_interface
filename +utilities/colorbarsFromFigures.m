function colorbarsFromFigures (folder, filetypes, kwargs)
%
% colorbarsFromFigures (folder, filetypes, resolution, kwargs)
%
% Collects the figures from a given folder, disables their colorbars and saves
% them using utilities.colorbar_from_figtool_fn.
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
% - kwargs.useSameColorLims = false
%
%   Determines whether the figures should share the same most extensive color
%   scale found within their axes.
%
% - kwargs.axisType = "UIAxes"
%
%   Allows a caller to specify which types of axes are sought in the figures.
%   Just in case somebody goes and changes how the Zeffiro Interface Figure
%   tool is constructed.
%

    arguments

        folder (1,1) string { mustBeFolder }

        filetypes (:,1) string { mustBeMember(filetypes, [".pdf",".eps",".png"]) }

        kwargs.resolution (1,1) double { mustBePositive } = 400

        kwargs.decplaces (1,1) double { mustBeInteger } = 1

    end

    fileStructs = dir ( fullfile ( folder, "**", "*.fig" ) ) ;

    fileN = numel (fileStructs) ;

    % Collect figures and their cleanup objects into arrays .

    figArray = gobjects (fileN,1) ;

    cleanUpArray (fileN) = onCleanup (@(x) []) ;

    for si = 1 : fileN

        fileStruct = fileStructs ( si ) ;

        filePath = fullfile ( folder_fn ( fileStruct ), name_fn ( fileStruct ) ) ;

        figArray (si) = openfig ( filePath ) ;

        cleanUpFn = @(ff) close (ff) ;

        cleanUpArray (si) = onCleanup ( @() cleanUpFn ( figArray (si) ) ) ;

    end

    % Actually save colorbars.

    for si = 1 : fileN

        fileStruct = fileStructs ( si ) ;

        filePath = fullfile ( folder_fn ( fileStruct ), name_fn ( fileStruct ) ) ;

        [stem, name, ~] = fileparts ( filePath ) ;

        pathWithoutExt = fullfile ( stem, name ) ;

        utilities.colorbar_from_figtool_fn (figArray (si), pathWithoutExt, filetypes, resolution=kwargs.resolution, decplaces=kwargs.decplaces)

    end

end % function

%% Helper functions

function name = name_fn(fileStruct)

    arguments

        fileStruct (1,1) struct

    end

    if not ( isfield ( fileStruct, "name" ) )

        error ( "The given file struct did not contain the field 'name'. Aborting..." ) ;

    end

    name = string ( fileStruct.name ) ;

end % function

function folder = folder_fn(fileStruct)

    arguments

        fileStruct (1,1) struct

    end

    if not ( isfield ( fileStruct, "folder" ) )

        error ( "The given file struct did not contain the field 'folder'. Aborting..." ) ;

    end

    folder = string ( fileStruct.folder ) ;

end % function
