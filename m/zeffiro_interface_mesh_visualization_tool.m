zef_data = zeffiro_interface_mesh_visualization_tool_app_exported;
zef_data.h_mesh_visualization_tool.Visible=zef.use_display;

zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
if isprop(zef.(zef.fieldnames{zef_i}),'ValueChangedFcn')
set(zef.(zef.fieldnames{zef_i}),'ValueChangedFcn','zef_update_mesh_visualization_tool;');
end
end

%*******

set(zef.h_plot_graph,'ButtonPushedFcn','zef_plot_graph;');
set(zef.h_pushbutton31,'ButtonPushedFcn','zef_visualize_volume;');
set(zef.h_pushbutton20,'ButtonPushedFcn','zef_visualize_surfaces;');
set(zef.h_pushbutton22,'ButtonPushedFcn','zef_snapshot_movie;');
set(zef.h_axes_popup,'ButtonPushedFcn','zef_axes_popup;');

set(zef.h_checkbox14,'value',zef.attach_electrodes);
set(zef.h_checkbox15,'value',zef.axes_visible);
set(zef.h_edit80,'value',zef.azimuth);
set(zef.h_edit81,'value',zef.elevation);
set(zef.h_edit82,'value',zef.cam_va);
set(zef.h_cone_draw,'value',zef.cone_draw);
set(zef.h_streamline_draw,'value',zef.streamline_draw);

set(zef.h_mesh_visualization_parameter_list,'Items',zef_get_profile_parameters);
zef.h_mesh_visualization_parameter_list.ItemsData = [1:length(zef.h_mesh_visualization_parameter_list.Items)];

zef.mesh_visualization_parameter_selected = 1;
set(zef.h_mesh_visualization_parameter_list,'value',zef.mesh_visualization_parameter_selected);

zef.mesh_visualization_graph_list = cell(0);
zef.dir_aux = dir([zef.program_path filesep 'm' filesep 'graph_bank']);
for zef_i = 3 : length(zef.dir_aux)
zef.mesh_visualization_graph_list{1}{zef_i-2} = help([zef.dir_aux(zef_i).folder filesep zef.dir_aux(zef_i).name]);
[~, zef.mesh_visualization_graph_list{2}{zef_i-2}] = fileparts(zef.dir_aux(zef_i).name);
end

set(zef.h_mesh_visualization_graph_list,'Items',zef.mesh_visualization_graph_list{1});
zef.h_mesh_visualization_graph_list.ItemsData = [1:length(zef.h_mesh_visualization_graph_list.Items)];

if not(isfield(zef,'mesh_visualization_graph_selected'))
    zef.mesh_visualization_graph_selected = 1;
end
set(zef.h_mesh_visualization_graph_list,'value',zef.mesh_visualization_graph_selected);

set(zef.h_visualization_type,'Items',{'Domain labels','Distribution (volume)','Distribution (surface)','Parcellation','Topography'});
zef.h_visualization_type.ItemsData = [1:length(zef.h_visualization_type.Items)];
set(zef.h_visualization_type,'Value',zef.visualization_type);

set(zef.h_volumetric_distribution_mode,'Items',{'Reconstruction','Parameter real','Parameter imaginary'});
zef.h_volumetric_distribution_mode.ItemsData = [1:length(zef.h_volumetric_distribution_mode.Items)];
set(zef.h_volumetric_distribution_mode,'Value',zef.volumetric_distribution_mode);

set(zef.h_frame_start,'value',num2str(zef.frame_start));
set(zef.h_frame_stop,'value',num2str(zef.frame_stop));
set(zef.h_frame_step,'value',num2str(zef.frame_step));
set(zef.h_orbit,'value',num2str(zef.orbit_1));
set(zef.h_orbit_2,'value',num2str(zef.orbit_2));
set(zef.h_cp2_on,'value',zef.cp2_on);
set(zef.h_cp2_a,'value',num2str(zef.cp2_a));
set(zef.h_cp2_b,'value',num2str(zef.cp2_b));
set(zef.h_cp2_c,'value',num2str(zef.cp2_c));
set(zef.h_cp2_d,'value',num2str(zef.cp2_d));
set(zef.h_cp3_on,'value',zef.cp3_on);
set(zef.h_cp3_a,'value',num2str(zef.cp3_a));
set(zef.h_cp3_b,'value',num2str(zef.cp3_b));
set(zef.h_cp3_c,'value',num2str(zef.cp3_c));
set(zef.h_cp3_d,'value',num2str(zef.cp3_d));
set(zef.h_layer_transparency,'value',num2str(1 - zef.layer_transparency));
set(zef.h_use_inflated_surfaces,'value',zef.use_inflated_surfaces);
set(zef.h_explode_everything,'value',zef.explode_everything);

set(zef.h_reconstruction_type,'Items',{'Amplitude','Normal','Tangential','Normal constraint (-)','Normal constraint (+)','Value','Amplitude smoothed'});
zef.h_reconstruction_type.ItemsData = [1:length(zef.h_reconstruction_type.Items)];
set(zef.h_reconstruction_type,'Value',zef.reconstruction_type);

set(zef.h_checkbox_cp_on,'value',zef.cp_on);
set(zef.h_edit_cp_a,'value',num2str(zef.cp_a));
set(zef.h_edit_cp_b,'value',num2str(zef.cp_b));
set(zef.h_edit_cp_c,'value',num2str(zef.cp_c));
set(zef.h_edit_cp_d,'value',num2str(zef.cp_d));

set(zef.h_inv_scale,'Items',{'Logarithmic','Linear','Square root'});
zef.h_inv_scale.ItemsData = [1:length(zef.h_inv_scale.Items)];
set(zef.h_inv_scale,'Value',zef.inv_scale);

zef.h_inv_colormap = zef_data.h_inv_colormap;

set(zef.h_inv_colormap,'Items',zef.colormap_items);
zef.h_inv_colormap.ItemsData = [1:length(zef.h_inv_colormap.Items)];
set(zef.h_inv_colormap,'Value',zef.inv_colormap);

set(zef.h_cp_mode,'Items',{'Cut out','Cut in','Cut out & whole brain','Cut in & whole brain'});
zef.h_cp_mode.ItemsData = [1:length(zef.h_cp_mode.Items)];
set(zef.h_cp_mode,'Value',zef.cp_mode);

set(zef.h_brain_transparency,'value',num2str(1 - zef.brain_transparency));

set(zef.h_inv_dynamic_range,'value',num2str(1./zef.inv_dynamic_range));

set(zef.h_submesh_num,'value',num2str(zef.submesh_num));

zef.h_mesh_visualization_tool.Units = 'normalized';
zef.h_mesh_visualization_tool.Position = [0.3 0.3 zef.h_mesh_visualization_tool.Position(3:4)];
zef.h_mesh_visualization_tool.Units = 'pixels';

set(findobj(zef.h_mesh_visualization_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_mesh_visualization_tool,'AutoResizeChildren','off');
zef.mesh_visualization_tool_current_size = get(zef.h_mesh_visualization_tool,'Position');
set(zef.h_mesh_visualization_tool,'SizeChangedFcn','zef.mesh_visualization_tool_current_size = zef_change_size_function(zef.h_mesh_visualization_tool,zef.mesh_visualization_tool_current_size);');

clear zef_data;

