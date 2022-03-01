zef_data = zeffiro_interface_mesh_tool_app_exported;
zef_data.h_mesh_tool.Visible=zef.use_display;
zef_assign_data;

set(zef.h_menu_forward_simulation_table_add,'MenuSelectedFcn','zef.h_forward_simulation_table.Data{end+1,1} = []; zef.h_forward_simulation_table.Data = [zef.h_forward_simulation_table.Data(1:zef.forward_simulation_selected(1),:) ; zef.h_forward_simulation_table.Data(end,:) ; zef.h_forward_simulation_table.Data(zef.forward_simulation_selected(1)+1:end-1,:)];');
set(zef.h_menu_forward_simulation_table_delete,'MenuSelectedFcn','zef.h_forward_simulation_table.Data = zef.h_forward_simulation_table.Data(find(not(ismember([1:size(zef.h_forward_simulation_table.Data,1)],zef.forward_simulation_selected))),:);');

set(zef.h_run_forward_simulation,'ButtonPushedFcn','zef_run_forward_simulation;');

set(zef.h_save_forward_simulation_profile,'ButtonPushedFcn','zef.forward_simulation_table = zef.h_forward_simulation_table.Data; writecell(zef.forward_simulation_table,[zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_forward_simulation.ini''],''filetype'',''text'',''delimiter'','','')');

%set(zef.h_plot_condition,'ButtonPushedFcn','zef_plot_condition;');
%set(zef.h_make_all,'ButtonPushedFcn','if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; zef.source_interpolation_on = 1; set(zef.h_source_interpolation_on,''value'',1); zef_postprocess_fem_mesh;  zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;zef_process_meshes; zef_attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_pushbutton21,'ButtonPushedFcn','zef_create_finite_element_mesh;');
%set(zef.h_pushbutton14,'ButtonPushedFcn','zef_delete_original_field;zef_process_meshes;zef_attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_interpolate,'ButtonPushedFcn','source_interpolation;');
set(zef.h_field_downsampling,'ButtonPushedFcn','zef_field_downsampling;');
set(zef.h_surface_downsampling,'ButtonPushedFcn','zef_surface_downsampling;');

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

set(zef.h_forward_simulation_table,'data',zef.forward_simulation_table);
set(zef.h_edit65,'value',(zef.mesh_resolution));
set(zef.h_edit_meshing_accuracy,'value',(zef.meshing_accuracy));
set(zef.h_smoothing_strength,'value',(zef.smoothing_strength));
set(zef.h_edit76,'value',(zef.solver_tolerance));
set(zef.h_edit75,'value',(zef.n_sources));
set(zef.h_max_surface_face_count,'value',(zef.max_surface_face_count));
set(zef.h_pushbutton23,'ButtonPushedFcn','zef_apply_transform;');
set(zef.h_pushbutton34,'ButtonPushedFcn','zef_postprocess_finite_element_mesh');
set(zef.h_forward_simulation_update_from_profile,'ButtonPushedFcn','zef.forward_simulation_table = readcell([zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_forward_simulation.ini''],''filetype'',''tex'',''delimiter'','','');zef.h_forward_simulation_table.Data = zef.forward_simulation_table;');

set(zef.h_forward_simulation_table,'CellEditCallback','zef.h_forward_simulation_script.Value = zef.h_forward_simulation_table.Data{zef.forward_simulation_selected(1), zef.forward_simulation_column_selected};')
set(zef.h_forward_simulation_table,'HandleVisibility','on');
set(zef.h_forward_simulation_script,'ValueChangedFcn','zef_update_mesh_tool;');
set(zef.h_forward_simulation_table,'DisplayDataChangedFcn','zef_update_mesh_tool;');
set(zef.h_forward_simulation_table,'CellSelectionCallback',@zef_forward_simulation_table_selection);
if isempty(zef.forward_simulation_table)
zef.forward_simulation_table = readcell([zef.program_path  filesep 'profile' filesep zef.profile_name filesep 'zeffiro_forward_simulation.ini'],'filetype','tex','delimiter',',');
end
zef.h_forward_simulation_table.Data = zef.forward_simulation_table;
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

zef.h_mesh_tool.Units = 'normalized';
zef.h_mesh_tool.Position(1:2) = [0.2 0.2];
zef.h_mesh_tool.Units = 'pixels';
set(zef.h_mesh_tool,'AutoResizeChildren','off');
zef.mesh_tool_current_size = get(zef.h_mesh_tool,'Position');
zef.mesh_tool_relative_size = zef_get_relative_size(zef.h_mesh_tool);
set(zef.h_mesh_tool,'SizeChangedFcn','zef.mesh_tool_current_size = zef_change_size_function(zef.h_mesh_tool,zef.mesh_tool_current_size,zef.mesh_tool_relative_size);');

clear zef_data;

