zef_data = zeffiro_interface_mesh_tool_app;

zef.h_plot_condition = zef_data.h_plot_condition;
zef.h_mesh_optimize = zef_data.h_mesh_optimize;
zef.h_mesh_tool = zef_data.h_mesh_tool;
zef.h_make_all = zef_data.h_make_all;
zef.h_pushbutton21 = zef_data.h_pushbutton21;
zef.h_pushbutton14 = zef_data.h_pushbutton14;
zef.h_interpolate = zef_data.h_interpolate;
zef.h_field_downsampling = zef_data.h_field_downsampling;
zef.h_surface_downsampling = zef_data.h_surface_downsampling;
zef.h_checkbox_mesh_smoothing_on = zef_data.h_checkbox_mesh_smoothing_on;
zef.h_refinement_on = zef_data.h_refinement_on;
zef.h_source_interpolation_on = zef_data.h_source_interpolation_on;
zef.h_downsample_surfaces = zef_data.h_downsample_surfaces;
zef.h_popupmenu6 = zef_data.h_popupmenu6;
zef.h_popupmenu2 = zef_data.h_popupmenu2;
zef.h_edit65 = zef_data.h_edit65;
zef.h_edit_meshing_accuracy = zef_data.h_edit_meshing_accuracy;
zef.h_smoothing_strength = zef_data.h_smoothing_strength;
zef.h_edit76 = zef_data.h_edit76;
zef.h_edit75 = zef_data.h_edit75;
zef.h_max_surface_face_count = zef_data.h_max_surface_face_count;
zef.h_pushbutton23 = zef_data.h_pushbutton23;
zef.h_pushbutton34 = zef_data.h_pushbutton34;
zef.h_inflate_n_iterations = zef_data.h_inflate_n_iterations;
zef.h_inflate_strength = zef_data.h_inflate_strength;

set(zef.h_plot_condition,'ButtonPushedFcn','zef_plot_condition;');
set(zef.h_mesh_optimize,'ButtonPushedFcn','[zef.nodes,zef.tetrahedra] = zef_optimize_mesh(zef.nodes,zef.tetra);');
set(zef.h_make_all,'ButtonPushedFcn','if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; zef.source_interpolation_on = 1; set(zef.h_source_interpolation_on,''value'',1); [zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); [zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);zef.tetra_aux = zef.tetra; [zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_pushbutton21,'ButtonPushedFcn','if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; [zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]); [zef.nodes,zef.nodes_b,zef.tetra,zef.sigma_ind,zef.surface_triangles]=fem_mesh([]);zef.tetra_aux = zef.tetra; [zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]); zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;');
set(zef.h_pushbutton14,'ButtonPushedFcn','zef_delete_original_field;[zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);[zef.sensors_attached_volume] = attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_interpolate,'ButtonPushedFcn','[zef.source_interpolation_ind] = source_interpolation([]);');
set(zef.h_field_downsampling,'ButtonPushedFcn','zef_field_downsampling;');
set(zef.h_surface_downsampling,'ButtonPushedFcn','zef_downsample_surfaces; [zef.sensors,zef.reuna_p,zef.reuna_t] = process_meshes([]);[zef.source_interpolation_ind] = source_interpolation([]);');

set(zef.h_checkbox_mesh_smoothing_on,'value',zef.mesh_smoothing_on);
set(zef.h_refinement_on,'value',zef.refinement_on);
set(zef.h_source_interpolation_on,'value',zef.source_interpolation_on);
set(zef.h_downsample_surfaces,'value',zef.downsample_surfaces);
set(zef.h_inflate_n_iterations,'value',zef.inflate_n_iterations);
set(zef.h_inflate_strength,'value',zef.inflate_strength);

set(zef.h_downsample_surfaces,'value',zef.downsample_surfaces);

set(zef.h_popupmenu6,'Items',{'mm','cm','m'});
zef.h_popupmenu6.ItemsData = [1:length(zef.h_popupmenu6.Items)];
set(zef.h_popupmenu6,'Value',zef.location_unit);

set(zef.h_popupmenu2,'Items',{'Cartesian','Normal','Basis'});
zef.h_popupmenu2.ItemsData = [1:length(zef.h_popupmenu2.Items)];
set(zef.h_popupmenu2,'Value',zef.source_direction_mode);

set(zef.h_edit65,'value',(zef.mesh_resolution));
set(zef.h_edit_meshing_accuracy,'value',(zef.meshing_accuracy));
set(zef.h_smoothing_strength,'value',(zef.smoothing_strength));
set(zef.h_edit76,'value',(zef.solver_tolerance));
set(zef.h_edit75,'value',(zef.n_sources));
set(zef.h_max_surface_face_count,'value',(zef.max_surface_face_count));
set(zef.h_pushbutton23,'ButtonPushedFcn','apply_transform;');
set(zef.h_pushbutton34,'ButtonPushedFcn','[zef.sigma,zef.brain_ind,zef.non_source_ind,zef.nodes,zef.tetra,zef.sigma_prisms,zef.prisms,zef.submesh_ind]=zef_sigma([]);zef_update_fig_details;');

set(zef.h_checkbox_mesh_smoothing_on,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_refinement_on,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_source_interpolation_on,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_downsample_surfaces,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_popupmenu6,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_popupmenu2,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_edit65,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_edit_meshing_accuracy,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_smoothing_strength,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_edit76,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_edit75,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_max_surface_face_count,'ValueChangedFcn','zef_update_mesh_tool;');

set(zef.h_inflate_n_iterations,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_inflate_strength,'ValueChangedFcn','zef_update_mesh_tool;');


set(findobj(zef.h_mesh_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.h_mesh_tool,'AutoResizeChildren','off');
zef.mesh_tool_current_size = get(zef.h_mesh_tool,'Position');
set(zef.h_mesh_tool,'SizeChangedFcn','zef.mesh_tool_current_size = zef_change_size_function(zef.h_mesh_tool,zef.mesh_tool_current_size);');

clear zef_data;


