function [file_name] = zef_bst_get_project_file_name(h_parent)

if nargin < 1
h_parent = get(gcbo,'Parent');
end

settings_file_name = h_parent.settings_file_name;
folder_name = h_parent.folder_name;
subfolder_name = h_parent.project_subfolder_name;
file_name = fullfile(folder_name,subfolder_name,[settings_file_name '.mat']);

end