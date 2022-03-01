[zef.file zef.file_path] = uigetfile({'*.mat'},'Import interpolation',zef.save_file_path);
if not(isequal(zef.file,0));
[zef.eit_sensitivity_tool_data_2] = load([zef.file_path zef.file]);
zef.eit_sensitivity_tool_file_2 = [zef.file_path zef.file];
set(zef.h_eit_sensitivity_tool_file_2, 'Value', zef.eit_sensitivity_tool_file_2);
end

