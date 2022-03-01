%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Load filter',zef.filter_save_file_path);
else
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Load filter');
end
if not(isequal(zef_data.file,0));

zef_filter_reset;
zef.filter_save_file = zef.file;
zef.filter_save_file_path = zef.file_path;
zef.filter_epoch_points = load([zef.file_path zef.file]);
zef.filter_epoch_points = zef.filter_epoch_points(:);
zef.filter_epoch_points = zef.filter_epoch_points';

