classdef MeshTool < handle

    % MeshTool
    %
    % A tool for building finite element meshes and initiating lead field
    % generation.

    properties

        zef app.Zef

        tab matlab.ui.container.Tab

        layout matlab.ui.container.GridLayout

        leftlayout matlab.ui.container.GridLayout

        leftlayout1 matlab.ui.container.GridLayout

        leftlayout2 matlab.ui.container.GridLayout

        leftlayout3 matlab.ui.container.GridLayout

        rightlayout matlab.ui.container.GridLayout

        rightlayout1 matlab.ui.container.GridLayout

        rightlayout2 matlab.ui.container.GridLayout

        rightlayout3 matlab.ui.container.GridLayout

        % leftlayout1 components

        fem_mesh_btn matlab.ui.control.Button

        pp_fem_mesh_btn matlab.ui.control.Button

        resamble_field_btn matlab.ui.control.Button

        resample_surf_btn matlab.ui.control.Button

        source_interpolation_btn matlab.ui.control.Button

        apply_transform_btn matlab.ui.control.Button

        % leftlayout2 components

        lf_source_int_cb matlab.ui.control.CheckBox

        downsample_surf_cb matlab.ui.control.CheckBox

        refinement_cb matlab.ui.control.CheckBox

        mesh_smoothing_cb matlab.ui.control.CheckBox

        % leftlayout3 components

        source_count_ef matlab.ui.control.EditField

        surf_tri_max_ef matlab.ui.control.EditField

        inflating_iter_ef matlab.ui.control.EditField

        mesh_resolution_ef matlab.ui.control.EditField

        smoothing_str_ef matlab.ui.control.EditField

        inflating_str_ef matlab.ui.control.EditField

        meshing_acc_ef matlab.ui.control.EditField

        solver_tol_ef matlab.ui.control.EditField

        dir_dd matlab.ui.control.DropDown

        source_count_label matlab.ui.control.Label

        surf_tri_max_label matlab.ui.control.Label

        inflating_iter_label matlab.ui.control.Label

        mesh_resolution_label matlab.ui.control.Label

        smoothing_str_label matlab.ui.control.Label

        inflating_str_label matlab.ui.control.Label

        meshing_acc_label matlab.ui.control.Label

        solver_tol_label matlab.ui.control.Label

        dir_label matlab.ui.control.Label

        % rightlayout1 components

        eeg_lf_btn matlab.ui.control.Button

        meg_lf_btn matlab.ui.control.Button

        meg_grad_lf_btn matlab.ui.control.Button

        eit_lf_btn matlab.ui.control.Button

        tes_lf_btn matlab.ui.control.Button

    end % properties

    methods

        function self = MeshTool(zef, tabs, varargin)

            self.zef = zef;

            self.tab = uitab(tabs, 'Title', 'Mesh Tool');

            % Create layouts

            self.layout = uigridlayout(self.tab, [1,2], 'Scrollable', 'on');

            self.leftlayout = uigridlayout(self.layout, [3,1]);

            self.leftlayout1 = uigridlayout(self.leftlayout, [3,2]);

            self.leftlayout2 = uigridlayout(self.leftlayout, [2,2]);

            self.leftlayout3 = uigridlayout(self.leftlayout, [3,6]);

            self.rightlayout = uigridlayout(self.layout, [3,1]);

            self.rightlayout1 = uigridlayout(self.rightlayout, [5,1]);

            self.rightlayout2 = uigridlayout(self.rightlayout, [3,1]);

            self.rightlayout3 = uigridlayout(self.rightlayout, [3,1]);

            % Place widgets into layouts
            %
            % leftlayout1

            self.fem_mesh_btn = uibutton(self.leftlayout1, 'Text', 'Create FEM Mesh');

            self.pp_fem_mesh_btn = uibutton(self.leftlayout1, 'Text', 'Postprocess FEM Mesh');

            self.resamble_field_btn = uibutton(self.leftlayout1, 'Text', 'Resample field');

            self.resample_surf_btn = uibutton(self.leftlayout1, 'Text', 'Resample surfaces');

            self.source_interpolation_btn = uibutton(self.leftlayout1, 'Text', 'Source interpolation');

            self.apply_transform_btn = uibutton(self.leftlayout1, 'Text', 'Apply transform');

            % leftlayout 2

            self.lf_source_int_cb = uicheckbox(self.leftlayout2, 'Text', 'LF source interpolation');

            self.downsample_surf_cb = uicheckbox(self.leftlayout2, 'Text', 'Refinement');

            self.refinement_cb = uicheckbox(self.leftlayout2, 'Text', 'Downsample surface');

            self.mesh_smoothing_cb = uicheckbox(self.leftlayout2, 'Text', 'Mesh smoothing');

            % leftlayout 3

            self.source_count_label = uilabel(self.leftlayout3, 'Text', 'Source count');

            self.source_count_ef = uieditfield(self.leftlayout3);

            self.surf_tri_max_label = uilabel(self.leftlayout3, 'Text', 'Max surf tris');

            self.surf_tri_max_ef = uieditfield(self.leftlayout3);

            self.inflating_iter_label = uilabel(self.leftlayout3, 'Text', 'Inflation iters');

            self.inflating_iter_ef = uieditfield(self.leftlayout3);

            self.mesh_resolution_label = uilabel(self.leftlayout3, 'Text', 'Mesh resolution');

            self.mesh_resolution_ef = uieditfield(self.leftlayout3);

            self.smoothing_str_label = uilabel(self.leftlayout3, 'Text', 'Smoothing str');

            self.smoothing_str_ef = uieditfield(self.leftlayout3);

            self.inflating_str_label = uilabel(self.leftlayout3, 'Text', 'Inflation str');

            self.inflating_str_ef = uieditfield(self.leftlayout3);

            self.meshing_acc_label = uilabel(self.leftlayout3, 'Text', 'Meshing acc.');

            self.meshing_acc_ef = uieditfield(self.leftlayout3);

            self.solver_tol_label = uilabel(self.leftlayout3, 'Text', 'Solver tol.');

            self.solver_tol_ef = uieditfield(self.leftlayout3);

            self.dir_label = uilabel(self.leftlayout3, 'Text', 'Directions');

            self.dir_dd = uidropdown(self.leftlayout3);

            % rightlayout1

            self.eeg_lf_btn = uibutton(self.rightlayout1, 'Text', 'EEG Lead Field');

            self.meg_lf_btn = uibutton(self.rightlayout1, 'Text', 'MEG Magneto Lead Field');

            self.meg_grad_lf_btn = uibutton(self.rightlayout1, 'Text', 'EEG Gradio Lead Field');

            self.eit_lf_btn = uibutton(self.rightlayout1, 'Text', 'EIT Lead Field');

            self.tes_lf_btn = uibutton(self.rightlayout1, 'Text', 'tES Lead Field');

        end

    end % methods

end % MeshTool
