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

zef.h_as_opt_1.ItemsData = [1:length(zef.h_as_opt_1.Items)];
zef.h_as_opt_1.Value = zef.preconditioner;
zef.h_as_opt_2.Value = num2str(zef.preconditioner_tolerance);
zef.h_as_opt_3.Value = num2str(zef.smoothing_steps_surf);
zef.h_as_opt_4.Value = num2str(zef.smoothing_steps_vol);
zef.h_meshing_threshold.Value = num2str(zef.meshing_threshold);
zef.h_as_opt_5.ItemsData = [1:length(zef.h_as_opt_5.Items)];
zef.h_as_opt_5.Value = zef.refinement_type;
zef.h_as_opt_6.Value = zef.surface_sources;
zef.h_use_depth_electrodes.Value = zef.use_depth_electrodes;
zef.h_source_model.ItemsData = [1:length(zef.h_source_model.Items)];
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


zef.h_zef_forward_and_inverse_processing_options.Name = 'ZEFFIRO Interface: Forward and inverse processing options';
set(findobj(zef.h_zef_forward_and_inverse_processing_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_zef_forward_and_inverse_processing_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_zef_forward_and_inverse_processing_options,'AutoResizeChildren','off');
zef.forward_and_inverse_options_current_size = get(zef.h_zef_forward_and_inverse_processing_options,'Position');
set(zef.h_zef_forward_and_inverse_processing_options,'SizeChangedFcn','zef.forward_and_inverse_options_current_size = zef_change_size_function(zef.h_zef_forward_and_inverse_processing_options,zef.forward_and_inverse_options_current_size);');

clear zef_data;
