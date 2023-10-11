function zeffiro_setup ( kwargs )
%
% zeffiro_setup ( kwargs )
%
% Downloads dependencies specified in the .gitmodules file into the external/
% folder and calls their installation scripts.
%
% Inputs:
%
% - kwargs.submodules = string([])
%
%   This column vector of submodule names specifies, which submodules listed in
%   the .gitmodules files are installed by this function. In addition to the
%   names in the .gitmodules file, the option "all" can be given, in which case
%   all submodules are installed.
%
% - kwargs.init = true
%
%   Determines whether the submodules are initialized. This should probably be
%   true at all times, as it does not harm if the submodules are already
%   downloaded.
%
% - kwargs.remote = true
%
%   Whether to force the submodules be downloaded from the URL specified in the
%   .gitmodules file, even when the folder is already populated.
%
% - kwargs.recursive = true
%
%   Whether to download the submodules of the submodules recursively.
%
% - kwargs.skip_submodules = false
%
%   If this is true, then only the zef_start_config file will be created, but
%   no submodules will be downloaded.
%

arguments
    kwargs.submodules (:,1) string = string ( [] )
    kwargs.init (1,1) logical = true
    kwargs.remote (1,1) logical = true
    kwargs.recursive (1,1) logical = true
    kwargs.skip_submodules (1,1) logical = false
end

[this_folder, ~, ~] = fileparts ( mfilename ( "fullpath" ) ) ;

% Validate kwargs.submodules, as this cannot be done in the arguments
% block without writing a validator function.

lower_submodule_names = unique ( lower ( kwargs.submodules ) ) ;

gitmodules_file = fullfile ( this_folder, ".gitmodules" ) ;

submodule_structs = utilities.read_gitmodules ( gitmodules_file ) ;

allowed_names = [ submodule_structs.name ] ;

if isrow ( allowed_names )
    allowed_names = transpose ( allowed_names ) ;
end

allowed_names = [ allowed_names ; "all" ] ;

lower_allowed_names = lower ( allowed_names ) ;

if not ( all ( ismember ( lower_submodule_names, lower_allowed_names ) ) )
    error ( ...
        "All of the given Git submodule names (" ...
        + strjoin (lower_submodule_names, ", ") ...
        + ") do not match with the acceptable ones. " ...
        + "The following ones are accepted:" ...
        + newline + newline ...
        + "  " ...
        + strjoin ( lower_allowed_names, newline + "  " ) ...
    ) ;
end

%% Set up path variables.

mfolder = fullfile ( this_folder, "m" ) ;

start_config = fullfile ( mfolder, "zef_start_config.m" ) ;

%% Do things with paths.

addpath ( mfolder );

zeffiro_start_config_fid = fopen ( start_config, 'w' );

%% Make sure zef_start_config is closed even in the case of an error or an early return.

cleanup_obj = onCleanup( @() cleanup_fn ( zeffiro_start_config_fid ) ) ;

%% Return early if asked to.

if kwargs.skip_submodules
    return
end

%% Start installation of individual packages.

fprintf(zeffiro_start_config_fid, "warning off;");

% Set Git submodule cloning settings.

if kwargs.init
    init = " --init" ;
else
    init = "" ;
end

if kwargs.remote
    remote = " --remote" ;
else
    remote = "" ;
end

if kwargs.recursive
    recursive = " --recursive" ;
else
    recursive = "" ;
end

% Determine which set to iterate over, all or just user-provided.

if ismember ( "all", lower_submodule_names )

    iterable = allowed_names (1:end-1) ; % Remove "all"

else

    iterable = kwargs.submodules ;

end

% Clone submodules.

stdout = 1 ;
stderr = 2 ;

for ii = 1 : numel ( iterable )

    lower_submodule_name = lower ( iterable ( ii ) ) ;

    % Find the path corresponding to the name under observation.

    name_ind = find ( lower_allowed_names == lower_submodule_name ) ;

    submodule = submodule_structs ( name_ind ) ;

    [status, message] = system ( "git submodule update" + init + remote + recursive + " " + submodule.path, "-echo" ) ;

    if status == 127

        error ( ...
            "Got exit code of " + status + " when trying to run Git." ...
            + newline ...
            + "This most likely means that Git is not properly installed on your system." ...
            + newline ...
            + " Make sure that the program is both present on your computer, and " ...
            + newline ...
            + "that it has been added to the program search path of the system." ...
        ) ;

    end

    if status ~= 0

        fprintf ( ...
            stderr, ...
            newline ...
            + "Encountered a (possible) issue when cloning submodules with an exit code of " ...
            + status ...
            + ". The output message was as follows:" ...
            + newline + newline ...
            + message ...
        ) ;

        continue

    end

    fprintf ( ...
        zeffiro_start_config_fid, ...
        newline + "if isequal(zef.zeffiro_restart, 0), addpath('" + submodule.path + "'); end;" ...
    ) ;

    if not ( isempty ( submodule.startupscript ) )

        fprintf ( ...
            zeffiro_start_config_fid, ...
            newline + "run ( '" + submodule.startupscript + "' ) ;" ...
        ) ;

    end % if

end % for

%% Perform finalization.

rmpath ( mfolder ) ;

end % function

%%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%%

function cleanup_fn ( fid )

    fprintf(fid, newline + "warning on;" );

    fprintf ( fid, newline ) ;

    fclose ( fid ) ;

end % function
