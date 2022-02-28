function zeffiro_downloader(varargin)
% This function downloads Zeffiro Interface in a given folder and sets it
% to be a local repository of the remote origin at
%
% https://github.com/sampsapursiainen/zeffiro_interface
%
% After downloading the local repository will be updated in each startup
% (each time when running zeffiro_interface.m).
%
% Set up instructions:
%
% The installation directory (install_directory), branch (branch_name) and
% default profile name (profile_name) can be set by calling the function as
% follows:
%
% zeffiro_downloader('install_directory',<directory string>,...
% 'branch_name',<branch name string>,'profile_name',<profile name string>);
%
% The folder name of the repository will be of the form
% zeffiro_interface-branch_name. The number of arguments is variable. By
% calling the function without arguments the default settings will be used.
% By default the installation directory will be the directory of the file
% zeffiro_downloader.m, branch will be main_development_branch, and
% profile will be multicompartment_head.

% Note: Some other branch than the master should be used for pushes. The
% preferred branch is main_development_branch which will be merged with
% master on a mothly basis.

install_directory = pwd;
branch_name = 'main_development_branch';
profile_name = 'multicompartment_head';

if not(isempty(varargin))
zef_i = 1;
while zef_i <= length(varargin)
eval([varargin{zef_i} '= ''' varargin{zef_i+1} ''';']);
zef_i = zef_i + 2;
end
end

directory_name = ['zeffiro_interface-' branch_name];
program_path = [install_directory filesep directory_name];

if not(isequal(branch_name,'master'))
eval(['!git clone -b ' branch_name ' https://github.com/sampsapursiainen/zeffiro_interface ' program_path]);
else
eval(['!git clone https://github.com/sampsapursiainen/zeffiro_interface ' program_path]);
end

ini_cell = readcell([program_path filesep 'profile' filesep 'zeffiro_interface.ini'],'FileType','text');
aux_row = find(ismember(ini_cell(:,3),'profile_name'));
ini_cell{aux_row,2} = profile_name;
writecell(ini_cell,[program_path filesep 'profile' filesep 'zeffiro_interface.ini'],'FileType','text');

end
