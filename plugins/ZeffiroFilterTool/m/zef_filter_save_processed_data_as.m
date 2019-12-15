%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path] = uiputfile('*.mat','Save processed data as...',[zef.filter_save_file_path zef.filter_save_file]);
else
[zef.file zef.file_path] = uiputfile('*.mat','Save processed data as...');
end
if not(isequal(zef.file,0));

zef_data = zef.processed_data;
save([zef.file_path zef.file],'zef_data','-v7.3');
clear zef_data;

end

