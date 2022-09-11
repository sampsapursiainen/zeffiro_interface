function zef_meshing_example_thalamus_refinement

project_struct = zeffiro_interface('start_mode','nodisplay','import_to_existing_project','scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');
project_struct.mesh_smoothing_on = 1;
project_struct.refinement_on = 1;
project_struct.refinement_surface_on = 1;
project_struct.refinement_volume_on = 1;
project_struct.refinement_surface_number = [1];
project_struct.refinement_surface_compartments = [1 23 22];
project_struct.refinement_volume_on_2 = [1];
project_struct.refinement_volume_compartments_2 = [8];
project_struct.refinement_volume_number_2 = 2;
project_struct.mesh_resolution = 3;
project_struct = zef_create_finite_element_mesh(project_struct);
zef_save(project_struct,'example_project.mat','data/');

end