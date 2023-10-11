function zeffiro_downloader( kwargs )
%
% zeffiro_downloader ( kwargs )
%
% This function downloads Zeffiro Interface in a given folder and sets it
% to be a local repository of the remote origin at
%
%   https://github.com/sampsapursiainen/zeffiro_interface
%
% After downloading, the local repository will be updated in each startup
% (each time when running zeffiro_interface.m).
%
% Inputs:
%
% - kwargs.install_directory = pwd
%
%   The directory into which the Zeffiro Interface folder will be placed.
%
% - kwargs.folder_name = "zeffiro_interface"
%
%   The name of the installation folder in kwargs.install_directory.
%
% - kwargs.branch_name = "main_development_branch"
%
%   The branch of Zeffiro Interface that will be installed.
%
% - kwargs.profile_name = "multicompartment_head"
%
%   The name of the default profile file for Zeffiro projects.
%
% - kwargs.run_setup = true
%
%   If this set to true, the dependencies of Zeffiro Interface will also be
%   installed via a function that is reserved for it
%
% - kwargs.submodules = []
%
%   Determines which submodules will be installed by zeffiro_setup.
%   The option "all" can be given to install all submodules.
%
% NOTE: Some other branch than the master should be used for pushes. The
% preferred branch is main_development_branch which will be merged with
% master on a monthly basis.

arguments
    kwargs.install_directory (1,1) string { mustBeFolder } = pwd
    kwargs.branch_name (1,1) string = "master"
    kwargs.profile_name (1,1) string = "multicompartment_head"
    kwargs.folder_name (1,1) string = "zeffiro_interface"
    kwargs.run_setup (1,1) logical = true
    kwargs.git_address (1,1) string = "https://github.com/sampsapursiainen/zeffiro_interface.git"
    kwargs.submodules = string ([])
end

if isempty(kwargs.folder_name)
    kwargs.folder_name = "zeffiro_interface-" + kwargs.branch_name ;
end

program_path = fullfile ( kwargs.install_directory, kwargs.folder_name ) ;

% Attempt cloning into the target folder.

[status, cmdout] = system ( ...
    "git clone --depth=1 -b " ...
    + " " ...
    + kwargs.branch_name ...
    + " " ...
    + kwargs.git_address ...
    + " " ...
    + program_path ...
);

if status ~= 0
    error ( ...
        "Downloading Zeffiro Interface with the branch name '" ...
        + kwargs.branch_name ...
        + "' and local destination folder '" ...
        + program_path ...
        + "' did not succeed. " ...
        + "The specific encountered error was as follows:" ...
        + newline + newline ...
        + "    " + cmdout ...
        + newline + newline ...
        + "Check your spelling and try again." ...
    ) ;
end

% Generate a profile file.

ini_cell = readcell ( fullfile ( program_path, "profile", "zeffiro_interface.ini" ), "FileType", "text" );
aux_row = find ( ismember ( ini_cell(:,3),"profile_name" ) );
ini_cell{aux_row,2} = kwargs.profile_name;
writecell ( ini_cell, fullfile ( program_path, "profile", "zeffiro_interface.ini" ), "FileType", "text");

% Run setup with the possible options

current_folder = pwd ;

cd ( program_path ) ;

if kwargs.run_setup
    zeffiro_setup ( "submodules", kwargs.submodules ) ;
end

cd ( current_folder ) ;

end % function
