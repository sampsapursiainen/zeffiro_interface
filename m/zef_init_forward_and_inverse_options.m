%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'smoothing_steps_ele'));
zef.smoothing_steps_ele = 100;
end

if not(isfield(zef,'lead_field_filter_quantile'));
zef.lead_field_filter_quantile = 0.995;
end

if not(isfield(zef,'use_fem_mesh_inflation'));
zef.use_fem_mesh_inflation = 1;
end

if not(isfield(zef,'reduce_labeling_outliers'));
zef.reduce_labeling_outliers = 1;
end

if not(isfield(zef,'fem_mesh_inflation_strength'));
zef.fem_mesh_inflation_strength = 0.3;
end

if not(isfield(zef,'adaptive_refinement_on'));
zef.adaptive_refinement_on = 0;
end

if not(isfield(zef,'adaptive_refinement_thresh_val'));
zef.adaptive_refinement_thresh_val = 2;
end

if not(isfield(zef,'adaptive_refinement_k_param'));
zef.adaptive_refinement_k_param = 5;
end

if not(isfield(zef,'source_space_creation_iterations'));
zef.source_space_creation_iterations = 2;
end

if not(isfield(zef,'streamline_linewidth'));
zef.streamline_linewidth = 1;
end

if not(isfield(zef,'pml_outer_radius_unit'));
zef.pml_outer_radius_unit = 1;
end

if not(isfield(zef,'exclude_box'));
zef.exclude_box = 0;
end

if not(isfield(zef,'fix_outer_surface'));
zef.fix_outer_surface = 0;
end

if not(isfield(zef,'pml_outer_radius'));
zef.pml_outer_radius = 2;
end

if not(isfield(zef,'pml_max_size_unit'));
zef.pml_max_size_unit = 1;
end

if not(isfield(zef,'pml_max_size'));
zef.pml_max_size = 5;
end

if not(isfield(zef,'mesh_relabeling'));
zef.mesh_relabeling = 1;
end

if not(isfield(zef,'normalize_lead_field'));
zef.normalize_lead_field = 4;
end

if not(isfield(zef,'streamline_color'));
zef.streamline_color = 'blue';
end

if not(isfield(zef,'n_streamline'));
zef.n_streamline = 100;
end

if not(isfield(zef,'use_depth_electrodes'));
    zef.use_depth_electrodes = 0;
end;

if not(isfield(zef,'source_model'));
    zef.source_model = ZefSourceModel.Whitney;
end;
if not(isfield(zef,'preconditioner'));
    zef.preconditioner = 1;
end;

if not(isfield(zef,'preconditioner_tolerance'));
    zef.preconditioner_tolerance = 0.001;
end;
if not(isfield(zef,'smoothing_steps_surf'));
    zef.smoothing_steps_surf = 1000;
end;
if not(isfield(zef,'smoothing_steps_vol'));
    zef.smoothing_steps_vol = 2;
end;
if not(isfield(zef,'initial_mesh_mode'));
    zef.initial_mesh_mode = 1;
end;
if not(isfield(zef,'refinement_volume_on'));
    zef.refinement_volume_on = 0;
end;
if not(isfield(zef,'refinement_volume_number'));
    zef.refinement_volume_number = 1;
end;
if not(isfield(zef,'adaptive_refinement_number'));
    zef.adaptive_refinement_number = 1;
end;
if not(isfield(zef,'refinement_volume_compartments'));
    zef.refinement_volume_compartments = 1;
end;
if not(isfield(zef,'adaptive_refinement_compartments'));
    zef.adaptive_refinement_compartments = 1;
end;
if not(isfield(zef,'refinement_volume_on_2'));
    zef.refinement_volume_on_2 = 0;
end;
if not(isfield(zef,'refinement_volume_number_2'));
    zef.refinement_volume_number_2 = 1;
end;
if not(isfield(zef,'refinement_volume_compartments_2'));
    zef.refinement_volume_compartments_2 = 1;
end;
if not(isfield(zef,'refinement_surface_on'));
    zef.refinement_surface_on = 0;
end;
if not(isfield(zef,'refinement_surface_number'));
    zef.refinement_surface_number = 1;
end;
if not(isfield(zef,'refinement_surface_compartments'));
    zef.refinement_surface_compartments = 1;
end;
if not(isfield(zef,'refinement_surface_on_2'));
    zef.refinement_surface_on_2 = 0;
end;
if not(isfield(zef,'refinement_surface_number_2'));
    zef.refinement_surface_number_2 = 1;
end;
if not(isfield(zef,'refinement_surface_compartments_2'));
    zef.refinement_surface_compartments_2 = 1;
end;
if not(isfield(zef,'surface_sources'));
    zef.surface_sources = 0;
end;

if not(isfield(zef,'use_gpu'));
    zef.use_gpu = 1;
end;

if not(isfield(zef,'gpu_num'));
    zef.gpu_num = 1;
end;

if not(isfield(zef,'mesh_smoothing_repetitions'));
    zef.mesh_smoothing_repetitions = 1;
end;

if not(isfield(zef,'mesh_optimization_repetitions'));
    zef.mesh_optimization_repetitions = 10;
end;

if not(isfield(zef,'mesh_optimization_parameter'));
    zef.mesh_optimization_parameter = 1E-5;
end;

if not(isfield(zef,'mesh_labeling_approach'));
    zef.mesh_labeling_approach = 1;
end;
