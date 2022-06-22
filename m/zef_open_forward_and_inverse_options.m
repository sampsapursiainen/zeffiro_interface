zef_init_forward_and_inverse_options;

zef_data = zef_forward_and_inverse_processing_options;

zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
if find(ismember(properties(zef.(zef.fieldnames{zef_i})),'ValueChangedFcn'))
zef.(zef.fieldnames{zef_i}).ValueChangedFcn = 'zef_update_forward_and_inverse_options;';
end
end

zef = rmfield(zef,'fieldnames');

clear zef_data;

[~, ~,zef.aux_field] = zef_get_active_compartments('name');
zef.h_as_opt_5.Items = {'Active compartments', zef.aux_field{:}};
zef.h_refinement_volume_compartments.Items = {'Active compartments', zef.aux_field{:}};
zef.h_refinement_volume_compartments_2.Items = {'Active compartments', zef.aux_field{:}};
zef.h_adaptive_refinement_compartments.Items = {'Active compartments', zef.aux_field{:}};
zef.h_refinement_surface_compartments.Items = {'Active compartments', zef.aux_field{:}};
zef = rmfield(zef,'aux_field');
zef.h_reduce_labeling_outliers.Value = zef.reduce_labeling_outliers;

zef.h_as_opt_1.ItemsData = [1:length(zef.h_as_opt_1.Items)];
zef.h_as_opt_1.Value = zef.preconditioner;
zef.h_as_opt_2.Value = num2str(zef.preconditioner_tolerance);
zef.h_as_opt_3.Value = num2str(zef.smoothing_steps_surf);
zef.h_as_opt_4.Value = num2str(zef.smoothing_steps_vol);
zef.h_lead_field_filter_quantile.Value = num2str(zef.lead_field_filter_quantile);
zef.h_meshing_threshold.Value = num2str(zef.meshing_threshold);
zef.h_as_opt_5.ItemsData = [1:length(zef.h_as_opt_5.Items)];
zef.h_as_opt_5.Multiselect = 'on';

zef.h_use_fem_mesh_inflation.Value = zef.use_fem_mesh_inflation;
zef.h_fem_mesh_inflation_strength.Value = num2str(zef.fem_mesh_inflation_strength);

if max(zef.refinement_surface_compartments) < length(zef.h_as_opt_5.ItemsData)
zef.h_as_opt_5.Value = zef.refinement_surface_compartments;
else
    zef.h_as_opt_5.Value = 1;
end

zef.h_refinement_volume_compartments.ItemsData = [1:length(zef.h_refinement_volume_compartments.Items)];
zef.h_refinement_volume_compartments.Multiselect = 'on';
if max(zef.refinement_volume_compartments) < length(zef.h_refinement_volume_compartments.ItemsData)
zef.h_refinement_volume_compartments.Value = zef.refinement_volume_compartments;
else
    zef.h_refinement_volume_compartments.Value = 1;
end

zef.h_refinement_volume_compartments_2.ItemsData = [1:length(zef.h_refinement_volume_compartments_2.Items)];
zef.h_refinement_volume_compartments_2.Multiselect = 'on';
if max(zef.refinement_volume_compartments_2) < length(zef.h_refinement_volume_compartments_2.ItemsData)
zef.h_refinement_volume_compartments_2.Value = zef.refinement_volume_compartments_2;
else
    zef.h_refinement_volume_compartments_2.Value = 1;
end

zef.h_refinement_surface_compartments.ItemsData = [1:length(zef.h_refinement_surface_compartments.Items)];
zef.h_refinement_surface_compartments.Multiselect = 'on';
if max(zef.refinement_surface_compartments) < length(zef.h_refinement_surface_compartments.ItemsData)
zef.h_refinement_surface_compartments.Value = zef.refinement_surface_compartments;
else
    zef.h_refinement_surface_compartments.Value = 1;
end

zef.h_adaptive_refinement_compartments.ItemsData = [1:length(zef.h_adaptive_refinement_compartments.Items)];
zef.h_adaptive_refinement_compartments.Multiselect = 'on';
if max(zef.adaptive_refinement_compartments) < length(zef.h_adaptive_refinement_compartments.ItemsData)
zef.h_adaptive_refinement_compartments.Value = zef.adaptive_refinement_compartments;
else
    zef.h_adaptive_refinement_compartments.Value = 1;
end

zef.h_refinement_volume_on.Value = zef.refinement_volume_on;
zef.h_refinement_volume_number.Value = num2str(zef.refinement_volume_number);
zef.h_refinement_volume_on_2.Value = zef.refinement_volume_on_2;
zef.h_refinement_volume_number_2.Value = num2str(zef.refinement_volume_number_2);
zef.h_refinement_surface_on.Value = zef.refinement_surface_on;
zef.h_refinement_surface_number.Value = num2str(zef.refinement_surface_number);
zef.h_refinement_surface_on_2.Value = zef.refinement_surface_on_2;
zef.h_refinement_surface_number_2.Value = num2str(zef.refinement_surface_number_2);
zef.h_fix_outer_surface.Value = zef.fix_outer_surface;

zef.h_adaptive_refinement_number.Value = num2str(zef.adaptive_refinement_number);

zef.h_initial_mesh_mode.Items = {'Regular 1','Regular 2'};
zef.h_initial_mesh_mode.ItemsData = [1:length(zef.h_initial_mesh_mode.Items)];
zef.h_initial_mesh_mode.Value = zef.initial_mesh_mode;

zef.h_pml_outer_radius_unit.Items = {'Relative','Absolute'};
zef.h_pml_outer_radius_unit.ItemsData = [1:length(zef.h_pml_outer_radius_unit.Items)];
zef.h_pml_outer_radius_unit.Value = zef.pml_outer_radius_unit;
zef.h_pml_outer_radius.Value =  num2str(zef.pml_outer_radius);

zef.h_pml_max_size_unit.Items = {'Relative','Absolute'};
zef.h_pml_max_size_unit.ItemsData = [1:length(zef.h_pml_max_size_unit.Items)];
zef.h_pml_max_size_unit.Value = zef.pml_max_size_unit;
zef.h_pml_max_size.Value =  num2str(zef.pml_max_size);
zef.h_mesh_relabeling.Value =  zef.mesh_relabeling;
zef.h_exclude_box.Value =  zef.exclude_box;

zef.h_adaptive_refinement_on.Value = zef.adaptive_refinement_on;
zef.h_adaptive_refinement_thresh_val.Value = num2str(zef.adaptive_refinement_thresh_val);
zef.h_adaptive_refinement_k_param.Value = num2str(zef.adaptive_refinement_k_param);

zef.h_as_opt_6.Value = zef.surface_sources;
zef.h_use_depth_electrodes.Value = zef.use_depth_electrodes;
zef.h_source_model.ItemsData = arrayfun(@ZefSourceModel.from, 1:length(zef.h_source_model.Items));
zef.source_model = ZefSourceModel.from(zef.source_model);
if eq(zef.source_model, ZefSourceModel.Error)
    warning("Invalid source model. Setting it as H(div)");
    zef.source_model = ZefSourceModel.Hdiv;
end
zef.h_source_model.Value = zef.source_model;
zef.h_use_gpu.Value = zef.use_gpu;
zef.h_gpu_num.Value = num2str(zef.gpu_num);
zef.h_mesh_labeling_approach.ItemsData = [1:length(zef.h_mesh_labeling_approach.Items)];
zef.h_mesh_smoothing_repetitions.Value = num2str(zef.mesh_smoothing_repetitions);
zef.h_mesh_optimization_repetitions.Value = num2str(zef.mesh_optimization_repetitions);
zef.h_mesh_optimization_parameter.Value = num2str(zef.mesh_optimization_parameter);
zef.h_mesh_labeling_approach.Value =  zef.mesh_labeling_approach;
zef.h_smoothing_steps_ele.Value =  num2str(zef.smoothing_steps_ele);
zef.h_source_space_creation_iterations.Value =  num2str(zef.source_space_creation_iterations);

zef.h_normalize_lead_field.Value =  num2str(zef.normalize_lead_field);

zef.h_zef_forward_and_inverse_processing_options.Name = 'ZEFFIRO Interface: Forward and inverse processing options';
set(findobj(zef.h_zef_forward_and_inverse_processing_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_zef_forward_and_inverse_processing_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_zef_forward_and_inverse_processing_options,'AutoResizeChildren','off');
zef.forward_and_inverse_options_current_size = get(zef.h_zef_forward_and_inverse_processing_options,'Position');
set(zef.h_zef_forward_and_inverse_processing_options,'SizeChangedFcn','zef.forward_and_inverse_options_current_size = zef_change_size_function(zef.h_zef_forward_and_inverse_processing_options,zef.forward_and_inverse_options_current_size);');

clear zef_data;
