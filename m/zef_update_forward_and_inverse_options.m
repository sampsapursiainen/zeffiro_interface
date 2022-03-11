%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
   zef.preconditioner = get(zef.h_as_opt_1,'Value');
    zef.preconditioner_tolerance = str2num(get(zef.h_as_opt_2,'Value'));
    zef.smoothing_steps_surf = str2num(get(zef.h_as_opt_3,'Value'));
    zef.smoothing_steps_vol = str2num(get(zef.h_as_opt_4,'Value'));
    zef.meshing_threshold = str2num(get(zef.h_meshing_threshold,'Value'));
    zef.adaptive_refinement_compartments = get(zef.h_adaptive_refinement_compartments,'Value');
        zef.adaptive_refinement_number = str2num(get(zef.h_adaptive_refinement_number,'Value'));
    zef.refinement_surface_compartments = get(zef.h_refinement_surface_compartments,'Value');
        zef.refinement_surface_number = str2num(get(zef.h_refinement_surface_number,'Value'));
    zef.refinement_surface_on = get(zef.h_refinement_surface_on,'Value');
     zef.refinement_surface_compartments_2 = get(zef.h_as_opt_5,'Value');
     zef.refinement_surface_number_2 = str2num(get(zef.h_refinement_surface_number_2,'Value'));
    zef.refinement_surface_on_2 = get(zef.h_refinement_surface_on_2,'Value');
    zef.refinement_volume_compartments = get(zef.h_refinement_volume_compartments,'Value');
    zef.refinement_volume_number = str2num(get(zef.h_refinement_volume_number,'Value'));
    zef.refinement_volume_on = get(zef.h_refinement_volume_on,'Value');
    zef.refinement_volume_compartments_2 = get(zef.h_refinement_volume_compartments_2,'Value');
    zef.refinement_volume_number_2 = str2num(get(zef.h_refinement_volume_number_2,'Value'));
    zef.refinement_volume_on_2 = get(zef.h_refinement_volume_on_2,'Value');
    zef.initial_mesh_mode = get(zef.h_initial_mesh_mode,'Value');
    zef.pml_outer_radius_unit = get(zef.h_pml_outer_radius_unit,'Value');
    zef.pml_max_size_unit = get(zef.h_pml_max_size_unit,'Value');
    zef.pml_outer_radius = str2num(get(zef.h_pml_outer_radius,'Value'));
    zef.pml_max_size = str2num(get(zef.h_pml_max_size,'Value'));
    zef.mesh_relabeling = zef.h_mesh_relabeling.Value;
    zef.fix_outer_surface = zef.h_fix_outer_surface.Value;
    zef.exclude_box = zef.h_exclude_box.Value;

    zef.adaptive_refinement_on = get(zef.h_adaptive_refinement_on,'Value');
     zef.adaptive_refinement_k_param = str2num(get(zef.h_adaptive_refinement_k_param,'Value'));
    zef.adaptive_refinement_thresh_val = str2num(get(zef.h_adaptive_refinement_thresh_val,'Value'));

    zef.use_fem_mesh_inflation = zef.h_use_fem_mesh_inflation.Value;
    zef.fem_mesh_inflation_strength = str2num(get(zef.h_fem_mesh_inflation_strength,'Value'));

    zef.surface_sources = get(zef.h_as_opt_6,'Value');
    zef.use_depth_electrodes = get(zef.h_use_depth_electrodes,'Value');
    zef.source_model = get(zef.h_source_model,'Value');
    zef.use_gpu = get(zef.h_use_gpu,'Value');
    zef.gpu_num = str2num(get(zef.h_gpu_num,'Value'));
    zef.smoothing_steps_ele = str2num(get(zef.h_smoothing_steps_ele,'Value'));
    zef.mesh_smoothing_repetitions = str2num(zef.h_mesh_smoothing_repetitions.Value);
    zef.mesh_optimization_repetitions = str2num(zef.h_mesh_optimization_repetitions.Value);
    zef.mesh_optimization_parameter = str2num(zef.h_mesh_optimization_parameter.Value);
    zef.mesh_labeling_approach =  zef.h_mesh_labeling_approach.Value;
    zef.source_space_creation_iterations = str2num(zef.h_source_space_creation_iterations.Value);
    zef.normalize_lead_field = str2num(zef.h_normalize_lead_field.Value);

if gpuDeviceCount > 0 & zef.use_gpu == 1
    gpuDevice(zef.gpu_num);
end
