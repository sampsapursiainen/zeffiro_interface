function zef_bst_edit_project(project_file_name)

if exist(project_file_name,'file')
zeffiro_interface('start_mode','display','open_project',project_file_name);
end

end