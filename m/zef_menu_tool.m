
set(groot,'defaultFigureVisible','off')
zef_data = zef_menu_tool_app_exported;
zef_data.h_zeffiro_menu.Visible = zef.use_display;
set(groot,'defaultFigureVisible','on')
zef.fieldnames = fieldnames(zef_data);
for zef_i = 1:length(zef.fieldnames)
    zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
end

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
set(zef.h_menu_sensor_dat_points,'MenuSelectedFcn','[zef.file zef.file_path] = uigetfile(''*.dat''); zef_get_sensor_points;zef_init_sensors_parameter_profile;zef = zef_update(zef);');
set(zef.h_menu_sensor_dat_directions,'MenuSelectedFcn','[zef.file zef.file_path] = uigetfile(''*.dat''); zef_get_sensor_directions;zef_init_sensors_parameter_profile;zef = zef_update(zef);');
set(zef.h_menu_add_compartment,'MenuSelectedFcn','zef_add_compartment;');
set(zef.h_menu_add_sensor_sets,'MenuSelectedFcn','zef_add_sensors;');
set(zef.h_menu_delete_sensor_sets,'MenuSelectedFcn','zef_delete_sensor_sets;');
set(zef.h_menu_lock_on,'MenuSelectedFcn','zef.lock_on = abs(zef.lock_on - 1); zef_toggle_lock_on');
set(zef.h_menu_stl,'MenuSelectedFcn','zef.surface_mesh_type = ''stl''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.stl'');zef_get_surface_mesh;zef = zef_update(zef);');
set(zef.h_menu_dat_points,'MenuSelectedFcn','zef.surface_mesh_type = ''points''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;zef = zef_update(zef);');
set(zef.h_menu_dat_triangles,'MenuSelectedFcn','zef.surface_mesh_type = ''triangles''; zef.file = 0;[zef.file zef.file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;zef = zef_update(zef);');
set(zef.h_menu_export_fem_mesh_as,'MenuSelectedFcn','zef_export_fem_mesh_as;');
set(zef.h_menu_new_empty,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset all?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.new_empty_project = 1; zef_start_new_project;end;');
set(zef.h_menu_compartments_visibility,'MenuSelectedFcn','zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),4) = mat2cell(abs(1 - cell2mat(zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),4))),ones(1,length(unique(zef.h_compartment_table.DisplaySelection(:,1)))));zef = zef_update(zef);');
set(zef.h_menu_sensors_visibility,'MenuSelectedFcn','zef.h_sensors_name_table.Data(unique(zef.h_sensors_name_table.DisplaySelection(:,1)),3) = mat2cell(abs(1 - cell2mat(zef.h_sensors_name_table.Data(unique(zef.h_sensors_name_table.DisplaySelection(:,1)),3))),ones(1,length(unique(zef.h_sensors_name_table.DisplaySelection(:,1)))));zef = zef_update(zef);');
set(zef.h_menu_compartments_visibility,'MenuSelectedFcn','zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),4) = mat2cell(abs(1 - cell2mat(zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),4))),ones(1,length(unique(zef.h_compartment_table.DisplaySelection(:,1)))));zef = zef_update(zef);');
set(zef.h_menu_compartments_on,'MenuSelectedFcn','if not(zef.lock_on); zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),2) = mat2cell(abs(1 - cell2mat(zef.h_compartment_table.Data(unique(zef.h_compartment_table.DisplaySelection(:,1)),2))),ones(1,length(unique(zef.h_compartment_table.DisplaySelection(:,1)))));zef = zef_update(zef);end;');


set(zef.h_menu_new,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset all?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.new_empty_project = 0; zef_start_new_project;end;');
set(zef.h_menu_open,'MenuSelectedFcn','zef_load;');
set(zef.h_menu_open_figure,'MenuSelectedFcn','zef =zef_import_figure(zef);zef_size_change;');
set(zef.h_menu_save                                  ,'MenuSelectedFcn','zef.save_switch=7;zef_save;zef = zef_update(zef);');
set(zef.h_menu_save_as                               ,'MenuSelectedFcn','zef.save_switch=1;zef_save;zef = zef_update(zef);');
set(zef.h_menu_save_figures_as                        ,'MenuSelectedFcn','zef.save_switch=9;zef_save;zef = zef_update(zef);');
set(zef.h_menu_print_to_file                         ,'MenuSelectedFcn','zef.save_switch=10;zef_save;zef = zef_update(zef);');
set(zef.h_menu_exit                                  ,'MenuSelectedFcn','zef_close_all;');
set(zef.h_menu_export_volume_data                    ,'MenuSelectedFcn','zef.save_switch=6;zef_save;zef = zef_update(zef);');
set(zef.h_menu_export_segmentation_data                     ,'MenuSelectedFcn','zef.save_switch=5;zef_save;zef = zef_update(zef);');
set(zef.h_menu_export_lead_field                            ,'MenuSelectedFcn','zef.save_switch=2;zef_save;zef = zef_update(zef);');
set(zef.h_menu_export_source_space                      ,'MenuSelectedFcn','zef.save_switch=3;zef_save;zef = zef_update(zef);');
set(zef.h_menu_export_sensors                     ,'MenuSelectedFcn','zef.save_switch=4;zef_save;zef = zef_update(zef);');
set(zef.h_menu_export_reconstruction                        ,'MenuSelectedFcn','zef.save_switch=8;zef_save;zef = zef_update(zef);');

set(zef.h_menu_new_segmentation_from_folder_legacy          ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a segmentation from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.new_empty_project = 0;zef_start_new_project; zef_import_segmentation_legacy;zef_build_compartment_table;end;');
set(zef.h_menu_import_segmentation_update_from_folder_legacy,'MenuSelectedFcn','zef.new_empty_project = 0;zef_import_segmentation_legacy;zef_build_compartment_table;');

set(zef.h_menu_new_segmentation_from_folder          ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a segmentation from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.new_empty_project = 1;zef_start_new_project; zef_import_segmentation;zef_build_compartment_table;end;');
set(zef.h_menu_import_segmentation_update_from_folder,'MenuSelectedFcn','zef.new_empty_project = 0;zef_import_segmentation;');

zef.h_menu_new_segmentation_from_folder.Text = 'Import data to a new project';
zef.h_menu_import_segmentation_update_from_folder.Text = 'Import data to project';

set(zef.h_menu_import_new_project_from_folder        ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a project from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef_start_new_project; zef_import_project;zef_build_compartment_table;end;');
set(zef.h_menu_import_project_update_from_folder    ,'MenuSelectedFcn','zef_import_project;zef = zef_update(zef);');
set(zef.h_menu_import_volume_data                    ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a new mesh and conductivity?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_start_new_project;[zef.nodes,zef.tetra,zef.sigma,zef.brain_ind,zef.surface_triangles]=zef_import([]); zef_update_fig_details; zef.import_mode = 1; end;');
set(zef.h_menu_import_measurement_data               ,'MenuSelectedFcn','zef.inv_import_type = 1; zef_inv_import;zef = zef_update(zef);');
set(zef.h_menu_import_noise_data                     ,'MenuSelectedFcn','zef.inv_import_type = 4; zef_inv_import;zef = zef_update(zef);');
set(zef.h_menu_import_reconstruction                 ,'MenuSelectedFcn','zef.inv_import_type = 2; zef_inv_import;zef = zef_update(zef);');
set(zef.h_menu_import_current_pattern                ,'MenuSelectedFcn','zef.inv_import_type = 3; zef_inv_import;zef = zef_update(zef);');
set(zef.h_menu_import_resection_points              ,'MenuSelectedFcn','zef_import_resection_points;');
set(zef.h_menu_reset_lead_field                      ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the lead field?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.L = []; end;zef = zef_update(zef);');
set(zef.h_menu_reset_volume_data                     ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset volume data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.nodes=[];zef.nodes_raw=[];zef.tetra=[];zef.tetra_raw=[];zef.domain_labels_aux=[];zef.sigma_vec=[];zef.surface_triangles=cell(0);zef.brain_ind=[];zef.source_ind=[];zef.sigma_prisms=[];zef.prisms=[];end;zef = zef_update(zef);');
set(zef.h_menu_reset_measurement_data                ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the measurement data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.measurements = []; end;zef = zef_update(zef);');
set(zef.h_menu_reset_reconstruction                  ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the reconstruction?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.reconstruction = []; end;zef = zef_update(zef);');
set(zef.h_menu_merge_lead_field                      ,'MenuSelectedFcn','merge_lead_field;zef = zef_update(zef);');
set(zef.h_menu_butterfly_plot                        ,'MenuSelectedFcn','zef_butterfly_plot;zef = zef_update(zef);');
set(zef.h_menu_find_synthetic_source                 ,'MenuSelectedFcn','find_synthetic_source;zef = zef_update(zef);');
set(zef.h_menu_generate_eit_data                     ,'MenuSelectedFcn','find_synthetic_eit_data;zef = zef_update(zef);');
set(zef.h_menu_mesh_tool                             ,'MenuSelectedFcn','zef.h_mesh_tool = zef_window_visible(zef,zef.h_mesh_tool);');
set(zef.h_menu_mesh_visualization_tool               ,'MenuSelectedFcn','zef.h_mesh_visualization_tool = zef_window_visible(zef,zef.h_mesh_visualization_tool);');
set(zef.h_menu_figure_tool                           ,'MenuSelectedFcn','zef_figure_tool;zef = zef_update(zef);');
set(zef.h_menu_parcellation_tool                     ,'MenuSelectedFcn','zef_parcellation_tool;zef = zef_update(zef);');
set(zef.h_menu_options                               ,'MenuSelectedFcn','zef_open_forward_and_inverse_options;zef = zef_update(zef);');
set(zef.h_menu_graphics_options                               ,'MenuSelectedFcn','zef_open_graphics_options;zef = zef_update(zef);');
set(zef.h_menu_system_settings                               ,'MenuSelectedFcn','zef_open_system_settings;');
set(zef.h_menu_plugin_settings                               ,'MenuSelectedFcn','zef_open_plugin_settings;');
set(zef.h_menu_gaussian_prior_options                               ,'MenuSelectedFcn','zef_open_gaussian_prior_options;zef = zef_update(zef);');
set(zef.h_menu_maximize_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''windows'',''all'');zef = zef_update(zef);');
set(zef.h_menu_maximize_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''tools'',''all'');zef = zef_update(zef);');
set(zef.h_menu_maximize_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''maximize'',''figs'',''all'');zef = zef_update(zef);');
set(zef.h_menu_minimize_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''windows'',''all'');zef = zef_update(zef);');
set(zef.h_menu_minimize_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''tools'',''all'');zef = zef_update(zef);');
set(zef.h_menu_minimize_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''minimize'',''figs'',''all'');zef = zef_update(zef);');
set(zef.h_menu_tile_onscreen_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''windows'',''on-screen'');zef = zef_update(zef);');
set(zef.h_menu_tile_onscreen_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''tools'',''on-screen'');zef = zef_update(zef);');
set(zef.h_menu_tile_onscreen_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''figs'',''on-screen'');zef = zef_update(zef);');
set(zef.h_menu_tile_all_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''windows'',''all'');zef = zef_update(zef);');
set(zef.h_menu_tile_all_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''tools'',''all'');zef = zef_update(zef);');
set(zef.h_menu_tile_all_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''tile'',''figs'',''all'');zef = zef_update(zef);');
set(zef.h_menu_close_windows                         ,'MenuSelectedFcn','zef_arrange_windows(''close'',''windows'',''all'');zef = zef_update(zef);');
set(zef.h_menu_close_tools                           ,'MenuSelectedFcn','zef_arrange_windows(''close'',''tools'',''all'');zef = zef_update(zef);');
set(zef.h_menu_close_figures                         ,'MenuSelectedFcn','zef_arrange_windows(''close'',''figs'',''all'');zef = zef_update(zef);');
set(zef.h_menu_documentation                         ,'MenuSelectedFcn','web(''https://github.com/sampsapursiainen/zeffiro_interface/wiki'');zef = zef_update(zef);');
set(zef.h_menu_about                                 ,'MenuSelectedFcn','msgbox([{''Application: ZEFFIRO Forward and inverse interface for complex geometries.''};{[]}; {[''Version: '' num2str(zef.current_version)]} ;{[]}; {''Copyright: © 2018- Sampsa Pursiainen.''} ;{[]};{[]}; {''Created using:''} ;{[]}; {''MATLAB. © 1984- The MathWorks, Inc.''};{[]};{[]}],''ZEFFIRO Interface: About'');');
set(zef.h_menu_segmentation_tool                   ,'MenuSelectedFcn','zef.h_zeffiro_window_main = zef_window_visible(zef,zef.h_zeffiro_window_main);');
set(zef.h_menu_parameter_profile                  ,'MenuSelectedFcn','zef_open_parameter_profile;');
set(zef.h_menu_segmentation_profile                  ,'MenuSelectedFcn','zef_open_segmentation_profile;');
set(zef.h_menu_init_profile                  ,'MenuSelectedFcn','zef_open_init_profile;');
set(zef.h_menu_reset_windows                ,'MenuSelectedFcn','zef_reset_windows;');


set(zef.h_menu_inverse_tools,'Tag','inverse_tools');
set(zef.h_menu_forward_tools,'Tag','forward_tools');
set(zef.h_menu_multi_tools,'Tag','multi_tools');
set(zef.h_menu_project,'Tag','project');
set(zef.h_menu_export,'Tag','export');
set(zef.h_menu_import,'Tag','import');
set(zef.h_menu_edit,'Tag','edit');
set(zef.h_menu_window,'Tag','window');
set(zef.h_menu_help,'Tag','about');

zef.ImportelectrodesMenu = zef_data.ImportelectrodesMenu ;

set(zef.ImportelectrodesMenu, "MenuSelectedFcn", "zef = zefCore.gui.menu_tool.import_electrodes_callback(zef);")

zef.h_zeffiro_menu.DeleteFcn = 'zef_close_all;';

zef_plugin;

zef.menu_accelerator_vec = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
zef.h_temp = findobj(zef.h_zeffiro_window_main,{'parent',zef.h_menu_forward_tools,'-or','parent',zef.h_menu_inverse_tools,'-or','parent',zef.h_menu_multi_tools});


for zef_k = 1 : length(zef.h_temp)
    if zef_k <= length(zef.menu_accelerator_vec)
        set(zef.h_temp(zef_k),'accelerator',char(zef.menu_accelerator_vec(zef_k)));
    end
end

clear  zef_k
zef = rmfield(zef,'h_temp');
zef = rmfield(zef,'menu_accelerator_vec');

zef_set_size_change_function(zef.h_zeffiro_menu,1);

% if zef.h_segmentation_tool_toggle == 1
% 
zef.h_zeffiro_menu.Position = [zef.segmentation_tool_default_position(1), ...
         zef.segmentation_tool_default_position(2) + zef.segmentation_tool_default_position(4),...
         zef.segmentation_tool_default_position(3),...
         0];
% 
% else
% 
%     zef.h_zeffiro_menu.Position = [zef.segmentation_tool_default_position(1), ...
%         zef.segmentation_tool_default_position(2) + zef.segmentation_tool_default_position(4),...
%         2.25*zef.segmentation_tool_default_position(3),...
%         0];
% 
% end





zef.menu_expanded_size = 0.8*zef.segmentation_tool_default_position(4);
zef.h_zeffiro_menu.WindowButtonUpFcn = 'zef_set_menu_size(zef,''minimized'');';
%zef.h_zeffiro_menu.WindowButtonMotionFcn = 'zef_set_menu_size(zef,''expanded'');';
zef.h_temp = findobj(zef.h_zeffiro_menu,'Type','uimenu');

for i = 1 : length(zef.h_temp)

    if isempty(zef.h_temp(i).Children)

        zef.h_temp(i).MenuSelectedFcn = [ zef.h_temp(i).MenuSelectedFcn ' zef_set_menu_size(zef,''minimized'');'];

    else

        zef.h_temp(i).MenuSelectedFcn = [ zef.h_temp(i).MenuSelectedFcn ' zef_set_menu_size(zef,''expanded'');'];

    end
end

zef = rmfield(zef,'h_temp');

set(findobj(zef.h_zeffiro_menu.Children,'-property','FontSize'),'FontSize',zef.font_size);

if not(isprop(zef.h_zeffiro_menu,'ZefTool'))
    addprop(zef.h_zeffiro_menu,'ZefTool');
end
zef.h_zeffiro_menu.ZefTool = mfilename;

if not(isprop(zef.h_zeffiro_menu,'ZefVerboseMode'))
    addprop(zef.h_zeffiro_menu,'ZefVerboseMode');
end
zef.h_zeffiro_menu.ZefVerboseMode = zef.verbose_mode;

if not(isprop(zef.h_zeffiro_menu,'ZefAlwaysShowWaitbar'))
    addprop(zef.h_zeffiro_menu,'ZefAlwaysShowWaitbar');
end
zef.h_zeffiro_menu.ZefAlwaysShowWaitbar = zef.always_show_waitbar;

if not(isprop(zef.h_zeffiro_menu,'ZefUseWaitbar'))
    addprop(zef.h_zeffiro_menu,'ZefUseWaitbar');
end
zef.h_zeffiro_menu.ZefUseWaitbar = zef.use_waitbar;

if not(isprop(zef.h_zeffiro_menu,'ZefUseLog'))
    addprop(zef.h_zeffiro_menu,'ZefUseLog');
end
zef.h_zeffiro_menu.ZefUseLog = zef.use_log;

if not(isprop(zef.h_zeffiro_menu,'ZefWaitbarSize'))
    addprop(zef.h_zeffiro_menu,'ZefWaitbarSize');
end
zef.h_zeffiro_menu.ZefWaitbarSize(1) = 1*zef.segmentation_tool_default_position(3)/zef_eval_entry(get(groot,'ScreenSize'),3);
zef.h_zeffiro_menu.ZefWaitbarSize(2) = 0.7*zef.h_zeffiro_menu.ZefWaitbarSize(1);

if not(isprop(zef.h_zeffiro_menu,'ZefTaskId'))
    addprop(zef.h_zeffiro_menu,'ZefTaskId');
end
zef.h_zeffiro_menu.ZefTaskId = zef.zeffiro_task_id;

if not(isprop(zef.h_zeffiro_menu,'ZefRestartTime'))
    addprop(zef.h_zeffiro_menu,'ZefRestartTime');
end
zef.h_zeffiro_menu.ZefRestartTime = zef.zeffiro_restart_time;

if not(isprop(zef.h_zeffiro_menu,'ZefProgramPath'))
    addprop(zef.h_zeffiro_menu,'ZefProgramPath');
end
zef.h_zeffiro_menu.ZefProgramPath = zef.program_path;

if not(isprop(zef.h_zeffiro_menu,'ZefFontSize'))
    addprop(zef.h_zeffiro_menu,'ZefFontSize');
end
zef.h_zeffiro_menu.ZefFontSize = zef.font_size;

if not(isprop(zef.h_zeffiro_menu,'ZefWaitbarHandle'))
    addprop(zef.h_zeffiro_menu,'ZefWaitbarHandle');
end
zef.h_zeffiro_menu.ZefWaitbarHandle = findall(groot,'-property','ZefWaitStartTime');
