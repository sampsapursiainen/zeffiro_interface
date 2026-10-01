classdef FigureToolControllersTest < matlab.unittest.TestCase
%FIGURETOOLCONTROLLERSTEST  Figure-tool camera controllers are live and exclusive.

    properties
        Figures = gobjects(0)
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
        function toolbarButtonsHaveCallbacks(testCase)
            f = local_shell_figure(testCase);
            keys = {'pan', 'rotate', 'zoom', 'zoomout', 'reset', 'screenshot', ...
                'colormap', 'measure', 'annotate', 'edges', 'sliders', 'more'};
            for i = 1:numel(keys)
                b = findall(f, 'Tag', ['zef_tool_' keys{i}]);
                testCase.verifyNotEmpty(b, keys{i});
                cb = b(1).Callback;
                testCase.verifyFalse(isempty(cb), keys{i});
            end
        end

        function rotateNudgeChangesCameraAndResetRestores(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'rotate');
            zef_figure_interact(f, 'capture');
            pos0 = ax.CameraPosition;
            view0 = ax.View;
            zef_figure_interact(f, 'nudge', 35, 12);
            testCase.verifyGreaterThan(norm(ax.CameraPosition - pos0), 1e-6);
            zef_figure_interact(f, 'reset');
            testCase.verifyEqual(ax.View, view0, 'AbsTol', 0.05);
        end

        function rotateDragPathOrbitsCamera(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            pos0 = ax.CameraPosition;
            view0 = ax.View;
            ap = ax.Position;
            x0 = ap(1) + ap(3) * 0.5;
            y0 = ap(2) + ap(4) * 0.5;
            zef_figure_interact(f, 'drag', x0, y0, x0 + 48, y0 + 18);
            moved = norm(ax.CameraPosition - pos0) > 1e-6 ...
                || norm(ax.View - view0) > 1e-3;
            testCase.verifyTrue(moved);
        end

        function rotateDragWorksForNestedFigureViewAxes(testCase)
            [f, ax] = local_volume_figure(testCase);
            viewp = findall(f, 'Tag', 'figure_view');
            if isempty(viewp)
                viewp = uipanel(f, 'Tag', 'figure_view', 'Units', 'pixels', ...
                    'Position', [40 80 640 480]);
            end
            viewp = viewp(1);
            ax.Parent = viewp;
            ax.Units = 'pixels';
            viewp.Units = 'pixels';
            vp = viewp.Position;
            ax.Position = [8, 8, max(80, vp(3) - 16), max(80, vp(4) - 16)];
            setappdata(ax, 'ZefHasVolumePlot', true);
            zef_figure_interact(f, 'reapply');
            zef_figure_interact(f, 'set', 'rotate');
            pos0 = ax.CameraPosition;
            ap = getpixelposition(ax, true);
            x0 = ap(1) + ap(3) * 0.5;
            y0 = ap(2) + ap(4) * 0.5;
            zef_figure_interact(f, 'drag', x0, y0, x0 + 48, y0 + 18);
            testCase.verifyGreaterThan(norm(ax.CameraPosition - pos0), 1e-6);
            testCase.verifyFalse(isstruct(getappdata(f, 'ZefInteractDrag')));
        end

        function rotateThenPanDragPansNotStale(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            zef_figure_interact(f, 'toggle', 'pan');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'pan');
            tgt0 = ax.CameraTarget;
            ap = ax.Position;
            zef_figure_interact(f, 'drag', ap(1)+ap(3)*0.5, ap(2)+ap(4)*0.5, ...
                ap(1)+ap(3)*0.5+40, ap(2)+ap(4)*0.5);
            testCase.verifyGreaterThan(norm(ax.CameraTarget - tgt0), 1e-8);
        end

        function modesAreMutuallyExclusive(testCase)
            f = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            zef_figure_interact(f, 'toggle', 'pan');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'pan');
            rot = findall(f, 'Tag', 'zef_tool_rotate');
            panb = findall(f, 'Tag', 'zef_tool_pan');
            testCase.verifyEqual(double(rot(1).UserData), 0);
            testCase.verifyEqual(double(panb(1).UserData), 1);
            zef_figure_interact(f, 'toggle', 'measure');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'measure');
            testCase.verifyEqual(double(panb(1).UserData), 0);
            zef_figure_interact(f, 'toggle', 'measure');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'none');
        end

        function zoomButtonsAndWheelChangeViewAngle(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            va0 = ax.CameraViewAngle;
            zin = findall(f, 'Tag', 'zef_tool_zoom');
            testCase.assertNotEmpty(zin);
            zin(1).Callback(zin(1), []);
            testCase.verifyNotEqual(ax.CameraViewAngle, va0);
            va1 = ax.CameraViewAngle;
            zout = findall(f, 'Tag', 'zef_tool_zoomout');
            testCase.assertNotEmpty(zout);
            zout(1).Callback(zout(1), []);
            testCase.verifyGreaterThan(ax.CameraViewAngle, va1);
            zef_figure_interact(f, 'wheel', 2);
            testCase.verifyNotEqual(ax.CameraViewAngle, va0);
        end

        function panNudgeMovesTarget(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'pan');
            tgt0 = ax.CameraTarget;
            zef_figure_interact(f, 'nudge', 40, -15);
            testCase.verifyGreaterThan(norm(ax.CameraTarget - tgt0), 1e-8);
        end

        function panDragTranslatesCameraWithPointer(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'pan');
            pos0 = ax.CameraPosition;
            tgt0 = ax.CameraTarget;
            up0 = ax.CameraUpVector;
            fwd = tgt0 - pos0;
            fwd = fwd / norm(fwd);
            up = up0 / norm(up0);
            right = cross(fwd, up);
            right = right / norm(right);
            up = cross(right, fwd);
            up = up / norm(up);
            ap = ax.Position;
            x = ap(1) + ap(3) * 0.5;
            y = ap(2) + ap(4) * 0.5;
            zef_figure_interact(f, 'drag', x, y, x + 80, y + 40);
            dpos = ax.CameraPosition - pos0;
            dtgt = ax.CameraTarget - tgt0;
            testCase.verifyGreaterThan(norm(dtgt), 1e-4);
            testCase.verifyLessThan(norm(dpos - dtgt), 1e-6 * max(1, norm(dtgt)));
            testCase.verifyLessThan(norm((ax.CameraPosition - ax.CameraTarget) - (pos0 - tgt0)), 1e-6);
            testCase.verifyLessThan(dot(dtgt, right), 0);
            testCase.verifyLessThan(dot(dtgt, up), 0);
            view_dir = pos0 - tgt0;
            dist = norm(view_dir);
            minor = min(ap(3), ap(4));
            span = 2 * dist * tand(ax.CameraViewAngle / 2);
            scale = span / max(1, minor);
            expect = (-80 * scale) * right + (-40 * scale) * up;
            testCase.verifyLessThan(norm(dtgt - expect) / max(1, norm(expect)), 0.05);
        end

        function panDragReachesFarCornerWhenWindowIsOffset(testCase)
            [f, ax] = local_volume_figure(testCase);
            f.Position(1:2) = [640 380];
            viewp = findall(f, 'Tag', 'figure_view');
            testCase.assertNotEmpty(viewp);
            ax.Parent = viewp(1);
            ax.Units = 'pixels';
            viewp(1).Units = 'pixels';
            vp = viewp(1).Position;
            ax.Position = [12, 16, max(120, vp(3) - 28), max(120, vp(4) - 32)];
            drawnow;
            zef_figure_interact(f, 'set', 'pan');
            ap = getpixelposition(ax, true);
            corners = [
                ap(1) + 6, ap(2) + 6
                ap(1) + ap(3) - 6, ap(2) + 6
                ap(1) + 6, ap(2) + ap(4) - 6
                ap(1) + ap(3) - 6, ap(2) + ap(4) - 6
                ];
            for i = 1:size(corners, 1)
                zef_figure_interact(f, 'reset');
                tgt0 = ax.CameraTarget;
                x0 = corners(i, 1);
                y0 = corners(i, 2);
                zef_figure_interact(f, 'drag', x0, y0, x0 + 24, y0 + 10);
                testCase.verifyGreaterThan(norm(ax.CameraTarget - tgt0), 1e-6, ...
                    sprintf('corner %d', i));
                testCase.verifyFalse(isstruct(getappdata(f, 'ZefInteractDrag')));
            end
            zef_figure_interact(f, 'reset');
            tgt0 = ax.CameraTarget;
            zef_figure_interact(f, 'drag', 2, 2, 30, 16);
            testCase.verifyLessThan(norm(ax.CameraTarget - tgt0), 1e-8);
        end

        function reapplySurvivesClaAndKeepsNativeRotate(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'rotate');
            down0 = f.WindowButtonDownFcn;
            [x, y, z] = sphere(12);
            cla(ax);
            surf(ax, x, y, z);
            view(ax, 3);
            axis(ax, 'vis3d');
            setappdata(ax, 'ZefHasVolumePlot', true);
            zef_figure_interact(f, 'reapply');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'rotate');
            testCase.verifyTrue(isa(f.WindowButtonDownFcn, 'function_handle'));
            testCase.verifyTrue(isequal(f.WindowButtonDownFcn, down0) ...
                || isa(f.WindowButtonDownFcn, 'function_handle'));
            pos0 = ax.CameraPosition;
            ap = ax.Position;
            zef_figure_interact(f, 'drag', ap(1)+ap(3)*0.5, ap(2)+ap(4)*0.5, ...
                ap(1)+ap(3)*0.5+30, ap(2)+ap(4)*0.5+12);
            testCase.verifyGreaterThan(norm(ax.CameraPosition - pos0), 1e-6);
            rz = [];
            try
                rz = rotate3d(f);
            catch
            end
            if ~isempty(rz)
                testCase.verifyFalse(strcmpi(char(rz.Enable), 'on'));
            end
        end

        function plotOnPlotDefaultsToRotate(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'none');
            zef_figure_interact(f, 'forget_home');
            zef_figure_interact(f, 'on_plot');
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'rotate');
            testCase.verifyTrue(isappdata(f, 'ZefInteractHome'));
            testCase.verifyEqual(ax.Tag, 'axes1');
            pos0 = ax.CameraPosition;
            ap = ax.Position;
            zef_figure_interact(f, 'drag', ap(1)+ap(3)*0.5, ap(2)+ap(4)*0.5, ...
                ap(1)+ap(3)*0.5+36, ap(2)+ap(4)*0.5+14);
            testCase.verifyGreaterThan(norm(ax.CameraPosition - pos0), 1e-6);
        end

        function extraToolbarControllersRemain(testCase)
            f = local_shell_figure(testCase);
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_colormap'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_edges'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_screenshot'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_more'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_sliders'));
            testCase.verifyNotEmpty(findall(f, 'Tag', 'zef_tool_zoomout'));
            testCase.verifyEmpty(findall(f, 'Tag', 'zef_tool_brush'));
        end

        function toolbarRotateCallbackActivatesMode(testCase)
            f = local_volume_figure(testCase);
            b = findall(f, 'Tag', 'zef_tool_rotate');
            testCase.assertNotEmpty(b);
            cb = b(1).Callback;
            testCase.assertTrue(isa(cb, 'function_handle'));
            cb(b(1), []);
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'rotate');
            panb = findall(f, 'Tag', 'zef_tool_pan');
            cb2 = panb(1).Callback;
            cb2(panb(1), []);
            testCase.verifyEqual(zef_figure_interact(f, 'get'), 'pan');
            testCase.verifyEqual(double(b(1).UserData), 0);
        end

        function measureClickLandsOnSurfaceAndKeepsTips(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'measure');
            ap = getpixelposition(ax, true);
            x = ap(1) + ap(3) * 0.5;
            y = ap(2) + ap(4) * 0.5;
            zef_figure_interact(f, 'down', [x, y]);
            zef_figure_interact(f, 'down', [x + 12, y + 6]);
            marks = [findall(ax, 'Type', 'datatip'); findall(ax, 'Tag', 'zef_datatip_text')];
            testCase.verifyGreaterThanOrEqual(numel(marks), 2);
            pos = local_mark_position(marks(1));
            testCase.verifyLessThan(abs(norm(pos) - 1), 0.25);
            n0 = numel(marks);
            zef_figure_interact(f, 'down', [-80, -80]);
            marks = [findall(ax, 'Type', 'datatip'); findall(ax, 'Tag', 'zef_datatip_text')];
            testCase.verifyEqual(numel(marks), n0);
            tb = findall(f, 'Tag', 'zef_shell_toolbar');
            testCase.assertNotEmpty(tb);
            tr = getpixelposition(tb(1), true);
            tpt = [tr(1) + 8, tr(2) + 6];
            zef_figure_interact(f, 'down', tpt);
            marks = [findall(ax, 'Type', 'datatip'); findall(ax, 'Tag', 'zef_datatip_text')];
            testCase.verifyEqual(numel(marks), n0);
        end

        function measureAndAnnotatePlaceOverlays(testCase)
            [f, ax] = local_volume_figure(testCase);
            zef_figure_interact(f, 'set', 'measure');
            zef_figure_interact(f, 'click');
            tips = [findall(ax, 'Type', 'datatip'); findall(ax, 'Tag', 'zef_datatip_text')];
            testCase.verifyNotEmpty(tips);
            zef_figure_interact(f, 'set', 'annotate');
            zef_figure_interact(f, 'click');
            notes = findall(ax, 'Tag', 'zef_annotate_text');
            testCase.verifyNotEmpty(notes);
        end

        function toggleEdgesKeepsDensePatchOnSurface(testCase)
            [f, ax] = local_volume_figure(testCase);
            figure(f);
            prev = [];
            had = evalin('base', 'exist(''zef'',''var'')');
            if had
                prev = evalin('base', 'zef');
            end
            delete(findall(ax, 'Type', 'surface'));
            [xs, ys, zs] = sphere(100);
            fv = surf2patch(xs, ys, zs, 'triangles');
            face = [0.85 0.55 0.45];
            p = patch(ax, 'Faces', fv.faces, 'Vertices', fv.vertices, ...
                'FaceColor', face, 'EdgeColor', 'none');
            cam0 = ax.CameraPosition;
            assignin('base', 'zef', struct('h_zeffiro', f, 'h_axes1', ax));
            restore = onCleanup(@() local_restore_zef(had, prev)); %#ok<NASGU>
            zef_toggle_edges;
            testCase.verifyEqual(p.FaceColor, face, 'AbsTol', 1e-6);
            testCase.verifyLessThan(norm(ax.CameraPosition - cam0), 1e-6);
            ln = getappdata(p, 'ZefEdgeOverlay');
            testCase.verifyTrue(isgraphics(ln));
            P = double(ln.VertexData);
            nedge = size(P, 2) / 2;
            testCase.verifyGreaterThan(nedge, 80);
            testCase.verifyLessThan(nedge, 9000);
            seg = sqrt(sum((P(:, 1:2:end) - P(:, 2:2:end)) .^ 2, 1));
            testCase.verifyLessThan(max(seg), 0.45);
            zef_toggle_edges;
            testCase.verifyFalse(isgraphics(ln));
            testCase.verifyEqual(p.FaceColor, face, 'AbsTol', 1e-6);
            testCase.verifyLessThan(norm(ax.CameraPosition - cam0), 1e-6);
        end

        function toggleEdgesChangesPatchEdgeColor(testCase)
            [f, ax] = local_volume_figure(testCase);
            figure(f);
            prev = [];
            had = evalin('base', 'exist(''zef'',''var'')');
            if had
                prev = evalin('base', 'zef');
            end
            assignin('base', 'zef', struct('h_zeffiro', f, 'h_axes1', ax));
            restore = onCleanup(@() local_restore_zef(had, prev)); %#ok<NASGU>
            ch = findall(ax, 'Type', 'surface', '-or', 'Type', 'patch');
            testCase.assumeNotEmpty(ch);
            ch(1).EdgeColor = 'none';
            zef_toggle_edges;
            theme = zef_ui_theme();
            testCase.verifyEqual(ch(1).EdgeColor, theme.color.text, 'AbsTol', 1e-6);
            zef_toggle_edges;
            testCase.verifyEqual(char(string(ch(1).EdgeColor)), 'none');
            ch(1).EdgeColor = [1 1 1];
            zef_toggle_edges;
            testCase.verifyEqual(char(string(ch(1).EdgeColor)), 'none');
        end

        function toggleControlsPersistsFromBothEntryPoints(testCase)
            [f, ax] = local_volume_figure(testCase);
            figure(f);
            prev = [];
            had = evalin('base', 'exist(''zef'',''var'')');
            if had
                prev = evalin('base', 'zef');
            end
            assignin('base', 'zef', struct('h_zeffiro', f));
            restore = onCleanup(@() local_restore_zef(had, prev));
            local_verify_toggle_rendered(testCase, f);
            tgb = findall(f, 'Tag', 'togglecontrolsbutton');
            for i = 1:7
                local_fire(tgb(1));
                local_verify_toggle_rendered(testCase, f);
            end
            sl = findall(f, 'Tag', 'zef_tool_sliders');
            testCase.assertNotEmpty(sl);
            for i = 1:7
                local_fire(sl(1));
                local_verify_toggle_rendered(testCase, f);
            end
            for i = 1:6
                if mod(i, 2) == 1
                    zef_toggle_figure_controls;
                else
                    sl = findall(f, 'Tag', 'zef_tool_sliders');
                    local_fire(sl(1));
                end
                local_verify_toggle_rendered(testCase, f);
            end
            f.Position(3:4) = f.Position(3:4) + [60 40];
            zef_figure_tool_layout(f);
            local_verify_toggle_rendered(testCase, f);
            zef_figure_interact(f, 'set', 'rotate');
            pos0 = ax.CameraPosition;
            zef_figure_interact(f, 'nudge', 20, 8);
            testCase.verifyGreaterThan(norm(ax.CameraPosition - pos0), 1e-6);
            zef_figure_interact(f, 'zoom_by', 1.6);
            zef_toggle_figure_controls;
            local_verify_toggle_rendered(testCase, f);
            zef_figure_sync_plot(f);
            local_verify_toggle_rendered(testCase, f);
            testCase.verifyEqual(numel(findall(f, 'Tag', 'togglecontrolsbutton')), 1);
            testCase.verifyLessThanOrEqual(numel(findall(f, 'Tag', 'togglecontrolsbutton_cap')), 1);
        end
    end
end

function f = local_shell_figure(testCase)

f = figure('Visible', 'off', 'Units', 'pixels', ...
    'Position', [40 40 1200 720], 'MenuBar', 'none', 'ToolBar', 'none', ...
    'Name', 'ZEFFIRO Interface: Figure tool', ...
    'AutoResizeChildren', 'off', 'Tag', 'figure_tool');
testCase.Figures(end+1) = f;
uipanel(f, 'Tag', 'figure_sidebar', 'Units', 'pixels', ...
    'Position', [900 200 260 400]);
uipanel(f, 'Tag', 'figure_lists', 'Units', 'pixels', ...
    'Position', [20 12 500 80]);
ax = uiaxes(f, 'Tag', 'axes1', 'Units', 'pixels', ...
    'Position', [20 200 500 400]);
uicontrol(f, 'Style', 'pushbutton', 'String', 'Toggle controls', ...
    'Tag', 'togglecontrolsbutton', 'UserData', 1, ...
    'Position', [900 620 120 28]);
zef_ui_shell('build', f);
zef_figure_tool_layout(f);
ax.Tag = 'axes1';

end

function [f, ax] = local_volume_figure(testCase)

f = local_shell_figure(testCase);
ax = findall(f, 'Tag', 'axes1');
testCase.assertNotEmpty(ax);
ax = ax(1);
[x, y, z] = sphere(16);
surf(ax, x, y, z, 'EdgeColor', 'none');
view(ax, 35, 20);
axis(ax, 'vis3d');
camva(ax, 8);
setappdata(ax, 'ZefHasVolumePlot', true);

end

function pos = local_mark_position(h)

pos = [NaN NaN NaN];
try
    pos = double(h.Position);
    pos = pos(1:3);
catch
end

end

function local_restore_zef(had, prev)

if had
    assignin('base', 'zef', prev);
else
    evalin('base', 'clear(''zef'')');
end

end

function local_fire(h)

cb = h.Callback;
if ischar(cb) || isstring(cb)
    evalin('base', char(cb));
elseif isa(cb, 'function_handle')
    cb(h, []);
end

end

function local_verify_toggle_rendered(testCase, f)

tgb = findall(f, 'Tag', 'togglecontrolsbutton');
testCase.verifyEqual(numel(tgb), 1);
testCase.verifyEqual(char(tgb(1).Visible), 'on');
testCase.verifyEqual(char(tgb(1).Enable), 'on');
par = tgb(1).Parent;
testCase.verifyTrue(isgraphics(par) && isvalid(par));
testCase.verifyEqual(char(par.Visible), 'on');
testCase.verifyNotEqual(char(par.Tag), 'figure_sidebar');
lab = strtrim(char(string(tgb(1).String)));
cap = findall(f, 'Tag', 'togglecontrolsbutton_cap');
testCase.verifyLessThanOrEqual(numel(cap), 1);
if ~isempty(cap)
    testCase.verifyEqual(char(cap(1).Visible), 'on');
    testCase.verifyEqual(cap(1).Parent, par);
    p = cap(1).Parent;
    while isgraphics(p)
        testCase.verifyNotEqual(char(p.Visible), 'off');
        if strcmpi(char(p.Type), 'figure')
            break
        end
        p = p.Parent;
    end
    lab = strtrim(char(string(cap(1).String)));
end
testCase.verifyEqual(lab, 'Toggle controls');
if ~isempty(cap)
    fg = double(cap(1).ForegroundColor);
    bgc = double(cap(1).BackgroundColor);
    testCase.verifyGreaterThan(norm(fg - bgc), 0.2);
    testCase.verifyGreaterThan(cap(1).Position(3), 40);
    testCase.verifyGreaterThan(cap(1).Position(4), 10);
end
sb = findall(f, 'Tag', 'figure_sidebar');
if ~isempty(sb)
    hidden = isequal(tgb(1).UserData, 2);
    if hidden
        testCase.verifyEqual(char(sb(1).Visible), 'off');
    else
        testCase.verifyEqual(char(sb(1).Visible), 'on');
    end
end

end
