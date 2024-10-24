function zef_bst_edit_project

h_parent = get(gcbo,'Parent');
addpath(h_parent.folder_name);
h_text_1 = findobj(h_parent.Children,'Tag','setup_file');

[folder_name,file_name] = fileparts(h_text_1.String);

project_file_name = [folder_name filesep file_name '.mat'];

if not(isequal(exist(project_file_name),2))
zef = zeffiro_interface('start_mode','nodisplay','import_to_new_project',h_text_1.String,'save_project',project_file_name,'exit_zeffiro',true);
addpath(h_parent.folder_name);
end

zef = zeffiro_interface('start_mode','display','open_project',project_file_name);

end