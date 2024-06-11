function zef_bst_setup_file

h_parent = get(gcbo,'Parent');
addpath(h_parent.folder_name);
h_text_1 = findobj(h_parent.Children,'Tag','setup_file');

folder_name = get(h_parent,'folder_name');

[file_name folder_name] = uigetfile('*.zef','Select setup file', folder_name);

h_text_1.String = [folder_name filesep file_name];

end