classdef WindowManagementTest < matlab.unittest.TestCase
%WINDOWMANAGEMENTTEST  zef_window_manager / figure WindowStyle vs docked factory (R2025a+).
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Creates real figures and restores groot defaults in teardown. Covers
%   factory docked style, standalone default, Position vs WindowStyle
%   order, zef_arrange_windows, and size-changed callbacks. Not inverse
%   dispatch. See +tests/README.md.
%     - menuMinimizeDoesNotWalkOffScreen: expects y0.
%     - hideCloseLeavesHandleValidAndShowRestores: expects 'off'.
%     - raiseDoesNotCreateExtraFigure: expects before + 1.
%     - dockMenuStacksAboveSegmentation: expects mainFig.Position(1.
%     - repeatedInitRestoreCycles: expects 'defaultFigureWindowStyle'.
%     - waitbarLikeConstructorIsStandaloneAfterInit: expects 'normal'.
%

    properties
        Figures = gobjects(0)
        SavedWindowStyle = ""
    end

    methods (TestMethodSetup)
        function captureGrootDefault(testCase)
            testCase.SavedWindowStyle = string(get(groot, 'defaultFigureWindowStyle'));
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
            try
                zef_window_manager('restore');
            catch
            end
            try
                set(groot, 'defaultFigureWindowStyle', testCase.SavedWindowStyle);
            catch
            end
        end
    end

    methods (Access = private)
        function h = track(testCase, h)
            testCase.Figures(end+1) = h; %#ok<AGROW>
        end
    end

    methods (Test)

        function factoryWindowStyleIsDockedOnR2025Plus(testCase)
            % R2025a+ factory is 'docked'; waitbars and tools must opt out
            % via zef_window_manager('standalone') or they appear in the
            % MATLAB desktop figure container.
            v = ver('MATLAB');
            rel = char(v.Release);
            year = sscanf(rel, '(R%d');
            testCase.assumeTrue(~isempty(year) && year >= 2025, ...
                'Factory docked WindowStyle applies from R2025a.');
            testCase.verifyEqual(char(get(groot, 'factoryFigureWindowStyle')), 'docked');
        end

        function legacyFigureOrderRedocksWhenDefaultIsDocked(testCase)
            % Reproduction of the inherited Zeffiro figure() constructor order.
            testCase.assumeTrue(strcmp(char(get(groot, 'factoryFigureWindowStyle')), 'docked'));
            set(groot, 'defaultFigureWindowStyle', 'docked');
            f = testCase.track(figure( ...
                'Units', 'Pixels', ...
                'OuterPosition', [80 80 320 240], ...
                'Visible', 'off', ...
                'MenuBar', 'figure', ...
                'ToolBar', 'figure', ...
                'Name', 'ZEFFIRO Interface: Figure tool 0', ...
                'WindowStyle', get(0, 'defaultfigureWindowStyle')));
            testCase.verifyEqual(char(f.WindowStyle), 'docked', ...
                'Legacy NV-pair order re-docks the figure into the container.');
        end

        function initForcesStandaloneDefault(testCase)
            set(groot, 'defaultFigureWindowStyle', 'docked');
            zef_window_manager('init');
            testCase.verifyEqual(char(get(groot, 'defaultFigureWindowStyle')), 'normal');
            f = testCase.track(figure( ...
                'Units', 'Pixels', ...
                'OuterPosition', [80 80 320 240], ...
                'Visible', 'off', ...
                'MenuBar', 'figure', ...
                'ToolBar', 'figure', ...
                'Name', 'ZEFFIRO Interface: Figure tool 1', ...
                'WindowStyle', get(0, 'defaultfigureWindowStyle')));
            testCase.verifyEqual(char(f.WindowStyle), 'normal');
        end

        function windowStyleFirstThenPositionStaysNormal(testCase)
            set(groot, 'defaultFigureWindowStyle', 'docked');
            f = testCase.track(figure( ...
                'WindowStyle', 'normal', ...
                'Units', 'Pixels', ...
                'OuterPosition', [90 90 300 220], ...
                'Visible', 'off', ...
                'Name', 'ZEFFIRO Interface: Figure tool 2'));
            testCase.verifyEqual(char(f.WindowStyle), 'normal');
        end

        function standaloneUndocksDockedFigure(testCase)
            set(groot, 'defaultFigureWindowStyle', 'docked');
            f = testCase.track(figure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Figure tool 3'));
            testCase.verifyEqual(char(f.WindowStyle), 'docked');
            zef_window_manager('standalone', f);
            testCase.verifyEqual(char(f.WindowStyle), 'normal');
            testCase.verifyTrue(isvalid(f));
        end

        function restorePutsBackOriginalDefault(testCase)
            original = char(get(groot, 'defaultFigureWindowStyle'));
            set(groot, 'defaultFigureWindowStyle', 'docked');
            zef_window_manager('init');
            testCase.verifyEqual(char(get(groot, 'defaultFigureWindowStyle')), 'normal');
            zef_window_manager('restore');
            testCase.verifyEqual(char(get(groot, 'defaultFigureWindowStyle')), 'docked');
            set(groot, 'defaultFigureWindowStyle', original);
        end

        function sizeChangedHandleDoesNotError(testCase)
            f = testCase.track(figure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Figure tool 4'));
            f.UserData = struct('CurrentSize', f.Position, 'ScalePositions', 1, ...
                'ExcludeCell', {{}}, 'RelativeSize', []);
            f.SizeChangedFcn = @(src, evt) zef_window_manager('on_size_changed', src);
            testCase.verifyWarningFree(@() zef_window_manager('sizechanged', f));
        end

        function sizeChangedEmptyDoesNotError(testCase)
            f = testCase.track(figure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Figure tool 5'));
            f.SizeChangedFcn = '';
            testCase.verifyWarningFree(@() zef_window_manager('sizechanged', f));
        end

        function arrangeWindowsDoesNotCloseMenuOrErrorOnHandleCallback(testCase)
            menuFig = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool'));
            mainFig = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Segmentation tool'));
            extra = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Mesh tool'));
            extra.AutoResizeChildren = 'off';
            extra.SizeChangedFcn = @(src, evt) disp('resized');
            extra.Position = [200 200 400 300];
            zef = struct();
            zef.h_zeffiro_menu = menuFig;
            zef.h_zeffiro_window_main = mainFig;
            zef.menu_expanded_size = 200;
            assignin('base', 'zef', zef);
            testCase.addTeardown(@() evalin('base', 'clear zef'));

            testCase.verifyWarningFree(@() zef_arrange_windows('tile', 'windows', 'all'));
            testCase.verifyTrue(isvalid(menuFig), 'Menu window must survive tile.');
            testCase.verifyTrue(isvalid(mainFig), 'Segmentation window must survive tile.');
            testCase.verifyTrue(isvalid(extra), 'Mesh window must survive tile.');
            testCase.verifyEqual(char(extra.WindowStyle), 'normal');

            testCase.verifyWarningFree(@() zef_arrange_windows('close', 'windows', 'all'));
            testCase.verifyTrue(isvalid(menuFig), 'Close-all must not destroy the menu.');
            testCase.verifyTrue(isvalid(mainFig), 'Close-all must not destroy segmentation.');
            testCase.verifyFalse(isvalid(extra), 'Non-protected tools should close.');
        end

        function hideCloseLeavesHandleValidAndShowRestores(testCase)
            f = testCase.track(uifigure('Visible', 'on', 'Name', 'ZEFFIRO Interface: Mesh tool'));
            f.CloseRequestFcn = 'set(gcbo,''Visible'',''off'');';
            close(f);
            testCase.verifyTrue(isvalid(f));
            testCase.verifyEqual(char(string(f.Visible)), 'off');
            zef = struct('font_size', 10, 'h_zeffiro_menu', f);
            % Use a second window as the target so we do not require a real menu.
            target = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Mesh visualization tool'));
            target.Position = [10 10 200 150];
            zef.h_zeffiro_menu = f;
            f.Position = [300 300 400 40];
            f.Visible = 'on';
            out = zef_window_visible(zef, target);
            testCase.verifyEqual(char(string(out.Visible)), 'on');
            testCase.verifyEqual(char(out.WindowStyle), 'normal');
        end

        function raiseDoesNotCreateExtraFigure(testCase)
            before = numel(findall(groot, 'Type', 'figure'));
            f = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Mesh tool'));
            zef_window_manager('raise', f);
            after = numel(findall(groot, 'Type', 'figure'));
            testCase.verifyEqual(after, before + 1);
            testCase.verifyEqual(char(string(f.Visible)), 'on');
            testCase.verifyTrue(isvalid(f));
        end

        function dockMenuStacksAboveSegmentation(testCase)
            mainFig = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Segmentation tool'));
            menuFig = testCase.track(uifigure('Visible', 'off', 'Name', 'ZEFFIRO Interface: Menu tool'));
            mainFig.Position = [80 80 400 300];
            menuFig.Position = [0 0 400 200];
            zef = struct();
            zef.h_zeffiro_window_main = mainFig;
            zef.h_zeffiro_menu = menuFig;
            zef.menu_expanded_size = 180;
            zef_window_manager('dock_menu', zef);
            testCase.verifyEqual(menuFig.Position(1), mainFig.Position(1), 'AbsTol', 2);
            testCase.verifyEqual(menuFig.Position(3), mainFig.Position(3), 'AbsTol', 2);
            testCase.verifyEqual(menuFig.Position(2), mainFig.Position(2) + mainFig.Position(4), 'AbsTol', 2);
            testCase.verifyEqual(char(menuFig.WindowStyle), 'normal');
            testCase.verifyEqual(char(mainFig.WindowStyle), 'normal');
        end

        function repeatedInitRestoreCycles(testCase)
            set(groot, 'defaultFigureWindowStyle', 'docked');
            for k = 1:3
                zef_window_manager('init');
                testCase.verifyEqual(char(get(groot, 'defaultFigureWindowStyle')), 'normal');
                f = testCase.track(figure('Visible', 'off', 'Name', sprintf('ZEFFIRO Interface: Figure tool cycle %d', k)));
                testCase.verifyEqual(char(f.WindowStyle), 'normal');
                zef_window_manager('restore');
                testCase.verifyEqual(char(get(groot, 'defaultFigureWindowStyle')), 'docked');
            end
        end

        function waitbarLikeConstructorIsStandaloneAfterInit(testCase)
            set(groot, 'defaultFigureWindowStyle', 'docked');
            zef_window_manager('init');
            f = testCase.track(figure( ...
                'WindowStyle', 'normal', ...
                'Units', 'normalized', ...
                'Position', [0.375 0.35 0.2 0.2], ...
                'Visible', 'off', ...
                'MenuBar', 'none', ...
                'ToolBar', 'none', ...
                'Name', 'ZEFFIRO Interface: Progress', ...
                'HandleVisibility', 'off'));
            testCase.verifyEqual(char(f.WindowStyle), 'normal');
        end

        function standalonePreservesModalDialog(testCase)
            f = testCase.track(uifigure('Visible', 'off', 'WindowStyle', 'modal', ...
                'Name', 'ZEFFIRO Interface: Confirm'));
            testCase.verifyEqual(char(f.WindowStyle), 'modal');
            zef_window_manager('standalone', f);
            testCase.verifyEqual(char(f.WindowStyle), 'modal');
            zef_window_manager('raise', f);
            testCase.verifyEqual(char(f.WindowStyle), 'modal');
            testCase.verifyTrue(isvalid(f));
        end

    end

end
