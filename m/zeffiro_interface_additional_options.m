zef_data = zeffiro_interface_additional_options_app;

zef.h_additional_options = zef_data.h_additional_options;
zef.h_as_opt_2 = zef_data.h_as_opt_2;
zef.h_as_opt_1 = zef_data.h_as_opt_1;
zef.h_as_opt_3 = zef_data.h_as_opt_3;
zef.h_as_opt_4 = zef_data.h_as_opt_4;
zef.h_meshing_threshold = zef_data.h_meshing_threshold;
zef.h_as_opt_5 = zef_data.h_as_opt_5;
zef.h_as_opt_6 = zef_data.h_as_opt_6;
zef.h_use_depth_electrodes = zef_data.h_use_depth_electrodes;
zef.h_source_model =  zef_data.h_source_model;
zef.h_colortune_param = zef_data.h_colortune_param;
zef.h_inv_hyperprior_weight = zef_data.h_inv_hyperprior_weight;
zef.h_use_gpu = zef_data.h_use_gpu;
zef.h_parcellation_type = zef_data.h_parcellation_type;
zef.h_gpu_num = zef_data.h_gpu_num;
zef.h_parcellation_quantile = zef_data.h_parcellation_quantile;
zef.h_inv_hyperprior = zef_data.h_inv_hyperprior;
zef.h_inv_hyperprior_tail_length_db = zef_data.h_inv_hyperprior_tail_length_db;
zef.h_inv_snr = zef_data.h_inv_snr;
zef.h_inv_prior_over_measurement_db = zef_data.h_inv_prior_over_measurement_db;
zef.h_plot_hyperprior = zef_data.h_plot_hyperprior;

zef.h_additional_options = zef_data.h_additional_options;
zef.h_as_opt_2.ValueChangedFcn = 'zef_update_options;';
zef.h_as_opt_1.ValueChangedFcn = 'zef_update_options;';
zef.h_as_opt_3.ValueChangedFcn = 'zef_update_options;';
zef.h_as_opt_4.ValueChangedFcn = 'zef_update_options;';
zef.h_meshing_threshold.ValueChangedFcn = 'zef_update_options;';
zef.h_as_opt_5.ValueChangedFcn = 'zef_update_options;';
zef.h_as_opt_6.ValueChangedFcn = 'zef_update_options;';
zef.h_use_depth_electrodes.ValueChangedFcn = 'zef_update_options;';
zef.h_source_model.ValueChangedFcn = 'zef_update_options;';
zef.h_colortune_param.ValueChangedFcn = 'zef_update_options;';
zef.h_inv_hyperprior_weight.ValueChangedFcn = 'zef_update_options;';
zef.h_use_gpu.ValueChangedFcn = 'zef_update_options;';
zef.h_parcellation_type.ValueChangedFcn = 'zef_update_options;';
zef.h_gpu_num.ValueChangedFcn = 'zef_update_options;';
zef.h_parcellation_quantile.ValueChangedFcn = 'zef_update_options;';
zef.h_inv_hyperprior.ValueChangedFcn = 'zef_update_options;';
zef.h_inv_hyperprior_tail_length_db.ValueChangedFcn = 'zef_update_options;';
zef.h_inv_snr.ValueChangedFcn = 'zef_update_options;';
zef.h_inv_prior_over_measurement_db.ValueChangedFcn = 'zef_update_options;';


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
zef.h_source_model.ItemsData = [1:length(zef.h_source_model.Items)];
zef.h_source_model.Value = zef.source_model;
zef.h_colortune_param.Value = num2str(zef.colortune_param);
zef.h_inv_hyperprior_weight.ItemsData = [1:length(zef.h_inv_hyperprior_weight.Items)];
zef.h_inv_hyperprior_weight.Value = zef.inv_hyperprior_weight;
zef.h_use_gpu.Value = zef.use_gpu;
zef.h_parcellation_type.ItemsData = [1:length(zef.h_parcellation_type.Items)];
zef.h_parcellation_type.Value = zef.parcellation_type;
zef.h_gpu_num.Value = num2str(zef.gpu_num);
zef.h_parcellation_quantile.Value = num2str(zef.parcellation_quantile);
zef.h_inv_hyperprior.ItemsData = [1:length(zef.h_inv_hyperprior.Items)];
zef.h_inv_hyperprior.Value = zef.inv_hyperprior;
zef.h_inv_hyperprior_tail_length_db.Value = num2str(zef.inv_hyperprior_tail_length_db);
zef.h_inv_snr.Value = num2str(zef.inv_snr);
zef.h_inv_prior_over_measurement_db.Value = num2str(zef.inv_prior_over_measurement_db);

zef.h_additional_options.Name = 'ZEFFIRO Interface: Options';
set(findobj(zef.h_additional_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_additional_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_additional_options,'AutoResizeChildren','off');
zef.h_additional_options_current_size = get(zef.h_additional_options,'Position');
set(zef.h_additional_options,'SizeChangedFcn','zef.h_additional_options_current_size = zef_change_size_function(zef.h_additional_options,zef.h_additional_options_current_size);');


clear zef_data;

