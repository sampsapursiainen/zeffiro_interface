function zef_import_example

project_struct = zeffiro_interface('start_mode','nodisplay','import_to_existing_project','scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');
zef_save(project_struct,'example_project.mat','data/');

end