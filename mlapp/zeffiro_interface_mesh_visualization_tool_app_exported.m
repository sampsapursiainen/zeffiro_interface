classdef zeffiro_interface_mesh_visualization_tool_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        h_mesh_visualization_tool       matlab.ui.Figure
        h_pushbutton31                  matlab.ui.control.Button
        h_pushbutton20                  matlab.ui.control.Button
        h_pushbutton22                  matlab.ui.control.Button
        h_checkbox14                    matlab.ui.control.CheckBox
        h_checkbox15                    matlab.ui.control.CheckBox
        CuttingplanecoeffEditFieldLabel  matlab.ui.control.Label
        h_edit80                        matlab.ui.control.NumericEditField
        h_edit81                        matlab.ui.control.NumericEditField
        h_edit82                        matlab.ui.control.NumericEditField
        CuttingplanecoeffEditFieldLabel_2  matlab.ui.control.Label
        h_visualization_type            matlab.ui.control.DropDown
        h_frame_start                   matlab.ui.control.EditField
        h_frame_stop                    matlab.ui.control.EditField
        h_frame_step                    matlab.ui.control.EditField
        PlotcolormapDropDownLabel       matlab.ui.control.Label
        h_orbit                         matlab.ui.control.EditField
        h_orbit_2                       matlab.ui.control.EditField
        h_cp2_on                        matlab.ui.control.CheckBox
        h_cp2_a                         matlab.ui.control.EditField
        h_cp3_on                        matlab.ui.control.CheckBox
        h_cp2_b                         matlab.ui.control.EditField
        h_cp2_c                         matlab.ui.control.EditField
        h_cp2_d                         matlab.ui.control.EditField
        h_cp3_a                         matlab.ui.control.EditField
        h_cp3_b                         matlab.ui.control.EditField
        h_cp3_c                         matlab.ui.control.EditField
        h_cp3_d                         matlab.ui.control.EditField
        h_layer_transparency            matlab.ui.control.EditField
        h_reconstruction_type           matlab.ui.control.DropDown
        RotationspeeddegsEditFieldLabel  matlab.ui.control.Label
        h_checkbox_cp_on                matlab.ui.control.CheckBox
        h_edit_cp_a                     matlab.ui.control.EditField
        h_edit_cp_b                     matlab.ui.control.EditField
        h_edit_cp_c                     matlab.ui.control.EditField
        h_edit_cp_d                     matlab.ui.control.EditField
        RotationspeeddegsEditFieldLabel_2  matlab.ui.control.Label
        RotationspeeddegsLabel          matlab.ui.control.Label
        h_inv_scale                     matlab.ui.control.DropDown
        h_inv_colormap                  matlab.ui.control.DropDown
        h_cp_mode                       matlab.ui.control.DropDown
        h_brain_transparency            matlab.ui.control.EditField
        h_inv_dynamic_range             matlab.ui.control.EditField
        h_submesh_num                   matlab.ui.control.EditField
        CuttingplanemodeLabel           matlab.ui.control.Label
        TransparencyrecsurfLabel        matlab.ui.control.Label
        PlotthresholdLabel              matlab.ui.control.Label
        DistributionmodeLabel           matlab.ui.control.Label
        PlotscaleLabel                  matlab.ui.control.Label
        ColormapLabel                   matlab.ui.control.Label
        h_use_inflated_surfaces         matlab.ui.control.CheckBox
        h_explode_everything            matlab.ui.control.NumericEditField
        h_cone_draw                     matlab.ui.control.CheckBox
        h_streamline_draw               matlab.ui.control.CheckBox
        h_volumetric_distribution_mode  matlab.ui.control.DropDown
        SubmeshLabel                    matlab.ui.control.Label
        h_axes_popup                    matlab.ui.control.Button
        ParameterListBoxLabel           matlab.ui.control.Label
        h_mesh_visualization_parameter_list  matlab.ui.control.ListBox
        GraphLabel                      matlab.ui.control.Label
        h_mesh_visualization_graph_list  matlab.ui.control.ListBox
        h_plot_graph                    matlab.ui.control.Button
        h_show_contour_text             matlab.ui.control.CheckBox
        h_show_contour                  matlab.ui.control.CheckBox
        h_contour_set_text              matlab.ui.control.EditField
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create h_mesh_visualization_tool and hide until all components are created
            app.h_mesh_visualization_tool = uifigure('Visible', 'off');
            app.h_mesh_visualization_tool.Position = [1000 700 349 606];
            app.h_mesh_visualization_tool.Name = 'ZEFFIRO Interface: Mesh visualization tool';

            % Create h_pushbutton31
            app.h_pushbutton31 = uibutton(app.h_mesh_visualization_tool, 'push');
            app.h_pushbutton31.Position = [12 567 158 30];
            app.h_pushbutton31.Text = 'Visualize volume';

            % Create h_pushbutton20
            app.h_pushbutton20 = uibutton(app.h_mesh_visualization_tool, 'push');
            app.h_pushbutton20.Position = [181 567 156 30];
            app.h_pushbutton20.Text = 'Visualize surfaces';

            % Create h_pushbutton22
            app.h_pushbutton22 = uibutton(app.h_mesh_visualization_tool, 'push');
            app.h_pushbutton22.Position = [12 531 158 30];
            app.h_pushbutton22.Text = 'Frame / Movie';

            % Create h_checkbox14
            app.h_checkbox14 = uicheckbox(app.h_mesh_visualization_tool);
            app.h_checkbox14.Text = 'Attach electrodes';
            app.h_checkbox14.Position = [12 500 104 22];

            % Create h_checkbox15
            app.h_checkbox15 = uicheckbox(app.h_mesh_visualization_tool);
            app.h_checkbox15.Text = 'Axes box';
            app.h_checkbox15.Position = [125 412 103 22];

            % Create CuttingplanecoeffEditFieldLabel
            app.CuttingplanecoeffEditFieldLabel = uilabel(app.h_mesh_visualization_tool);
            app.CuttingplanecoeffEditFieldLabel.Position = [125 253 96 22];
            app.CuttingplanecoeffEditFieldLabel.Text = 'Orientation (degrees):';

            % Create h_edit80
            app.h_edit80 = uieditfield(app.h_mesh_visualization_tool, 'numeric');
            app.h_edit80.Position = [168 227 26 22];

            % Create h_edit81
            app.h_edit81 = uieditfield(app.h_mesh_visualization_tool, 'numeric');
            app.h_edit81.Position = [201 227 26 22];

            % Create h_edit82
            app.h_edit82 = uieditfield(app.h_mesh_visualization_tool, 'numeric');
            app.h_edit82.Position = [276 278 26 22];

            % Create CuttingplanecoeffEditFieldLabel_2
            app.CuttingplanecoeffEditFieldLabel_2 = uilabel(app.h_mesh_visualization_tool);
            app.CuttingplanecoeffEditFieldLabel_2.Position = [239 303 98 22];
            app.CuttingplanecoeffEditFieldLabel_2.Text = 'Distance / Explode:';

            % Create h_visualization_type
            app.h_visualization_type = uidropdown(app.h_mesh_visualization_tool);
            app.h_visualization_type.Position = [42 278 75 22];

            % Create h_frame_start
            app.h_frame_start = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_frame_start.HorizontalAlignment = 'right';
            app.h_frame_start.Position = [136 278 26 22];

            % Create h_frame_stop
            app.h_frame_stop = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_frame_stop.HorizontalAlignment = 'right';
            app.h_frame_stop.Position = [169 278 26 22];

            % Create h_frame_step
            app.h_frame_step = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_frame_step.HorizontalAlignment = 'right';
            app.h_frame_step.Position = [201 278 26 22];

            % Create PlotcolormapDropDownLabel
            app.PlotcolormapDropDownLabel = uilabel(app.h_mesh_visualization_tool);
            app.PlotcolormapDropDownLabel.Position = [125 303 106 22];
            app.PlotcolormapDropDownLabel.Text = 'Frame start, stop, step:';

            % Create h_orbit
            app.h_orbit = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_orbit.HorizontalAlignment = 'right';
            app.h_orbit.Position = [311 328 26 22];

            % Create h_orbit_2
            app.h_orbit_2 = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_orbit_2.HorizontalAlignment = 'right';
            app.h_orbit_2.Position = [276 328 26 22];

            % Create h_cp2_on
            app.h_cp2_on = uicheckbox(app.h_mesh_visualization_tool);
            app.h_cp2_on.Text = 'Clipping plane 2:';
            app.h_cp2_on.Position = [125 470 117 22];

            % Create h_cp2_a
            app.h_cp2_a = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp2_a.HorizontalAlignment = 'right';
            app.h_cp2_a.Position = [239 470 16 22];

            % Create h_cp3_on
            app.h_cp3_on = uicheckbox(app.h_mesh_visualization_tool);
            app.h_cp3_on.Text = 'Clipping plane 3:';
            app.h_cp3_on.Position = [125 441 117 22];

            % Create h_cp2_b
            app.h_cp2_b = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp2_b.HorizontalAlignment = 'right';
            app.h_cp2_b.Position = [259 470 16 22];

            % Create h_cp2_c
            app.h_cp2_c = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp2_c.HorizontalAlignment = 'right';
            app.h_cp2_c.Position = [279 470 16 22];

            % Create h_cp2_d
            app.h_cp2_d = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp2_d.HorizontalAlignment = 'right';
            app.h_cp2_d.Position = [301 470 36 22];

            % Create h_cp3_a
            app.h_cp3_a = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp3_a.HorizontalAlignment = 'right';
            app.h_cp3_a.Position = [239 441 16 22];

            % Create h_cp3_b
            app.h_cp3_b = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp3_b.HorizontalAlignment = 'right';
            app.h_cp3_b.Position = [259 441 16 22];

            % Create h_cp3_c
            app.h_cp3_c = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp3_c.HorizontalAlignment = 'right';
            app.h_cp3_c.Position = [279 441 16 22];

            % Create h_cp3_d
            app.h_cp3_d = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_cp3_d.HorizontalAlignment = 'right';
            app.h_cp3_d.Position = [301 441 36 22];

            % Create h_layer_transparency
            app.h_layer_transparency = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_layer_transparency.HorizontalAlignment = 'right';
            app.h_layer_transparency.Position = [311 227 26 22];

            % Create h_reconstruction_type
            app.h_reconstruction_type = uidropdown(app.h_mesh_visualization_tool);
            app.h_reconstruction_type.Items = {'Amplitude', 'Normal', 'Tangential', 'Normal constraint (-)', 'Normal constraint (+)', 'Value', 'Amplitude smoothed'};
            app.h_reconstruction_type.ItemsData = {'1', '2', '3', '4', '5', '6', '7'};
            app.h_reconstruction_type.Position = [42 328 75 22];
            app.h_reconstruction_type.Value = '1';

            % Create RotationspeeddegsEditFieldLabel
            app.RotationspeeddegsEditFieldLabel = uilabel(app.h_mesh_visualization_tool);
            app.RotationspeeddegsEditFieldLabel.Position = [12 353 86 22];
            app.RotationspeeddegsEditFieldLabel.Text = 'Reconstrution type:';

            % Create h_checkbox_cp_on
            app.h_checkbox_cp_on = uicheckbox(app.h_mesh_visualization_tool);
            app.h_checkbox_cp_on.Text = 'Clipping plane 1:';
            app.h_checkbox_cp_on.Position = [125 500 117 22];

            % Create h_edit_cp_a
            app.h_edit_cp_a = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_edit_cp_a.HorizontalAlignment = 'right';
            app.h_edit_cp_a.Position = [239 500 16 22];

            % Create h_edit_cp_b
            app.h_edit_cp_b = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_edit_cp_b.HorizontalAlignment = 'right';
            app.h_edit_cp_b.Position = [259 500 16 22];

            % Create h_edit_cp_c
            app.h_edit_cp_c = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_edit_cp_c.HorizontalAlignment = 'right';
            app.h_edit_cp_c.Position = [279 500 16 22];

            % Create h_edit_cp_d
            app.h_edit_cp_d = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_edit_cp_d.HorizontalAlignment = 'right';
            app.h_edit_cp_d.Position = [301 500 36 22];

            % Create RotationspeeddegsEditFieldLabel_2
            app.RotationspeeddegsEditFieldLabel_2 = uilabel(app.h_mesh_visualization_tool);
            app.RotationspeeddegsEditFieldLabel_2.Position = [12 303 86 22];
            app.RotationspeeddegsEditFieldLabel_2.Text = 'Visualization type:';

            % Create RotationspeeddegsLabel
            app.RotationspeeddegsLabel = uilabel(app.h_mesh_visualization_tool);
            app.RotationspeeddegsLabel.Position = [239 353 98 22];
            app.RotationspeeddegsLabel.Text = 'Rotation speed (deg/s):';

            % Create h_inv_scale
            app.h_inv_scale = uidropdown(app.h_mesh_visualization_tool);
            app.h_inv_scale.Items = {'Logarithmic', 'Linear', 'Square root'};
            app.h_inv_scale.ItemsData = {'1', '2', '3'};
            app.h_inv_scale.Position = [42 182 75 22];
            app.h_inv_scale.Value = '1';

            % Create h_inv_colormap
            app.h_inv_colormap = uidropdown(app.h_mesh_visualization_tool);
            app.h_inv_colormap.Items = {'Monterosso', 'Intensity I', 'Intensity II', 'Intensity III', 'Contrast I', 'Contrast II', 'Contrast III', 'Contrast IV', 'Contrast V', 'Blue brain I', 'Blue brain II', 'Blue brain III', 'Parcellation'};
            app.h_inv_colormap.ItemsData = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'};
            app.h_inv_colormap.Position = [155 182 75 22];
            app.h_inv_colormap.Value = '1';

            % Create h_cp_mode
            app.h_cp_mode = uidropdown(app.h_mesh_visualization_tool);
            app.h_cp_mode.Items = {'Cut out', 'Cut in', 'Cut out & whole brain', 'Cut in & whole brain'};
            app.h_cp_mode.ItemsData = {'1', '2', '3', '4'};
            app.h_cp_mode.Position = [42 227 75 22];
            app.h_cp_mode.Value = '1';

            % Create h_brain_transparency
            app.h_brain_transparency = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_brain_transparency.HorizontalAlignment = 'right';
            app.h_brain_transparency.Position = [276 227 26 22];

            % Create h_inv_dynamic_range
            app.h_inv_dynamic_range = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_inv_dynamic_range.HorizontalAlignment = 'right';
            app.h_inv_dynamic_range.Position = [276 182 61 22];

            % Create h_submesh_num
            app.h_submesh_num = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_submesh_num.HorizontalAlignment = 'right';
            app.h_submesh_num.Position = [311 412 26 22];

            % Create CuttingplanemodeLabel
            app.CuttingplanemodeLabel = uilabel(app.h_mesh_visualization_tool);
            app.CuttingplanemodeLabel.Position = [12 253 91 22];
            app.CuttingplanemodeLabel.Text = 'Cutting plane mode:';

            % Create TransparencyrecsurfLabel
            app.TransparencyrecsurfLabel = uilabel(app.h_mesh_visualization_tool);
            app.TransparencyrecsurfLabel.Position = [239 253 98 22];
            app.TransparencyrecsurfLabel.Text = 'Transparency rec./surf.:';

            % Create PlotthresholdLabel
            app.PlotthresholdLabel = uilabel(app.h_mesh_visualization_tool);
            app.PlotthresholdLabel.Position = [239 205 98 22];
            app.PlotthresholdLabel.Text = 'Plot threshold:';

            % Create DistributionmodeLabel
            app.DistributionmodeLabel = uilabel(app.h_mesh_visualization_tool);
            app.DistributionmodeLabel.Position = [125 353 104 22];
            app.DistributionmodeLabel.Text = 'Distribution mode:';

            % Create PlotscaleLabel
            app.PlotscaleLabel = uilabel(app.h_mesh_visualization_tool);
            app.PlotscaleLabel.Position = [12 205 37 22];
            app.PlotscaleLabel.Text = 'Plot scale:';

            % Create ColormapLabel
            app.ColormapLabel = uilabel(app.h_mesh_visualization_tool);
            app.ColormapLabel.Position = [125 205 38 22];
            app.ColormapLabel.Text = 'Colormap:';

            % Create h_use_inflated_surfaces
            app.h_use_inflated_surfaces = uicheckbox(app.h_mesh_visualization_tool);
            app.h_use_inflated_surfaces.Text = 'Use inflated surfaces';
            app.h_use_inflated_surfaces.Position = [12 470 105 22];

            % Create h_explode_everything
            app.h_explode_everything = uieditfield(app.h_mesh_visualization_tool, 'numeric');
            app.h_explode_everything.Position = [311 278 26 22];

            % Create h_cone_draw
            app.h_cone_draw = uicheckbox(app.h_mesh_visualization_tool);
            app.h_cone_draw.Text = 'Cone field';
            app.h_cone_draw.Position = [12 441 105 22];

            % Create h_streamline_draw
            app.h_streamline_draw = uicheckbox(app.h_mesh_visualization_tool);
            app.h_streamline_draw.Text = 'Streamlines';
            app.h_streamline_draw.Position = [12 412 85 22];

            % Create h_volumetric_distribution_mode
            app.h_volumetric_distribution_mode = uidropdown(app.h_mesh_visualization_tool);
            app.h_volumetric_distribution_mode.Items = {'Point-wise', 'Element-wise', ''};
            app.h_volumetric_distribution_mode.ItemsData = {'1', '2'};
            app.h_volumetric_distribution_mode.Position = [156 328 75 22];
            app.h_volumetric_distribution_mode.Value = '1';

            % Create SubmeshLabel
            app.SubmeshLabel = uilabel(app.h_mesh_visualization_tool);
            app.SubmeshLabel.Position = [239 412 58 22];
            app.SubmeshLabel.Text = 'Submesh:';

            % Create h_axes_popup
            app.h_axes_popup = uibutton(app.h_mesh_visualization_tool, 'push');
            app.h_axes_popup.Position = [181 531 156 30];
            app.h_axes_popup.Text = 'Axes pop-up';

            % Create ParameterListBoxLabel
            app.ParameterListBoxLabel = uilabel(app.h_mesh_visualization_tool);
            app.ParameterListBoxLabel.Position = [12 153 64 22];
            app.ParameterListBoxLabel.Text = 'Parameter:';

            % Create h_mesh_visualization_parameter_list
            app.h_mesh_visualization_parameter_list = uilistbox(app.h_mesh_visualization_tool);
            app.h_mesh_visualization_parameter_list.Position = [12 52 160 99];

            % Create GraphLabel
            app.GraphLabel = uilabel(app.h_mesh_visualization_tool);
            app.GraphLabel.Position = [176 153 42 22];
            app.GraphLabel.Text = 'Graph:';

            % Create h_mesh_visualization_graph_list
            app.h_mesh_visualization_graph_list = uilistbox(app.h_mesh_visualization_tool);
            app.h_mesh_visualization_graph_list.Position = [176 52 160 99];

            % Create h_plot_graph
            app.h_plot_graph = uibutton(app.h_mesh_visualization_tool, 'push');
            app.h_plot_graph.Position = [178 13 156 30];
            app.h_plot_graph.Text = 'Plot graph';

            % Create h_show_contour_text
            app.h_show_contour_text = uicheckbox(app.h_mesh_visualization_tool);
            app.h_show_contour_text.Text = 'Contour labels';
            app.h_show_contour_text.Position = [12 383 100 22];

            % Create h_show_contour
            app.h_show_contour = uicheckbox(app.h_mesh_visualization_tool);
            app.h_show_contour.Text = 'Contour array';
            app.h_show_contour.Position = [125 383 96 22];

            % Create h_contour_set_text
            app.h_contour_set_text = uieditfield(app.h_mesh_visualization_tool, 'text');
            app.h_contour_set_text.Position = [239 383 98 22];

            % Show the figure after all components are created
            app.h_mesh_visualization_tool.Visible = 'off';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = zeffiro_interface_mesh_visualization_tool_app_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.h_mesh_visualization_tool)
            else

                % Focus the running singleton app
                figure(runningApp.h_mesh_visualization_tool)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.h_mesh_visualization_tool)
        end
    end
end