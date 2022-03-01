zef.attach_electrodes = zef.h_checkbox14.Value;
zef.axes_visible = zef.h_checkbox15.Value;
zef.azimuth = zef.h_edit80.Value;
zef.elevation = zef.h_edit81.Value;
zef.cam_va = zef.h_edit82.Value;
zef.visualization_type = zef.h_visualization_type.Value;
zef.frame_start = str2num(zef.h_frame_start.Value);
zef.frame_stop = str2num(zef.h_frame_stop.Value);
zef.frame_step = str2num(zef.h_frame_step.Value);
zef.orbit_1 = str2num(zef.h_orbit.Value);
zef.orbit_2 = str2num(zef.h_orbit_2.Value);
zef.cp2_on = zef.h_cp2_on.Value;
zef.cp2_a = str2num(zef.h_cp2_a.Value);
zef.cp3_on = zef.h_cp3_on.Value;
zef.cp2_b = str2num(zef.h_cp2_b.Value);
zef.cp2_c = str2num(zef.h_cp2_c.Value);
zef.cp2_d = str2num(zef.h_cp2_d.Value);
zef.cp3_a = str2num(zef.h_cp3_a.Value);
zef.cp3_b = str2num(zef.h_cp3_b.Value);
zef.cp3_c = str2num(zef.h_cp3_c.Value);
zef.cp3_d = str2num(zef.h_cp3_d.Value);
zef.layer_transparency = 1 - str2num(zef.h_layer_transparency.Value);
zef.reconstruction_type = zef.h_reconstruction_type.Value;
zef.cp_on = zef.h_checkbox_cp_on.Value;
zef.cp_a = str2num(zef.h_edit_cp_a.Value);
zef.cp_b = str2num(zef.h_edit_cp_b.Value);
zef.cp_c = str2num(zef.h_edit_cp_c.Value);
zef.cp_d = str2num(zef.h_edit_cp_d.Value);
zef.inv_scale = zef.h_inv_scale.Value;
zef.inv_colormap = zef.h_inv_colormap.Value;
zef.cp_mode = zef.h_cp_mode.Value;
zef.brain_transparency = 1 - str2num(zef.h_brain_transparency.Value);
zef.inv_dynamic_range = str2num(zef.h_inv_dynamic_range.Value);
zef.use_inflated_surfaces = zef.h_use_inflated_surfaces.Value;
zef.explode_everything = zef.h_explode_everything.Value;
zef.cone_draw = zef.h_cone_draw.Value;
zef.streamline_draw = zef.h_streamline_draw.Value;
zef.volumetric_distribution_mode = zef.h_volumetric_distribution_mode.Value;

set(zef.h_mesh_visualization_parameter_list,'Items',zef_get_profile_parameters);
zef.h_mesh_visualization_parameter_list.ItemsData = [1:length(zef.h_mesh_visualization_parameter_list.Items)];

zef.mesh_visualization_parameter_selected = zef.h_mesh_visualization_parameter_list.Value;
zef.mesh_visualization_graph_selected = zef.h_mesh_visualization_graph_list.Value;

if zef.inv_dynamic_range == 0
zef.inv_dynamic_range = Inf;
else
    zef.inv_dynamic_range = 1./zef.inv_dynamic_range;
end

zef.submesh_num = str2num(zef.h_submesh_num.Value);

if zef.cp_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_edit_cp_a, 'enable', zef.enable_str);
set(zef.h_edit_cp_b, 'enable', zef.enable_str);
set(zef.h_edit_cp_c, 'enable', zef.enable_str);
set(zef.h_edit_cp_d, 'enable', zef.enable_str);

if zef.cp2_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_cp2_a, 'enable', zef.enable_str);
set(zef.h_cp2_b, 'enable', zef.enable_str);
set(zef.h_cp2_c, 'enable', zef.enable_str);
set(zef.h_cp2_d, 'enable', zef.enable_str);

if zef.cp3_on
zef.enable_str = 'on';
else
zef.enable_str = 'off';
end;

set(zef.h_cp3_a, 'enable', zef.enable_str);
set(zef.h_cp3_b, 'enable', zef.enable_str);
set(zef.h_cp3_c, 'enable', zef.enable_str);
set(zef.h_cp3_d, 'enable', zef.enable_str);

