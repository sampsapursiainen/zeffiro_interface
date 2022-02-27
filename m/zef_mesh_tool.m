%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if zef.mlapp == 1
zeffiro_interface_mesh_tool;
else

zef.h_mesh_tool = open('zeffiro_interface_mesh_tool.fig');
set(findobj(zef.h_mesh_tool.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_mesh_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.aux_handle_vec = [zef.h_pushbutton31;
zef.h_pushbutton20;
zef.h_pushbutton22;
zef.h_checkbox14;
zef.h_checkbox15;
zef.h_checkbox_cp_on;
zef.h_edit_cp_a;
zef.h_edit_cp_b;
zef.h_edit_cp_c;
zef.h_edit_cp_d;
zef.h_edit80;
zef.h_edit81;
zef.h_edit82;
zef.h_visualization_type;
zef.h_pushbutton23;
zef.h_pushbutton21;
zef.h_pushbutton34;
zef.h_checkbox_mesh_smoothing_on;
zef.h_refinement_on;
zef.h_edit65;
zef.h_edit_meshing_accuracy;
zef.h_edit75;
zef.h_smoothing_strength;
zef.h_pushbutton14;
zef.h_source_interpolation_on;
zef.h_popupmenu1;
zef.h_popupmenu6;
zef.h_popupmenu2;
zef.h_edit76];
uistack(flipud(zef.aux_handle_vec),'bottom');
zef = rmfield(zef,'aux_handle_vec');
set(zef.h_pushbutton21,'callback','if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; zef_process_meshes; zef_create_fem_mesh;  zef_postprocess_fem_mesh; zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;');
set(zef.h_zef_downsample_surfaces,'callback','zef_downsample_surfaces; zef_process_meshes; source_interpolation;');
set(zef.h_pushbutton14,'callback','zef_process_meshes;zef_attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_make_all,'callback','if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; zef.source_interpolation_on = 1; set(zef.h_source_interpolation_on,''value'',1); zef_process_meshes;zef_create_fem_mesh;zef_postprocess_fem_mesh;  zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details; zef_process_meshes;  zef_attach_sensors_volume(zef.sensors);lead_field_matrix;');
set(zef.h_pushbutton34,'callback','zef_postprocess_fem_mesh;zef_update_fig_details;');
set(zef.h_popupmenu2,'string',{'Cartesian','Normal','Basis'});
set(zef.h_visualization_type,'string',{'Sigma','Recon. (volume)','Recon. (surface)','Parcellation','Topography'});
set(zef.h_pushbutton31,'string','Visualize volume');
set(zef.h_checkbox14,'value',zef.attach_electrodes);
set(zef.h_checkbox_mesh_smoothing_on,'value',zef.mesh_smoothing_on);
set(zef.h_source_interpolation_on,'value',zef.source_interpolation_on);
set(zef.h_checkbox15,'value',zef.axes_visible);
set(zef.h_refinement_on,'value',zef.refinement_on);
set(zef.h_checkbox_cp_on,'value',zef.cp_on);
set(zef.h_edit_cp_a,'string',num2str(zef.cp_a));
set(zef.h_edit_cp_b,'string',num2str(zef.cp_b));
set(zef.h_edit_cp_c,'string',num2str(zef.cp_c));
set(zef.h_edit_cp_d,'string',num2str(zef.cp_d));
set(zef.h_edit65,'string',num2str(zef.mesh_resolution));
set(zef.h_popupmenu1,'string',zef.imaging_method_cell);
set(zef.h_popupmenu1,'value',zef.imaging_method);
set(zef.h_edit80,'string',num2str(zef.azimuth));
set(zef.h_edit81,'string',num2str(zef.elevation));
set(zef.h_edit_meshing_accuracy,'string',num2str(zef.meshing_accuracy));
set(zef.h_popupmenu6,'value',zef.location_unit);
set(zef.h_edit82,'value',zef.cam_va);
set(zef.h_edit75,'string',num2str(zef.n_sources));
set(zef.h_popupmenu2,'value',zef.source_direction_mode);
set(zef.h_visualization_type,'value',zef.visualization_type);
set(zef.h_smoothing_strength,'string',num2str(zef.smoothing_strength));
set(zef.h_edit76,'string', num2str(zef.inv_pcg_tol));
set(zef.h_loop_movie,'value',zef.loop_movie);
set(zef.h_edit76,'string',num2str(zef.solver_tolerance));

zef_update_mesh_tool;

end

