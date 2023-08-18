function messages = copy_dependencies_to_folder ( file, target_folder, kwargs )
%
% utilities.copy_dependencies_to_folder ( file, target_folder, kwargs )
%
% Reads the dependencies that are not Matlab built-ins of the given file using
%
%   matlab.codetools.requiredFilesAndProducts
%
% and tranfers them to a target folder. The target folder needs to exist or an
% exception will be thrown.
%
% NOTE: The function matlab.codetools.requiredFilesAndProducts does not find
% files that are not on the MATLAB search path. Use addpath(genpath("folder"))
% to recursively add the subdirectories of a folder to the path, if you know
% the files can be found inside.
%
% Inputs:
%
% - file
%
%   The file whose dependencies will be searched.
%
% - target_folder
%
%   The folder into which the dependencies will be copied.
%
% - kwargs.folder_whitelist = string([])
%
%   A list of folder paths from which a transfer is allowed. This is to prevent
%   dependencies like waitbars, that are not directly related to an algorithm
%   but might be utilized by it from being copied to the target location. If
%   this is empty, as in string([]), this restriction is not applied.
%
% Outputs:
%
% - messages
%
%   A string array of error messages emitted by the copying process.
%

    arguments

        file (1,1) string { mustBeFile }

        target_folder (1,1) string { mustBeFolder }

        kwargs.folder_whitelist (:,1) string { mustBeFolder } = string ( [] )

    end

    % Get full paths to the whitelisted folders.

    full_whitelist_paths = repmat ( "", numel ( kwargs.folder_whitelist ), 1 ) ;

    for ii = 1 : numel ( kwargs.folder_whitelist )

        dir_structs = dir ( kwargs.folder_whitelist (ii) ) ;

        folder_paths = dir_structs.folder ;

        unique_folder_paths = unique ( folder_paths ) ;

        full_whitelist_paths (ii) = string ( unique_folder_paths ) ;

    end % for

    % Read file paths into a column vector of strings.

    [ filepath_cells, ~ ] = matlab.codetools.requiredFilesAndProducts ( file ) ;

    if isrow ( filepath_cells )

        filepath_cells = transpose ( filepath_cells ) ;

    end

    file_paths = string ( filepath_cells ) ;

    % Preallocate error message array.

    n_of_files = numel ( file_paths ) ;

    message_count = 0 ;

    messages = repmat ("", n_of_files, 1 ) ;

    % Go over the paths and copy them to a target folder, if the whitelist so allows.

    for fi = 1 : numel ( file_paths )

        fpath = file_paths ( fi ) ;

        status = 1 ;

        message = "" ;

        if isempty ( full_whitelist_paths )

            [ status, message, ~ ] = copyfile ( fpath, target_folder ) ;

        else % Check whether transfer is allowed.

            [ parent, ~, ~ ] = fileparts ( fpath ) ;

            if ismember ( parent, full_whitelist_paths )

                [ status, message, ~ ] = copyfile ( fpath, target_folder ) ;

            end

        end % if

        % Collect warnings and errors.

        if status ~= 1 && not ( isempty ( message ) )

            message_count = message_count + 1 ;

            messages ( fi ) = message ;

        end

    end % for

    % Finally, truncate message array so we save space in the caller workspace.

    difference = n_of_files - message_count ;

    if difference > 0

        messages = messages ( 1 : end - difference ) ;

    else % ... or just return no messages if everything went ok.

        messages = string ( [] ) ;

    end

end % function
