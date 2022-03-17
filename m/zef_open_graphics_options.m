zef_init_graphics_options;

zef_data = zef_graphics_processing_options;

zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
if find(ismember(properties(zef.(zef.fieldnames{zef_i})),'ValueChangedFcn'))
zef.(zef.fieldnames{zef_i}).ValueChangedFcn = 'zef_update_graphics_options;';
end
end

zef = rmfield(zef,'fieldnames');

clear zef_data;

zef.h_sensors_visual_size.Value = num2str(zef.sensors_visual_size);
zef.h_use_gpu_graphic.Value = zef.use_gpu_graphic;
zef.h_parcellation_type.ItemsData = [1:length(zef.h_parcellation_type.Items)];
zef.h_parcellation_type.Value = zef.parcellation_type;
zef.h_cone_alpha.Value = num2str(1 - zef.cone_alpha);
zef.h_parcellation_quantile.Value = num2str(zef.parcellation_quantile);
zef.h_cone_lattice_resolution.Value = num2str(zef.cone_lattice_resolution);
zef.h_cone_scale.Value = num2str(zef.cone_scale);
zef.h_colormap_size.Value = num2str(zef.colormap_size);
zef.h_streamline_linestyle.Value = zef.streamline_linestyle;
zef.h_streamline_linewidth.Value = num2str(zef.streamline_linewidth);
zef.h_streamline_color.Value = zef.streamline_color;
zef.h_n_streamline.Value = num2str(zef.n_streamline);
zef.h_colortune_param.Value = num2str(zef.colortune_param);

zef.h_zef_graphics_processing_options.Name = 'ZEFFIRO Interface: Graphics processing options';
set(findobj(zef.h_zef_graphics_processing_options.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_zef_graphics_processing_options.Children,'-property','FontSize'), 'FontSize', zef.font_size);

set(zef.h_zef_graphics_processing_options,'AutoResizeChildren','off');
zef.graphics_options_current_size = get(zef.h_zef_graphics_processing_options,'Position');
set(zef.h_zef_graphics_processing_options,'SizeChangedFcn','zef.graphics_options_current_size = zef_change_size_function(zef.h_zef_graphics_processing_options,zef.graphics_options_current_size);');

clear zef_data;
