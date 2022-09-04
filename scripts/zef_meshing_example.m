function zef_meshing_example

project_struct = zeffiro_interface('start_mode','nodisplay');
project_struct = zef_load(project_struct,'example_project.mat','data/');
project_struct = zef_create_finite_element_mesh(project_struct);
zef_save(project_struct,'example_project.mat','data/');

end