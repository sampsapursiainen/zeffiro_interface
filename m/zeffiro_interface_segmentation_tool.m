set(groot,'defaultFigureVisible','off')
zef_data = zeffiro_interface_segmentation_tool_app_exported;
zef_data.h_zeffiro_window_main.Visible = zef.use_display;
set(groot,'defaultFigureVisible','on')
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end

set(zef.h_transform_table,'columnformat',{'numeric','char'});
set(zef.h_transform_table,'columnformat',{'numeric','char'});
set(zef.h_sensors_name_table,'columnformat',{'numeric','char','logical'});
set(zef.h_sensors_table,'columnformat',{'numeric','char',zef.imaging_method_cell,'logical','logical','logical','logical','logical'});
set(zef.h_parameters_table,'columnformat',{'char','numeric'});
set(zef.h_zeffiro_window_main,'DeleteFcn','if not(isdeployed); zef.h_zeffiro = []; zef_arrange_windows(''close'',''windows'',''all''); rmpath([zef.program_path zef.code_path]); rmpath([zef.program_path ''/fig'']); end; clear zef;');
set(zef.h_project_tag,'ValueChangedFcn','zef_update;');
set(zef.h_compartment_table,'CellEditCallback','zef_update;');
set(zef.h_sensors_table,'CellEditCallback','zef_update;');
set(zef.h_transform_table,'CellEditCallback','zef_update_transform;');
set(zef.h_sensors_name_table,'CellEditCallback','zef_update_sensors_name_table;');
set(zef.h_parameters_table,'CellEditCallback','zef_update_parameters;');
set(zef.h_compartment_table,'CellSelectionCallback',@zef_compartment_table_selection);
set(zef.h_transform_table,'CellSelectionCallback',@zef_transform_table_selection);
set(zef.h_sensors_table,'CellSelectionCallback',@zef_sensors_table_selection);
set(zef.h_sensors_name_table,'CellSelectionCallback',@zef_sensors_name_table_selection);

set(zef.h_menu_settings,'Tag','settings');
set(zef.h_menu_add_sensors,'MenuSelectedFcn','zef_add_sensor_name;');
set(zef.h_menu_delete_sensors,'MenuSelectedFcn','zef_delete_sensors;');
set(zef.h_menu_import_sensor_names,'MenuSelectedFcn','zef_import_sensor_names;');
set(zef.h_menu_delete_transform,'MenuSelectedFcn','zef_delete_transform;');
set(zef.h_menu_add_transform,'MenuSelectedFcn','zef_add_transform;');
set(zef.h_menu_lock_transforms_on,'MenuSelectedFcn','zef.lock_transforms_on = abs(zef.lock_transforms_on - 1); zef_toggle_lock_transforms_on;');
set(zef.h_menu_lock_sensor_names_on,'MenuSelectedFcn','zef.lock_sensor_names_on = abs(zef.lock_sensor_names_on - 1); zef_toggle_lock_sensor_names_on;');
set(zef.h_menu_lock_sensor_sets_on,'MenuSelectedFcn','zef.lock_sensor_sets_on = abs(zef.lock_sensor_sets_on - 1); zef_toggle_lock_sensor_sets_on;');
set(zef.h_menu_delete_compartment,'MenuSelectedFcn','zef_delete_compartment;zef_init_sensors_parameter_profile;');
set(zef.h_menu_sensor_dat_points,'MenuSelectedFcn','[zef.file zef.file_path] = uigetfile(''*.dat''); zef_get_sensor_points;zef_init_sensors_parameter_profile;zef_update;');
set(zef.h_menu_sensor_dat_directions,'MenuSelectedFcn','[zef.file zef.file_path] = uigetfile(''*.dat''); zef_get_sensor_directions;zef_init_sensors_parameter_profile;zef_update;');
set(zef.h_menu_add_compartment,'MenuSelectedFcn','zef_add_compartment;');
set(zef.h_menu_add_sensor_sets,'MenuSelectedFcn','zef_add_sensors;');
set(zef.h_menu_delete_sensor_sets,'MenuSelectedFcn','zef_delete_sensor_sets;');
set(zef.h_menu_lock_on,'MenuSelectedFcn','zef.lock_on = abs(zef.lock_on - 1); zef_toggle_lock_on');
set(zef.h_menu_stl,'MenuSelectedFcn','zef.surface_mesh_type = ''stl''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.stl'');zef_get_surface_mesh;');
set(zef.h_menu_dat_points,'MenuSelectedFcn','zef.surface_mesh_type = ''points''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;');
set(zef.h_menu_dat_triangles,'MenuSelectedFcn','zef.surface_mesh_type = ''triangles''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;');
set(zef.h_menu_export_fem_mesh_as,'MenuSelectedFcn','zef_export_fem_mesh_as;');
set(zef.h_menu_new_empty,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset all?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.new_empty_project = 1; zef_start_new_project;end;');

set(zef.h_menu_new,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset all?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.new_empty_project = 0; zef_start_new_project;end;');
set(zef.h_menu_open,'MenuSelectedFcn','zef_load;');
set(zef.h_menu_open_figure,'MenuSelectedFcn','zef_import_figure;zef_size_change;');
set(zef.h_menu_save                                  ,'MenuSelectedFcn','zef.save_switch=7;zef_save;zef_update;');
set(zef.h_menu_save_as                               ,'MenuSelectedFcn','zef.save_switch=1;zef_save;zef_update;');
set(zef.h_menu_save_figures_as                        ,'MenuSelectedFcn','zef.save_switch=9;zef_save;zef_update;');
set(zef.h_menu_print_to_file                         ,'MenuSelectedFcn','zef.save_switch=10;zef_save;zef_update;');
set(zef.h_menu_exit                                  ,'MenuSelectedFcn','zef_close_all;');
set(zef.h_menu_export_volume_data                    ,'MenuSelectedFcn','zef.save_switch=6;zef_save;zef_update;');
set(zef.h_menu_export_segmentation_data                     ,'MenuSelectedFcn','zef.save_switch=5;zef_save;zef_update;');
set(zef.h_menu_export_lead_field                            ,'MenuSelectedFcn','zef.save_switch=2;zef_save;zef_update;');
set(zef.h_menu_export_source_space                      ,'MenuSelectedFcn','zef.save_switch=3;zef_save;zef_update;');
set(zef.h_menu_export_sensors                     ,'MenuSelectedFcn','zef.save_switch=4;zef_save;zef_update;');
set(zef.h_menu_export_reconstruction                        ,'MenuSelectedFcn','zef.save_switch=8;zef_save;zef_update;');

set(zef.h_menu_new_segmentation_from_folder_legacy          ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a segmentation from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.new_empty_project = 0;zef_start_new_project; zef_import_segmentation_legacy;zef_build_compartment_table;end;');
set(zef.h_menu_import_segmentation_update_from_folder_legacy,'MenuSelectedFcn','zef.new_empty_project = 0;zef_import_segmentation_legacy;zef_update;');

set(zef.h_menu_new_segmentation_from_folder          ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a segmentation from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.new_empty_project = 1;zef_start_new_project; zef_import_segmentation;zef_build_compartment_table;end;');
set(zef.h_menu_import_segmentation_update_from_folder,'MenuSelectedFcn','zef.new_empty_project = 0;zef_import_segmentation;zef_update;');

set(zef.h_menu_import_new_project_from_folder        ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a project from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef_start_new_project; zef_import_project;zef_build_compartment_table;end;');
set(zef.h_menu_import_project_update_from_folder    ,'MenuSelectedFcn','zef_import_project;zef_update;');
set(zef.h_menu_import_volume_data                    ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a new mesh and conductivity?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_start_new_project;[zef.nodes,zef.tetra,zef.sigma,zef.brain_ind,zef.surface_triangles]=zef_import([]); zef_update_fig_details; zef.import_mode = 1; end;');
set(zef.h_menu_import_measurement_data               ,'MenuSelectedFcn','zef.inv_import_type = 1; zef_inv_import;zef_update;');
set(zef.h_menu_import_noise_data                     ,'MenuSelectedFcn','zef.inv_import_type = 4; zef_inv_import;zef_update;');
set(zef.h_menu_import_reconstruction                 ,'MenuSelectedFcn','zef.inv_import_type = 2; zef_inv_import;zef_update;');
set(zef.h_menu_import_current_pattern                ,'MenuSelectedFcn','zef.inv_import_type = 3; zef_inv_import;zef_update;');
set(zef.h_menu_import_resection_points              ,'MenuSelectedFcn','zef_import_resection_points;');
set(zef.h_menu_reset_lead_field                      ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the lead field?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.L = []; end;zef_update;');
set(zef.h_menu_reset_volume_data                     ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset volume data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.nodes=[];zef.nodes_raw=[];zef.tetra=[];zef.tetra_raw=[];zef.domain_labels_aux=[];zef.sigma_vec=[];zef.surface_triangles=[];zef.brain_ind=[];zef.source_ind=[];zef.sigma_prisms=[];zef.prisms=[];end;zef_update;');
set(zef.h_menu_reset_measurement_data                ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the measurement data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.measurements = []; end;zef_update;');
set(zef.h_menu_reset_reconstruction                  ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the reconstruction?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.reconstruction = []; end;zef_update;');
set(zef.h_menu_merge_lead_field                      ,'MenuSelectedFcn','merge_lead_field;zef_update;');
set(zef.h_menu_butterfly_plot                        ,'MenuSelectedFcn','zef_butterfly_plot;zef_update;');
set(zef.h_menu_find_synthetic_source                 ,'MenuSelectedFcn','find_synthetic_source;zef_update;');
set(zef.h_menu_generate_eit_data                     ,'MenuSelectedFcn','find_synthetic_eit_data;zef_update;');
set(zef.h_menu_mesh_tool                             ,'MenuSelectedFcn','zef_mesh_tool;zef_update;');
set(zef.h_menu_mesh_visualization_tool               ,'MenuSelectedFcn','zeffiro_interface_mesh_visualization_tool;zef_update;');
set(zef.h_menu_figure_tool                           ,'MenuSelectedFcn','zef_figure_tool;zef_update;');
set(zef.h_menu_parcellation_tool                     ,'MenuSelectedFcn','zef_parcellation_tool;zef_update;');
set(zef.h_menu_options                               ,'MenuSelectedFcn','zef_open_forward_and_inverse_options;zef_update;');
set(zef.h_menu_graphics_options                               ,'MenuSelectedFcn','zef_open_graphics_options;zef_update;');
set(zef.h_menu_system_settings                               ,'MenuSelectedFcn','zef_open_system_settings;');
set(zef.h_menu_plugin_settings                               ,'MenuSelectedFcn','zef_open_plugin_settings;');
set(zef.h_menu_gaussian_prior_options                               ,'MenuSelectedFcn','zef_open_gaussian_prior_options;zef_update;');
set(zef.h_menu_maximize_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''windows'',''all'');zef_update;');
set(zef.h_menu_maximize_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''tools'',''all'');zef_update;');
set(zef.h_menu_maximize_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''figs'',''all'');zef_update;');
set(zef.h_menu_minimize_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''windows'',''all'');zef_update;');
set(zef.h_menu_minimize_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''tools'',''all'');zef_update;');
set(zef.h_menu_minimize_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''figs'',''all'');zef_update;');
set(zef.h_menu_tile_onscreen_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''windows'',''on-screen'');zef_update;');
set(zef.h_menu_tile_onscreen_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''tools'',''on-screen'');zef_update;');
set(zef.h_menu_tile_onscreen_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''figs'',''on-screen'');zef_update;');
set(zef.h_menu_tile_all_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''windows'',''all'');zef_update;');
set(zef.h_menu_tile_all_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''tools'',''all'');zef_update;');
set(zef.h_menu_tile_all_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''figs'',''all'');zef_update;');
set(zef.h_menu_close_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''close'',''windows'',''all'');zef_update;');
set(zef.h_menu_close_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''close'',''tools'',''all'');zef_update;');
set(zef.h_menu_close_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''close'',''figs'',''all'');zef_update;');
set(zef.h_menu_documentation                         ,'MenuSelectedFcn','web(''https://github.com/sampsapursiainen/zeffiro_interface/wiki'');zef_update;');
set(zef.h_menu_about                                 ,'MenuSelectedFcn','msgbox([{''Application: ZEFFIRO Forward and inverse interface for complex geometries.''};{[]}; {[''Version: '' num2str(zef.current_version)]} ;{[]}; {''Copyright: © 2018- Sampsa Pursiainen.''} ;{[]};{[]}; {''Created using:''} ;{[]}; {''MATLAB. © 1984- The MathWorks, Inc.''};{[]};{[]}],''ZEFFIRO Interface: About'');');
set(zef.h_menu_segmentation_tool                   ,'MenuSelectedFcn','zef_reopen_segmentation_tool;');
set(zef.h_menu_parameter_profile                  ,'MenuSelectedFcn','zef_open_parameter_profile;');
set(zef.h_menu_segmentation_profile                  ,'MenuSelectedFcn','zef_open_segmentation_profile;');
set(zef.h_menu_init_profile                  ,'MenuSelectedFcn','zef_open_init_profile;');

set(zef.h_menu_inverse_tools,'Tag','inverse_tools');
set(zef.h_menu_forward_tools,'Tag','forward_tools');
set(zef.h_menu_multi_tools,'Tag','multi_tools');
set(zef.h_menu_project,'Tag','project');
set(zef.h_menu_export,'Tag','export');
set(zef.h_menu_import,'Tag','import');
set(zef.h_menu_edit,'Tag','edit');
set(zef.h_menu_window,'Tag','window');
set(zef.h_menu_help,'Tag','about');

zef.h_project_notes.ValueChangedFcn = 'zef_update;';

zef.mlapp = 1;

clear zef_data;

zef.aux_dir = dir([zef.program_path filesep 'profile']);
zef.aux_cell = cell(0);
zef_j = 0;
for zef_i = 3 : length(zef.aux_dir)
    if zef.aux_dir(zef_i).isdir
        zef_j = zef_j + 1;
   zef.aux_cell{zef_j} = zef.aux_dir(zef_i).name;
    end
end
zef.h_profile_name.Items = zef.aux_cell;
zef = rmfield(zef,{'aux_dir','aux_cell'});
zef.h_profile_name.Value = zef.profile_name;
zef.h_profile_name.ValueChangedFcn = 'zef.profile_name = zef.h_profile_name.Value;';

zef.h_project_tag.Value = zef.project_tag;

set(zef.h_zeffiro_window_main,'AutoResizeChildren','off');
zef.zeffiro_window_main_current_size = get(zef.h_zeffiro_window_main,'Position');
zef.zeffiro_window_main_relative_size = zef_get_relative_size(zef.h_zeffiro_window_main);
set(zef.h_zeffiro_window_main,'SizeChangedFcn','zef.zeffiro_window_main_current_size = zef_change_size_function(zef.h_zeffiro_window_main,zef.zeffiro_window_main_current_size,zef.zeffiro_window_main_relative_size);');

zef.h_windows_open = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*','-not','Name','ZEFFIRO Interface: Segmentation tool');

set(zef.h_zeffiro_window_main,'DeleteFcn','zef_close_all;');

