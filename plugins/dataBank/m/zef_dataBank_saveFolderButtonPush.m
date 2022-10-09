function zef = zef_dataBank_saveFolderButtonPush(zef)

if nargin == 0
zef = evalin('base','zef')
end

zef.dataBank.folder=uigetdir('', 'select folder for the databank');
zef.dataBank.folder=strcat(zef.dataBank.folder, filesep);

zef.dataBank.folder(strfind(zef.dataBank.folder,'\'))='/'; %ubuntu system works in windows, but not vice versa
zef.dataBank.app.savetodiskSwitch.Enable=true;
zef.dataBank.app.DataFolder.Text=zef.dataBank.folder;

if nargout == 0
assignin('base','zef',zef);
end

end
