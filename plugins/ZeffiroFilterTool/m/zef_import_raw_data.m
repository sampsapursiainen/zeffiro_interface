%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)
[zef.file zef.file_path zef.file_type] = uigetfile({'*.mat','*.dat'},'Import',zef.save_file_path);
else
[zef.file zef.file_path zef.file_type] = uigetfile({'*.mat','*.dat'},'Import');
end
    if not(isequal(zef.file,0));
    if zef.file_type == 1
    [zef.raw_data] = struct2cell(load([zef.file_path zef.file]));
    zef.raw_data = zef.raw_data{1};
    else
[zef.raw_data] = load([zef.file_path zef.file]);
    end
    end