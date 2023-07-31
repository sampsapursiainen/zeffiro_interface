classdef zef_menu_tool_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        h_zeffiro_menu                  matlab.ui.Figure
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
        ImportelectrodesMenu            matlab.ui.container.Menu
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
        h_menu_reset_windows            matlab.ui.container.Menu
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
        h_menu_logo                     matlab.ui.control.Image
        CheckBox                        matlab.ui.control.CheckBox
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

            % Create h_zeffiro_menu and hide until all components are created
            app.h_zeffiro_menu = uifigure('Visible', 'off');
            colormap(app.h_zeffiro_menu, 'parula');
            app.h_zeffiro_menu.Position = [42 157 796 386];
            app.h_zeffiro_menu.Name = 'ZEFFIRO Interface: Menu tool';
            app.h_zeffiro_menu.Scrollable = 'on';

            % Create h_menu_project
            app.h_menu_project = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_export = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_import = uimenu(app.h_zeffiro_menu);
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

            % Create ImportelectrodesMenu
            app.ImportelectrodesMenu = uimenu(app.h_menu_import);
            app.ImportelectrodesMenu.Text = 'Import electrodes';

            % Create h_menu_edit
            app.h_menu_edit = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_inverse_tools = uimenu(app.h_zeffiro_menu);
            app.h_menu_inverse_tools.Checked = 'on';
            app.h_menu_inverse_tools.Text = 'Inverse tools';

            % Create h_menu_forward_tools
            app.h_menu_forward_tools = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_multi_tools = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_settings = uimenu(app.h_zeffiro_menu);
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
            app.h_menu_window = uimenu(app.h_zeffiro_menu);
            app.h_menu_window.Text = 'Window';

            % Create h_menu_reset_windows
            app.h_menu_reset_windows = uimenu(app.h_menu_window);
            app.h_menu_reset_windows.Text = 'Reset windows';

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
            app.h_menu_help = uimenu(app.h_zeffiro_menu);
            app.h_menu_help.Text = 'Help';

            % Create h_menu_documentation
            app.h_menu_documentation = uimenu(app.h_menu_help);
            app.h_menu_documentation.Text = 'Documentation';

            % Create h_menu_about
            app.h_menu_about = uimenu(app.h_menu_help);
            app.h_menu_about.Text = 'About';

            % Create CheckBox
            app.CheckBox = uicheckbox(app.h_zeffiro_menu);
            app.CheckBox.Visible = 'off';
            app.CheckBox.Position = [43 346 81 22];

            % Create h_menu_logo
            app.h_menu_logo = uiimage(app.h_zeffiro_menu);
            app.h_menu_logo.Position = [18 80 764 229];
            app.h_menu_logo.ImageSource = 'zeffiro_logo_compass.png';

            % Show the figure after all components are created
            app.h_zeffiro_menu.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zef_menu_tool_app_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.h_zeffiro_menu)
            else

                % Focus the running singleton app
                figure(runningApp.h_zeffiro_menu)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.h_zeffiro_menu)
        end
    end
end