function zeffiro_downloader(varargin)
%This function downloads Zeffiro Interface in the subfolder a given folder. If the subfolder already
%exists, please remove that first. The default profile to be used can be
%defined in the argument, for example:
%zeffiro_downloader('profile_name','multicompartment_head'). 
%koe
install_directory = userpath;
branch_name = 'master';
profile_name = 'multicompartment_head';

if not(isempty(varargin))
zef_i = 1; 
while zef_i <= length(varargin)
eval([varargin{zef_i} '= ' varargin{zef_i+1}]);
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
