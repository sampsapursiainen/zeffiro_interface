project_struct = zeffiro_interface('start_mode','nodisplay','open_project','data/example_projects/ary_sphere_project_2');
project_struct = zef_dipole_start(project_struct);
hauk_map = zef_hauk_map_dipoleScan(project_struct, 2, -30)