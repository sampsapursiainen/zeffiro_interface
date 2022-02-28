classdef zeffiro_interface_mesh_tool_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        h_mesh_tool                   matlab.ui.Figure
        h_pushbutton21                matlab.ui.control.Button
        h_run_forward_simulation      matlab.ui.control.Button
        h_interpolate                 matlab.ui.control.Button
        h_field_downsampling          matlab.ui.control.Button
        h_surface_downsampling        matlab.ui.control.Button
        h_checkbox_mesh_smoothing_on  matlab.ui.control.CheckBox
        h_refinement_on               matlab.ui.control.CheckBox
        h_source_interpolation_on     matlab.ui.control.CheckBox
        h_downsample_surfaces         matlab.ui.control.CheckBox
        SurfacetrianglesmaxLabel      matlab.ui.control.Label
        CuttingplanecoeffEditFieldLabel_4  matlab.ui.control.Label
        CuttingplanecoeffEditFieldLabel_5  matlab.ui.control.Label
        CuttingplanecoeffEditFieldLabel_6  matlab.ui.control.Label
        CuttingplanecoeffEditFieldLabel_7  matlab.ui.control.Label
        UnitLabel                     matlab.ui.control.Label
        h_popupmenu6                  matlab.ui.control.DropDown
        DirectionsDropDownLabel       matlab.ui.control.Label
        h_popupmenu2                  matlab.ui.control.DropDown
        CuttingplanecoeffEditFieldLabel_8  matlab.ui.control.Label
        h_edit65                      matlab.ui.control.NumericEditField
        h_edit_meshing_accuracy       matlab.ui.control.NumericEditField
        h_smoothing_strength          matlab.ui.control.NumericEditField
        h_edit76                      matlab.ui.control.NumericEditField
        h_edit75                      matlab.ui.control.NumericEditField
        h_max_surface_face_count      matlab.ui.control.NumericEditField
        h_pushbutton23                matlab.ui.control.Button
        h_pushbutton34                matlab.ui.control.Button
        InflatingiterationsLabel      matlab.ui.control.Label
        CuttingplanecoeffEditFieldLabel_9  matlab.ui.control.Label
        h_inflate_strength            matlab.ui.control.NumericEditField
        h_inflate_n_iterations        matlab.ui.control.NumericEditField
        h_forward_simulation_table    matlab.ui.control.Table
        h_save_forward_simulation_profile  matlab.ui.control.Button
        h_forward_simulation_script   matlab.ui.control.TextArea
        h_forward_simulation_update_from_profile  matlab.ui.control.Button
        h_menu_forward_simulation_table_context  matlab.ui.container.ContextMenu
        h_menu_forward_simulation_table_add  matlab.ui.container.Menu
        h_menu_forward_simulation_table_delete  matlab.ui.container.Menu
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create h_mesh_tool and hide until all components are created
            app.h_mesh_tool = uifigure('Visible', 'off');
            app.h_mesh_tool.Position = [1000 200 719 367];
            app.h_mesh_tool.Name = 'ZEFFIRO Interface: Mesh tool';

            % Create h_pushbutton21
            app.h_pushbutton21 = uibutton(app.h_mesh_tool, 'push');
            app.h_pushbutton21.Position = [17 319 165 39];
            app.h_pushbutton21.Text = {'Create'; 'FEM mesh'};

            % Create h_run_forward_simulation
            app.h_run_forward_simulation = uibutton(app.h_mesh_tool, 'push');
            app.h_run_forward_simulation.Position = [599 17 105 39];
            app.h_run_forward_simulation.Text = 'Run script';

            % Create h_interpolate
            app.h_interpolate = uibutton(app.h_mesh_tool, 'push');
            app.h_interpolate.Position = [16 227 165 39];
            app.h_interpolate.Text = 'Source interpolation';

            % Create h_field_downsampling
            app.h_field_downsampling = uibutton(app.h_mesh_tool, 'push');
            app.h_field_downsampling.Position = [16 273 165 39];
            app.h_field_downsampling.Text = 'Downsample field';

            % Create h_surface_downsampling
            app.h_surface_downsampling = uibutton(app.h_mesh_tool, 'push');
            app.h_surface_downsampling.Position = [190 273 165 39];
            app.h_surface_downsampling.Text = 'Downsample surfaces';

            % Create h_checkbox_mesh_smoothing_on
            app.h_checkbox_mesh_smoothing_on = uicheckbox(app.h_mesh_tool);
            app.h_checkbox_mesh_smoothing_on.Text = 'Mesh smoothing';
            app.h_checkbox_mesh_smoothing_on.Position = [192 174 164 22];

            % Create h_refinement_on
            app.h_refinement_on = uicheckbox(app.h_mesh_tool);
            app.h_refinement_on.Text = 'Refinement';
            app.h_refinement_on.Position = [20 174 102 22];

            % Create h_source_interpolation_on
            app.h_source_interpolation_on = uicheckbox(app.h_mesh_tool);
            app.h_source_interpolation_on.Text = 'LF source interp.';
            app.h_source_interpolation_on.Position = [20 198 161 22];

            % Create h_downsample_surfaces
            app.h_downsample_surfaces = uicheckbox(app.h_mesh_tool);
            app.h_downsample_surfaces.Text = 'Downsample surf.';
            app.h_downsample_surfaces.Position = [192 198 163 22];

            % Create SurfacetrianglesmaxLabel
            app.SurfacetrianglesmaxLabel = uilabel(app.h_mesh_tool);
            app.SurfacetrianglesmaxLabel.Position = [20 93 102 22];
            app.SurfacetrianglesmaxLabel.Text = 'Surface triangles max.:';

            % Create CuttingplanecoeffEditFieldLabel_4
            app.CuttingplanecoeffEditFieldLabel_4 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_4.Position = [131 144 100 22];
            app.CuttingplanecoeffEditFieldLabel_4.Text = 'Mesh resolution:';

            % Create CuttingplanecoeffEditFieldLabel_5
            app.CuttingplanecoeffEditFieldLabel_5 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_5.Position = [245 144 87 22];
            app.CuttingplanecoeffEditFieldLabel_5.Text = 'Meshing accuracy:';

            % Create CuttingplanecoeffEditFieldLabel_6
            app.CuttingplanecoeffEditFieldLabel_6 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_6.Position = [20 144 85 22];
            app.CuttingplanecoeffEditFieldLabel_6.Text = 'Source/Field count:';

            % Create CuttingplanecoeffEditFieldLabel_7
            app.CuttingplanecoeffEditFieldLabel_7 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_7.Position = [131 93 89 22];
            app.CuttingplanecoeffEditFieldLabel_7.Text = 'Smoothing strength:';

            % Create UnitLabel
            app.UnitLabel = uilabel(app.h_mesh_tool);
            app.UnitLabel.Visible = 'off';
            app.UnitLabel.Position = [245 175 47 22];
            app.UnitLabel.Text = 'Unit:';

            % Create h_popupmenu6
            app.h_popupmenu6 = uidropdown(app.h_mesh_tool);
            app.h_popupmenu6.Visible = 'off';
            app.h_popupmenu6.Position = [298 174 49 22];

            % Create DirectionsDropDownLabel
            app.DirectionsDropDownLabel = uilabel(app.h_mesh_tool);
            app.DirectionsDropDownLabel.Position = [245 40 111 22];
            app.DirectionsDropDownLabel.Text = 'Directions:';

            % Create h_popupmenu2
            app.h_popupmenu2 = uidropdown(app.h_mesh_tool);
            app.h_popupmenu2.Position = [265 17 82 22];

            % Create CuttingplanecoeffEditFieldLabel_8
            app.CuttingplanecoeffEditFieldLabel_8 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_8.Position = [245 93 110 22];
            app.CuttingplanecoeffEditFieldLabel_8.Text = 'Solver tolerance:';

            % Create h_edit65
            app.h_edit65 = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_edit65.Position = [186 118 50 22];

            % Create h_edit_meshing_accuracy
            app.h_edit_meshing_accuracy = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_edit_meshing_accuracy.Position = [297 117 50 22];

            % Create h_smoothing_strength
            app.h_smoothing_strength = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_smoothing_strength.Position = [186 66 50 22];

            % Create h_edit76
            app.h_edit76 = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_edit76.Position = [297 65 50 22];

            % Create h_edit75
            app.h_edit75 = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_edit75.Position = [75 119 50 22];

            % Create h_max_surface_face_count
            app.h_max_surface_face_count = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_max_surface_face_count.Position = [75 67 50 22];

            % Create h_pushbutton23
            app.h_pushbutton23 = uibutton(app.h_mesh_tool, 'push');
            app.h_pushbutton23.Position = [190 227 165 39];
            app.h_pushbutton23.Text = 'Apply transform';

            % Create h_pushbutton34
            app.h_pushbutton34 = uibutton(app.h_mesh_tool, 'push');
            app.h_pushbutton34.Position = [191 319 165 39];
            app.h_pushbutton34.Text = {'Postprocess'; 'FEM mesh'};

            % Create InflatingiterationsLabel
            app.InflatingiterationsLabel = uilabel(app.h_mesh_tool);
            app.InflatingiterationsLabel.Position = [21 40 104 22];
            app.InflatingiterationsLabel.Text = 'Inflating iterations:';

            % Create CuttingplanecoeffEditFieldLabel_9
            app.CuttingplanecoeffEditFieldLabel_9 = uilabel(app.h_mesh_tool);
            app.CuttingplanecoeffEditFieldLabel_9.Position = [132 40 99 22];
            app.CuttingplanecoeffEditFieldLabel_9.Text = 'Inflating strength:';

            % Create h_inflate_strength
            app.h_inflate_strength = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_inflate_strength.Position = [186 15 50 22];

            % Create h_inflate_n_iterations
            app.h_inflate_n_iterations = uieditfield(app.h_mesh_tool, 'numeric');
            app.h_inflate_n_iterations.Position = [75 15 50 22];

            % Create h_forward_simulation_table
            app.h_forward_simulation_table = uitable(app.h_mesh_tool);
            app.h_forward_simulation_table.ColumnName = {'Name'; 'Description'; 'Script'};
            app.h_forward_simulation_table.RowName = {};
            app.h_forward_simulation_table.ColumnSortable = true;
            app.h_forward_simulation_table.ColumnEditable = true;
            app.h_forward_simulation_table.Position = [366 175 338 183];

            % Create h_save_forward_simulation_profile
            app.h_save_forward_simulation_profile = uibutton(app.h_mesh_tool, 'push');
            app.h_save_forward_simulation_profile.Position = [366 17 105 39];
            app.h_save_forward_simulation_profile.Text = 'Save profile';

            % Create h_forward_simulation_script
            app.h_forward_simulation_script = uitextarea(app.h_mesh_tool);
            app.h_forward_simulation_script.Position = [366 65 338 101];

            % Create h_forward_simulation_update_from_profile
            app.h_forward_simulation_update_from_profile = uibutton(app.h_mesh_tool, 'push');
            app.h_forward_simulation_update_from_profile.Position = [483 17 105 39];
            app.h_forward_simulation_update_from_profile.Text = {'Update from'; 'profile'};

            % Create h_menu_forward_simulation_table_context
            app.h_menu_forward_simulation_table_context = uicontextmenu(app.h_mesh_tool);

            % Assign app.h_menu_forward_simulation_table_context
            app.h_forward_simulation_table.ContextMenu = app.h_menu_forward_simulation_table_context;

            % Create h_menu_forward_simulation_table_add
            app.h_menu_forward_simulation_table_add = uimenu(app.h_menu_forward_simulation_table_context);
            app.h_menu_forward_simulation_table_add.Text = 'Add';

            % Create h_menu_forward_simulation_table_delete
            app.h_menu_forward_simulation_table_delete = uimenu(app.h_menu_forward_simulation_table_context);
            app.h_menu_forward_simulation_table_delete.Text = 'Delete';

            % Show the figure after all components are created
            app.h_mesh_tool.Visible = 'off';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zeffiro_interface_mesh_tool_app_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.h_mesh_tool)
            else

                % Focus the running singleton app
                figure(runningApp.h_mesh_tool)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.h_mesh_tool)
        end
    end
end