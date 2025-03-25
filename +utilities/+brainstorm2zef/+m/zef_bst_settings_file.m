function zef_bst_settings_file

h_parent = get(gcbo,'Parent');
h_text_1 = findobj(h_parent.Children,'Tag','settings_file');

folder_name = get(h_parent,'folder_name');
settings_subfolder_name = get(h_parent,'settings_subfolder_name');

[file_name] = uigetfile('*.m','Select settings file', fullfile(folder_name,settings_subfolder_name));

h_text_1.String = file_name;
set(h_parent,'settings_file_name',file_name);

end