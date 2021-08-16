zef_data = zeffiro_interface_segmentation_tool_app;
zef.h_project_notes=zef_data.h_project_notes;
zef.h_zeffiro_window_main=zef_data.h_zeffiro_window_main;
zef.h_menu_project=zef_data.h_menu_project;
zef.h_menu_new=zef_data.h_menu_new;
zef.h_menu_open=zef_data.h_menu_open;
zef.h_menu_save=zef_data.h_menu_save;
zef.h_menu_save_as=zef_data.h_menu_save_as;
zef.h_menu_save_figures_as=zef_data.h_menu_save_figures_as;
zef.h_menu_print_to_file=zef_data.h_menu_print_to_file;
zef.h_menu_exit=zef_data.h_menu_exit;
zef.h_menu_export=zef_data.h_menu_export;
zef.h_menu_export_volume_data=zef_data.h_menu_export_volume_data;
zef.h_menu_segmentation_data=zef_data.h_menu_segmentation_data;
zef.h_menu_lead_field=zef_data.h_menu_lead_field;
zef.h_menu_source_positions=zef_data.h_menu_source_positions;
zef.h_menu_source_directions=zef_data.h_menu_source_directions;
zef.h_menu_reconstruction=zef_data.h_menu_reconstruction;
zef.h_menu_edit=zef_data.h_menu_edit;
zef.h_menu_reset_lead_field=zef_data.h_menu_reset_lead_field;
zef.h_menu_reset_volume_data=zef_data.h_menu_reset_volume_data;;
zef.h_menu_reset_measurement_data=zef_data.h_menu_reset_measurement_data;
zef.h_menu_reset_reconstruction=zef_data.h_menu_reset_reconstruction;
zef.h_menu_merge_lead_field=zef_data.h_menu_merge_lead_field;
zef.h_menu_inverse_tools=zef_data.h_menu_inverse_tools;
zef.h_menu_forward_tools=zef_data.h_menu_forward_tools;
zef.h_menu_butterfly_plot=zef_data.h_menu_butterfly_plot;
zef.h_menu_find_synthetic_source=zef_data.h_menu_find_synthetic_source;
zef.h_menu_generate_eit_data=zef_data.h_menu_generate_eit_data;
zef.h_menu_multi_tools=zef_data.h_menu_multi_tools;
zef.h_menu_mesh_tool=zef_data.h_menu_mesh_tool;
zef.h_menu_mesh_visualization_tool=zef_data.h_menu_mesh_visualization_tool;
zef.h_menu_figure_tool=zef_data.h_menu_figure_tool;
zef.h_menu_parcellation_tool=zef_data.h_menu_parcellation_tool;
zef.h_menu_options=zef_data.h_menu_options;
zef.h_menu_window=zef_data.h_menu_window;
zef.h_menu_close_tools=zef_data.h_menu_close_tools;
zef.h_menu_close_figures=zef_data.h_menu_close_figures;
zef.h_menu_help=zef_data.h_menu_help;
zef.h_menu_documentation=zef_data.h_menu_documentation;
zef.h_menu_about=zef_data.h_menu_about;
zef.h_menu_import=zef_data.h_menu_import;
zef.h_menu_segmentation_tool=zef_data.h_menu_segmentation_tool;
zef.h_menu_new_segmentation_from_folder=zef_data.h_menu_new_segmentation_from_folder;
zef.h_menu_import_segmentation_update_from_folder=zef_data.h_menu_import_segmentation_update_from_folder;
zef.h_menu_import_new_project_from_folder=zef_data.h_menu_import_new_project_from_folder;
zef.h_menu_import_project_update_from_folder=zef_data.h_menu_import_project_update_from_folder;
zef.h_menu_import_volume_data=zef_data.h_menu_import_volume_data;
zef.h_menu_import_measurement_data=zef_data.h_menu_import_measurement_data;
zef.h_menu_import_noise_data=zef_data.h_menu_import_noise_data;
zef.h_menu_import_reconstruction=zef_data.h_menu_import_reconstruction;
zef.h_menu_import_current_pattern=zef_data.h_menu_import_current_pattern;
zef.h_axes2=zef_data.h_axes2;
zef.h_compartment_table=zef_data.h_compartment_table;
zef.h_sensors_table=zef_data.h_sensors_table;
zef.h_transform_table=zef_data.h_transform_table;
zef.h_sensors_name_table=zef_data.h_sensors_name_table;
zef.h_project_information=zef_data.h_project_information;
zef.h_parameters_table=zef_data.h_parameters_table;

set(zef.h_compartment_table,'columnformat',{'numeric','char','logical','logical','logical','logical',{'Inactive','Constrained field','Unconstrained field','Active surface'},'numeric'})
set(zef.h_transform_table,'columnformat',{'numeric','char'});

set(zef.h_transform_table,'columnformat',{'numeric','char'});
set(zef.h_sensors_name_table,'columnformat',{'numeric','char','logical'});

set(zef.h_sensors_table,'columnformat',{'numeric','char',{'EEG', 'MEG magnetometers', 'MEG gradiometers', 'EIT', 'tES'},'logical','logical','logical','logical','logical'});
set(zef.h_parameters_table,'columnformat',{'char','numeric'});

set(zef.h_zeffiro_window_main,'DeleteFcn','if not(isdeployed); zef.h_zeffiro = []; zef_close_tools; zef_close_figs; rmpath([zef.program_path zef.code_path]); rmpath([zef.program_path ''/fig'']); end; clear zef;');

set(zef.h_compartment_table,'CellEditCallback','zef_update;');
set(zef.h_sensors_table,'CellEditCallback','zef_update;');
set(zef.h_transform_table,'CellEditCallback','zef_update_transform;');
set(zef.h_sensors_name_table,'CellEditCallback','zef_update_sensors_name_table;');
set(zef.h_parameters_table,'CellEditCallback','zef_update_parameters;');




set(zef.h_compartment_table,'CellSelectionCallback',@zef_compartment_table_selection);
set(zef.h_transform_table,'CellSelectionCallback',@zef_transform_table_selection);
set(zef.h_sensors_table,'CellSelectionCallback',@zef_sensors_table_selection);
set(zef.h_sensors_name_table,'CellSelectionCallback',@zef_sensors_name_table_selection);
zef.h_menu_inverse_tools = zef_data.h_menu_inverse_tools;
zef.h_menu_forward_tools = zef_data.h_menu_forward_tools;
zef.h_menu_multi_tools = zef_data.h_menu_multi_tools;
zef.h_menu_project = zef_data.h_menu_project;
zef.h_menu_export = zef_data.h_menu_export;
zef.h_menu_import = zef_data.h_menu_import;
zef.h_menu_edit = zef_data.h_menu_edit; 
zef.h_menu_window = zef_data.h_menu_window;
zef.h_menu_help = zef_data.h_menu_help;

zef.h_menu_new                                    =zef_data.h_menu_new;     
zef.h_menu_open                                   =zef_data.h_menu_open;
zef.h_menu_save                                   =zef_data.h_menu_save;
zef.h_menu_save_as                                =zef_data.h_menu_save_as;    
zef.h_menu_save_figures_as                         =zef_data.h_menu_save_figures_as;  
zef.h_menu_print_to_file                          =zef_data.h_menu_print_to_file; 
zef.h_menu_exit                                   =zef_data.h_menu_exit;
zef.h_menu_export_volume_data                     =zef_data.h_menu_export_volume_data;   
zef.h_menu_segmentation_data                      =zef_data.h_menu_segmentation_data;
zef.h_menu_lead_field                             =zef_data.h_menu_lead_field ;
zef.h_menu_source_positions                       =zef_data.h_menu_source_positions; 
zef.h_menu_source_directions                      =zef_data.h_menu_source_directions;  
zef.h_menu_reconstruction                         =zef_data.h_menu_reconstruction;
zef.h_menu_new_segmentation_from_folder           =zef_data.h_menu_new_segmentation_from_folder;      
zef.h_menu_import_segmentation_update_from_folder =zef_data.h_menu_import_segmentation_update_from_folder;   
zef.h_menu_import_new_project_from_folder         =zef_data.h_menu_import_new_project_from_folder;
zef.h_menu_import_project_update_from_folder     =zef_data.h_menu_import_project_update_from_folder;
zef.h_menu_import_volume_data                     =zef_data.h_menu_import_volume_data;
zef.h_menu_import_measurement_data                =zef_data.h_menu_import_measurement_data;  
zef.h_menu_import_noise_data                      =zef_data.h_menu_import_noise_data;
zef.h_menu_import_reconstruction                  =zef_data.h_menu_import_reconstruction;
zef.h_menu_import_current_pattern                 =zef_data.h_menu_import_current_pattern;
zef.h_menu_reset_lead_field                       =zef_data.h_menu_reset_lead_field;
zef.h_menu_reset_volume_data                      =zef_data.h_menu_reset_volume_data;    
zef.h_menu_reset_measurement_data                 =zef_data.h_menu_reset_measurement_data;         
zef.h_menu_reset_reconstruction                   =zef_data.h_menu_reset_reconstruction;
zef.h_menu_merge_lead_field                       =zef_data.h_menu_merge_lead_field;       
zef.h_menu_butterfly_plot                         =zef_data.h_menu_butterfly_plot;
zef.h_menu_find_synthetic_source                  =zef_data.h_menu_find_synthetic_source;   
zef.h_menu_generate_eit_data                      =zef_data.h_menu_generate_eit_data; 
zef.h_menu_mesh_tool                              =zef_data.h_menu_mesh_tool;
zef.h_menu_mesh_visualization_tool                =zef_data.h_menu_mesh_visualization_tool;
zef.h_menu_figure_tool                            =zef_data.h_menu_figure_tool;
zef.h_menu_parcellation_tool                      =zef_data.h_menu_parcellation_tool;                 
zef.h_menu_options                                =zef_data.h_menu_options;
zef.h_menu_close_tools                            =zef_data.h_menu_close_tools;        
zef.h_menu_close_figures                          =zef_data.h_menu_close_figures;        
zef.h_menu_documentation                          =zef_data.h_menu_documentation;       
zef.h_menu_about                                  =zef_data.h_menu_about;

zef.h_menu_lock_sensor_names_on = zef_data.h_menu_lock_sensor_names_on;
zef.h_menu_lock_transforms_on = zef_data.h_menu_lock_transforms_on;
zef.h_menu_add_sensor_sets = zef_data.h_menu_add_sensor_sets;
zef.h_menu_sensor_dat_points = zef_data.h_menu_sensor_dat_points;
zef.h_menu_sensor_dat_directions = zef_data.h_menu_sensor_dat_directions;
zef.h_menu_delete_sensor_sets = zef_data.h_menu_delete_sensor_sets;
zef.h_menu_lock_sensor_sets_on = zef_data.h_menu_lock_sensor_sets_on;
zef.h_menu_add_compartment = zef_data.h_menu_add_compartment;
zef.h_menu_delete_compartment = zef_data.h_menu_delete_compartment;
zef.h_menu_lock_on = zef_data.h_menu_lock_on;
zef.h_menu_stl = zef_data.h_menu_stl;
zef.h_menu_dat_points = zef_data.h_menu_dat_points;
zef.h_menu_dat_triangles = zef_data.h_menu_dat_triangles;

zef.h_menu_add_sensors = zef_data.h_menu_add_sensors;
zef.h_menu_delete_sensors = zef_data.h_menu_delete_sensors;
zef.h_menu_import_sensor_names = zef_data.h_menu_import_sensor_names;
zef.h_menu_add_transform = zef_data.h_menu_add_transform;
zef.h_menu_delete_transform = zef_data.h_menu_delete_transform;

set(zef.h_menu_add_sensors,'MenuSelectedFcn','zef_add_sensor_name;');
set(zef.h_menu_delete_sensors,'MenuSelectedFcn','zef_delete_sensors;');
set(zef.h_menu_import_sensor_names,'MenuSelectedFcn','zef_import_sensor_names;');
set(zef.h_menu_delete_transform,'MenuSelectedFcn','zef_delete_transform;');
set(zef.h_menu_add_transform,'MenuSelectedFcn','zef_add_transform;');

set(zef.h_menu_lock_transforms_on,'MenuSelectedFcn','zef.lock_transforms_on = abs(zef.lock_transforms_on - 1); zef_toggle_lock_transforms_on;');
set(zef.h_menu_lock_sensor_names_on,'MenuSelectedFcn','zef.lock_sensor_names_on = abs(zef.lock_sensor_names_on - 1); zef_toggle_lock_sensor_names_on;');
set(zef.h_menu_lock_sensor_sets_on,'MenuSelectedFcn','zef.lock_sensor_sets_on = abs(zef.lock_sensor_sets_on - 1); zef_toggle_lock_sensor_sets_on;');
set(zef.h_menu_delete_compartment,'MenuSelectedFcn','zef_delete_compartment;');
set(zef.h_menu_sensor_dat_points,'MenuSelectedFcn','zef_get_sensor_points;');
set(zef.h_menu_sensor_dat_directions,'MenuSelectedFcn','zef_get_sensor_directions;');
set(zef.h_menu_add_compartment,'MenuSelectedFcn','zef_add_compartment;');
set(zef.h_menu_add_sensor_sets,'MenuSelectedFcn','zef_add_sensors;');
set(zef.h_menu_delete_sensor_sets,'MenuSelectedFcn','zef_delete_sensor_sets;');
set(zef.h_menu_lock_on,'MenuSelectedFcn','zef.lock_on = abs(zef.lock_on - 1); zef_toggle_lock_on');
set(zef.h_menu_stl,'MenuSelectedFcn','zef.surface_mesh_type = 1; zef.file = 0;[file file_path] = uigetfile(''*.stl'');zef_get_surface_mesh;');
set(zef.h_menu_dat_points,'MenuSelectedFcn','zef.surface_mesh_type = 2; zef.file = 0;[file file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;');
set(zef.h_menu_dat_triangles,'MenuSelectedFcn','zef.surface_mesh_type = 3; zef.file = 0;[file file_path] = uigetfile(''*.dat'');zef_get_surface_mesh;');


set(zef.h_menu_new,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset all?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_start_new_project;end;');
set(zef.h_menu_open,'MenuSelectedFcn','zef_load;');
set(zef.h_menu_save                                  ,'MenuSelectedFcn','zef.save_switch=7;zef_save;zef_update;');
set(zef.h_menu_save_as                               ,'MenuSelectedFcn','zef.save_switch=1;zef_save;zef_update;');
set(zef.h_menu_save_figures_as                        ,'MenuSelectedFcn','zef.save_switch=9;zef_save;zef_update;');
set(zef.h_menu_print_to_file                         ,'MenuSelectedFcn','zef.save_switch=10;zef_save;zef_update;');
set(zef.h_menu_exit                                  ,'MenuSelectedFcn','zef_close_tools; zef_close_figs; close(zef.h_zeffiro_window_main);');
set(zef.h_menu_export_volume_data                    ,'MenuSelectedFcn','zef.save_switch=6;zef_save;zef_update;');
set(zef.h_menu_segmentation_data                     ,'MenuSelectedFcn','zef.save_switch=5;zef_save;zef_update;');
set(zef.h_menu_lead_field                            ,'MenuSelectedFcn','zef.save_switch=2;zef_save;zef_update;');
set(zef.h_menu_source_positions                      ,'MenuSelectedFcn','zef.save_switch=3;zef_save;zef_update;');
set(zef.h_menu_source_directions                     ,'MenuSelectedFcn','zef.save_switch=4;zef_save;zef_update;');
set(zef.h_menu_reconstruction                        ,'MenuSelectedFcn','zef.save_switch=8;zef_save;zef_update;');
set(zef.h_menu_new_segmentation_from_folder          ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import an ASCII segmentation from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef_start_new_project; zef_import_segmentation;zef_build_compartment_table;end;');
set(zef.h_menu_import_segmentation_update_from_folder,'MenuSelectedFcn','zef_import_segmentation;zef_update;');
set(zef.h_menu_import_new_project_from_folder        ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import an ASCII  project from folder?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef_start_new_project; zef_import_project;zef_build_compartment_table;end;');
set(zef.h_menu_import_project_update_from_folder    ,'MenuSelectedFcn','zef_import_project;zef_update;');
set(zef.h_menu_import_volume_data                    ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset and import a new mesh and conductivity?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef_start_new_project;[zef.nodes,zef.tetra,zef.sigma,zef.brain_ind,zef.surface_triangles]=zef_import([]); zef_update_fig_details; zef.import_mode = 1; end;');
set(zef.h_menu_import_measurement_data               ,'MenuSelectedFcn','zef.inv_import_type = 1; zef_inv_import;zef_update;');
set(zef.h_menu_import_noise_data                     ,'MenuSelectedFcn','zef.inv_import_type = 4; zef_inv_import;zef_update;');
set(zef.h_menu_import_reconstruction                 ,'MenuSelectedFcn','zef.inv_import_type = 2; zef_inv_import;zef_update;');
set(zef.h_menu_import_current_pattern                ,'MenuSelectedFcn','zef.inv_import_type = 3; zef_inv_import;zef_update;');
set(zef.h_menu_reset_lead_field                      ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the lead field?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.L = []; end;zef_update;');
set(zef.h_menu_reset_volume_data                     ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset volume data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes'');zef.nodes=[];zef.nodes_b=[];zef.tetra=[];zef.tetra_aux=[];zef.sigma_ind=[];zef.sigma_vec=[];zef.surface_triangles=[];zef.brain_ind=[];zef.source_ind=[];zef.sigma_prisms=[];zef.prisms=[];end;zef_update;');
set(zef.h_menu_reset_measurement_data                ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the measurement data?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.measurements = []; end;zef_update;');
set(zef.h_menu_reset_reconstruction                  ,'MenuSelectedFcn','[zef.yesno] = questdlg(''Reset the reconstruction?'',''Yes'',''No''); if isequal(zef.yesno,''Yes''); zef.reconstruction = []; end;zef_update;');
set(zef.h_menu_merge_lead_field                      ,'MenuSelectedFcn','merge_lead_field;zef_update;');
set(zef.h_menu_butterfly_plot                        ,'MenuSelectedFcn','zef_butterfly_plot;zef_update;');
set(zef.h_menu_find_synthetic_source                 ,'MenuSelectedFcn','find_synthetic_source;zef_update;');
set(zef.h_menu_generate_eit_data                     ,'MenuSelectedFcn','find_synthetic_eit_data;zef_update;');
set(zef.h_menu_mesh_tool                             ,'MenuSelectedFcn','zef_mesh_tool;zef_update;');
set(zef.h_menu_mesh_visualization_tool                             ,'MenuSelectedFcn','zeffiro_interface_mesh_visualization_tool;zef_update;');
set(zef.h_menu_figure_tool                           ,'MenuSelectedFcn','zef_figure_tool;zef_update;');
set(zef.h_menu_parcellation_tool                     ,'MenuSelectedFcn','zef_parcellation_tool;zef_update;');
set(zef.h_menu_options                               ,'MenuSelectedFcn','additional_options;zef_update;');
set(zef.h_menu_close_tools                           ,'MenuSelectedFcn','zef_close_tools;zef_update;');
set(zef.h_menu_close_figures                         ,'MenuSelectedFcn','zef_close_figs;zef_update;');
set(zef.h_menu_documentation                         ,'MenuSelectedFcn','web(''https://github.com/sampsapursiainen/zeffiro_interface/wiki'');zef_update;');
set(zef.h_menu_about                                 ,'MenuSelectedFcn','msgbox([{''Application: ZEFFIRO Forward and inverse interface for EEG/MEG brain imaging.''};{[]}; {''Version: '' num2str(zef.current_version)} ;{[]}; {''Copyright: © 2018- Sampsa Pursiainen.''} ;{[]};{[]}; {''Created using:''} ;{[]}; {''MATLAB. © 1984- The MathWorks, Inc.''};{[]};{[]}],''About'');');
set(zef.h_menu_segmentation_tool                   ,'MenuSelectedFcn','zef_reopen_segmentation_tool;');



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

set(zef.h_zeffiro_window_main,'AutoResizeChildren','off');
zef.zeffiro_window_main_current_size = get(zef.h_zeffiro_window_main,'Position');
zef.zeffiro_window_main_relative_size = zef_get_relative_size(zef.h_zeffiro_window_main);
set(zef.h_zeffiro_window_main,'SizeChangedFcn','zef.zeffiro_window_main_current_size = zef_change_size_function(zef.h_zeffiro_window_main,zef.zeffiro_window_main_current_size,zef.zeffiro_window_main_relative_size);');

zef.h_windows_open = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*','-not','Name','ZEFFIRO Interface: Segmentation tool');
