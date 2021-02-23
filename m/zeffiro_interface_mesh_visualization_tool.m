zef_data = zeffiro_interface_mesh_visualization_tool_app;

zef.h_mesh_visualization_tool = zef_data.h_mesh_visualization_tool;
zef.h_pushbutton31 = zef_data.h_pushbutton31;
zef.h_pushbutton20 = zef_data.h_pushbutton20;
zef.h_pushbutton22 = zef_data.h_pushbutton22;
zef.h_checkbox14 = zef_data.h_checkbox14;
zef.h_checkbox15 = zef_data.h_checkbox15;
zef.h_edit80 = zef_data.h_edit80;
zef.h_edit81 = zef_data.h_edit81;
zef.h_edit82 = zef_data.h_edit82;
zef.h_visualization_type = zef_data.h_visualization_type;
zef.h_frame_start = zef_data.h_frame_start;
zef.h_frame_stop = zef_data.h_frame_stop;
zef.h_frame_step = zef_data.h_frame_step;
zef.h_orbit = zef_data.h_orbit;
zef.h_orbit_2 = zef_data.h_orbit_2;
zef.h_cp2_on = zef_data.h_cp2_on;
zef.h_cp2_a = zef_data.h_cp2_a;
zef.h_cp3_on = zef_data.h_cp3_on;
zef.h_cp2_b = zef_data.h_cp2_b;
zef.h_cp2_c = zef_data.h_cp2_c;
zef.h_cp2_d = zef_data.h_cp2_d;
zef.h_cp3_a = zef_data.h_cp3_a;
zef.h_cp3_b = zef_data.h_cp3_b;
zef.h_cp3_c = zef_data.h_cp3_c;
zef.h_cp3_d = zef_data.h_cp3_d;
zef.h_layer_transparency = zef_data.h_layer_transparency;
zef.h_reconstruction_type = zef_data.h_reconstruction_type;
zef.h_checkbox_cp_on = zef_data.h_checkbox_cp_on;
zef.h_edit_cp_a = zef_data.h_edit_cp_a;
zef.h_edit_cp_b = zef_data.h_edit_cp_b;
zef.h_edit_cp_c = zef_data.h_edit_cp_c;
zef.h_edit_cp_d = zef_data.h_edit_cp_d;
zef.h_inv_scale = zef_data.h_inv_scale;
zef.h_inv_colormap = zef_data.h_inv_colormap;
zef.h_cp_mode = zef_data.h_cp_mode;
zef.h_brain_transparency = zef_data.h_brain_transparency;
zef.h_inv_dynamic_range = zef_data.h_inv_dynamic_range;
zef.h_submesh_num = zef_data.h_submesh_num;
zef.h_use_inflated_surfaces = zef_data.h_use_inflated_surfaces;

%*******

set(zef.h_pushbutton31,'ButtonPushedFcn','zef_visualize_volume;');
set(zef.h_pushbutton20,'ButtonPushedFcn','zef_visualize_surfaces;'); 
set(zef.h_pushbutton22,'ButtonPushedFcn','zef_snapshot_movie;');

set(zef.h_checkbox14,'value',zef.attach_electrodes);
set(zef.h_checkbox15,'value',zef.axes_visible);
set(zef.h_edit80,'value',zef.azimuth);
set(zef.h_edit81,'value',zef.elevation);
set(zef.h_edit82,'value',zef.cam_va);

set(zef.h_visualization_type,'Items',{'Sigma','Recon. (volume)','Recon. (surface)','Parcellation','Topography'});
zef.h_visualization_type.ItemsData = [1:length(zef.h_visualization_type.Items)];
set(zef.h_visualization_type,'Value',zef.visualization_type);

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

set(zef.h_inv_scale,'value',num2str(zef.inv_scale));
set(zef.h_inv_scale,'Items',{'Logarithmic','Linear','Square root'});
zef.h_inv_scale.ItemsData = [1:length(zef.h_inv_scale.Items)];
set(zef.h_inv_scale,'Value',zef.inv_scale);

zef.h_inv_colormap = zef_data.h_inv_colormap;

set(zef.h_inv_colormap,'Items',{'Monterosso','Intensity I','Intensity II','Intensity III','Contrast I','Contrast II','Contrast III','Contrast IV','Contrast V','Blue brain I','Blue brain II','Blue brain III','Parcellation'});
zef.h_inv_colormap.ItemsData = [1:length(zef.h_inv_colormap.Items)];
set(zef.h_inv_colormap,'Value',zef.inv_colormap);


set(zef.h_cp_mode,'Items',{'Cut out','Cut in','Cut out & whole brain','Cut in & whole brain'});
zef.h_cp_mode.ItemsData = [1:length(zef.h_cp_mode.Items)];
set(zef.h_cp_mode,'Value',zef.cp_mode);

set(zef.h_brain_transparency,'value',num2str(1 - zef.brain_transparency));

set(zef.h_inv_dynamic_range,'value',num2str(1./zef.inv_dynamic_range));

set(zef.h_submesh_num,'value',num2str(zef.submesh_num));


set(zef.h_checkbox14,'ValueChangedFcn','zef_update_mesh_visualization_tool;'); 
set(zef.h_checkbox15,'ValueChangedFcn','zef_update_mesh_visualization_tool;'); 
set(zef.h_edit80,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_edit81,'ValueChangedFcn','zef_update_mesh_visualization_tool;'); 
set(zef.h_edit82,'ValueChangedFcn','zef_update_mesh_visualization_tool;'); 
set(zef.h_visualization_type,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_frame_start,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_frame_stop,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_frame_step,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_orbit,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_orbit_2,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp2_on,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp2_a,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp3_on,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp2_b,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp2_c,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp2_d,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp3_a,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp3_b,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp3_c,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp3_d,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_layer_transparency,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_reconstruction_type,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_checkbox_cp_on,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_edit_cp_a,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_edit_cp_b,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_edit_cp_c,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_edit_cp_d,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_inv_scale,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_inv_colormap,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_cp_mode,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_brain_transparency,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_inv_dynamic_range,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_submesh_num,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_use_inflated_surfaces,'ValueChangedFcn','zef_update_mesh_visualization_tool;');
set(zef.h_explode_everything,'ValueChangedFcn','zef_update_mesh_visualization_tool;');


set(findobj(zef.h_mesh_visualization_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);
clear zef_data;







