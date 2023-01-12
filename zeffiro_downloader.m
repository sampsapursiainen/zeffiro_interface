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
% The arguments of this function are property-value pair of the form: 
% <property 1>,<property value 1>,<property 2>,<property value 2>,...
% 
% These properties and their values are the following:
% Property: <install_directory>, Value: <directory of the program folder>
% Property: <folder_name>, Value: <program folder name>
% Property: <branch_name>, Value: <branch to be downloaded from github>
% Property: <profile_name>, Value: <name of the profile>
% Property: <run_setup>, Value: 'yes' or 'no'
%
% The length of the argument list can vary. By calling the function without 
% arguments the default settings will be used. The default values are:
% Property: <install_directory>, Default: <directory of the file>
% Property: <folder_name>, Default: 'zeffiro_interface-<branch_name>'
% Property: <branch_name>, Default: 'main_development_branch' and
% Property: <profile_name>, Default: 'multicompartment_head'
% Property: <run_setup>, Default: 'yes' 
%
% Note: Some other branch than the master should be used for pushes. The
% preferred branch is main_development_branch which will be merged with
% master on a mothly basis.

install_directory = pwd;
branch_name = 'main_development_branch';
profile_name = 'multicompartment_head';
folder_name = [];
run_setup = 'no';

if not(isempty(varargin))
zef_i = 1;
while zef_i <= length(varargin)
eval([varargin{zef_i} '= ''' varargin{zef_i+1} ''';']);
zef_i = zef_i + 2;
end
end

if isempty(folder_name)
folder_name = ['zeffiro_interface-' branch_name];
end
program_path = [install_directory filesep folder_name];
if not(isempty(folder_name))
end

if not(isequal(branch_name,'master'))
eval(['!git clone --depth=1 -b ' branch_name ' https://github.com/sampsapursiainen/zeffiro_interface ' program_path]);
else
eval(['!git clone --depth=1 https://github.com/sampsapursiainen/zeffiro_interface ' program_path]);
end

ini_cell = readcell([program_path filesep 'profile' filesep 'zeffiro_interface.ini'],'FileType','text');
aux_row = find(ismember(ini_cell(:,3),'profile_name'));
ini_cell{aux_row,2} = profile_name;
writecell(ini_cell,[program_path filesep 'profile' filesep 'zeffiro_interface.ini'],'FileType','text');

if isequal(run_setup,'yes')
run([program_path filesep 'zeffiro_setup.m']);
end

end
