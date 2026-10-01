classdef UiThemeTest < matlab.unittest.TestCase
%UITHEMETEST  Shared UI theme tokens, sizing, and layout resize behavior.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).

    properties
        Figures = gobjects(0)
        HadBaseZef = false
        OldBaseZef = []
    end

    methods (TestClassSetup)
        function setupPath(testCase)
            testCase.HadBaseZef = evalin('base', 'exist(''zef'',''var'')') == 1;
            if testCase.HadBaseZef
                testCase.OldBaseZef = evalin('base', 'zef');
            end
            zeffiro_interface('start_mode', 'nodisplay', 'zeffiro_restart', true);
        end
    end

    methods (TestClassTeardown)
        function restoreBaseZef(testCase)
            if testCase.HadBaseZef
                assignin('base', 'zef', testCase.OldBaseZef);
            else
                evalin('base', 'clear zef');
            end
        end
    end

    methods (TestMethodTeardown)
        function cleanupFigures(testCase)
            for i = 1:numel(testCase.Figures)
                if isgraphics(testCase.Figures(i)) && isvalid(testCase.Figures(i))
                    delete(testCase.Figures(i));
                end
            end
            testCase.Figures = gobjects(0);
        end
    end

    methods (Test)

        function themeHasReadableFontAndTealAccent(testCase)
            theme = zef_ui_theme(struct('font_size', 8));
            testCase.verifyGreaterThanOrEqual(theme.font.size, 11);
            testCase.verifyEqual(theme.color.accent, [0.120 0.520 0.550], 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.space.sidebarW, 240);
            testCase.verifyEqual(theme.space.sliderH, 16);
            testCase.verifyEqual(theme.space.rowGap, 4);
            testCase.verifyLessThanOrEqual(theme.space.bottomH, 180);
            testCase.verifyLessThanOrEqual(theme.space.minWinW, 800);
            testCase.verifyLessThanOrEqual(theme.space.minWinH, 580);
        end

        function windowLabelStripsPrefixAndIndex(testCase)
            testCase.verifyEqual(zef_ui_window_label('ZEFFIRO Interface: Figure tool 1'), 'Figure tool');
            testCase.verifyEqual(zef_ui_window_label( ...
                'ZEFFIRO Interface: Mesh visualization tool 1'), 'Mesh visualization tool');
            testCase.verifyEqual(zef_ui_window_label('Open project'), 'Open project');
        end

        function applyThemePaintsFigureAndButton(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', [1 0 0], 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            b = uicontrol(f, 'Style', 'pushbutton', 'String', 'Reset', ...
                'Position', [10 10 80 28]);
            zef_ui_apply_theme(f, theme);
            testCase.verifyEqual(f.Color, theme.color.bg, 'AbsTol', 1e-6);
            testCase.verifyEqual(b.BackgroundColor, theme.color.button, 'AbsTol', 1e-6);
            testCase.verifyGreaterThanOrEqual(b.FontSize, 11);
            f2 = uifigure('Visible', 'off');
            testCase.Figures(end+1) = f2;
            helper = uilabel(f2, 'Text', 'Hold Ctrl/Cmd to multi-select', ...
                'FontSize', 9, 'FontColor', [0.5 0.5 0.5]);
            zef_ui_apply_theme(f2, theme);
            testCase.verifyEqual(helper.FontSize, 9);
            testCase.verifyEqual(helper.FontColor, theme.color.textMuted, 'AbsTol', 1e-6);
        end

        function applyThemeBlendsCompassLogoOntoBackground(testCase)
            theme = zef_ui_theme();
            f = uifigure('Visible', 'off', 'Color', theme.color.bg);
            testCase.Figures(end+1) = f;
            logo = uiimage(f, 'Tag', 'h_axes2', ...
                'ImageSource', which('zeffiro_logo_compass.png'), ...
                'Position', [10 10 176 48]);
            zef_ui_blend_logo(logo, theme);
            src = logo.ImageSource;
            testCase.verifyTrue(isnumeric(src));
            testCase.verifyGreaterThanOrEqual(size(src, 3), 3);
            corner = double(squeeze(src(1, 1, 1:3)))' / 255;
            testCase.verifyEqual(corner, theme.color.bg, 'AbsTol', 0.04);
            mid = double(squeeze(src(round(size(src, 1) / 2), ...
                round(size(src, 2) / 2), 1:3)))' / 255;
            testCase.verifyGreaterThan(max(abs(mid - theme.color.bg)), 0.05);
        end

        function figureToolLayoutHidesSidebarWhenToggled(testCase)
            f = figure('Visible', 'off', 'Units', 'pixels', ...
                'Position', [80 80 980 720], 'MenuBar', 'none', ...
                'Name', 'ZEFFIRO Interface: Figure tool', ...
                'AutoResizeChildren', 'off');
            testCase.Figures(end+1) = f;
            uipanel(f, 'Tag', 'figure_sidebar', 'Units', 'pixels', ...
                'Position', [650 200 300 400]);
            uipanel(f, 'Tag', 'figure_lists', 'Units', 'pixels', ...
                'Position', [20 12 500 168]);
            uiaxes(f, 'Tag', 'axes1', 'Units', 'pixels', ...
                'Position', [20 200 500 400]);
            tgb = uicontrol(f, 'Style', 'pushbutton', 'String', 'Toggle controls', ...
                'Tag', 'togglecontrolsbutton', 'UserData', 1, ...
                'Position', [650 600 120 28]);
            zef_figure_tool_layout(f);
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            testCase.verifyEqual(char(sidebar.Visible), 'on');
            tgb.UserData = 2;
            zef_figure_tool_layout(f);
            testCase.verifyEqual(char(sidebar.Visible), 'off');
            ax = findall(f, 'Tag', 'axes1');
            axp = local_plot_box(ax);
            testCase.verifyGreaterThan(axp(3), 700);
            tgb = findall(f, 'Tag', 'togglecontrolsbutton');
            testCase.verifyNotEmpty(tgb);
            testCase.verifyEqual(char(tgb(1).Visible), 'on');
            testCase.verifyEqual(char(tgb(1).String), 'Toggle controls');
            par = tgb(1).Parent;
            testCase.verifyFalse(strcmp(char(par.Tag), 'figure_sidebar'));
            testCase.verifyEqual(char(par.Visible), 'on');
        end

        function figureToolGivesExtraWidthToAxes(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1400 900]);
            zef_figure_tool_layout(f);
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            ax = findall(f, 'Tag', 'axes1');
            testCase.verifyLessThanOrEqual(sidebar.Position(3), 296);
            axp = local_plot_box(ax);
            testCase.verifyGreaterThan(axp(3), 1000);
        end

        function figureToolStaysCoherentWhenSmall(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 760 580]);
            zef_figure_tool_layout(f);
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            lists = findall(f, 'Tag', 'figure_lists');
            play = findall(f, 'Tag', 'playbutton');
            sl = findall(f, 'Tag', 'slider');
            testCase.verifyGreaterThanOrEqual(sidebar.Position(2), 0);
            testCase.verifyGreaterThanOrEqual(lists.Position(2), 0);
            testCase.verifyGreaterThanOrEqual(play.Position(2), 0);
            testCase.verifyGreaterThan(sl.Position(2), play.Position(2) + play.Position(4) - 2);
            testCase.verifyLessThanOrEqual(sidebar.Position(2) + sidebar.Position(4), f.Position(4) + 1);
            scale = findall(f, 'Tag', 'colorscaleselection');
            testCase.verifyGreaterThan(scale.Position(2), play.Position(2) + play.Position(4) - 2);
            testCase.verifyGreaterThanOrEqual(lists.Position(4), 64);
            testCase.verifyGreaterThanOrEqual(sl.Position(4), 16);
        end

        function figureToolWideShortKeepsSidebarCap(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1100 580]);
            zef_figure_tool_layout(f);
            play = findall(f, 'Tag', 'playbutton');
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            sl = findall(f, 'Tag', 'slider');
            testCase.verifyGreaterThanOrEqual(play.Position(2), 0);
            testCase.verifyLessThanOrEqual(sidebar.Position(3), 296);
            testCase.verifyGreaterThanOrEqual(sidebar.Position(2), 0);
            testCase.verifyGreaterThanOrEqual(sl(1).Position(4), 16);
        end

        function figureToolAppearancePopupsStayInsideSidebar(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 680]);
            zef_figure_tool_layout(f);
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            pop_tags = {'lightsselection', 'colormapselection', 'colorscaleselection'};
            inner_right = sidebar.Position(3) - 10;
            for i = 1:numel(pop_tags)
                pop = findall(f, 'Tag', pop_tags{i});
                testCase.verifyNotEmpty(pop, pop_tags{i});
                pop = pop(1);
                testCase.verifyGreaterThanOrEqual(pop.Position(1), 10 - 0.5);
                testCase.verifyLessThanOrEqual(pop.Position(1) + pop.Position(3), ...
                    inner_right + 1.5, pop_tags{i});
                testCase.verifyGreaterThanOrEqual(pop.Position(2), 0);
                testCase.verifyLessThanOrEqual(pop.Position(2) + pop.Position(4), ...
                    sidebar.Position(4) + 1, pop_tags{i});
            end
            play = findall(f, 'Tag', 'playbutton');
            scale = findall(f, 'Tag', 'colorscaleselection');
            testCase.verifyGreaterThan(scale.Position(2), play.Position(2) + play.Position(4) - 2);
            sl = findall(f, 'Tag', 'slider');
            testCase.verifyEqual(scale.Position(1), sl(1).Position(1), 'AbsTol', 1);
        end

        function figureToolSlidersKeepNativeHeightOnResize(testCase)
            theme = zef_ui_theme();
            sizes = {[40 40 900 720], [40 40 760 580], [40 40 1100 820], ...
                [40 40 880 900], [40 40 1200 520], [40 40 700 640]};
            slider_tags = {'slider', 'colorscale_min_slider', 'update_zoom_slider', ...
                'transparency_surface_slider', 'update_ambience_slider'};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                zef_figure_tool_layout(f);
                for t = 1:numel(slider_tags)
                    sl = findall(f, 'Tag', slider_tags{t});
                    testCase.verifyNotEmpty(sl, slider_tags{t});
                    testCase.verifyGreaterThanOrEqual(sl(1).Position(4), theme.space.sliderH, ...
                        sprintf('%s at %s', slider_tags{t}, mat2str(sizes{s}(3:4))));
                    testCase.verifyEqual(sl(1).Position(2), round(sl(1).Position(2)));
                end
                sliders = findall(f, 'Style', 'slider');
                ys = sort(arrayfun(@(h) h.Position(2), sliders));
                for i = 1:numel(ys) - 1
                    testCase.verifyGreaterThanOrEqual(ys(i + 1) - ys(i), 16);
                end
            end
        end

        function figureToolPopupsHaveConsistentGap(testCase)
            sizes = {[40 40 900 720], [40 40 760 580], [40 40 1100 820]};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                zef_figure_tool_layout(f);
                lights = findall(f, 'Tag', 'lightsselection');
                cmap = findall(f, 'Tag', 'colormapselection');
                scale = findall(f, 'Tag', 'colorscaleselection');
                gap1 = lights(1).Position(2) - (cmap(1).Position(2) + cmap(1).Position(4));
                gap2 = cmap(1).Position(2) - (scale(1).Position(2) + scale(1).Position(4));
                testCase.verifyGreaterThanOrEqual(gap1, 3, mat2str(sizes{s}(3:4)));
                testCase.verifyGreaterThanOrEqual(gap2, 3, mat2str(sizes{s}(3:4)));
                testCase.verifyEqual(gap1, gap2, 'AbsTol', 1);
                testCase.verifyLessThanOrEqual(gap1, 8);
                testCase.verifyGreaterThanOrEqual(lights(1).Position(4), 20);
                testCase.verifyGreaterThanOrEqual(cmap(1).Position(4), 20);
                testCase.verifyGreaterThanOrEqual(scale(1).Position(4), 20);
                play = findall(f, 'Tag', 'playbutton');
                testCase.verifyGreaterThan(scale(1).Position(2), ...
                    play(1).Position(2) + play(1).Position(4) - 2);
            end
        end

        function figureToolHeadersAndFooterStayInside(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 700]);
            sb = findall(f, 'Tag', 'figure_sidebar');
            ls = findall(f, 'Tag', 'figure_lists');
            uicontrol(sb, 'Style', 'text', 'Tag', 'section_color', 'String', 'Color');
            uicontrol(sb, 'Style', 'text', 'Tag', 'section_transparency', 'String', 'Transparency');
            uicontrol(sb, 'Style', 'text', 'Tag', 'section_lighting', 'String', 'Lighting');
            uicontrol(ls, 'Style', 'text', 'Tag', 'label_compartments', 'String', 'Compartments');
            uicontrol(ls, 'Style', 'text', 'Tag', 'copyright_text', 'String', 'Copyright');
            uicontrol(sb, 'Style', 'pushbutton', 'String', 'Reset', 'Tag', 'resetbutton');
            uicontrol(sb, 'Style', 'pushbutton', 'String', 'Stop', 'Tag', 'stopbutton');
            uicontrol(sb, 'Style', 'pushbutton', 'String', 'Logo', 'Tag', 'logobutton');
            zef_figure_tool_layout(f);
            zef_ui_apply_theme(f);
            zef_figure_tool_layout(f);
            hdr = findall(f, 'Tag', 'section_color');
            testCase.verifyGreaterThanOrEqual(hdr(1).Position(2), 0);
            testCase.verifyLessThanOrEqual(hdr(1).Position(2) + hdr(1).Position(4), ...
                sb(1).Position(4) + 0.5);
            testCase.verifyGreaterThanOrEqual(hdr(1).Position(4), 16);
            lab = findall(f, 'Tag', 'label_compartments');
            testCase.verifyGreaterThanOrEqual(lab(1).Position(2), 0);
            testCase.verifyLessThanOrEqual(lab(1).Position(2) + lab(1).Position(4), ...
                ls(1).Position(4) + 0.5);
            play = findall(f, 'Tag', 'playbutton');
            logo = findall(f, 'Tag', 'logobutton');
            testCase.verifyEqual(play(1).Position(4), logo(1).Position(4), 'AbsTol', 1);
            testCase.verifyEqual(play(1).Position(3), logo(1).Position(3), 'AbsTol', 6);
            scale = findall(f, 'Tag', 'colorscaleselection');
            testCase.verifyGreaterThan(scale(1).Position(2), play(1).Position(2) + play(1).Position(4) - 2);
        end

        function fitTableShortensSurfaceHeadersAndKeepsNameFlex(testCase)
            f = uifigure('Visible', 'off', 'Position', [40 40 1280 620]);
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', num2cell(zeros(2, 10)), ...
                'ColumnName', {'Index', 'On', 'Name', 'Visible', 'Surface nodes', ...
                'Surface triangles', 'Merge', 'Invert normal', 'Activity', 'Electrical conductivity'}, ...
                'Position', [20 20 620 280]);
            zef_ui_fit_table(t);
            names = cellstr(string(t.ColumnName));
            testCase.verifyEqual(names{1}, 'ID');
            testCase.verifyEqual(names{4}, 'Vis');
            testCase.verifyEqual(names{5}, 'Nodes');
            testCase.verifyEqual(names{6}, 'Faces');
            testCase.verifyEqual(names{8}, 'Inv');
            testCase.verifyEqual(names{10}, 'Cond.');
            w = t.ColumnWidth;
            testCase.verifyTrue(contains(char(string(w{3})), 'x') || (isnumeric(w{3}) && w{3} >= 64));
            testCase.verifyTrue(isnumeric(w{9}) && w{9} >= 64 || contains(char(string(w{9})), 'x'));
            testCase.verifyGreaterThanOrEqual(w{2}, 42);
            if all(cellfun(@(c) isnumeric(c), w))
                testCase.verifyLessThanOrEqual(sum([w{:}]), t.Position(3) + 2);
            end
        end

        function fitTableValueColumnGetsMoreWeight(testCase)
            f = uifigure('Visible', 'off');
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {'Affine transform', '[1 0 0 0; 0 1 0 0]'}, ...
                'ColumnName', {'Parameter', 'Value'}, 'Position', [20 20 360 120]);
            zef_ui_fit_table(t);
            names = cellstr(string(t.ColumnName));
            testCase.verifyEqual(names{1}, 'Param');
            w = t.ColumnWidth;
            testCase.verifyTrue(contains(char(string(w{1})), 'x') || isnumeric(w{1}));
            if isnumeric(w{1}) && isnumeric(w{2})
                testCase.verifyGreaterThan(w{2}, w{1});
            else
                testCase.verifyTrue(contains(char(string(w{2})), '2x') || contains(char(string(w{2})), 'x'));
            end
        end

        function fitTableParameterNameColumnGetsWeight(testCase)
            f = uifigure('Visible', 'off');
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {'numFeedbackLoops', '0'; 'samplingRate_Hz', '1000'}, ...
                'ColumnName', {'Parameter name', 'Parameter value'}, ...
                'Position', [20 20 400 140]);
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue(contains(char(string(w{1})), '2x') || contains(char(string(w{1})), 'x'));
            if isnumeric(w{1}) && isnumeric(w{2})
                testCase.verifyGreaterThan(w{1}, w{2} * 0.9);
            end
        end

        function uifigureGridRespectsMinSize(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 520 400], ...
                'AutoResizeChildren', 'on');
            testCase.Figures(end+1) = f;
            g = uigridlayout(f, [1 1]);
            g.Tag = 'zef_ui_root';
            uilabel(g, 'Text', 'Probe');
            zef_ui_apply_size(f, 520, 400, 400, 320);
            % zef_ui_bind_min_size has to clear AutoResizeChildren: MATLAB
            % refuses to run SizeChangedFcn while it is on, and that callback
            % is what enforces the size floor asserted below.
            testCase.verifyEqual(char(f.AutoResizeChildren), 'off');
            f.Position(3:4) = [180 140];
            drawnow;
            if f.Position(3) < 400 || f.Position(4) < 320
                fcn = [];
                if isappdata(f, 'ZefMinSizeFcn')
                    fcn = getappdata(f, 'ZefMinSizeFcn');
                end
                if isa(fcn, 'function_handle')
                    fcn(f, struct());
                    drawnow;
                end
            end
            testCase.verifyGreaterThanOrEqual(f.Position(3), 400);
            testCase.verifyGreaterThanOrEqual(f.Position(4), 320);
        end

        function figureToolTallGivesHeightToAxes(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 880 900]);
            zef_figure_tool_layout(f);
            ax = findall(f, 'Tag', 'axes1');
            lists = findall(f, 'Tag', 'figure_lists');
            axp = local_plot_box(ax);
            testCase.verifyGreaterThan(axp(4), 500);
            testCase.verifyLessThanOrEqual(lists.Position(4), 168);
        end

        function applySizeSetsDefaultAndBindsFloor(testCase)
            f = figure('Visible', 'off', 'Units', 'pixels', ...
                'Position', [80 80 200 160], 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            zef_ui_apply_size(f, 640, 480, 400, 300);
            work = zef_ui_screen_workarea(f.Position);
            testCase.verifyEqual(f.Position(3), min(640, work(3)));
            testCase.verifyEqual(f.Position(4), min(480, work(4)));
            f.Position(3:4) = [220 180];
            fcn = f.SizeChangedFcn;
            if isa(fcn, 'function_handle')
                fcn(f, struct());
            end
            drawnow;
            testCase.verifyGreaterThanOrEqual(f.Position(3), 400);
            testCase.verifyGreaterThanOrEqual(f.Position(4), 300);
        end

        function fitTableStretchesNameColumn(testCase)
            f = uifigure('Visible', 'off');
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {'alpha', 1; 'beta', 2}, ...
                'ColumnName', {'Name', 'On'});
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue(isnumeric(w{1}) || (ischar(w{1}) || isstring(w{1})) && contains(char(string(w{1})), 'x'));
            if isnumeric(w{1})
                testCase.verifyGreaterThanOrEqual(w{1}, 48);
            end
            testCase.verifyGreaterThanOrEqual(w{2}, 42);
        end

        function fitTableFlexColumnsFillWithWeights(testCase)
            f = uifigure('Visible', 'off', 'Position', [40 40 900 400]);
            testCase.Figures(end+1) = f;
            g = uigridlayout(f, [1 1]);
            g.Padding = [0 0 0 0];
            t = uitable(g, 'Data', {1, 'White matter', true, 0.14}, ...
                'ColumnName', {'ID', 'Name', 'On', 'Cond.'});
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue(isnumeric(w{1}));
            testCase.verifyTrue((ischar(w{2}) || isstring(w{2})) && contains(char(string(w{2})), 'x'));
            testCase.verifyTrue(isnumeric(w{3}));
            testCase.verifyTrue(isnumeric(w{4}));
            testCase.verifyGreaterThanOrEqual(w{1}, 28);
            testCase.verifyGreaterThanOrEqual(w{3}, 40);
        end

        function fitTableScalesCompactWhenGridIsNarrow(testCase)
            f = uifigure('Visible', 'off', 'Position', [40 40 320 260]);
            testCase.Figures(end+1) = f;
            g = uigridlayout(f, [1 1]);
            g.Padding = [0 0 0 0];
            t = uitable(g, 'Data', num2cell(zeros(1, 8)), ...
                'ColumnName', {'ID', 'Name', 'Mod.', 'On', 'Vis', 'Tags', 'Pts', 'Dir'});
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue((ischar(w{2}) || isstring(w{2})) && contains(char(string(w{2})), 'x'));
            testCase.verifyTrue(isnumeric(w{3}));
            testCase.verifyLessThan(w{3}, 56);
            testCase.verifyGreaterThanOrEqual(w{3}, 26);
        end

        function fitTableUsesFigureWhenPositionStale(testCase)
            f = uifigure('Visible', 'off', 'Position', [40 40 1152 560]);
            testCase.Figures(end+1) = f;
            g = uigridlayout(f, [1 1]);
            g.Padding = [0 0 0 0];
            t = uitable(g, 'Data', num2cell(zeros(2, 8)), ...
                'ColumnName', {'ID', 'Name', 'Mod.', 'On', 'Vis', 'Tags', 'Pts', 'Dir'});
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue(isnumeric(w{2}) || (ischar(w{2}) || isstring(w{2})) && contains(char(string(w{2})), 'x'));
            if isnumeric(w{2})
                testCase.verifyGreaterThanOrEqual(w{2}, 48);
            end
            testCase.verifyGreaterThanOrEqual(w{3}, 50);
            testCase.verifyGreaterThanOrEqual(w{4}, 40);
        end

        function tableDialogDoesNotInflate(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 500 360], ...
                'Name', 'ZEFFIRO Interface: System settings');
            testCase.Figures(end+1) = f;
            uitable(f, 'Data', {1, 2; 3, 4}, 'ColumnName', {'A', 'B'});
            uibutton(f, 'Text', 'Save');
            zef_layout_table_dialog(f);
            testCase.verifyLessThanOrEqual(f.Position(3), 660);
            testCase.verifyLessThanOrEqual(f.Position(4), 400);
            testCase.verifyGreaterThanOrEqual(f.Position(3), 560);
        end

        function tableDialogWidensLongButtonColumn(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 500 280], ...
                'Name', 'ZEFFIRO Interface: Initialization profile');
            testCase.Figures(end+1) = f;
            uitable(f, 'Data', {1, 2; 3, 4}, 'ColumnName', {'A', 'B'});
            uibutton(f, 'Text', 'Update from profile');
            uibutton(f, 'Text', 'Apply');
            uibutton(f, 'Text', 'Save');
            zef_layout_table_dialog(f);
            grids = findall(f, 'Type', 'uigridlayout');
            found = false;
            for i = 1:numel(grids)
                cw = grids(i).ColumnWidth;
                nums = [];
                for k = 1:numel(cw)
                    if isnumeric(cw{k})
                        nums(end+1) = cw{k}; %#ok<AGROW>
                    end
                end
                if numel(nums) == 3 && max(nums) >= 150 && min(nums) <= 120
                    found = true;
                    break
                end
            end
            testCase.verifyTrue(found);
            testCase.verifyLessThanOrEqual(f.Position(3), 660);
        end

        function aboutDialogIsMarkedThemed(testCase)
            zef_about_dialog;
            af = findall(groot, 'Type', 'figure', 'Name', 'ZEFFIRO Interface: About');
            testCase.assertNotEmpty(af);
            testCase.Figures(end+1) = af(1);
            testCase.verifyTrue(isappdata(af(1), 'ZefUiThemed'));
            close(af(1));
        end

        function tableDialogTableFillsWidthWhenWide(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 500 360], ...
                'Name', 'ZEFFIRO Interface: System settings');
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {1, 2; 3, 4}, 'ColumnName', {'Description', 'Value'});
            uibutton(f, 'Text', 'Save');
            uibutton(f, 'Text', 'Apply');
            zef_layout_table_dialog(f);
            f.Position(3) = 900;
            drawnow;
            zef_ui_adapt_grid(f);
            w = t.ColumnWidth;
            testCase.verifyTrue(contains(char(string(w{1})), 'x') ...
                || contains(char(string(w{2})), 'x'));
        end

        function formDialogDoesNotInflate(testCase)
            % Deliberately a name zef_layout_form_dialog does not
            % special-case, so this exercises the generic short-form path.
            % Naming it after a real dialog would instead hit that dialog's
            % hard-coded floor (see formDialogHonoursPerDialogFloor).
            f = uifigure('Visible', 'off', 'Position', [80 80 420 380], ...
                'Name', 'ZEFFIRO Interface: Tiny form');
            testCase.Figures(end+1) = f;
            uilabel(f, 'Text', 'Colormap size:', 'Position', [20 300 140 22]);
            uieditfield(f, 'Position', [180 300 80 22]);
            uilabel(f, 'Text', 'Streamline width:', 'Position', [20 270 140 22]);
            uieditfield(f, 'Position', [180 270 80 22]);
            uilabel(f, 'Text', 'Cone scale:', 'Position', [20 240 140 22]);
            uieditfield(f, 'Position', [180 240 80 22]);
            uibutton(f, 'Text', 'Apply');
            zef_layout_form_dialog(f);
            testCase.verifyEqual(f.Position(3), 360);
            testCase.verifyLessThanOrEqual(f.Position(4), 200);
            testCase.verifyGreaterThanOrEqual(f.Position(4), 150);
        end

        function formDialogHonoursPerDialogFloor(testCase)
            % zef_layout_form_dialog keys a minimum size off fig.Name for
            % dialogs whose real content is larger than the widgets a test
            % fixture creates. Pin that behaviour so the name matching is
            % not dropped or retuned unnoticed.
            f = uifigure('Visible', 'off', 'Position', [80 80 420 380], ...
                'Name', 'ZEFFIRO Interface: Graphics processing options');
            testCase.Figures(end+1) = f;
            % Three pairs, matching formDialogDoesNotInflate: a single pair
            % takes a different branch of zef_layout_form_dialog that does no
            % name matching, which would make this test vacuous.
            uilabel(f, 'Text', 'Colormap size:', 'Position', [20 300 140 22]);
            uieditfield(f, 'Position', [180 300 80 22]);
            uilabel(f, 'Text', 'Streamline width:', 'Position', [20 270 140 22]);
            uieditfield(f, 'Position', [180 270 80 22]);
            uilabel(f, 'Text', 'Cone scale:', 'Position', [20 240 140 22]);
            uieditfield(f, 'Position', [180 240 80 22]);
            uibutton(f, 'Text', 'Apply');
            zef_layout_form_dialog(f);
            testCase.verifyGreaterThanOrEqual(f.Position(3), 500);
            testCase.verifyGreaterThanOrEqual(f.Position(4), 420);
            testCase.verifyLessThanOrEqual(f.Position(4), 520);
        end

        function coreAppWindowsKeepDefaultSizeAndResize(testCase)
            addpath(fullfile(fileparts(which('zeffiro_interface')), 'assets', 'fig'));
            cases = { ...
                @zef_segmentation_tool_app_exported, 'h_zeffiro_window_main', [1280 620], [1020 500], [1480 820]; ...
                @zef_mesh_tool_app_exported, 'h_mesh_tool', [1040 560], [860 520], [1200 700]; ...
                @zef_mesh_visualization_tool_app_exported, 'h_mesh_visualization_tool', [700 620], [640 580], [840 740]};
            for i = 1:size(cases, 1)
                app = cases{i, 1}();
                f = app.(cases{i, 2});
                f.Visible = 'off';
                testCase.Figures(end+1) = f;
                zef = struct();
                props = properties(app);
                for k = 1:numel(props)
                    try
                        zef.(props{k}) = app.(props{k});
                    catch
                    end
                end
                zef = zef_ui_tag_handles(zef);
                assignin('base', 'zef', zef);
                def = cases{i, 3};
                zef_ui_apply_size(f, def(1), def(2), cases{i, 4}(1), cases{i, 4}(2));
                zef_ui_ready(f);
                work = zef_ui_screen_workarea(double(f.Position));
                expect_w = min(def(1), work(3));
                expect_h = min(def(2), work(4));
                testCase.verifyEqual(f.Position(3), expect_w, ...
                    sprintf('%s default width', f.Name));
                testCase.verifyEqual(f.Position(4), expect_h, ...
                    sprintf('%s default height', f.Name));
                testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_ui_root'));
                f.Position(3:4) = cases{i, 4};
                drawnow;
                testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_ui_root'));
                f.Position(3:4) = cases{i, 5};
                drawnow;
                pause(0.25);
                drawnow;
                testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_ui_root'));
                % apply_size caps the first size to the work area. A later
                % Position assignment is not forced back onto the screen;
                % the window must not collapse below the work-area cap.
                testCase.verifyGreaterThanOrEqual(f.Position(3), ...
                    min(cases{i, 5}(1), work(3)) - 1, ...
                    sprintf('%s large width', f.Name));
            end
        end

        function meshVisUsesTwoColumnsWithoutScroll(testCase)
            addpath(fullfile(fileparts(which('zeffiro_interface')), 'assets', 'fig'));
            app = zef_mesh_visualization_tool_app_exported;
            f = app.h_mesh_visualization_tool;
            f.Visible = 'off';
            testCase.Figures(end+1) = f;
            zef = struct();
            props = properties(app);
            for k = 1:numel(props)
                try
                    zef.(props{k}) = app.(props{k});
                catch
                end
            end
            zef = zef_ui_tag_handles(zef);
            assignin('base', 'zef', zef);
            zef_ui_apply_size(f, 700, 620, 640, 580);
            zef_ui_ready(f);
            testCase.verifyEqual(char(f.Scrollable), 'off');
            root = findall(f, 'Tag', 'zef_ui_root');
            testCase.verifyNotEmpty(root);
            testCase.verifyEqual(numel(root(1).ColumnWidth), 2);
            testCase.verifyEqual(numel(root(1).RowHeight), 2);
            plot_btn = findall(f, 'Type', 'uibutton');
            testCase.verifyGreaterThan(numel(plot_btn), 3);
        end

        function uiAxesSurvivesClaResetAndSliderLookup(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 680]);
            ax = findall(f, 'Tag', 'axes1');
            cla(ax, 'reset');
            testCase.verifyNotEqual(char(ax.Tag), 'axes1');
            found = zef_ui_axes(f);
            testCase.verifyTrue(isvalid(found));
            testCase.verifyEqual(found, ax);
            testCase.verifyEqual(char(found.Tag), 'axes1');
            clim_vec = found.CLim;
            testCase.verifyEqual(numel(clim_vec), 2);
            kids = found.Children;
            testCase.verifyTrue(isgraphics(found));
            sl = zef_ui_control(f, 'slider');
            testCase.verifyTrue(isvalid(sl));
            pop = zef_ui_control(f, 'colormapselection');
            testCase.verifyTrue(isvalid(pop));
        end

        function figureToolUpdateCallbacksUseLiveAxes(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 680]);
            sb = findall(f, 'Tag', 'figure_sidebar');
            uicontrol(sb, 'Style', 'slider', 'Tag', 'colorscale_min_slider', ...
                'Min', -1, 'Max', 1, 'Value', 0);
            uicontrol(sb, 'Style', 'slider', 'Tag', 'update_ambience_slider', ...
                'Min', 0, 'Max', 1, 'Value', 0.5);
            uicontrol(sb, 'Style', 'slider', 'Tag', 'update_contrast_slider', ...
                'Min', -1, 'Max', 1, 'Value', 0);
            uicontrol(sb, 'Style', 'slider', 'Tag', 'update_brightness_slider', ...
                'Min', 0, 'Max', 5, 'Value', 0);
            ax = findall(f, 'Tag', 'axes1');
            cla(ax, 'reset');
            zef = struct('h_zeffiro', f, 'h_axes1', ax, 'show_contour', false, ...
                'colormap_items', {{'Monterosso'}}, 'update_colormap', 1);
            assignin('base', 'zef', zef);
            h = zef_ui_axes(f);
            testCase.verifyEqual(char(h.Tag), 'axes1');
            h.CLim = [0 1];
            h.Colormap = parula(8);
            kids = h.Children;
            testCase.verifyClass(h, 'matlab.ui.control.UIAxes');
        end

        function figureToolHidesEmptyTimeTextOverlay(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 680]);
            tt = findall(f, 'Tag', 'time_text');
            testCase.verifyNotEmpty(tt);
            tt.String = '';
            tt.Visible = 'on';
            tt.Position = [20 600 240 20];
            zef_figure_tool_layout(f);
            testCase.verifyEqual(char(tt.Visible), 'off');
            tt.String = 'Time: 0.010000 s, Frame: 1 / 10.';
            zef_figure_tool_layout(f);
            testCase.verifyEqual(char(tt.Visible), 'on');
            ax = findall(f, 'Tag', 'axes1');
            axp = local_plot_box(ax);
            testCase.verifyGreaterThanOrEqual(tt.Position(2), axp(2));
            testCase.verifyLessThanOrEqual(tt.Position(2) + tt.Position(4), ...
                axp(2) + axp(4) + 1);
        end

        function guideWindowKeepsOriginalSize(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', ...
                'Name', 'ZEFFIRO Interface: Test plugin', ...
                'Position', [80 80 320 240]);
            testCase.Figures(end+1) = f;
            b = uicontrol(f, 'Style', 'text', 'String', 'Prior:', ...
                'Units', 'normalized', 'FontUnits', 'normalized', ...
                'FontSize', 0.4, 'Position', [0.05 0.8 0.4 0.1]);
            zef_layout_guide_window(f);
            testCase.verifyEqual(char(b.FontUnits), 'pixels');
            testCase.verifyGreaterThanOrEqual(b.FontSize, 11);
            testCase.verifyLessThanOrEqual(f.Position(3), 360);
            testCase.verifyLessThanOrEqual(f.Position(4), 280);
        end

        function themeExposesShellTokens(testCase)
            theme = zef_ui_theme();
            testCase.verifyEqual(theme.mode, 'light');
            testCase.verifyEqual(theme.space.navW, 168);
            testCase.verifyEqual(theme.space.headerH, 40);
            testCase.verifyEqual(theme.space.footerH, 22);
            testCase.verifyGreaterThanOrEqual(theme.space.headerGap, 8);
            testCase.verifyLessThanOrEqual(theme.space.headerGap, 16);
            testCase.verifyGreaterThanOrEqual(theme.space.cardGap, 6);
            testCase.verifyGreaterThanOrEqual(theme.space.cardRadius, 8);
            testCase.verifyGreaterThanOrEqual(theme.space.shellMinW, 900);
            testCase.verifyEqual(theme.space.shellDefW, 1000);
            testCase.verifyEqual(theme.space.shellDefH, 646);
            testCase.verifyGreaterThanOrEqual(theme.space.labelW, 108);
            testCase.verifyGreaterThanOrEqual(theme.space.flyoutW, 260);
            testCase.verifyGreaterThan(theme.color.cardEdge(2), theme.color.cardEdge(1));
            testCase.verifyGreaterThan(theme.color.cardEdge(3), theme.color.cardEdge(1));
            testCase.verifyGreaterThan(theme.color.bg(1), 0.9);
            testCase.verifyEqual(theme.color.surface, theme.color.panel, 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.surfaceRaised, theme.color.panel, 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.textPrimary, theme.color.text, 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.error, theme.color.danger, 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.success, theme.color.ready, 'AbsTol', 1e-6);
            legacy = zef_ui_theme(struct('ui_color_mode', 'dark', 'font_size', 12));
            testCase.verifyEqual(legacy.mode, 'light');
            testCase.verifyEqual(legacy.color.bg, theme.color.bg, 'AbsTol', 1e-6);
        end

        function roundrectCornersMatchOuterNotFill(testCase)
            fillc = [1 1 1];
            borderc = [0.86 0.92 0.92];
            outerc = [0.965 0.970 0.974];
            rgb = zef_ui_roundrect(40, 40, 12, fillc, borderc, outerc);
            testCase.verifyEqual(size(rgb), [40 40 3]);
            testCase.verifyEqual(squeeze(rgb(1, 1, :)).', outerc, 'AbsTol', 0.06);
            testCase.verifyEqual(squeeze(rgb(20, 20, :)).', fillc, 'AbsTol', 0.02);
            disk = zef_ui_roundrect(24, 24, 12, fillc, fillc, outerc);
            testCase.verifyEqual(squeeze(disk(1, 1, :)).', outerc, 'AbsTol', 0.06);
            testCase.verifyEqual(squeeze(disk(12, 12, :)).', fillc, 'AbsTol', 0.02);
        end

        function roundrectStrokePaintsEveryEdge(testCase)
            theme = zef_ui_theme();
            rgb = zef_ui_roundrect(96, 28, 6, theme.color.button, ...
                theme.color.buttonBorder, theme.color.panel, theme.space.btnStroke);
            testCase.verifyEqual(size(rgb), [28 96 3]);
            testCase.verifyEqual(squeeze(rgb(1, 1, :)).', theme.color.panel, 'AbsTol', 0.08);
            testCase.verifyEqual(squeeze(rgb(14, 48, :)).', theme.color.button, 'AbsTol', 0.02);
            mid = squeeze(rgb(14, :, :));
            if size(mid, 1) == 3
                mid = mid.';
            end
            delta = max(abs(mid - theme.color.button), [], 2);
            testCase.verifyGreaterThan(max(delta), 0.18);
            hair = zef_ui_roundrect(96, 28, 6, [1 1 1], theme.color.border, [1 1 1]);
            hair_mid = squeeze(hair(14, :, :));
            if size(hair_mid, 1) == 3
                hair_mid = hair_mid.';
            end
            hair_delta = max(abs(hair_mid - 1), [], 2);
            testCase.verifyLessThan(max(hair_delta), 0.02);
        end

        function roundButtonKeepsBorderAcrossStates(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', theme.color.panel, 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            p = uipanel(f, 'Tag', 'figure_sidebar', 'Units', 'pixels', ...
                'Position', [10 10 220 80], 'BackgroundColor', theme.color.panel, ...
                'BorderType', 'none');
            b = uicontrol(p, 'Style', 'pushbutton', 'String', 'Reset', ...
                'Tag', 'resetbutton', 'Position', [8 8 96 26]);
            zef_ui_round_button(b, theme, false);
            idle = b.CData;
            testCase.verifyGreaterThan(local_edge_contrast(idle, theme.color.button), 0.18);
            zef_ui_interact(b, 'paint', 'hover');
            hover = b.CData;
            testCase.verifyFalse(isequal(hover, idle));
            testCase.verifyGreaterThan(local_edge_contrast(hover, hover(14, 48, :)), 0.12);
            zef_ui_interact(b, 'paint', 'press');
            pressed = b.CData;
            testCase.verifyGreaterThan(local_edge_contrast(pressed, pressed(14, 48, :)), 0.10);
            zef_ui_interact(b, 'paint', 'idle');
            testCase.verifyEqual(b.CData, idle);
            play = uicontrol(p, 'Style', 'pushbutton', 'String', 'Play', ...
                'Tag', 'playbutton', 'Position', [112 8 96 26]);
            zef_ui_round_button(play, theme, true);
            testCase.verifyGreaterThan(local_edge_contrast(play.CData, theme.color.primary), 0.08);
            cap = findall(p, 'Tag', 'playbutton_cap');
            testCase.verifyGreaterThanOrEqual(cap(1).Position(1), play.Position(1) + 3);
        end

        function cardChromeAvoidsPushbuttonBevel(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', theme.color.bg, 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            ax = axes(f, 'Tag', 'axes1', 'Units', 'pixels', 'Position', [20 20 80 60]);
            p = uipanel(f, 'Units', 'pixels', 'Position', [120 20 180 100], ...
                'BorderType', 'none', 'BackgroundColor', theme.color.bg, ...
                'Tag', 'figure_sidebar');
            zef_ui_card(p, theme);
            bg = findall(p, 'Tag', 'zef_card_bg');
            testCase.verifyNotEmpty(bg);
            testCase.verifyEqual(char(bg(1).Type), 'axes');
            btn = findall(p, 'Tag', 'zef_card_bg', 'Type', 'uicontrol');
            testCase.verifyEmpty(btn);
            zef_ui_card_corners(f, [20 20 400 240], theme, 12);
            caps = findall(f, '-regexp', 'Tag', '^zef_card_c_');
            testCase.verifyEmpty(caps);
            found = zef_ui_axes(f);
            testCase.verifyEqual(found, ax);
        end

        function figureCardCornersDoNotPaintOverlaySquares(testCase)
            had_zef = evalin('base', 'exist(''zef'',''var'')');
            old_zef = [];
            if had_zef
                old_zef = evalin('base', 'zef');
            end
            cleaner = onCleanup(@() local_restore_zef(had_zef, old_zef)); %#ok<NASGU>
            assignin('base', 'zef', struct('ui_color_mode', 'light', 'font_size', 12));
            light = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', light.color.bg, ...
                'MenuBar', 'none', 'ToolBar', 'none', 'WindowStyle', 'normal');
            testCase.Figures(end+1) = f;
            leftover = uipanel(f, 'Tag', 'zef_card_c_tl', 'Units', 'pixels', ...
                'Position', [20 240 12 12], 'BackgroundColor', [1 1 1]);
            zef_ui_card_corners(f, [20 20 400 240], light, 12);
            testCase.verifyFalse(isvalid(leftover));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_c_'));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_e_'));
            zef_ui_card_corners(f, [20 20 400 240], light, 12);
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_c_'));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_e_'));
        end

        function figureWorkspaceUsesRoundedCardWithoutOverlays(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            leftover = uipanel(f, 'Tag', 'zef_card_c_tl', 'Units', 'pixels', ...
                'Position', [20 240 12 12], 'BackgroundColor', [1 0 0]);
            leftover.Parent = f;
            zef_figure_tool_layout(f);
            work = findall(f, 'Tag', 'zef_shell_card');
            testCase.verifyNotEmpty(work);
            testCase.verifyEqual(char(work.Visible), 'on');
            bg = findall(work, 'Tag', 'zef_card_bg');
            testCase.verifyNotEmpty(bg);
            testCase.verifyEqual(char(bg(1).Type), 'axes');
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_c_'));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_card_e_'));
            testCase.verifyFalse(isvalid(leftover));
            theme = zef_ui_theme();
            rad = theme.space.cardRadius;
            tabs = findall(f, 'Tag', 'zef_shell_tabs');
            tools = findall(f, 'Tag', 'zef_shell_toolbar');
            view = findall(f, 'Tag', 'figure_view');
            testCase.verifyEqual(char(tabs.Parent.Tag), 'zef_shell_card');
            testCase.verifyEqual(char(tools.Parent.Tag), 'zef_shell_card');
            testCase.verifyEqual(char(view.Parent.Tag), 'zef_shell_card');
            testCase.verifyGreaterThanOrEqual(tabs.Position(1), rad - 1);
            testCase.verifyGreaterThanOrEqual(view.Position(1), rad - 1);
            testCase.verifyGreaterThanOrEqual(view.Position(2), rad - 1);
            testCase.verifyLessThanOrEqual(tabs.Position(1) + tabs.Position(3), ...
                work.Position(3) - rad + 1);
            testCase.verifyLessThanOrEqual(view.Position(2) + view.Position(4), ...
                work.Position(4) - rad + 1);
            nav = findall(f, 'Tag', 'zef_shell_nav');
            testCase.verifyEqual(work.Position(2) + work.Position(4), ...
                nav.Position(2) + nav.Position(4), 'AbsTol', 2);
        end

        function unifiedShellPlacesNavAndSidebar(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1024 682]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            nav = findall(f, 'Tag', 'zef_shell_nav');
            header = findall(f, 'Tag', 'zef_shell_header');
            footer = findall(f, 'Tag', 'zef_shell_footer');
            sidebar = findall(f, 'Tag', 'figure_sidebar');
            ax = findall(f, 'Tag', 'axes1');
            axp = local_plot_box(ax);
            testCase.verifyNotEmpty(nav);
            testCase.verifyTrue(zef_ui_is_unified(f));
            testCase.verifyGreaterThanOrEqual(nav.Position(3), 108);
            testCase.verifyGreaterThanOrEqual(nav.Position(1), 8);
            testCase.verifyLessThan(nav.Position(1), 20);
            testCase.verifyGreaterThan(header.Position(2), footer.Position(2));
            testCase.verifyGreaterThan(sidebar.Position(1), axp(1) + axp(3) - 2);
            testCase.verifyGreaterThan(axp(1), nav.Position(1) + nav.Position(3) - 2);
            testCase.verifyEqual(char(findall(f, 'Tag', 'zef_nav_project').String), 'Project');
            testCase.verifyEqual(char(findall(f, 'Tag', 'zef_nav_help').String), 'Help');
            help_row = findall(f, 'Tag', 'zef_nav_row_help');
            project_row = findall(f, 'Tag', 'zef_nav_row_project');
            settings_row = findall(f, 'Tag', 'zef_nav_row_settings');
            multi_row = findall(f, 'Tag', 'zef_nav_row_multi');
            testCase.verifyGreaterThan(project_row.Position(2), help_row.Position(2));
            testCase.verifyLessThan(help_row.Position(2), nav.Position(4) * 0.45);
            testCase.verifyGreaterThan(multi_row.Position(2), ...
                settings_row.Position(2) + settings_row.Position(4) + 8);
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tab_figure'));
            testCase.verifyEmpty(findall(f, 'Tag', 'zef_tab_3d'));
            testCase.verifyEqual(char(findall(f, 'Tag', 'zef_tab_figure').String), 'Figure');
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_pan'));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_shell_theme'));
            names = {'Toggle controls', 'Toggle edges'};
            for i = 1:numel(names)
                hit = findall(f, 'String', names{i});
                testCase.verifyNotEmpty(hit, names{i});
            end
        end

        function navRowsKeepIconTextAlignment(testCase)
            sizes = {[40 40 1024 682], [40 40 1280 820], [40 40 980 640], ...
                [40 40 1100 720], [40 40 1400 900], [40 40 1600 1000], ...
                [40 40 900 620], [40 40 1180 540]};
            keys = {'project', 'export', 'import', 'edit', 'inverse', ...
                'forward', 'multi', 'settings', 'window', 'help'};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                f.Tag = 'figure_tool';
                zef_ui_shell('build', f);
                zef_figure_tool_layout(f);
                gaps = [];
                for i = 1:numel(keys)
                    row = findall(f, 'Tag', ['zef_nav_row_' keys{i}]);
                    ic = findall(f, 'Tag', ['zef_nav_icon_' keys{i}]);
                    lab = findall(f, 'Tag', ['zef_nav_' keys{i}]);
                    hit = findall(f, 'Tag', ['zef_nav_hit_' keys{i}]);
                    testCase.verifyNotEmpty(row, keys{i});
                    testCase.verifyNotEmpty(ic, keys{i});
                    testCase.verifyNotEmpty(lab, keys{i});
                    testCase.verifyNotEmpty(hit, keys{i});
                    testCase.verifyEqual(ic(1).Parent, row(1), keys{i});
                    testCase.verifyEqual(lab(1).Parent, row(1), keys{i});
                    testCase.verifyEqual(hit(1).Parent, row(1), keys{i});
                    ic_c = ic(1).Position(2) + ic(1).Position(4) / 2;
                    lab_c = lab(1).Position(2) + lab(1).Position(4) / 2;
                    row_c = row(1).Position(4) / 2;
                    testCase.verifyEqual(ic_c, lab_c, 'AbsTol', 1);
                    testCase.verifyEqual(ic_c, row_c, 'AbsTol', 1);
                    testCase.verifyEqual(ic(1).Position(2), 0, 'AbsTol', 1);
                    testCase.verifyEqual(ic(1).Position(4), row(1).Position(4), 'AbsTol', 1);
                    testCase.verifyEqual(lab(1).Position(2), 0, 'AbsTol', 1);
                    testCase.verifyEqual(lab(1).Position(4), row(1).Position(4), 'AbsTol', 1);
                    testCase.verifyEqual(char(hit(1).Style), 'text', keys{i});
                    testCase.verifyEqual(char(ic(1).Style), 'text', keys{i});
                    testCase.verifyEqual(char(hit(1).Enable), 'inactive', keys{i});
                    testCase.verifyEqual(char(ic(1).Visible), 'off', keys{i});
                    if strcmpi(char(ic(1).Type), 'uiimage')
                        testCase.verifyTrue(isprop(ic(1), 'ImageSource'), keys{i});
                    else
                        testCase.verifyEqual(char(ic(1).Enable), 'inactive', keys{i});
                        testCase.verifyNotEmpty(ic(1).Callback, keys{i});
                    end
                    if strcmp(char(lab(1).Visible), 'on')
                        gap = lab(1).Position(1) - (ic(1).Position(1) + ic(1).Position(3));
                        gaps(end+1) = gap; %#ok<AGROW>
                    end
                    testCase.verifyEqual(hit(1).Position(1), 0, 'AbsTol', 1);
                    testCase.verifyEqual(hit(1).Position(2), 0, 'AbsTol', 1);
                    testCase.verifyEqual(hit(1).Position(3), row(1).Position(3), 'AbsTol', 1);
                    testCase.verifyEqual(hit(1).Position(4), row(1).Position(4), 'AbsTol', 1);
                    rgb = local_menu_chip_cdata(row(1), ['zef_nav_bg_' keys{i}]);
                    testCase.verifyEqual(size(rgb, 2), round(row(1).Position(3)), 'AbsTol', 1);
                    testCase.verifyEqual(size(rgb, 1), round(row(1).Position(4)), 'AbsTol', 1);
                    testCase.verifyNotEmpty(lab(1).Callback, keys{i});
                    testCase.verifyNotEmpty(hit(1).Callback, keys{i});
                    if ~strcmpi(char(ic(1).Type), 'uiimage')
                        testCase.verifyNotEmpty(ic(1).Callback, keys{i});
                    end
                end
                if numel(gaps) > 1
                    testCase.verifyEqual(max(gaps), min(gaps), 'AbsTol', 1);
                end
            end
            f = local_figure_tool_fixture(testCase, [40 40 1024 682]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            ic0 = findall(f, 'Tag', 'zef_nav_icon_project');
            lab0 = findall(f, 'Tag', 'zef_nav_project');
            c0 = (ic0(1).Position(2) + ic0(1).Position(4) / 2) - ...
                (lab0(1).Position(2) + lab0(1).Position(4) / 2);
            f.Position = [40 40 1600 1000];
            zef_figure_tool_layout(f);
            ic1 = findall(f, 'Tag', 'zef_nav_icon_project');
            lab1 = findall(f, 'Tag', 'zef_nav_project');
            c1 = (ic1(1).Position(2) + ic1(1).Position(4) / 2) - ...
                (lab1(1).Position(2) + lab1(1).Position(4) / 2);
            testCase.verifyEqual(c0, 0, 'AbsTol', 1);
            testCase.verifyEqual(c1, 0, 'AbsTol', 1);
            nav = findall(f, 'Tag', 'zef_shell_nav');
            setappdata(nav, 'ZefNavHoverKey', 'project');
            zef_figure_tool_layout(f);
            row = findall(f, 'Tag', 'zef_nav_row_project');
            pos_before = row(1).Position;
            lab_before = lab1(1).Position;
            setappdata(nav, 'ZefNavHoverKey', 'export');
            zef_figure_tool_layout(f);
            testCase.verifyEqual(row(1).Position, pos_before);
            testCase.verifyEqual(lab1(1).Position, lab_before);
        end

        function navHoverFillsEntireRow(testCase)
            theme = zef_ui_theme();
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            nav = findall(f, 'Tag', 'zef_shell_nav');
            keys = {'project', 'export', 'import', 'edit', 'inverse', ...
                'forward', 'multi', 'settings', 'window', 'help'};
            for i = 1:numel(keys)
                row = findall(f, 'Tag', ['zef_nav_row_' keys{i}]);
                hit = findall(f, 'Tag', ['zef_nav_hit_' keys{i}]);
                ic = findall(f, 'Tag', ['zef_nav_icon_' keys{i}]);
                lab = findall(f, 'Tag', ['zef_nav_' keys{i}]);
                testCase.verifyEqual(row(1).BackgroundColor, theme.color.panel, 'AbsTol', 1e-6);
                testCase.verifyEqual(hit(1).BackgroundColor, theme.color.panel, 'AbsTol', 1e-6);
                testCase.verifyEqual(lab(1).BackgroundColor, theme.color.panel, 'AbsTol', 1e-6);
                cd = [];
                try
                    cd = hit(1).CData;
                catch
                end
                testCase.verifyEmpty(cd, keys{i});
                rgb = local_menu_chip_cdata(row(1), ['zef_nav_bg_' keys{i}]);
                testCase.verifyEqual(size(rgb, 2), round(row(1).Position(3)), 'AbsTol', 1);
                testCase.verifyEqual(size(rgb, 1), round(row(1).Position(4)), 'AbsTol', 1);
            end
            setappdata(f, 'ZefNavHoverKey', 'project');
            setappdata(nav, 'ZefNavHoverKey', 'project');
            try
                rmappdata(nav, 'ZefNavPaintKey');
            catch
            end
            zef_figure_tool_layout(f);
            row = findall(f, 'Tag', 'zef_nav_row_project');
            hit = findall(f, 'Tag', 'zef_nav_hit_project');
            ic = findall(f, 'Tag', 'zef_nav_icon_project');
            lab = findall(f, 'Tag', 'zef_nav_project');
            fill = theme.color.navHover;
            outer = theme.color.panel;
            testCase.verifyEqual(row(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(hit(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            % Single-layer rendering: only the chip axes image carries the
            % hover fill. Icon/label uicontrols stay hidden and keep the
            % idle (panel) background so they cannot stack a second,
            % square rectangle over the rounded chip.
            testCase.verifyEqual(ic(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(lab(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(char(ic(1).Visible), 'off');
            testCase.verifyEqual(char(lab(1).Visible), 'off');
            rgb = local_menu_chip_cdata(row(1), 'zef_nav_bg_project');
            mid = double(squeeze(rgb(round(end / 2), round(end / 2), :))).';
            corner = double(squeeze(rgb(1, 1, :))).';
            testCase.verifyEqual(mid, fill, 'AbsTol', 0.08);
            testCase.verifyLessThan(norm(corner - outer), norm(corner - fill));
            % The label glyph lives in the chip axes as transparent text.
            cax = [];
            try
                cax = getappdata(row(1), 'ZefChipAx');
            catch
            end
            testCase.verifyNotEmpty(cax);
            txt = findall(cax, 'Type', 'text');
            testCase.assertNotEmpty(txt);
            testCase.verifyEqual(char(txt(1).String), 'Project');
            testCase.verifyEqual(char(txt(1).Visible), 'on');
            testCase.verifyEqual(txt(1).BackgroundColor, 'none');
            icon_box = im2double(rgb(max(1, round(end / 2) - 10):min(end, round(end / 2) + 10), ...
                8:min(size(rgb, 2), 32), :));
            fill_img = reshape(fill, 1, 1, 3);
            d_icon = sqrt(sum((icon_box - fill_img) .^ 2, 3));
            testCase.verifyGreaterThan(max(d_icon(:)), 0.05);
            if strcmpi(char(ic(1).Type), 'uiimage')
                src = ic(1).ImageSource;
            else
                src = ic(1).CData;
            end
            try
                rmappdata(nav, 'ZefNavPaintKey');
            catch
            end
            zef_figure_tool_layout(f);
            ic2 = findall(f, 'Tag', 'zef_nav_icon_project');
            if strcmpi(char(ic2(1).Type), 'uiimage')
                testCase.verifyEqual(ic2(1).ImageSource, src);
            else
                testCase.verifyEqual(ic2(1).CData, src);
            end
            cd = [];
            try
                cd = hit(1).CData;
            catch
            end
            testCase.verifyEmpty(cd);
            idle_row = findall(f, 'Tag', 'zef_nav_row_export');
            testCase.verifyEqual(idle_row(1).BackgroundColor, theme.color.panel, 'AbsTol', 1e-6);
            pan = findall(f, 'Tag', 'zef_tool_pan');
            labp = findall(f, 'Tag', 'zef_tool_lab_pan');
            idle_icon = pan(1).CData;
            zef_ui_interact(pan(1), 'paint', 'hover');
            testCase.verifyEqual(pan(1).CData, idle_icon);
            if ~isempty(labp)
                testCase.verifyEqual(char(labp(1).Enable), 'inactive');
            end
        end

        function navHoverMotionFillsRowFromPaddingAndToolbarPair(testCase)
            theme = zef_ui_theme();
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            zef_ui_shell('hits', f);
            row = findall(f, 'Tag', 'zef_nav_row_project');
            hit = findall(f, 'Tag', 'zef_nav_hit_project');
            ic = findall(f, 'Tag', 'zef_nav_icon_project');
            lab = findall(f, 'Tag', 'zef_nav_project');
            testCase.assertNotEmpty(row);
            % getpixelposition(h, true) is already figure-relative (same
            % frame as CurrentPoint); do not subtract the figure position.
            ap = getpixelposition(row(1), true);
            f.Units = 'pixels';
            f.CurrentPoint = [ap(1) + 4, ap(2) + 2];
            notify(f, 'WindowMouseMotion');
            testCase.verifyEqual(char(getappdata(f, 'ZefNavHoverKey')), 'project');
            fill = theme.color.navHover;
            outer = theme.color.panel;
            testCase.verifyEqual(row(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(hit(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            % Hover padding hits fill the whole row via the chip axes
            % alone; child uicontrols never paint a second background.
            testCase.verifyEqual(ic(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(lab(1).BackgroundColor, outer, 'AbsTol', 1e-6);
            testCase.verifyEqual(char(lab(1).Visible), 'off');
            rgb = local_menu_chip_cdata(row(1), 'zef_nav_bg_project');
            mid = double(squeeze(rgb(round(end / 2), round(end / 2), :))).';
            corner = double(squeeze(rgb(1, 1, :))).';
            testCase.verifyEqual(mid, fill, 'AbsTol', 0.08);
            testCase.verifyLessThan(norm(corner - outer), norm(corner - fill));
            testCase.verifyEqual(size(rgb, 2), round(row(1).Position(3)), 'AbsTol', 1);
            cd = [];
            try
                cd = hit(1).CData;
            catch
            end
            testCase.verifyEmpty(cd);
            pan = findall(f, 'Tag', 'zef_tool_pan');
            labp = findall(f, 'Tag', 'zef_tool_lab_pan');
            testCase.assertNotEmpty(pan);
            testCase.assertNotEmpty(labp);
            idle_c = pan(1).CData;
            pp = getpixelposition(pan(1), true);
            f.CurrentPoint = [pp(1) + pp(3) / 2, pp(2) + pp(4) / 2];
            notify(f, 'WindowMouseMotion');
            testCase.verifyEqual(pan(1).CData, idle_c);
            testCase.verifyEqual(pan(1).BackgroundColor, theme.color.hover, 'AbsTol', 1e-6);
            testCase.verifyEqual(labp(1).BackgroundColor, theme.color.hover, 'AbsTol', 1e-6);
        end

        function roundButtonCaptionDoesNotStealFocus(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', theme.color.bg, 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            b = uicontrol(f, 'Style', 'pushbutton', 'String', 'Apply', ...
                'Tag', 'applybutton', 'Position', [20 20 88 28], ...
                'Callback', @(~, ~) assignin('base', 'zef_round_fire', true));
            zef_ui_round_button(b, theme, false);
            cap = findall(f, 'Tag', 'applybutton_cap');
            testCase.verifyNotEmpty(cap);
            testCase.verifyEqual(char(cap(1).Enable), 'inactive');
            testCase.verifyEmpty(cap(1).Callback);
            testCase.verifyNotEmpty(cap(1).ButtonDownFcn);
            testCase.verifyTrue(isappdata(b, 'ZefRoundKey'));
            idle = b.CData;
            zef_ui_interact(b, 'paint', 'hover');
            testCase.verifyFalse(isequal(b.CData, idle));
            zef_ui_interact(b, 'paint', 'idle');
            testCase.verifyEqual(b.CData, idle);
            assignin('base', 'zef_round_fire', false);
            cap(1).ButtonDownFcn(cap(1), []);
            testCase.verifyTrue(evalin('base', 'zef_round_fire'));
            evalin('base', 'clear zef_round_fire');
        end

        function interactBindIsIdempotentAndSetsPointerPolicy(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'Position', [40 40 320 200]);
            testCase.Figures(end+1) = f;
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Go', 'Position', [10 10 60 28]);
            zef_ui_interact(f);
            zef_ui_interact(f);
            testCase.verifyTrue(isappdata(f, 'ZefInteractBound'));
        end

        function unifiedShellResizesWithoutOverlap(testCase)
            sizes = {[40 40 1024 682], [40 40 1280 820], [40 40 980 640], ...
                [40 40 1100 720], [40 40 1400 900]};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                f.Tag = 'figure_tool';
                zef_ui_shell('build', f);
                zef_figure_tool_layout(f);
                nav = findall(f, 'Tag', 'zef_shell_nav');
                sidebar = findall(f, 'Tag', 'figure_sidebar');
                ax = findall(f, 'Tag', 'axes1');
                lists = findall(f, 'Tag', 'figure_lists');
                header = findall(f, 'Tag', 'zef_shell_header');
                footer = findall(f, 'Tag', 'zef_shell_footer');
                axp = local_plot_box(ax);
                testCase.verifyGreaterThanOrEqual(nav.Position(2), footer.Position(4) - 1);
                testCase.verifyLessThanOrEqual(nav.Position(2) + nav.Position(4), ...
                    header.Position(2) - 6);
                testCase.verifyGreaterThanOrEqual(axp(1), nav.Position(1) + nav.Position(3) - 2);
                testCase.verifyLessThanOrEqual(axp(1) + axp(3), ...
                    sidebar.Position(1) + 2);
                testCase.verifyGreaterThanOrEqual(lists.Position(2), footer.Position(4) - 2);
                testCase.verifyGreaterThanOrEqual(sidebar.Position(2), 0);
                sl = findall(f, 'Tag', 'slider');
                testCase.verifyGreaterThanOrEqual(sl(1).Position(4), 16);
                play = findall(f, 'Tag', 'playbutton');
                testCase.verifyGreaterThanOrEqual(play.Position(2), 0);
            end
        end

        function defaultWidthShowsToolbarLabels(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            keys = {'pan', 'rotate', 'zoom', 'zoomout', 'reset', 'screenshot', ...
                'colormap', 'measure', 'annotate', 'edges'};
            sl = findall(f, 'Tag', 'zef_tool_sliders');
            testCase.verifyNotEmpty(sl);
            for i = 1:numel(keys)
                lab = findall(f, 'Tag', ['zef_tool_lab_' keys{i}]);
                testCase.verifyNotEmpty(lab, keys{i});
                testCase.verifyEqual(char(lab(1).Visible), 'on', keys{i});
                right = lab(1).Position(1) + lab(1).Position(3);
                testCase.verifyLessThanOrEqual(right, sl(1).Position(1) - 1, keys{i});
            end
            logo = findall(f, 'Tag', 'zef_shell_header_logo');
            testCase.verifyNotEmpty(logo);
            testCase.verifyGreaterThan(logo(1).Position(3), logo(1).Position(4));
            testCase.verifyGreaterThanOrEqual(logo(1).Position(4), 18);
            testCase.verifyEqual(size(logo(1).CData, 1), round(logo(1).Position(4)), 'AbsTol', 1);
            testCase.verifyEqual(size(logo(1).CData, 2), round(logo(1).Position(3)), 'AbsTol', 1);
            old_h = logo(1).Position(4);
            f.Position = [40 40 1600 900];
            zef_figure_tool_layout(f);
            logo = findall(f, 'Tag', 'zef_shell_header_logo');
            testCase.verifyGreaterThanOrEqual(logo(1).Position(4), old_h);
            testCase.verifyEqual(size(logo(1).CData, 1), round(logo(1).Position(4)), 'AbsTol', 1);
            testCase.verifyEqual(size(logo(1).CData, 2), round(logo(1).Position(3)), 'AbsTol', 1);
        end

        function sidebarLabelsUseSharedWidth(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            lab = findall(f, 'Tag', 'label_time');
            rec = findall(f, 'Tag', 'label_transp_rec');
            testCase.verifyNotEmpty(lab);
            testCase.verifyGreaterThanOrEqual(lab(1).Position(3), 100);
            if ~isempty(rec)
                testCase.verifyGreaterThanOrEqual(rec(1).Position(3), 100);
                testCase.verifyEqual(rec(1).Position(3), lab(1).Position(3), 'AbsTol', 1);
            end
            dt = findall(f, 'Tag', 'status_details_text');
            pill = findall(f, 'Tag', 'status_ready_pill');
            lab = findall(f, 'Tag', 'label_details');
            if ~isempty(pill)
                testCase.verifyEqual(char(pill(1).Visible), 'on');
            end
            if ~isempty(lab) && ~isempty(pill)
                mid_lab = lab(1).Position(2) + lab(1).Position(4) / 2;
                mid_pill = pill(1).Position(2) + pill(1).Position(4) / 2;
                testCase.verifyEqual(mid_pill, mid_lab, 'AbsTol', 8);
            elseif ~isempty(dt) && ~isempty(pill)
                top_dt = dt(1).Position(2) + dt(1).Position(4);
                top_pill = pill(1).Position(2) + pill(1).Position(4);
                testCase.verifyGreaterThanOrEqual(top_pill, top_dt - 8);
            end
        end

        function figureListsInspectorKeepsDynamicCountsAndReady(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            ls = findall(f, 'Tag', 'figure_lists');
            uicontrol(ls, 'Style', 'text', 'Tag', 'label_compartments', ...
                'String', 'Compartments', 'Position', [10 140 120 18]);
            uicontrol(ls, 'Style', 'text', 'Tag', 'label_sensors', ...
                'String', 'Sensors', 'Position', [170 140 80 18]);
            uicontrol(ls, 'Style', 'text', 'Tag', 'label_details', ...
                'String', 'Details', 'Position', [330 140 80 18]);
            uicontrol(ls, 'Style', 'text', 'Tag', 'status_compartments_count', ...
                'String', '6', 'Position', [130 140 28 18]);
            uicontrol(ls, 'Style', 'text', 'Tag', 'status_sensors_count', ...
                'String', '8', 'Position', [250 140 28 18]);
            uicontrol(ls, 'Style', 'text', 'Tag', 'status_sep_1', 'String', '');
            uicontrol(ls, 'Style', 'text', 'Tag', 'status_sep_2', 'String', '');
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            cnt = findall(f, 'Tag', 'status_compartments_count');
            testCase.verifyEqual(char(cnt(1).String), '6');
            testCase.verifyEqual(char(cnt(1).Visible), 'on');
            sc = findall(f, 'Tag', 'status_sensors_count');
            testCase.verifyEqual(char(sc(1).String), '8');
            lab = findall(f, 'Tag', 'label_compartments');
            testCase.verifyEqual(strtrim(char(lab(1).String)), 'Compartments');
            pill = findall(f, 'Tag', 'status_ready_pill');
            det = findall(f, 'Tag', 'label_details');
            testCase.verifyEqual(char(pill(1).Visible), 'on');
            mid_pill = pill(1).Position(2) + pill(1).Position(4) / 2;
            mid_det = det(1).Position(2) + det(1).Position(4) / 2;
            testCase.verifyEqual(mid_pill, mid_det, 'AbsTol', 8);
            dlab = findall(f, 'Tag', 'status_dlab_1');
            dval = findall(f, 'Tag', 'status_dval_1');
            testCase.verifyNotEmpty(dlab);
            testCase.verifyEqual(char(dlab(1).Visible), 'on');
            testCase.verifyNotEmpty(dval);
            testCase.verifyGreaterThan(dval(1).Position(1), dlab(1).Position(1));
            f.Position(3) = 980;
            zef_figure_tool_layout(f);
            lab2 = findall(f, 'Tag', 'label_details');
            pill2 = findall(f, 'Tag', 'status_ready_pill');
            testCase.verifyGreaterThan(pill2(1).Position(1), lab2(1).Position(1) + lab2(1).Position(3) - 1);
            f.Position(3) = 1400;
            zef_figure_tool_layout(f);
            sep = findall(f, 'Tag', 'status_sep_1');
            sep2 = findall(f, 'Tag', 'status_sep_2');
            testCase.verifyGreaterThan(sep2(1).Position(1), sep(1).Position(1));
            theme = zef_ui_theme();
            lists = findall(f, 'Tag', 'figure_lists');
            testCase.verifyEqual(lists(1).Position(4), theme.space.statusH, 'AbsTol', 1);
            zef_figure_tool_layout(f);
            testCase.verifyEqual(lists(1).Position(4), theme.space.statusH, 'AbsTol', 1);
            dt = findall(f, 'Tag', 'status_details_text');
            testCase.verifyEqual(char(dt(1).Visible), 'off');
            testCase.verifyLessThanOrEqual(max(dt(1).Position(3:4)), 2);
        end

        function flyoutWidensForLongMenuLabels(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Inverse Tools');
            uimenu(root, 'Text', ...
                'Standardized Hierarchical L1 MAP Inversion (quadprog)', ...
                'MenuSelectedFcn', @(~, ~) disp(''));
            uimenu(root, 'Text', 'RAMUS Inversion', ...
                'MenuSelectedFcn', @(~, ~) disp(''));
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_inverse');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            testCase.verifyGreaterThanOrEqual(fly(1).Position(3), 360);
            testCase.verifyLessThanOrEqual(fly(1).Position(3), 480);
        end

        function layoutDismissesOpenFlyout(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            uimenu(root, 'Text', 'Open project', 'MenuSelectedFcn', @(~, ~) disp(''));
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_project');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            zef_ui_shell('layout', f);
            fly2 = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyEmpty(fly2);
        end

        function escapeDismissesOpenFlyout(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            uimenu(root, 'Text', 'Open project', 'MenuSelectedFcn', @(~, ~) disp(''));
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_project');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            kcb = f.WindowKeyPressFcn;
            testCase.verifyNotEmpty(kcb);
            kcb(f, struct('Key', 'escape', 'Character', char(27), 'Modifier', {{}}));
            fly2 = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyEmpty(fly2);
        end

        function escapeDismissesNestedFlyoutOneLevel(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Window');
            tools = uimenu(root, 'Text', 'Tools');
            uimenu(tools, 'Text', 'Tile');
            uimenu(tools, 'Text', 'Maximize tools');
            uimenu(root, 'Text', 'Reset windows');
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_window');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            items = findall(fly, 'Style', 'text');
            sub = [];
            for i = 1:numel(items)
                if contains(char(string(items(i).String)), 'Tools')
                    sub = items(i);
                    break
                end
            end
            testCase.verifyNotEmpty(sub);
            sub.Callback(sub, []);
            nested = findall(f, 'Tag', 'zef_shell_flyout_2');
            testCase.verifyNotEmpty(nested);
            kcb = f.WindowKeyPressFcn;
            kcb(f, struct('Key', 'escape', 'Character', char(27), 'Modifier', {{}}));
            testCase.verifyEmpty(findall(f, 'Tag', 'zef_shell_flyout_2'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_shell_flyout'));
            kcb(f, struct('Key', 'escape', 'Character', char(27), 'Modifier', {{}}));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_shell_flyout'));
        end

        function siblingSubmenuClosesDeeperFlyout(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Window');
            tools = uimenu(root, 'Text', 'Tools');
            tile = uimenu(tools, 'Text', 'Tile');
            uimenu(tile, 'Text', 'Left');
            uimenu(tile, 'Text', 'Right');
            figs = uimenu(root, 'Text', 'Figures');
            uimenu(figs, 'Text', 'Maximize');
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_window');
            setappdata(btn, 'ZefMenuHandle', root);
            btn.Callback(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            items = findall(fly, 'Style', 'text');
            tools_item = [];
            figs_item = [];
            for i = 1:numel(items)
                s = char(string(items(i).String));
                if contains(s, 'Tools')
                    tools_item = items(i);
                elseif contains(s, 'Figures')
                    figs_item = items(i);
                end
            end
            testCase.verifyNotEmpty(tools_item);
            testCase.verifyNotEmpty(figs_item);
            tools_item.Callback(tools_item, []);
            nested = findall(f, 'Tag', 'zef_shell_flyout_2');
            testCase.verifyNotEmpty(nested);
            tile_item = [];
            nitems = findall(nested, 'Style', 'text');
            for i = 1:numel(nitems)
                if contains(char(string(nitems(i).String)), 'Tile')
                    tile_item = nitems(i);
                    break
                end
            end
            testCase.verifyNotEmpty(tile_item);
            tile_item.Callback(tile_item, []);
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_shell_flyout_3'));
            figs_item.Callback(figs_item, []);
            testCase.verifyEmpty(findall(f, 'Tag', 'zef_shell_flyout_3'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_shell_flyout_2'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_shell_flyout'));
        end

        function flyoutStaysInsideFigure(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            uimenu(root, 'Text', 'Open project');
            f = local_figure_tool_fixture(testCase, [40 40 720 520]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_shell_theme'));
            btn = findall(f, 'Tag', 'zef_nav_project');
            testCase.verifyNotEmpty(btn);
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, '-regexp', 'Tag', '^zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            p = fly(1).Position;
            testCase.verifyGreaterThanOrEqual(p(1), 4);
            testCase.verifyLessThanOrEqual(p(1) + p(3), f.Position(3) + 1);
            testCase.verifyGreaterThanOrEqual(p(2), 0);
        end

        function layoutRemovesLegacyThemeControls(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1024 682]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            header = findall(f, 'Tag', 'zef_shell_header');
            leftover = uicontrol(header, 'Style', 'pushbutton', ...
                'Tag', 'zef_shell_theme_pill', 'String', 'Theme');
            zef_ui_shell('theme', f);
            testCase.verifyFalse(isvalid(leftover));
            testCase.verifyEmpty(findall(f, '-regexp', 'Tag', '^zef_shell_theme'));
        end

        function placeWindowMovesDefaultOriginBesideSession(testCase)
            main = figure('Visible', 'off', 'Tag', 'figure_tool', ...
                'Name', 'ZEFFIRO Interface: Figure tool', 'MenuBar', 'none', ...
                'Position', [-420 180 900 600]);
            testCase.Figures(end+1) = main;
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: System settings', ...
                'Position', [100 100 420 220]);
            testCase.Figures(end+1) = f;
            zef_ui_place_window(f);
            still_default = abs(f.Position(1) - 100) < 10 && abs(f.Position(2) - 100) < 10;
            testCase.verifyFalse(still_default);
            testCase.verifyLessThan(abs(f.Position(1) - main.Position(1)), ...
                abs(100 - main.Position(1)) + 1);
        end

        function placeWindowUnstacksDuplicateOrigin(testCase)
            main = figure('Visible', 'off', 'Tag', 'figure_tool', ...
                'Name', 'ZEFFIRO Interface: Figure tool', 'MenuBar', 'none', ...
                'Position', [-420 180 900 600]);
            testCase.Figures(end+1) = main;
            f1 = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: System settings', ...
                'Position', [100 100 420 220]);
            testCase.Figures(end+1) = f1;
            f2 = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Plugin settings', ...
                'Position', [100 100 420 220]);
            testCase.Figures(end+1) = f2;
            zef_ui_place_window(f1);
            zef_ui_place_window(f2);
            testCase.verifyGreaterThan(abs(f2.Position(1) - f1.Position(1)) ...
                + abs(f2.Position(2) - f1.Position(2)), 16);
            testCase.verifyFalse(abs(f1.Position(1) - 100) < 10 ...
                && abs(f1.Position(2) - 100) < 10);
        end

        function formDialogPairsLabelsAboveFields(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 420 380], ...
                'Name', 'ZEFFIRO Interface: Graphics processing options');
            testCase.Figures(end+1) = f;
            lab = uilabel(f, 'Text', 'Colormap size:', 'Position', [20 300 140 22]);
            uieditfield(f, 'Position', [180 240 80 22]);
            uilabel(f, 'Text', 'Streamline width:', 'Position', [20 200 140 22]);
            uieditfield(f, 'Position', [180 140 80 22]);
            uilabel(f, 'Text', 'Cone scale:', 'Position', [20 100 140 22]);
            uieditfield(f, 'Position', [180 40 80 22]);
            uibutton(f, 'Text', 'Apply');
            zef_layout_form_dialog(f);
            testCase.verifyTrue(strcmpi(char(lab.Visible), 'on'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_ui_root'));
        end

        function interactPointerIsHandOnInactiveNav(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'Position', [40 40 320 200]);
            testCase.Figures(end+1) = f;
            nav = uicontrol(f, 'Style', 'text', 'Enable', 'inactive', ...
                'Tag', 'zef_nav_project', 'String', 'Project', ...
                'Position', [20 80 100 24], 'ButtonDownFcn', @(s, e) []);
            zef_ui_interact(f);
            zef_ui_interact(f, 'motion', nav);
            testCase.verifyEqual(char(f.Pointer), 'hand');
        end

        function interactPointerIsIbeamOnEdit(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'Position', [40 40 320 200]);
            testCase.Figures(end+1) = f;
            ed = uicontrol(f, 'Style', 'edit', 'String', '1', 'Position', [20 80 80 24]);
            zef_ui_interact(f);
            zef_ui_interact(f, 'motion', ed);
            testCase.verifyEqual(char(f.Pointer), 'ibeam');
        end

        function panToolShowsActiveFill(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            pan = findall(f, 'Tag', 'zef_tool_pan');
            testCase.verifyNotEmpty(pan);
            idle = pan(1).BackgroundColor;
            pan(1).UserData = 1;
            zef_ui_shell('layout', f);
            pan = findall(f, 'Tag', 'zef_tool_pan');
            testCase.verifyFalse(isequal(pan(1).BackgroundColor, idle));
        end

        function parcellationLayoutEnforcesMinHeight(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'Position', [40 40 520 400], ...
                'Name', 'ZEFFIRO Interface: Parcellation tool');
            testCase.Figures(end+1) = f;
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Plot', 'Position', [10 10 60 24]);
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Add ROI', 'Position', [10 40 60 24]);
            zef_layout_parcellation_tool(f);
            f.Position(4) = 400;
            zef_layout_parcellation_tool(f);
            testCase.verifyGreaterThanOrEqual(f.Position(4), 600);
            testCase.verifyGreaterThanOrEqual(f.Position(3), 420);
        end

        function parcellationActivateClearsPlotType(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'Position', [40 40 480 640], ...
                'Name', 'ZEFFIRO Interface: Parcellation tool');
            testCase.Figures(end+1) = f;
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Plot', 'Position', [10 10 60 24]);
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Add ROI', 'Position', [10 40 60 24]);
            uicontrol(f, 'Style', 'pushbutton', 'String', 'Delete ROI', 'Position', [80 40 60 24]);
            uicontrol(f, 'Style', 'togglebutton', 'String', 'Activate', ...
                'Tag', 'h_use_parcellation', 'Position', [200 80 80 24]);
            uicontrol(f, 'Style', 'text', 'String', 'Plot type:', 'Position', [10 50 80 20]);
            zef_layout_parcellation_tool(f);
            theme = zef_ui_theme();
            zef_ui_polish_window(f, theme);
            zef_layout_parcellation_tool(f);
            act = findall(f, 'Tag', 'h_use_parcellation');
            plotlab = findall(f, 'String', 'Plot type:');
            testCase.verifyNotEmpty(act);
            testCase.verifyNotEmpty(plotlab);
            act = act(1);
            plotlab = plotlab(1);
            act.Units = 'pixels';
            plotlab.Units = 'pixels';
            a = act.Position;
            p = plotlab.Position;
            overlap = (a(2) < p(2) + p(4)) && (p(2) < a(2) + a(4)) ...
                && (a(1) < p(1) + p(3)) && (p(1) < a(1) + a(3));
            testCase.verifyFalse(overlap);
            plotbtn = findall(f, 'Style', 'pushbutton', 'String', 'Plot');
            if isempty(plotbtn)
                caps = findall(f, 'Type', 'uicontrol');
                for i = 1:numel(caps)
                    lab = '';
                    try
                        lab = char(getappdata(caps(i), 'ZefButtonLabel'));
                    catch
                    end
                    if strcmp(lab, 'Plot')
                        plotbtn = caps(i);
                        break
                    end
                end
            end
            testCase.verifyNotEmpty(plotbtn);
            plotbtn = plotbtn(1);
            plotbtn.Units = 'pixels';
            testCase.verifyGreaterThanOrEqual(plotbtn.Position(2), 8);
        end

        function menuFlyoutInvokesLiveCallback(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            invoked = false;
            uimenu(root, 'Text', 'Open project', 'MenuSelectedFcn', @(~, ~) ...
                assignin('base', 'zef_ui_shell_test_flag', true));
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_project');
            setappdata(btn, 'ZefMenuHandle', root);
            assignin('base', 'zef_ui_shell_test_flag', false);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            leaf = findall(fly, 'String', '  Open project');
            testCase.verifyNotEmpty(leaf);
            leaf.Callback(leaf(1), []);
            testCase.verifyTrue(evalin('base', 'zef_ui_shell_test_flag'));
            evalin('base', 'clear zef_ui_shell_test_flag');
        end

        function flyoutShowsEveryMenuItem(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            labels = {'New project from profile', 'New empty project', 'Open project', ...
                'Open figure', 'Save', 'Save as...', 'Save figures as...', ...
                'Print figure to file as...', 'Exit'};
            for i = 1:numel(labels)
                uimenu(root, 'Text', labels{i});
            end
            f = local_figure_tool_fixture(testCase, [40 40 1100 720]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_project');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            txt = findall(fly, 'Style', 'text');
            shown = strings(0, 1);
            for i = 1:numel(txt)
                shown(end+1, 1) = strtrim(string(txt(i).String)); %#ok<AGROW>
            end
            testCase.verifyTrue(any(contains(shown, 'Exit')));
            testCase.verifyTrue(any(contains(shown, 'New project from profile')));
            rows = findall(fly, 'Tag', 'zef_fly_item');
            testCase.verifyGreaterThanOrEqual(numel(rows), numel(labels));
            for i = 1:numel(rows)
                testCase.verifyEqual(rows(i).Position(1), 8, 'AbsTol', 1);
                testCase.verifyGreaterThanOrEqual(rows(i).Position(3), fly(1).Position(3) - 24);
                rgb = local_menu_chip_cdata(rows(i), 'zef_fly_bg');
                testCase.verifyEqual(size(rgb, 2), round(rows(i).Position(3)), 'AbsTol', 1);
                testCase.verifyEqual(size(rgb, 1), round(rows(i).Position(4)), 'AbsTol', 1);
            end
        end

        function flyoutHidesToolbarSoButtonsDoNotPunchThrough(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Project');
            uimenu(root, 'Text', 'Open project');
            f = local_figure_tool_fixture(testCase, [40 40 1000 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            pan = findall(f, 'Tag', 'zef_tool_pan');
            testCase.assumeNotEmpty(pan);
            testCase.verifyEqual(char(pan(1).Visible), 'on');
            ax = findall(f, 'Tag', 'axes1');
            testCase.assumeNotEmpty(ax);
            imh = image(ax(1), rand(6, 8, 3));
            imh.Tag = 'zef_logo_img';
            n_kids = numel(allchild(ax(1)));
            btn = findall(f, 'Tag', 'zef_nav_project');
            setappdata(btn, 'ZefMenuHandle', root);
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            testCase.verifyEqual(char(pan(1).Visible), 'off');
            view = findall(f, 'Tag', 'figure_view');
            if ~isempty(view)
                testCase.verifyEqual(char(view(1).Visible), 'on');
            end
            testCase.verifyEqual(char(ax(1).Visible), 'on');
            testCase.verifyTrue(isvalid(imh));
            testCase.verifyEqual(numel(allchild(ax(1))), n_kids);
            zef_ui_shell('dismiss', f);
            testCase.verifyEqual(char(pan(1).Visible), 'on');
            if ~isempty(view)
                testCase.verifyEqual(char(view(1).Visible), 'on');
            end
            testCase.verifyEqual(char(ax(1).Visible), 'on');
            testCase.verifyTrue(isvalid(imh));
            testCase.verifyEqual(numel(allchild(ax(1))), n_kids);
        end

        function flyoutOverflowKeepsThemedItems(testCase)
            menuFig = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool');
            testCase.Figures(end+1) = menuFig;
            root = uimenu(menuFig, 'Text', 'Inverse Tools');
            invoked = '';
            for i = 1:20
                lab = sprintf('Plugin %02d', i);
                uimenu(root, 'Text', lab, 'MenuSelectedFcn', @(~, ~) ...
                    assignin('base', 'zef_ui_shell_overflow', lab));
            end
            f = local_figure_tool_fixture(testCase, [40 40 1100 520]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            btn = findall(f, 'Tag', 'zef_nav_inverse');
            setappdata(btn, 'ZefMenuHandle', root);
            assignin('base', 'zef_ui_shell_overflow', '');
            cb = btn.Callback;
            cb(btn, []);
            fly = findall(f, 'Tag', 'zef_shell_flyout');
            testCase.verifyNotEmpty(fly);
            testCase.verifyEmpty(findall(fly, 'Style', 'listbox'));
            leaf = findall(fly, 'String', '  Plugin 01');
            testCase.verifyNotEmpty(leaf);
            sl = findall(fly, 'Tag', 'zef_shell_flyout_slider');
            testCase.verifyNotEmpty(sl);
            leaf(1).Callback(leaf(1), []);
            testCase.verifyEqual(char(evalin('base', 'zef_ui_shell_overflow')), 'Plugin 01');
            evalin('base', 'clear zef_ui_shell_overflow');
        end

        function disabledRoundButtonCaptionDoesNotFire(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Color', theme.color.bg, 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            assignin('base', 'zef_round_fire', false);
            b = uicontrol(f, 'Style', 'pushbutton', 'String', 'Apply', ...
                'Tag', 'applybutton', 'Position', [20 20 88 28], 'Enable', 'off', ...
                'Callback', @(~, ~) assignin('base', 'zef_round_fire', true));
            zef_ui_round_button(b, theme, false);
            cap = findall(f, 'Tag', 'applybutton_cap');
            testCase.verifyNotEmpty(cap);
            cap(1).ButtonDownFcn(cap(1), []);
            testCase.verifyFalse(evalin('base', 'zef_round_fire'));
            evalin('base', 'clear zef_round_fire');
        end

        function interactBindSkipsUIFigureMotion(testCase)
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Settings');
            testCase.Figures(end+1) = f;
            zef_ui_interact(f);
            testCase.verifyTrue(isappdata(f, 'ZefInteractBound'));
            testCase.verifyFalse(isappdata(f, 'ZefInteractMotion'));
        end

        function interactPointerIsHandOnUIFigureButton(testCase)
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Settings');
            testCase.Figures(end+1) = f;
            b = uibutton(f, 'Text', 'Apply', 'Position', [20 20 80 28]);
            zef_ui_interact(f);
            zef_ui_interact(f, 'motion', b);
            testCase.verifyEqual(char(f.Pointer), 'hand');
        end

        function themeExposesTableAndStateTokens(testCase)
            theme = zef_ui_theme();
            testCase.verifyEqual(theme.color.tableRow, [1 1 1], 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.surface, theme.color.panel, 'AbsTol', 1e-6);
            testCase.verifyEqual(theme.color.error, theme.color.danger, 'AbsTol', 1e-6);
            testCase.verifyGreaterThan(theme.color.bg(1), 0.9);
            testCase.verifyLessThan(theme.color.text(1), 0.3);
            testCase.verifyEqual(theme.color.borderSubtle, theme.color.hairline, 'AbsTol', 1e-6);
            testCase.verifyLessThan(max(theme.color.buttonBorder), 0.80);
            testCase.verifyGreaterThan(min(theme.color.button - theme.color.buttonBorder), 0.20);
            testCase.verifyLessThan(theme.color.buttonBorderPrimary, theme.color.primary);
            testCase.verifyEqual(theme.space.btnStroke, 1);
        end

        function applyThemePaintsTableFromTokens(testCase)
            theme = zef_ui_theme();
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Table fixture');
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {1; 2; 3}, 'ColumnName', {'Value'});
            zef_ui_apply_theme(f, theme);
            bg = t.BackgroundColor;
            testCase.verifyEqual(bg(1, :), theme.color.tableRow, 'AbsTol', 1e-6);
            if size(bg, 1) > 1
                testCase.verifyEqual(bg(2, :), theme.color.tableAlt, 'AbsTol', 1e-6);
            end
        end

        function broadcastThemeRestylesOpenWindows(testCase)
            old_zef = [];
            had_zef = evalin('base', 'exist(''zef'',''var'')');
            if had_zef
                old_zef = evalin('base', 'zef');
            end
            testCase.addTeardown(@() local_restore_zef(had_zef, old_zef));
            assignin('base', 'zef', struct('ui_color_mode', 'dark', 'font_size', 12));
            f = figure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Settings', ...
                'Color', [1 0 0], 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            b = uicontrol(f, 'Style', 'pushbutton', 'String', 'Reset', ...
                'Position', [10 10 80 28]);
            zef_ui_broadcast_theme();
            theme = zef_ui_theme();
            testCase.verifyEqual(theme.mode, 'light');
            testCase.verifyEqual(f.Color, theme.color.bg, 'AbsTol', 1e-6);
            testCase.verifyEqual(b.BackgroundColor, theme.color.button, 'AbsTol', 1e-6);
            testCase.verifyGreaterThan(theme.color.bg(1), 0.9);
        end

        function confirmDialogUsesThemeAndPrimaryYes(testCase)
            [choice, fig] = zef_ui_confirm('Reset all?', 'Wait', false);
            testCase.Figures(end+1) = fig;
            testCase.verifyEqual(choice, 'No');
            testCase.verifyTrue(isgraphics(fig) && isvalid(fig));
            testCase.verifyEqual(char(fig.Name), 'ZEFFIRO Interface: Confirm');
            theme = zef_ui_theme();
            testCase.verifyEqual(fig.Color, theme.color.bg, 'AbsTol', 1e-6);
            yes = findall(fig, 'Tag', 'zef_confirm_yes');
            no = findall(fig, 'Tag', 'zef_confirm_no');
            testCase.verifyNotEmpty(yes);
            testCase.verifyNotEmpty(no);
            testCase.verifyEqual(yes(1).BackgroundColor, theme.color.primary, 'AbsTol', 1e-3);
            testCase.verifyTrue(isappdata(fig, 'ZefUiThemed'));
            testCase.verifyEqual(char(fig.Visible), 'on');
        end

        function readyNewWindowsThemesUnthemedFigures(testCase)
            theme = zef_ui_theme();
            f = figure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Filter tool', ...
                'Color', [1 0 0], 'MenuBar', 'none');
            testCase.Figures(end+1) = f;
            testCase.verifyFalse(isappdata(f, 'ZefUiThemed'));
            zef_ui_ready_new_windows();
            testCase.verifyTrue(isappdata(f, 'ZefUiThemed'));
            testCase.verifyEqual(f.Color, theme.color.bg, 'AbsTol', 1e-6);
            zef_ui_ready_new_windows();
            testCase.verifyTrue(isappdata(f, 'ZefUiThemed'));
        end

        function adoptAppRenamesAndThemesMatlabApp(testCase)
            f = uifigure('Visible', 'off', 'Name', 'MATLAB App', 'Color', [1 0 0]);
            testCase.Figures(end+1) = f;
            zef_ui_adopt_app(f, 'ZEFFIRO Interface: MUSIC');
            testCase.verifyEqual(char(f.Name), 'ZEFFIRO Interface: MUSIC');
            testCase.verifyTrue(isappdata(f, 'ZefUiThemed'));
            theme = zef_ui_theme();
            testCase.verifyEqual(f.Color, theme.color.bg, 'AbsTol', 1e-6);
            testCase.verifyGreaterThanOrEqual(f.Position(3), 500);
        end

        function guideFormCompactsSparseLabelFieldWindow(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'ToolBar', 'none', ...
                'Name', 'ZEFFIRO Interface: Gaussian Mixture Model tool', ...
                'Color', [0.94 0.94 0.94], 'Position', [80 80 520 438]);
            testCase.Figures(end+1) = f;
            labels = {'Maximum number of clusters:', 'Credibility (relative):', ...
                'Dynamic levels:', 'Regularization parameter:'};
            for i = 1:numel(labels)
                y = 0.88 - (i - 1) * 0.11;
                uicontrol(f, 'Style', 'text', 'Units', 'normalized', ...
                    'String', labels{i}, 'Position', [0.05 y 0.5 0.07], ...
                    'HorizontalAlignment', 'left');
                uicontrol(f, 'Style', 'edit', 'Units', 'normalized', ...
                    'String', '1', 'Position', [0.8 y 0.15 0.07]);
            end
            uicontrol(f, 'Style', 'pushbutton', 'Units', 'normalized', ...
                'String', 'Run', 'Position', [0.8 0.03 0.15 0.1]);
            zef_layout_guide_window(f);
            testCase.verifyLessThan(f.Position(3), 480);
            edits = findall(f, 'Style', 'edit');
            testCase.verifyGreaterThanOrEqual(numel(edits), 4);
            xs = zeros(numel(edits), 1);
            for i = 1:numel(edits)
                edits(i).Units = 'pixels';
                xs(i) = edits(i).Position(1);
            end
            testCase.verifyLessThan(max(xs) - min(xs), 4);
            testCase.verifyLessThan(min(xs), 280);
        end

        function guideFormGrowsFieldsNotButtons(testCase)
            f = figure('Visible', 'off', 'MenuBar', 'none', 'ToolBar', 'none', ...
                'Name', 'ZEFFIRO Interface: Gaussian Mixture Model tool', ...
                'Color', [0.94 0.94 0.94], 'Position', [80 80 520 438]);
            testCase.Figures(end+1) = f;
            labels = {'Maximum number of clusters:', 'Credibility (relative):', ...
                'Dynamic levels:', 'Regularization parameter:'};
            for i = 1:numel(labels)
                y = 0.88 - (i - 1) * 0.11;
                uicontrol(f, 'Style', 'text', 'Units', 'normalized', ...
                    'String', labels{i}, 'Position', [0.05 y 0.5 0.07], ...
                    'HorizontalAlignment', 'left');
                uicontrol(f, 'Style', 'edit', 'Units', 'normalized', ...
                    'String', '1', 'Position', [0.8 y 0.15 0.07]);
            end
            uicontrol(f, 'Style', 'pushbutton', 'Units', 'normalized', ...
                'String', 'Run', 'Position', [0.8 0.03 0.15 0.1]);
            zef_layout_guide_window(f);
            edits = findall(f, 'Style', 'edit');
            btns = findall(f, 'Style', 'pushbutton');
            edits(1).Units = 'pixels';
            btns(1).Units = 'pixels';
            w0 = edits(1).Position(3);
            bw0 = btns(1).Position(3);
            y0 = btns(1).Position(2);
            f.Position(3) = f.Position(3) + 220;
            f.Position(4) = f.Position(4) + 80;
            fcn = f.SizeChangedFcn;
            if isa(fcn, 'function_handle')
                fcn(f, struct());
            end
            drawnow;
            edits(1).Units = 'pixels';
            btns(1).Units = 'pixels';
            testCase.verifyGreaterThan(edits(1).Position(3), w0);
            testCase.verifyLessThanOrEqual(edits(1).Position(3), 320);
            testCase.verifyEqual(btns(1).Position(3), bw0);
            testCase.verifyLessThanOrEqual(btns(1).Position(2), y0);
        end

        function formDialogButtonsStayCompactWhenWide(testCase)
            f = uifigure('Visible', 'off', 'Position', [80 80 420 420], ...
                'Name', 'ZEFFIRO Interface: MUSIC');
            testCase.Figures(end+1) = f;
            for i = 1:4
                y = 320 - (i - 1) * 40;
                uilabel(f, 'Text', sprintf('Parameter %d:', i), 'Position', [20 y 140 22]);
                uieditfield(f, 'Position', [180 y 80 22]);
            end
            b1 = uibutton(f, 'Text', 'Close');
            b2 = uibutton(f, 'Text', 'Start');
            zef_layout_form_dialog(f);
            root = findall(f, 'Tag', 'zef_ui_root');
            testCase.verifyNotEmpty(root);
            % The dialog is sized to its content, so every row resolves to
            % 'fit'. That is what keeps the footer from stretching, so assert
            % it rather than looking for a weighted 'x' row: a flexible row
            % here would mean the dialog had been inflated past its content.
            rh = root(1).RowHeight;
            testCase.verifyNotEmpty(rh);
            for i = 1:numel(rh)
                if ischar(rh{i}) || isstring(rh{i})
                    testCase.verifyEqual(char(rh{i}), 'fit');
                end
            end
            f.Position(3:4) = [f.Position(3) + 280, f.Position(4) + 120];
            drawnow;
            testCase.verifyLessThanOrEqual(b1.Position(3), 120);
            testCase.verifyLessThanOrEqual(b2.Position(3), 120);
        end

        function figureToolSidebarFooterTracksBottomOnResize(testCase)
            sizes = {[40 40 900 720], [40 40 760 580], [40 40 1100 820], ...
                [40 40 880 900], [40 40 1200 646], [40 40 1400 1000], ...
                [40 40 1000 540], [40 40 700 640]};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                zef_figure_tool_layout(f);
                sidebar = findall(f, 'Tag', 'figure_sidebar');
                play = findall(f, 'Tag', 'playbutton');
                tgb = findall(f, 'Tag', 'togglecontrolsbutton');
                scale = findall(f, 'Tag', 'colorscaleselection');
                testCase.verifyLessThanOrEqual(play(1).Position(2), 16, ...
                    mat2str(sizes{s}(3:4)));
                testCase.verifyGreaterThanOrEqual(play(1).Position(2), 6, ...
                    mat2str(sizes{s}(3:4)));
                testCase.verifyLessThan(play(1).Position(2), 0.15 * sidebar.Position(4), ...
                    mat2str(sizes{s}(3:4)));
                host = findall(f, 'Tag', 'figure_toggle_host');
                testCase.verifyNotEmpty(host, mat2str(sizes{s}(3:4)));
                hp = host(1).Position;
                sp = sidebar.Position;
                testCase.verifyGreaterThan(hp(2) + hp(4), sp(2) + sp(4) - 56, ...
                    mat2str(sizes{s}(3:4)));
                testCase.verifyEqual(char(tgb(1).Parent.Tag), 'figure_toggle_host');
                testCase.verifyGreaterThan(scale(1).Position(2), ...
                    play(1).Position(2) + play(1).Position(4) - 2, ...
                    mat2str(sizes{s}(3:4)));
            end
        end

        function unifiedShellSidebarFillsColumn(testCase)
            theme = zef_ui_theme();
            sizes = {[40 40 1200 646], [40 40 1200 820], [40 40 980 640], ...
                [40 40 1400 900], [40 40 1100 720], [40 40 1600 1000]};
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                f.Tag = 'figure_tool';
                zef_ui_shell('build', f);
                zef_figure_tool_layout(f);
                sidebar = findall(f, 'Tag', 'figure_sidebar');
                header = findall(f, 'Tag', 'zef_shell_header');
                play = findall(f, 'Tag', 'playbutton');
                tgb = findall(f, 'Tag', 'togglecontrolsbutton');
                testCase.verifyEqual(sidebar.Position(2), ...
                    theme.space.footerH + theme.space.cardGap, 'AbsTol', 2);
                top_gap = header.Position(2) - (sidebar.Position(2) + sidebar.Position(4));
                testCase.verifyGreaterThanOrEqual(top_gap, 6, mat2str(sizes{s}(3:4)));
                testCase.verifyLessThanOrEqual(top_gap, 20, mat2str(sizes{s}(3:4)));
                testCase.verifyLessThanOrEqual(play(1).Position(2), ...
                    theme.space.cardRadius + 8, mat2str(sizes{s}(3:4)));
                testCase.verifyGreaterThanOrEqual(play(1).Position(2), 6, ...
                    mat2str(sizes{s}(3:4)));
                host = findall(f, 'Tag', 'figure_toggle_host');
                testCase.verifyNotEmpty(host, mat2str(sizes{s}(3:4)));
                hp = host(1).Position;
                sp = sidebar.Position;
                testCase.verifyGreaterThan(hp(2) + hp(4), sp(2) + sp(4) - 56, ...
                    mat2str(sizes{s}(3:4)));
                testCase.verifyEqual(char(tgb(1).Parent.Tag), 'figure_toggle_host');
            end
        end

        function unifiedShellSeparatesCardsFromHeaderOnResize(testCase)
            sizes = {[40 40 980 620], [40 40 1200 646], [40 40 1400 900], ...
                [40 40 1600 1000]};
            gaps = zeros(1, numel(sizes));
            for s = 1:numel(sizes)
                f = local_figure_tool_fixture(testCase, sizes{s});
                f.Tag = 'figure_tool';
                zef_ui_shell('build', f);
                zef_figure_tool_layout(f);
                header = findall(f, 'Tag', 'zef_shell_header');
                nav = findall(f, 'Tag', 'zef_shell_nav');
                sidebar = findall(f, 'Tag', 'figure_sidebar');
                work = findall(f, 'Tag', 'zef_shell_card');
                hb = header.Position(2);
                g_nav = hb - (nav.Position(2) + nav.Position(4));
                g_side = hb - (sidebar.Position(2) + sidebar.Position(4));
                g_card = hb - (work.Position(2) + work.Position(4));
                testCase.verifyGreaterThanOrEqual(g_nav, 8, mat2str(sizes{s}(3:4)));
                testCase.verifyLessThanOrEqual(g_nav, 20, mat2str(sizes{s}(3:4)));
                testCase.verifyEqual(g_side, g_nav, 'AbsTol', 2, mat2str(sizes{s}(3:4)));
                testCase.verifyEqual(g_card, g_nav, 'AbsTol', 2, mat2str(sizes{s}(3:4)));
                gaps(s) = g_nav;
            end
            testCase.verifyGreaterThan(gaps(end), gaps(1));
            f = local_figure_tool_fixture(testCase, [40 40 1200 646]);
            f.Tag = 'figure_tool';
            zef_ui_shell('build', f);
            zef_figure_tool_layout(f);
            header = findall(f, 'Tag', 'zef_shell_header');
            nav = findall(f, 'Tag', 'zef_shell_nav');
            compact = header.Position(2) - (nav.Position(2) + nav.Position(4));
            f.Position = [40 40 1600 1000];
            zef_figure_tool_layout(f);
            header = findall(f, 'Tag', 'zef_shell_header');
            nav = findall(f, 'Tag', 'zef_shell_nav');
            grown = header.Position(2) - (nav.Position(2) + nav.Position(4));
            testCase.verifyGreaterThan(grown, compact);
        end

        function shellInstallsWheelHandlerAtBuild(testCase)
            f = local_figure_tool_fixture(testCase, [40 40 900 640]);
            zef_ui_shell('build', f);
            fcn = get(f, 'WindowScrollWheelFcn');
            testCase.verifyTrue(isa(fcn, 'function_handle'));
        end

        function fitTableUnitsAndRefAreCompact(testCase)
            f = uifigure('Visible', 'off', 'Position', [40 40 720 280]);
            testCase.Figures(end+1) = f;
            t = uitable(f, 'Data', {'Electrical conductivity', 'sigma', 'S/m', 'Segmentation'}, ...
                'ColumnName', {'Description', 'Param', 'Units', 'Reference'}, ...
                'Position', [10 10 700 240]);
            zef_ui_fit_table(t);
            w = t.ColumnWidth;
            testCase.verifyTrue((ischar(w{1}) || isstring(w{1})) && contains(char(string(w{1})), 'x'));
            testCase.verifyTrue(isnumeric(w{3}) && w{3} >= 48 && w{3} <= 64);
            testCase.verifyTrue(isnumeric(w{4}) && w{4} >= 72);
        end

        function interactPointerStaysArrowOnDisabledUIButton(testCase)
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Settings');
            testCase.Figures(end+1) = f;
            b = uibutton(f, 'Text', 'Apply', 'Position', [20 20 80 28], 'Enable', 'off');
            zef_ui_interact(f);
            zef_ui_interact(f, 'motion', b);
            testCase.verifyEqual(char(f.Pointer), 'arrow');
        end

        function applyThemePaintsUiTreeFromTokens(testCase)
            theme = zef_ui_theme();
            f = uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Tree fixture');
            testCase.Figures(end+1) = f;
            tr = uitree(f);
            zef_ui_apply_theme(f, theme);
            testCase.verifyEqual(tr.BackgroundColor, theme.color.panel, 'AbsTol', 1e-6);
            testCase.verifyEqual(tr.FontColor, theme.color.text, 'AbsTol', 1e-6);
        end

    end
end

function pos = local_plot_box(ax)

pos = [0 0 0 0];
if nargin < 1 || isempty(ax) || ~isgraphics(ax) || ~isvalid(ax)
    return
end
try
    u = ax.Units;
    ax.Units = 'pixels';
    pos = ax.InnerPosition;
    ax.Units = u;
catch
    try
        u = ax.Units;
        ax.Units = 'pixels';
        pos = ax.Position;
        ax.Units = u;
    catch
        return
    end
end
p = [];
try
    p = ax.Parent;
catch
end
while ~isempty(p) && isgraphics(p) && isvalid(p)
    typ = '';
    try
        typ = lower(char(p.Type));
    catch
    end
    if strcmp(typ, 'figure')
        break
    end
    try
        u = p.Units;
        p.Units = 'pixels';
        pp = p.Position;
        p.Units = u;
        pos(1) = pos(1) + pp(1);
        pos(2) = pos(2) + pp(2);
    catch
        break
    end
    try
        p = p.Parent;
    catch
        break
    end
end

end

function f = local_figure_tool_fixture(testCase, pos)

f = figure('Visible', 'off', 'Units', 'pixels', ...
    'Position', pos, 'MenuBar', 'none', ...
    'Name', 'ZEFFIRO Interface: Figure tool', ...
    'AutoResizeChildren', 'off');
testCase.Figures(end+1) = f;
sb = uipanel(f, 'Tag', 'figure_sidebar', 'Units', 'pixels', ...
    'Position', [650 200 300 400]);
uipanel(f, 'Tag', 'figure_lists', 'Units', 'pixels', ...
    'Position', [20 12 500 168]);
lists = findall(f, 'Tag', 'figure_lists');
uicontrol(lists, 'Style', 'text', 'Tag', 'status_details_text', ...
    'String', {'Nodes: 0', 'Tetrahedra: 0'}, 'Position', [200 20 160 52]);
uicontrol(lists, 'Style', 'pushbutton', 'Tag', 'status_ready_pill', ...
    'String', '', 'Position', [400 30 78 26]);
uicontrol(lists, 'Style', 'text', 'Tag', 'status_ready', ...
    'String', 'Ready', 'Position', [418 36 50 16]);
uiaxes(f, 'Tag', 'axes1', 'Units', 'pixels', ...
    'Position', [20 200 500 400]);
uicontrol(f, 'Style', 'pushbutton', 'String', 'Toggle controls', ...
    'Tag', 'togglecontrolsbutton', 'UserData', 1, ...
    'Position', [650 600 120 28]);
uicontrol(f, 'Style', 'text', 'String', '', 'Tag', 'time_text', ...
    'Visible', 'on', 'Position', [20 600 240 20]);
uicontrol(sb, 'Style', 'pushbutton', 'String', 'Toggle edges', ...
    'Tag', 'toggleedgesbutton', 'Position', [10 360 120 28]);
uicontrol(sb, 'Style', 'text', 'String', 'Time', 'Tag', 'label_time', ...
    'Position', [10 300 80 20]);
uicontrol(sb, 'Style', 'text', 'String', 'Reconstruction', ...
    'Tag', 'label_transp_rec', 'Position', [10 280 80 20]);
uicontrol(sb, 'Style', 'slider', 'Tag', 'slider', ...
    'Position', [90 300 180 18]);
uicontrol(sb, 'Style', 'slider', 'Tag', 'colorscale_min_slider', ...
    'Position', [90 280 180 18]);
uicontrol(sb, 'Style', 'slider', 'Tag', 'update_zoom_slider', ...
    'Position', [90 260 180 18]);
uicontrol(sb, 'Style', 'slider', 'Tag', 'transparency_surface_slider', ...
    'Position', [90 240 180 18]);
uicontrol(sb, 'Style', 'slider', 'Tag', 'update_ambience_slider', ...
    'Position', [90 220 180 18]);
uicontrol(sb, 'Style', 'text', 'String', 'Appearance', 'Tag', 'section_appearance');
uicontrol(sb, 'Style', 'text', 'String', 'Lights', 'Tag', 'label_lights');
uicontrol(sb, 'Style', 'popupmenu', 'Tag', 'lightsselection', ...
    'String', {'Default', 'Lights off', 'Add X', 'Add Y', 'Add Z', 'Headlight'}, ...
    'Position', [90 80 220 22]);
uicontrol(sb, 'Style', 'text', 'String', 'Colormap', 'Tag', 'label_colormap');
uicontrol(sb, 'Style', 'popupmenu', 'Tag', 'colormapselection', ...
    'String', {'Monterosso', 'Blue brain III', 'Parcellation'}, ...
    'Position', [90 56 220 22]);
uicontrol(sb, 'Style', 'text', 'String', 'Scale', 'Tag', 'label_scale');
uicontrol(sb, 'Style', 'popupmenu', 'Tag', 'colorscaleselection', ...
    'String', {'Linear', 'Logarithmic'}, ...
    'Position', [90 32 220 22]);
uicontrol(sb, 'Style', 'pushbutton', 'String', 'Play', ...
    'Tag', 'playbutton', 'Position', [80 10 60 28]);

end

function rgb = local_menu_chip_cdata(parent, tag)

ax = findall(parent, 'Tag', tag, 'Type', 'axes');
if isempty(ax)
    ax = findall(parent, 'Type', 'axes');
end
if isempty(ax)
    error('tests:NoMenuChip', 'No chip axes with tag %s', tag);
end
im = findall(ax(1), 'Type', 'image');
if isempty(im)
    error('tests:NoMenuChipImage', 'No chip image with tag %s', tag);
end
rgb = im(1).CData;

end

function local_restore_zef(had_zef, old_zef)

if had_zef
    assignin('base', 'zef', old_zef);
else
    evalin('base', 'clear zef');
end

end

function contrast = local_edge_contrast(rgb, fillc)

fillc = double(reshape(fillc, 1, []));
fillc = fillc(1:3);
row = max(1, round(size(rgb, 1) / 2));
mid = double(squeeze(rgb(row, :, :)));
if size(mid, 1) == 3
    mid = mid.';
end
contrast = max(max(abs(mid - fillc), [], 2));

end
