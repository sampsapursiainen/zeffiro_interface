zef_bst.subject_struct = struct;
zef_bst.subject_folder = "";
zef_bst.save_project = 1;
zef_bst.import_settings = "";
zef_bst.verbose_mode = 1;
zef_bst.use_waitbar = 1;
zef_bst.surface_names = cell(0);
zef_bst.mesh_resolution = 3;
zef_bst.refine_surface = {'Scalp','OuterSkull','InnerSkull','Cortex','Other','subcortical'};
zef_bst.refine_surface_number = 1; 
zef_bst.refine_surface_on = 1;
zef_bst.refine_surface_mode = 2;
zef_bst.refine_volume = cell(0);
zef_bst.refine_volume_number = 1;
zef_bst.refine_volume_on = 0;
zef_bst.inflation_on = 1;
zef_bst.inflation_strength = 0.05;
zef_bst.surface_mesh_density = 0.5;
zef_bst.compartment_list = {'Scalp','OuterSkull','InnerSkull','Cortex','Other','white','subcortical'};
zef_bst.use_gpu = 1;
zef_bst.always_show_waitbar = 1;
zef_bst.parallel_processes = 10;
zef_bst.compartment_files = cell(0);
zef_bst.unit_conversion = 1000;
zef_bst.extensive_relabeling = 0; 
zef_bst.priority_mode = 1;
zef_bst.labeling_priority = [];
zef_bst.mesh_smoothing_on = 1;
zef_bst.distance_smoothing_on = 1;
zef_bst.distance_smoothing_exp = 0.01;
zef_bst.distance_smoothing_tol = 0.9;
zef_bst.electrical_conductivity = {'Scalp',0.34,'OuterSkull',0.0042,'InnerSkull',1.79,'Cortex',0.33,'white',0.14,'subcortical',0.33};
zef_bst.n_inflation_steps = 20;
zef_bst.transform_cell = {'InitTransf'};
zef_bst.dof_space = {'Scalp',0,'OuterSkull',0,'InnerSkull',0,'Cortex',2,'white',3,'subcortical',1};
zef_bst.compartment_on_vec = [];