function zef_bst_run

h_parent = get(gcbo,'Parent');
addpath(h_parent.folder_name);
h_text_1 = findobj(h_parent.Children,'Tag','setup_file');
h_popupmenu_1 = findobj(h_parent.Children,'Tag','postprocessing_script');
h_popupmenu_2 = findobj(h_parent.Children,'Tag','run_script');

[project_file_folder, project_file_name] = fileparts(h_text_1.String);

project_file_name = [project_file_name '.mat'];

if not(isequal(exist(project_file_name),2))
zef = zeffiro_interface('start_mode','nodisplay','import_to_new_project',h_text_1.String,'save_project',[project_file_folder filesep project_file_name],'exit_zeffiro',true);
addpath(h_parent.folder_name);
end

run_script_name = ['utilities.brainstorm2zef.m.run_script_bank'];
run_script_name = [run_script_name '.' h_popupmenu_2.String{h_popupmenu_2.Value}];

postprocessing_script_name = ['utilities.brainstorm2zef.m.postprocessing_script_bank'];
postprocessing_script_name = [postprocessing_script_name '.' h_popupmenu_1.String{h_popupmenu_1.Value}];

zef = zeffiro_interface('start_mode','nodisplay','open_project',[project_file_folder filesep project_file_name],'run_script',run_script_name,'exit_zeffiro',true);
addpath(h_parent.folder_name);
eval(postprocessing_script_name);
disp('Done.')

end