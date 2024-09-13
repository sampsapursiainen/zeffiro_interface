zef_data = zef_additional_options_app;

zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
    zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
    if find(ismember(properties(zef.(zef.fieldnames{zef_i})),'ValueChangedFcn'))
        zef.(zef.fieldnames{zef_i}).ValueChangedFcn = 'zef_update_options;';
    end
end

zef = rmfield(zef,'fieldnames');

zef.h_plot_hyperprior.ButtonPushedFcn = 'zef_plot_hyperprior';

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
zef.h_source_model.ItemsData = arrayfun(@zefCore.ZefSourceModel.from, 1:length(zef.h_source_model.Items));
zef.h_source_model.Value = zefCore.ZefSourceModel.from(zef.source_model);
zef.h_colortune_param.Value = num2str(zef.colortune_param);
zef.h_inv_hyperprior_weight.ItemsData = [1:length(zef.h_inv_hyperprior_weight.Items)];
zef.h_inv_hyperprior_weight.Value = zef.inv_hyperprior_weight;
zef.h_use_gpu.Value = zef.use_gpu;
zef.h_use_gpu_graphic.Value = zef.use_gpu_graphic;
zef.h_parcellation_type.ItemsData = [1:length(zef.h_parcellation_type.Items)];
zef.h_parcellation_type.Value = zef.parcellation_type;
zef.h_gpu_num.Value = num2str(zef.gpu_num);
zef.h_parcellation_quantile.Value = num2str(zef.parcellation_quantile);
zef.h_inv_hyperprior.ItemsData = [1:length(zef.h_inv_hyperprior.Items)];
zef.h_inv_hyperprior.Value = zef.inv_hyperprior;
zef.h_inv_hyperprior_tail_length_db.Value = num2str(zef.inv_hyperprior_tail_length_db);
zef.h_inv_snr.Value = num2str(zef.inv_snr);
zef.h_inv_prior_over_measurement_db.Value = num2str(zef.inv_prior_over_measurement_db);
zef.h_cone_lattice_resolution.Value = num2str(zef.cone_lattice_resolution);
zef.h_cone_scale.Value = num2str(zef.cone_scale);
zef.h_colormap_size.Value = num2str(zef.colormap_size);

zef.h_streamline_linestyle.Value = zef.streamline_linestyle;
zef.h_streamline_linewidth.Value = num2str(zef.streamline_linewidth);
zef.h_streamline_color.Value = zef.streamline_color;
zef.h_n_streamline.Value = num2str(zef.n_streamline);

zef.h_mesh_labeling_approach.ItemsData = [1:length(zef.h_mesh_labeling_approach.Items)];
zef.h_mesh_smoothing_repetitions.Value = num2str(zef.mesh_smoothing_repetitions);
zef.h_mesh_optimization_repetitions.Value = num2str(zef.mesh_optimization_repetitions);
zef.h_mesh_optimization_parameter.Value = num2str(zef.mesh_optimization_parameter);
zef.h_mesh_labeling_approach.Value =  zef.mesh_labeling_approach;
zef.h_smoothing_steps_ele.Value =  num2str(zef.smoothing_steps_ele);

zef.h_cone_alpha.Value = num2str(1 - zef.cone_alpha);

zef.h_additional_options.Name = 'ZEFFIRO Interface: Options';
set(findobj(zef.h_additional_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_additional_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_additional_options,'AutoResizeChildren','off');
zef.additional_options_current_size = get(zef.h_additional_options,'Position');
set(zef.h_additional_options,'SizeChangedFcn','zef.additional_options_current_size = zef_change_size_function(zef.h_additional_options,zef.additional_options_current_size);');

clear zef_data;
