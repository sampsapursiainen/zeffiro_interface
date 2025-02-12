function [file_name] = zef_bst_get_settings_file_name(h_parent)

if nargin < 1
h_parent = get(gcbo,'Parent');
end

folder_name = get(h_parent,'folder_name');
settings_file_name = get(h_parent,'settings_file_name');
settings_subfolder_name = get(h_parent,'settings_subfolder_name');
file_name = fullfile(folder_name, settings_subfolder_name, settings_file_name);

end