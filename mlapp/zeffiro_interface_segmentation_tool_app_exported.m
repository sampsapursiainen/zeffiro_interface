classdef zeffiro_interface_segmentation_tool_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        h_zeffiro_window_main           matlab.ui.Figure
        h_menu_project                  matlab.ui.container.Menu
        h_menu_new                      matlab.ui.container.Menu
        h_menu_new_empty                matlab.ui.container.Menu
        h_menu_open                     matlab.ui.container.Menu
        h_menu_open_figure              matlab.ui.container.Menu
        h_menu_save                     matlab.ui.container.Menu
        h_menu_save_as                  matlab.ui.container.Menu
        h_menu_save_figures_as          matlab.ui.container.Menu
        h_menu_print_to_file            matlab.ui.container.Menu
        h_menu_exit                     matlab.ui.container.Menu
        h_menu_export                   matlab.ui.container.Menu
        h_menu_export_volume_data       matlab.ui.container.Menu
        h_menu_export_segmentation_data  matlab.ui.container.Menu
        h_menu_export_lead_field        matlab.ui.container.Menu
        h_menu_export_source_space      matlab.ui.container.Menu
        h_menu_export_sensors           matlab.ui.container.Menu
        h_menu_export_reconstruction    matlab.ui.container.Menu
        h_menu_export_fem_mesh_as       matlab.ui.container.Menu
        h_menu_import                   matlab.ui.container.Menu
        h_menu_new_segmentation_from_folder  matlab.ui.container.Menu
        h_menu_import_segmentation_update_from_folder  matlab.ui.container.Menu
        h_menu_new_segmentation_from_folder_legacy  matlab.ui.container.Menu
        h_menu_import_segmentation_update_from_folder_legacy  matlab.ui.container.Menu
        h_menu_import_new_project_from_folder  matlab.ui.container.Menu
        h_menu_import_project_update_from_folder  matlab.ui.container.Menu
        h_menu_import_volume_data       matlab.ui.container.Menu
        h_menu_import_measurement_data  matlab.ui.container.Menu
        h_menu_import_noise_data        matlab.ui.container.Menu
        h_menu_import_reconstruction    matlab.ui.container.Menu
        h_menu_import_current_pattern   matlab.ui.container.Menu
        h_menu_import_resection_points  matlab.ui.container.Menu
        h_menu_edit                     matlab.ui.container.Menu
        h_menu_reset_lead_field         matlab.ui.container.Menu
        h_menu_reset_volume_data        matlab.ui.container.Menu
        h_menu_reset_measurement_data   matlab.ui.container.Menu
        h_menu_reset_reconstruction     matlab.ui.container.Menu
        h_menu_merge_lead_field         matlab.ui.container.Menu
        h_menu_inverse_tools            matlab.ui.container.Menu
        h_menu_forward_tools            matlab.ui.container.Menu
        h_menu_butterfly_plot           matlab.ui.container.Menu
        h_menu_find_synthetic_source    matlab.ui.container.Menu
        h_menu_generate_eit_data        matlab.ui.container.Menu
        h_menu_multi_tools              matlab.ui.container.Menu
        h_menu_segmentation_tool        matlab.ui.container.Menu
        h_menu_mesh_tool                matlab.ui.container.Menu
        h_menu_mesh_visualization_tool  matlab.ui.container.Menu
        h_menu_figure_tool              matlab.ui.container.Menu
        h_menu_parcellation_tool        matlab.ui.container.Menu
        h_menu_settings                 matlab.ui.container.Menu
        h_menu_options                  matlab.ui.container.Menu
        h_menu_graphics_options         matlab.ui.container.Menu
        h_menu_gaussian_prior_options   matlab.ui.container.Menu
        h_menu_system_settings          matlab.ui.container.Menu
        h_menu_parameter_profile        matlab.ui.container.Menu
        h_menu_segmentation_profile     matlab.ui.container.Menu
        h_menu_init_profile             matlab.ui.container.Menu
        h_menu_plugin_settings          matlab.ui.container.Menu
        h_menu_window                   matlab.ui.container.Menu
        h_menu_window_tools             matlab.ui.container.Menu
        h_menu_maximize_tools           matlab.ui.container.Menu
        h_menu_minimize_tools           matlab.ui.container.Menu
        h_menu_window_tools_tile        matlab.ui.container.Menu
        h_menu_tile_onscreen_tools      matlab.ui.container.Menu
        h_menu_tile_all_tools           matlab.ui.container.Menu
        h_menu_close_tools              matlab.ui.container.Menu
        h_menu_window_figures           matlab.ui.container.Menu
        h_menu_maximize_figures         matlab.ui.container.Menu
        h_menu_minimize_figures         matlab.ui.container.Menu
        h_menu_window_figures_tile      matlab.ui.container.Menu
        h_menu_tile_onscreen_figures    matlab.ui.container.Menu
        h_menu_tile_all_figures         matlab.ui.container.Menu
        h_menu_close_figures            matlab.ui.container.Menu
        h_menu_window_all               matlab.ui.container.Menu
        h_menu_maximize_windows         matlab.ui.container.Menu
        h_menu_minimize_windows         matlab.ui.container.Menu
        h_menu_window_all_tile          matlab.ui.container.Menu
        h_menu_tile_onscreen_windows    matlab.ui.container.Menu
        h_menu_tile_all_windows         matlab.ui.container.Menu
        h_menu_close_windows            matlab.ui.container.Menu
        h_menu_help                     matlab.ui.container.Menu
        h_menu_documentation            matlab.ui.container.Menu
        h_menu_about                    matlab.ui.container.Menu
        h_axes2                         matlab.ui.control.Image
        h_compartment_table             matlab.ui.control.Table
        h_sensors_table                 matlab.ui.control.Table
        h_transform_table               matlab.ui.control.Table
        h_project_information           matlab.ui.control.ListBox
        CompartmentsLabel               matlab.ui.control.Label
        ProjectinformationLabel         matlab.ui.control.Label
        SensorsetsLabel                 matlab.ui.control.Label
        TransformLabel                  matlab.ui.control.Label
        h_parameters_table              matlab.ui.control.Table
        h_sensors_name_table            matlab.ui.control.Table
        SensorsLabel_2                  matlab.ui.control.Label
        ParametersLabel                 matlab.ui.control.Label
        ProjectnotesTextAreaLabel       matlab.ui.control.Label
        h_project_notes                 matlab.ui.control.TextArea
        ProjecttagEditFieldLabel        matlab.ui.control.Label
        h_project_tag                   matlab.ui.control.EditField
        ProfileDropDownLabel            matlab.ui.control.Label
        h_profile_name                  matlab.ui.control.DropDown
        h_menu_compartment_table        matlab.ui.container.ContextMenu
        h_menu_lock_on                  matlab.ui.container.Menu
        h_menu_add_compartment          matlab.ui.container.Menu
        h_menu_delete_compartment       matlab.ui.container.Menu
        h_menu_compartment_surface_mesh  matlab.ui.container.Menu
        h_menu_stl                      matlab.ui.container.Menu
        h_menu_dat_points               matlab.ui.container.Menu
        h_menu_dat_triangles            matlab.ui.container.Menu
        ContextMenu                     matlab.ui.container.ContextMenu
        h_menu_lock_sensor_sets_on      matlab.ui.container.Menu
        h_menu_add_sensor_sets          matlab.ui.container.Menu
        h_menu_delete_sensor_sets       matlab.ui.container.Menu
        ImportsensorsMenu               matlab.ui.container.Menu
        h_menu_sensor_dat_points        matlab.ui.container.Menu
        h_menu_sensor_dat_directions    matlab.ui.container.Menu
        ContextMenu2                    matlab.ui.container.ContextMenu
        h_menu_lock_transforms_on       matlab.ui.container.Menu
        h_menu_add_transform            matlab.ui.container.Menu
        h_menu_delete_transform         matlab.ui.container.Menu
        ContextMenu3                    matlab.ui.container.ContextMenu
        h_menu_lock_sensor_names_on     matlab.ui.container.Menu
        h_menu_add_sensors              matlab.ui.container.Menu
        h_menu_delete_sensors           matlab.ui.container.Menu
        h_menu_import_sensor_names      matlab.ui.container.Menu
    end

    methods (Access = private)
        function local_CreateFcn(app, hObject, eventdata, createfcn, appdata)

            if ~isempty(appdata)
               names = fieldnames(appdata);
               for i=1:length(names)
                   name = char(names(i));
                   setappdata(hObject, name, getfield(appdata,name));
               end
            end

            if ~isempty(createfcn)
               if isa(createfcn,'function_handle')
                   createfcn(hObject, eventdata);
               else
                   eval(createfcn);
               end
            end
        end

    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create h_zeffiro_window_main and hide until all components are created
            app.h_zeffiro_window_main = uifigure('Visible', 'off');
            app.h_zeffiro_window_main.Colormap = [0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0];
            app.h_zeffiro_window_main.Position = [42 157 1151 606];
            app.h_zeffiro_window_main.Name = 'ZEFFIRO Interface: Segmentation tool';
            app.h_zeffiro_window_main.Scrollable = 'on';

            % Create h_menu_project
            app.h_menu_project = uimenu(app.h_zeffiro_window_main);
            app.h_menu_project.Text = 'Project';

            % Create h_menu_new
            app.h_menu_new = uimenu(app.h_menu_project);
            app.h_menu_new.Separator = 'on';
            app.h_menu_new.Text = 'New project from profile';

            % Create h_menu_new_empty
            app.h_menu_new_empty = uimenu(app.h_menu_project);
            app.h_menu_new_empty.Text = 'New empty project';

            % Create h_menu_open
            app.h_menu_open = uimenu(app.h_menu_project);
            app.h_menu_open.Text = 'Open project';

            % Create h_menu_open_figure
            app.h_menu_open_figure = uimenu(app.h_menu_project);
            app.h_menu_open_figure.Text = 'Open figure';

            % Create h_menu_save
            app.h_menu_save = uimenu(app.h_menu_project);
            app.h_menu_save.Text = 'Save';

            % Create h_menu_save_as
            app.h_menu_save_as = uimenu(app.h_menu_project);
            app.h_menu_save_as.Text = 'Save as...';

            % Create h_menu_save_figures_as
            app.h_menu_save_figures_as = uimenu(app.h_menu_project);
            app.h_menu_save_figures_as.Text = 'Save figures as...';

            % Create h_menu_print_to_file
            app.h_menu_print_to_file = uimenu(app.h_menu_project);
            app.h_menu_print_to_file.Text = 'Print figure to file as...';

            % Create h_menu_exit
            app.h_menu_exit = uimenu(app.h_menu_project);
            app.h_menu_exit.Text = 'Exit';

            % Create h_menu_export
            app.h_menu_export = uimenu(app.h_zeffiro_window_main);
            app.h_menu_export.Text = 'Export';

            % Create h_menu_export_volume_data
            app.h_menu_export_volume_data = uimenu(app.h_menu_export);
            app.h_menu_export_volume_data.Text = 'Export volume data';

            % Create h_menu_export_segmentation_data
            app.h_menu_export_segmentation_data = uimenu(app.h_menu_export);
            app.h_menu_export_segmentation_data.Text = 'Export segmentation data';

            % Create h_menu_export_lead_field
            app.h_menu_export_lead_field = uimenu(app.h_menu_export);
            app.h_menu_export_lead_field.Text = 'Export lead field';

            % Create h_menu_export_source_space
            app.h_menu_export_source_space = uimenu(app.h_menu_export);
            app.h_menu_export_source_space.Text = 'Export source space';

            % Create h_menu_export_sensors
            app.h_menu_export_sensors = uimenu(app.h_menu_export);
            app.h_menu_export_sensors.Text = 'Export sensors';

            % Create h_menu_export_reconstruction
            app.h_menu_export_reconstruction = uimenu(app.h_menu_export);
            app.h_menu_export_reconstruction.Text = 'Export reconstruction';

            % Create h_menu_export_fem_mesh_as
            app.h_menu_export_fem_mesh_as = uimenu(app.h_menu_export);
            app.h_menu_export_fem_mesh_as.Text = 'Export FEM mesh';

            % Create h_menu_import
            app.h_menu_import = uimenu(app.h_zeffiro_window_main);
            app.h_menu_import.Text = 'Import';

            % Create h_menu_new_segmentation_from_folder
            app.h_menu_new_segmentation_from_folder = uimenu(app.h_menu_import);
            app.h_menu_new_segmentation_from_folder.Text = 'Import new segmentation from folder';

            % Create h_menu_import_segmentation_update_from_folder
            app.h_menu_import_segmentation_update_from_folder = uimenu(app.h_menu_import);
            app.h_menu_import_segmentation_update_from_folder.Text = 'Import segmentation update from folder';

            % Create h_menu_new_segmentation_from_folder_legacy
            app.h_menu_new_segmentation_from_folder_legacy = uimenu(app.h_menu_import);
            app.h_menu_new_segmentation_from_folder_legacy.Text = 'Import new segmentation from folder (legacy)';

            % Create h_menu_import_segmentation_update_from_folder_legacy
            app.h_menu_import_segmentation_update_from_folder_legacy = uimenu(app.h_menu_import);
            app.h_menu_import_segmentation_update_from_folder_legacy.Text = 'Import segmentation update from folder (legacy)';

            % Create h_menu_import_new_project_from_folder
            app.h_menu_import_new_project_from_folder = uimenu(app.h_menu_import);
            app.h_menu_import_new_project_from_folder.Visible = 'off';
            app.h_menu_import_new_project_from_folder.Text = 'Import new ASCII project from folder';

            % Create h_menu_import_project_update_from_folder
            app.h_menu_import_project_update_from_folder = uimenu(app.h_menu_import);
            app.h_menu_import_project_update_from_folder.Visible = 'off';
            app.h_menu_import_project_update_from_folder.Text = 'Import ASCII project update from folder';

            % Create h_menu_import_volume_data
            app.h_menu_import_volume_data = uimenu(app.h_menu_import);
            app.h_menu_import_volume_data.Visible = 'off';
            app.h_menu_import_volume_data.Text = 'Import volume data';

            % Create h_menu_import_measurement_data
            app.h_menu_import_measurement_data = uimenu(app.h_menu_import);
            app.h_menu_import_measurement_data.Text = 'Import measurement data';

            % Create h_menu_import_noise_data
            app.h_menu_import_noise_data = uimenu(app.h_menu_import);
            app.h_menu_import_noise_data.Text = 'Import noise data';

            % Create h_menu_import_reconstruction
            app.h_menu_import_reconstruction = uimenu(app.h_menu_import);
            app.h_menu_import_reconstruction.Text = 'Import reconstruction';

            % Create h_menu_import_current_pattern
            app.h_menu_import_current_pattern = uimenu(app.h_menu_import);
            app.h_menu_import_current_pattern.Text = 'Import current pattern';

            % Create h_menu_import_resection_points
            app.h_menu_import_resection_points = uimenu(app.h_menu_import);
            app.h_menu_import_resection_points.Text = 'Import resection points';

            % Create h_menu_edit
            app.h_menu_edit = uimenu(app.h_zeffiro_window_main);
            app.h_menu_edit.Text = 'Edit';

            % Create h_menu_reset_lead_field
            app.h_menu_reset_lead_field = uimenu(app.h_menu_edit);
            app.h_menu_reset_lead_field.Text = 'Reset lead field';

            % Create h_menu_reset_volume_data
            app.h_menu_reset_volume_data = uimenu(app.h_menu_edit);
            app.h_menu_reset_volume_data.Text = 'Reset volume data';

            % Create h_menu_reset_measurement_data
            app.h_menu_reset_measurement_data = uimenu(app.h_menu_edit);
            app.h_menu_reset_measurement_data.Text = 'Reset inversion data ';

            % Create h_menu_reset_reconstruction
            app.h_menu_reset_reconstruction = uimenu(app.h_menu_edit);
            app.h_menu_reset_reconstruction.Text = 'Reset reconstruction';

            % Create h_menu_merge_lead_field
            app.h_menu_merge_lead_field = uimenu(app.h_menu_edit);
            app.h_menu_merge_lead_field.Text = 'Merge lead field with...';

            % Create h_menu_inverse_tools
            app.h_menu_inverse_tools = uimenu(app.h_zeffiro_window_main);
            app.h_menu_inverse_tools.Checked = 'on';
            app.h_menu_inverse_tools.Text = 'Inverse tools';

            % Create h_menu_forward_tools
            app.h_menu_forward_tools = uimenu(app.h_zeffiro_window_main);
            app.h_menu_forward_tools.Text = 'Forward tools';

            % Create h_menu_butterfly_plot
            app.h_menu_butterfly_plot = uimenu(app.h_menu_forward_tools);
            app.h_menu_butterfly_plot.Text = 'Butterfly plot';

            % Create h_menu_find_synthetic_source
            app.h_menu_find_synthetic_source = uimenu(app.h_menu_forward_tools);
            app.h_menu_find_synthetic_source.Text = 'Find synthetic source';

            % Create h_menu_generate_eit_data
            app.h_menu_generate_eit_data = uimenu(app.h_menu_forward_tools);
            app.h_menu_generate_eit_data.Text = 'Generate synthetic EIT data';

            % Create h_menu_multi_tools
            app.h_menu_multi_tools = uimenu(app.h_zeffiro_window_main);
            app.h_menu_multi_tools.Text = 'Multi-tools';

            % Create h_menu_segmentation_tool
            app.h_menu_segmentation_tool = uimenu(app.h_menu_multi_tools);
            app.h_menu_segmentation_tool.Text = 'Segmentation tool';

            % Create h_menu_mesh_tool
            app.h_menu_mesh_tool = uimenu(app.h_menu_multi_tools);
            app.h_menu_mesh_tool.Accelerator = '4';
            app.h_menu_mesh_tool.Text = 'Mesh tool';

            % Create h_menu_mesh_visualization_tool
            app.h_menu_mesh_visualization_tool = uimenu(app.h_menu_multi_tools);
            app.h_menu_mesh_visualization_tool.Accelerator = '5';
            app.h_menu_mesh_visualization_tool.Text = 'Mesh visualization tool';

            % Create h_menu_figure_tool
            app.h_menu_figure_tool = uimenu(app.h_menu_multi_tools);
            app.h_menu_figure_tool.Accelerator = '6';
            app.h_menu_figure_tool.Text = 'Figure tool';

            % Create h_menu_parcellation_tool
            app.h_menu_parcellation_tool = uimenu(app.h_menu_multi_tools);
            app.h_menu_parcellation_tool.Accelerator = '7';
            app.h_menu_parcellation_tool.Text = 'Parcellation tool';

            % Create h_menu_settings
            app.h_menu_settings = uimenu(app.h_zeffiro_window_main);
            app.h_menu_settings.Text = 'Settings';

            % Create h_menu_options
            app.h_menu_options = uimenu(app.h_menu_settings);
            app.h_menu_options.Accelerator = '8';
            app.h_menu_options.Text = 'Forward and inverse processing options';

            % Create h_menu_graphics_options
            app.h_menu_graphics_options = uimenu(app.h_menu_settings);
            app.h_menu_graphics_options.Text = 'Graphics processing options';

            % Create h_menu_gaussian_prior_options
            app.h_menu_gaussian_prior_options = uimenu(app.h_menu_settings);
            app.h_menu_gaussian_prior_options.Text = 'Gaussian prior options';

            % Create h_menu_system_settings
            app.h_menu_system_settings = uimenu(app.h_menu_settings);
            app.h_menu_system_settings.Text = 'System settings (zeffiro_interface.ini)';

            % Create h_menu_parameter_profile
            app.h_menu_parameter_profile = uimenu(app.h_menu_settings);
            app.h_menu_parameter_profile.Text = 'Parameter profile';

            % Create h_menu_segmentation_profile
            app.h_menu_segmentation_profile = uimenu(app.h_menu_settings);
            app.h_menu_segmentation_profile.Text = 'Segmentation profile';

            % Create h_menu_init_profile
            app.h_menu_init_profile = uimenu(app.h_menu_settings);
            app.h_menu_init_profile.Text = 'Pre-settings profile';

            % Create h_menu_plugin_settings
            app.h_menu_plugin_settings = uimenu(app.h_menu_settings);
            app.h_menu_plugin_settings.Text = 'Plugin settings';

            % Create h_menu_window
            app.h_menu_window = uimenu(app.h_zeffiro_window_main);
            app.h_menu_window.Text = 'Window';

            % Create h_menu_window_tools
            app.h_menu_window_tools = uimenu(app.h_menu_window);
            app.h_menu_window_tools.Text = 'Tools';

            % Create h_menu_maximize_tools
            app.h_menu_maximize_tools = uimenu(app.h_menu_window_tools);
            app.h_menu_maximize_tools.Text = 'Maximize';

            % Create h_menu_minimize_tools
            app.h_menu_minimize_tools = uimenu(app.h_menu_window_tools);
            app.h_menu_minimize_tools.Text = 'Minimize';

            % Create h_menu_window_tools_tile
            app.h_menu_window_tools_tile = uimenu(app.h_menu_window_tools);
            app.h_menu_window_tools_tile.Text = 'Tile';

            % Create h_menu_tile_onscreen_tools
            app.h_menu_tile_onscreen_tools = uimenu(app.h_menu_window_tools_tile);
            app.h_menu_tile_onscreen_tools.Text = 'On-screen';

            % Create h_menu_tile_all_tools
            app.h_menu_tile_all_tools = uimenu(app.h_menu_window_tools_tile);
            app.h_menu_tile_all_tools.Text = 'All';

            % Create h_menu_close_tools
            app.h_menu_close_tools = uimenu(app.h_menu_window_tools);
            app.h_menu_close_tools.Text = 'Close';

            % Create h_menu_window_figures
            app.h_menu_window_figures = uimenu(app.h_menu_window);
            app.h_menu_window_figures.Text = 'Figures';

            % Create h_menu_maximize_figures
            app.h_menu_maximize_figures = uimenu(app.h_menu_window_figures);
            app.h_menu_maximize_figures.Text = 'Maximize';

            % Create h_menu_minimize_figures
            app.h_menu_minimize_figures = uimenu(app.h_menu_window_figures);
            app.h_menu_minimize_figures.Text = 'Minimize';

            % Create h_menu_window_figures_tile
            app.h_menu_window_figures_tile = uimenu(app.h_menu_window_figures);
            app.h_menu_window_figures_tile.Text = 'Tile';

            % Create h_menu_tile_onscreen_figures
            app.h_menu_tile_onscreen_figures = uimenu(app.h_menu_window_figures_tile);
            app.h_menu_tile_onscreen_figures.Text = 'On-screen';

            % Create h_menu_tile_all_figures
            app.h_menu_tile_all_figures = uimenu(app.h_menu_window_figures_tile);
            app.h_menu_tile_all_figures.Text = 'All';

            % Create h_menu_close_figures
            app.h_menu_close_figures = uimenu(app.h_menu_window_figures);
            app.h_menu_close_figures.Text = 'Close';

            % Create h_menu_window_all
            app.h_menu_window_all = uimenu(app.h_menu_window);
            app.h_menu_window_all.Text = 'All';

            % Create h_menu_maximize_windows
            app.h_menu_maximize_windows = uimenu(app.h_menu_window_all);
            app.h_menu_maximize_windows.Text = 'Maximize';

            % Create h_menu_minimize_windows
            app.h_menu_minimize_windows = uimenu(app.h_menu_window_all);
            app.h_menu_minimize_windows.Text = 'Minimize';

            % Create h_menu_window_all_tile
            app.h_menu_window_all_tile = uimenu(app.h_menu_window_all);
            app.h_menu_window_all_tile.Text = 'Tile';

            % Create h_menu_tile_onscreen_windows
            app.h_menu_tile_onscreen_windows = uimenu(app.h_menu_window_all_tile);
            app.h_menu_tile_onscreen_windows.Text = 'On-screen';

            % Create h_menu_tile_all_windows
            app.h_menu_tile_all_windows = uimenu(app.h_menu_window_all_tile);
            app.h_menu_tile_all_windows.Text = 'All';

            % Create h_menu_close_windows
            app.h_menu_close_windows = uimenu(app.h_menu_window_all);
            app.h_menu_close_windows.Text = 'Close';

            % Create h_menu_help
            app.h_menu_help = uimenu(app.h_zeffiro_window_main);
            app.h_menu_help.Text = 'Help';

            % Create h_menu_documentation
            app.h_menu_documentation = uimenu(app.h_menu_help);
            app.h_menu_documentation.Text = 'Documentation';

            % Create h_menu_about
            app.h_menu_about = uimenu(app.h_menu_help);
            app.h_menu_about.Text = 'About';

            % Create h_axes2
            app.h_axes2 = uiimage(app.h_zeffiro_window_main);
            app.h_axes2.HorizontalAlignment = 'right';
            app.h_axes2.Position = [761 211 153 50];
            app.h_axes2.ImageSource = 'zeffiro_logo.png';

            % Create h_compartment_table
            app.h_compartment_table = uitable(app.h_zeffiro_window_main);
            app.h_compartment_table.ColumnName = {'ID'; 'Name'; 'On'; 'Visible'; 'Merge'; 'Invert normal'; 'Activity'; 'Conductivity'};
            app.h_compartment_table.ColumnWidth = {'fit', 'auto', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
            app.h_compartment_table.RowName = {};
            app.h_compartment_table.ColumnEditable = true;
            app.h_compartment_table.FontSize = 8;
            app.h_compartment_table.Position = [11 142 563 438];

            % Create h_sensors_table
            app.h_sensors_table = uitable(app.h_zeffiro_window_main);
            app.h_sensors_table.ColumnName = {'ID'; 'Name'; 'Modality'; 'On'; 'Visible'; 'Tags'; 'Points'; 'Directions'};
            app.h_sensors_table.ColumnWidth = {'fit', 'auto', 'fit', 'fit', 'fit', 'fit', 'fit', 'fit'};
            app.h_sensors_table.RowName = {};
            app.h_sensors_table.ColumnEditable = [true true true true true true false false];
            app.h_sensors_table.Position = [593 448 321 132];

            % Create h_transform_table
            app.h_transform_table = uitable(app.h_zeffiro_window_main);
            app.h_transform_table.ColumnName = {'ID'; 'Name'};
            app.h_transform_table.ColumnWidth = {'fit', 'auto'};
            app.h_transform_table.RowName = {};
            app.h_transform_table.ColumnEditable = true;
            app.h_transform_table.Position = [593 266 150 153];

            % Create h_project_information
            app.h_project_information = uilistbox(app.h_zeffiro_window_main);
            app.h_project_information.Position = [11 10 563 104];

            % Create CompartmentsLabel
            app.CompartmentsLabel = uilabel(app.h_zeffiro_window_main);
            app.CompartmentsLabel.Position = [11 582 89 22];
            app.CompartmentsLabel.Text = 'Compartments:';

            % Create ProjectinformationLabel
            app.ProjectinformationLabel = uilabel(app.h_zeffiro_window_main);
            app.ProjectinformationLabel.Position = [11 113 110 22];
            app.ProjectinformationLabel.Text = 'Project information:';

            % Create SensorsetsLabel
            app.SensorsetsLabel = uilabel(app.h_zeffiro_window_main);
            app.SensorsetsLabel.Position = [593 583 72 22];
            app.SensorsetsLabel.Text = 'Sensor sets:';

            % Create TransformLabel
            app.TransformLabel = uilabel(app.h_zeffiro_window_main);
            app.TransformLabel.Position = [593 422 47 22];
            app.TransformLabel.Text = 'Transform:';

            % Create h_parameters_table
            app.h_parameters_table = uitable(app.h_zeffiro_window_main);
            app.h_parameters_table.ColumnName = {'Parameter'; 'Value'};
            app.h_parameters_table.ColumnWidth = {'fit', 'auto'};
            app.h_parameters_table.RowName = {};
            app.h_parameters_table.ColumnEditable = [false true];
            app.h_parameters_table.Position = [757 266 157 153];

            % Create h_sensors_name_table
            app.h_sensors_name_table = uitable(app.h_zeffiro_window_main);
            app.h_sensors_name_table.ColumnName = {'ID'; 'Tag'; 'Visible'};
            app.h_sensors_name_table.ColumnWidth = {'fit', 'auto', 'fit'};
            app.h_sensors_name_table.RowName = {};
            app.h_sensors_name_table.ColumnEditable = true;
            app.h_sensors_name_table.Position = [930 10 212 570];

            % Create SensorsLabel_2
            app.SensorsLabel_2 = uilabel(app.h_zeffiro_window_main);
            app.SensorsLabel_2.Position = [930 582 53 22];
            app.SensorsLabel_2.Text = 'Sensors:';

            % Create ParametersLabel
            app.ParametersLabel = uilabel(app.h_zeffiro_window_main);
            app.ParametersLabel.Position = [758 422 85 22];
            app.ParametersLabel.Text = 'Parameters:';

            % Create ProjectnotesTextAreaLabel
            app.ProjectnotesTextAreaLabel = uilabel(app.h_zeffiro_window_main);
            app.ProjectnotesTextAreaLabel.Position = [595 209 80 22];
            app.ProjectnotesTextAreaLabel.Text = 'Project notes:';

            % Create h_project_notes
            app.h_project_notes = uitextarea(app.h_zeffiro_window_main);
            app.h_project_notes.Position = [594 10 321 196];

            % Create ProjecttagEditFieldLabel
            app.ProjecttagEditFieldLabel = uilabel(app.h_zeffiro_window_main);
            app.ProjecttagEditFieldLabel.HorizontalAlignment = 'right';
            app.ProjecttagEditFieldLabel.Position = [402 582 67 22];
            app.ProjecttagEditFieldLabel.Text = 'Project tag:';

            % Create h_project_tag
            app.h_project_tag = uieditfield(app.h_zeffiro_window_main, 'text');
            app.h_project_tag.Position = [474 582 100 22];

            % Create ProfileDropDownLabel
            app.ProfileDropDownLabel = uilabel(app.h_zeffiro_window_main);
            app.ProfileDropDownLabel.HorizontalAlignment = 'right';
            app.ProfileDropDownLabel.Position = [248 582 43 22];
            app.ProfileDropDownLabel.Text = 'Profile:';

            % Create h_profile_name
            app.h_profile_name = uidropdown(app.h_zeffiro_window_main);
            app.h_profile_name.Position = [297 582 100 22];

            % Create h_menu_compartment_table
            app.h_menu_compartment_table = uicontextmenu(app.h_zeffiro_window_main);

            % Assign app.h_menu_compartment_table
            app.h_compartment_table.ContextMenu = app.h_menu_compartment_table;

            % Create h_menu_lock_on
            app.h_menu_lock_on = uimenu(app.h_menu_compartment_table);
            app.h_menu_lock_on.Text = 'Lock on';

            % Create h_menu_add_compartment
            app.h_menu_add_compartment = uimenu(app.h_menu_compartment_table);
            app.h_menu_add_compartment.Text = 'Add compartment';

            % Create h_menu_delete_compartment
            app.h_menu_delete_compartment = uimenu(app.h_menu_compartment_table);
            app.h_menu_delete_compartment.Text = 'Delete compartment(s)';

            % Create h_menu_compartment_surface_mesh
            app.h_menu_compartment_surface_mesh = uimenu(app.h_menu_compartment_table);
            app.h_menu_compartment_surface_mesh.Text = 'Import surface mesh';

            % Create h_menu_stl
            app.h_menu_stl = uimenu(app.h_menu_compartment_surface_mesh);
            app.h_menu_stl.Text = 'Full mesh (STL file)';

            % Create h_menu_dat_points
            app.h_menu_dat_points = uimenu(app.h_menu_compartment_surface_mesh);
            app.h_menu_dat_points.Text = 'Points (DAT file)';

            % Create h_menu_dat_triangles
            app.h_menu_dat_triangles = uimenu(app.h_menu_compartment_surface_mesh);
            app.h_menu_dat_triangles.Text = 'Triangles (DAT file)';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.h_zeffiro_window_main);

            % Assign app.ContextMenu
            app.h_sensors_table.ContextMenu = app.ContextMenu;

            % Create h_menu_lock_sensor_sets_on
            app.h_menu_lock_sensor_sets_on = uimenu(app.ContextMenu);
            app.h_menu_lock_sensor_sets_on.Text = 'Lock on';

            % Create h_menu_add_sensor_sets
            app.h_menu_add_sensor_sets = uimenu(app.ContextMenu);
            app.h_menu_add_sensor_sets.Text = 'Add sensor set';

            % Create h_menu_delete_sensor_sets
            app.h_menu_delete_sensor_sets = uimenu(app.ContextMenu);
            app.h_menu_delete_sensor_sets.Text = 'Delete sensor set(s)';

            % Create ImportsensorsMenu
            app.ImportsensorsMenu = uimenu(app.ContextMenu);
            app.ImportsensorsMenu.Text = 'Import sensors';

            % Create h_menu_sensor_dat_points
            app.h_menu_sensor_dat_points = uimenu(app.ImportsensorsMenu);
            app.h_menu_sensor_dat_points.Text = 'Points (DAT file)';

            % Create h_menu_sensor_dat_directions
            app.h_menu_sensor_dat_directions = uimenu(app.ImportsensorsMenu);
            app.h_menu_sensor_dat_directions.Text = 'Directions (DAT file)';

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.h_zeffiro_window_main);

            % Assign app.ContextMenu2
            app.h_transform_table.ContextMenu = app.ContextMenu2;

            % Create h_menu_lock_transforms_on
            app.h_menu_lock_transforms_on = uimenu(app.ContextMenu2);
            app.h_menu_lock_transforms_on.Text = 'Lock on';

            % Create h_menu_add_transform
            app.h_menu_add_transform = uimenu(app.ContextMenu2);
            app.h_menu_add_transform.Text = 'Add transform';

            % Create h_menu_delete_transform
            app.h_menu_delete_transform = uimenu(app.ContextMenu2);
            app.h_menu_delete_transform.Text = 'Delete transform(s)';

            % Create ContextMenu3
            app.ContextMenu3 = uicontextmenu(app.h_zeffiro_window_main);

            % Assign app.ContextMenu3
            app.h_sensors_name_table.ContextMenu = app.ContextMenu3;

            % Create h_menu_lock_sensor_names_on
            app.h_menu_lock_sensor_names_on = uimenu(app.ContextMenu3);
            app.h_menu_lock_sensor_names_on.Text = 'Lock on';

            % Create h_menu_add_sensors
            app.h_menu_add_sensors = uimenu(app.ContextMenu3);
            app.h_menu_add_sensors.Text = 'Add sensor';

            % Create h_menu_delete_sensors
            app.h_menu_delete_sensors = uimenu(app.ContextMenu3);
            app.h_menu_delete_sensors.Text = 'Delete sensor(s)';

            % Create h_menu_import_sensor_names
            app.h_menu_import_sensor_names = uimenu(app.ContextMenu3);
            app.h_menu_import_sensor_names.Text = 'Import sensor names (DAT file)';

            % Show the figure after all components are created
            app.h_zeffiro_window_main.Visible = 'off';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zeffiro_interface_segmentation_tool_app_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.h_zeffiro_window_main)
            else

                % Focus the running singleton app
                figure(runningApp.h_zeffiro_window_main)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.h_zeffiro_window_main)
        end
    end
end