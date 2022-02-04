function zeffiro_downloader(varargin)
%This function downloads Zeffiro Interface in the current folder.
!git clone https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(varargin)
zef_i = 1; 
while zef_i <= length(varargin)
if isequal(varargin{zef_i},'profile_name')
zef.profile_name = varargin{zef_i+1};
zef.ini_cell = readcell('./profile/zeffiro_interface.ini','FileType','text');
zef.aux_row = find(ismember(zef.ini_cell(:,3),'profile_name'));
zef.ini_cell{zef.aux_row,2} = zef.profile_name;
writecell(zef.ini_cell,'./profile/zeffiro_interface.ini','FileType','text');
end
end
end
clear zef zef_i;
end
