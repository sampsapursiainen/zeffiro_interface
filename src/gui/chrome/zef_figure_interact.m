function varargout = zef_figure_interact(varargin)
%ZEF_FIGURE_INTERACT  Figure-tool camera, data-tip, and annotate manager.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   rotate3d is not used. On R2025a+ uifigures, native axes Interactions
%   never enable, so rotate/pan/zoom use a custom WindowMouseMotion path
%   (camrotate + a single CameraPosition/UpVector update). A drag paints
%   with drawnow limitrate while that move is still busy, so motion
%   events that arrive during the paint only record the latest point.
%   Pointer hit tests use figure-relative pixels so nested figure_view
%   axes work.
%   Modes are mutually exclusive and survive re-plotting via
%   zef_figure_sync_plot.
%
%   zef_figure_interact(fig, 'toggle', mode)
%   zef_figure_interact(fig, 'set', mode)
%   mode = zef_figure_interact(fig, 'get')
%   zef_figure_interact(fig, 'reapply')
%   zef_figure_interact(fig, 'reset')
%   zef_figure_interact(fig, 'forget_home')
%   zef_figure_interact(fig, 'capture_if_empty')
%   consumed = zef_figure_interact(fig, 'down')
%   consumed = zef_figure_interact(fig, 'move')
%   consumed = zef_figure_interact(fig, 'up')
%   consumed = zef_figure_interact(fig, 'wheel', scroll_count)
%   zef_figure_interact(fig, 'nudge', dx, dy)
%   zef_figure_interact(fig, 'zoom_by', factor)
%   zef_figure_interact(fig, 'drag', x0, y0, x1, y1)
%   tf = zef_figure_interact(fig, 'native')
%   ptr = zef_figure_interact(fig, 'pointer')
%
%   Modes: none, rotate, pan, zoom, measure, annotate.
%
%   See also zef_ui_shell, zef_figure_sync_plot, zef_figure_tool.

fig = [];
action = 'get';
args = {};
if nargin >= 1
    if local_is_fig(varargin{1})
        fig = varargin{1};
        if nargin >= 2
            action = char(string(varargin{2}));
            args = varargin(3:end);
        end
    else
        action = char(string(varargin{1}));
        args = varargin(2:end);
        if ~isempty(args) && local_is_fig(args{1})
            fig = args{1};
            args = args(2:end);
        end
    end
end
if ~local_is_fig(fig)
    fig = local_default_fig();
end
if ~local_is_fig(fig)
    if nargout > 0
        varargout{1} = [];
    end
    return
end

action = lower(strtrim(action));
out = [];
switch action
    case {'toggle', 'set'}
        mode = 'none';
        if ~isempty(args)
            mode = lower(char(string(args{1})));
        end
        if strcmp(action, 'toggle')
            cur = local_get_mode(fig);
            if strcmp(cur, mode)
                mode = 'none';
            end
        end
        local_set_mode(fig, mode);
        out = local_get_mode(fig);
    case 'get'
        out = local_get_mode(fig);
    case 'reapply'
        local_reapply(fig);
        out = local_get_mode(fig);
    case 'reset'
        local_reset_view(fig);
        out = true;
    case 'forget_home'
        local_forget_home(fig);
        out = true;
    case {'capture', 'capture_if_empty'}
        only_empty = strcmp(action, 'capture_if_empty');
        local_capture_home(fig, only_empty);
        out = true;
    case 'on_plot'
        local_on_plot(fig);
        out = local_get_mode(fig);
    case 'down'
        pt = [];
        if ~isempty(args)
            pt = args{1};
        end
        out = local_down(fig, pt);
    case 'move'
        pt = [];
        if ~isempty(args)
            pt = args{1};
        end
        out = local_move(fig, pt);
    case 'up'
        out = local_up(fig);
    case 'wheel'
        n = 0;
        if ~isempty(args)
            n = args{1};
        end
        out = local_wheel(fig, n);
    case 'nudge'
        dx = 0;
        dy = 0;
        if numel(args) >= 1
            dx = args{1};
        end
        if numel(args) >= 2
            dy = args{2};
        end
        out = local_nudge(fig, dx, dy);
    case {'zoom_by', 'zoomby'}
        factor = 1.6;
        if ~isempty(args)
            factor = args{1};
        end
        out = local_zoom_by(fig, factor);
    case 'drag'
        x0 = 0;
        y0 = 0;
        x1 = 40;
        y1 = 12;
        if numel(args) >= 2
            x0 = args{1};
            y0 = args{2};
        end
        if numel(args) >= 4
            x1 = args{3};
            y1 = args{4};
        end
        out = local_drag(fig, x0, y0, x1, y1);
    case 'native'
        out = local_native_on(local_axes(fig));
    case 'click'
        ax = local_axes(fig);
        mode = local_get_mode(fig);
        if isempty(ax) || strcmp(mode, 'none')
            out = false;
        else
        out = local_click_overlay(fig, ax, mode);
        end
    case 'pointer'
        out = local_pointer(fig);
    case 'is_plot'
        obj = [];
        if ~isempty(args)
            obj = args{1};
        end
        out = local_over_plot(fig, obj);
    otherwise
        out = local_get_mode(fig);
end

if nargout > 0
    varargout{1} = out;
end

end

function local_set_mode(fig, mode)

mode = local_norm_mode(mode);
local_disable_legacy(fig);
try
    if isappdata(fig, 'ZefInteractAxes')
        rmappdata(fig, 'ZefInteractAxes');
    end
catch
end
local_end_drag(fig);
try
    setappdata(fig, 'ZefInteractMode', mode);
catch
end
local_apply_axes_state(fig, mode);
local_sync_toolbar(fig, mode);
local_set_pointer(fig, local_pointer_for(mode));

end

function local_reapply(fig)

try
    if isappdata(fig, 'ZefInteractAxes')
        rmappdata(fig, 'ZefInteractAxes');
    end
catch
end
mode = local_get_mode(fig);
if strcmp(mode, 'none') && local_has_volume(fig)
    mode = 'rotate';
    try
        setappdata(fig, 'ZefInteractMode', mode);
    catch
    end
end
local_end_drag(fig);
local_disable_legacy(fig);
local_apply_axes_state(fig, mode);
local_sync_toolbar(fig, mode);

end

function local_on_plot(fig)

try
    if isappdata(fig, 'ZefInteractAxes')
        rmappdata(fig, 'ZefInteractAxes');
    end
catch
end
local_end_drag(fig);
local_capture_home(fig, true);
mode = local_get_mode(fig);
if strcmp(mode, 'none')
    mode = 'rotate';
    try
        setappdata(fig, 'ZefInteractMode', mode);
    catch
    end
end
local_disable_legacy(fig);
local_apply_axes_state(fig, mode);
local_sync_toolbar(fig, mode);

end

function local_apply_axes_state(fig, mode)

ax = local_axes(fig);
if isempty(ax)
    try
        setappdata(fig, 'ZefNativeInteract', false);
    catch
    end
    return
end
local_ensure_toolbar(ax);
if strcmp(mode, 'none') || strcmp(mode, 'annotate')
    try
        disableDefaultInteractivity(ax);
    catch
    end
    try
        setappdata(fig, 'ZefNativeInteract', false);
    catch
    end
    return
end
if strcmp(mode, 'rotate') && ~local_has_volume(ax) && ~local_is_3d(ax)
    try
        disableDefaultInteractivity(ax);
    catch
    end
    try
        setappdata(fig, 'ZefNativeInteract', false);
    catch
    end
    return
end
try
    axis(ax, 'vis3d');
catch
end
ok = local_enable_interactions(ax, mode);
try
    setappdata(fig, 'ZefNativeInteract', ok);
catch
end

end

function ok = local_enable_interactions(ax, mode)

ok = false;
if isempty(ax)
    return
end
local_ensure_toolbar(ax);
% Traditional axes inside R2025a+ uifigures never actually enable
% InteractionContainer. A half-installed native rotator still consumes
% mouse events and fights the custom camorbit path.
is_ui = false;
try
    is_ui = matlab.ui.internal.isUIFigure(ancestor(ax, 'figure'));
catch
end
if is_ui
    try
        disableDefaultInteractivity(ax);
    catch
    end
    return
end
try
    switch mode
        case 'rotate'
            ax.Interactions = rotateInteraction;
        case 'pan'
            ax.Interactions = panInteraction;
        case 'zoom'
            ax.Interactions = [zoomInteraction, regionZoomInteraction];
        case 'measure'
            ax.Interactions = dataTipInteraction;
        otherwise
            ax.Interactions = rotateInteraction;
    end
catch
    try
        ax.Interactions = rotateInteraction;
    catch
    end
end
try
    enableDefaultInteractivity(ax);
catch
    return
end
ok = local_native_on(ax);
if ~ok
    try
        enableDefaultInteractivity(ax);
    catch
    end
    ok = local_native_on(ax);
end

end

function tf = local_native_on(ax)

tf = false;
if ~local_ok(ax)
    return
end
try
    ic = ax.InteractionContainer;
    val = ic.Enabled;
    tf = strcmpi(char(string(val)), 'on') || isequal(val, true);
catch
end

end

function local_ensure_toolbar(ax)

if ~local_ok(ax)
    return
end
try
    if isempty(ax.Toolbar)
        axtoolbar(ax, {'restoreview'});
    end
catch
end
try
    ax.Toolbar.Visible = 'off';
catch
end

end

function consumed = local_down(fig, pt)

consumed = false;
if nargin < 2
    pt = [];
end
clear_ptr = false;
if numel(pt) >= 2 && all(isfinite(double(pt(1:2))))
    try
        setappdata(fig, 'ZefInteractPointer', double(pt(1:2)));
        clear_ptr = true;
    catch
    end
end
ax = local_axes(fig);
if isempty(ax)
    local_clear_ptr(fig, clear_ptr);
    return
end
if ~local_pointer_in_axes(fig, ax)
    local_clear_ptr(fig, clear_ptr);
    return
end
existing = [];
try
    existing = getappdata(fig, 'ZefInteractDrag');
catch
end
if isstruct(existing)
    consumed = true;
    local_clear_ptr(fig, clear_ptr);
    return
end
mode = local_get_mode(fig);
if strcmp(mode, 'none')
    local_clear_ptr(fig, clear_ptr);
    return
end
sel = 'normal';
try
    sel = char(fig.SelectionType);
catch
end
origin = local_fig_point(fig);
if any(strcmp(mode, {'measure', 'annotate'}))
    local_clear_ptr(fig, clear_ptr);
    if strcmp(mode, 'measure') && local_native_on(ax)
        consumed = false;
        return
    end
    consumed = local_click_overlay(fig, ax, mode, [], origin);
    return
end
cam0 = [];
view0 = [];
try
    cam0 = ax.CameraPosition;
    view0 = ax.View;
catch
end
drag = struct('mode', mode, 'sel', sel, 'pt', origin, ...
    'origin', origin, 'moved', false, 'delegate', false, ...
    'cam0', cam0, 'view0', view0, 'ax', ax, ...
    'va', local_view_angle(ax));
try
    setappdata(fig, 'ZefInteractDrag', drag);
    setappdata(fig, 'ZefInteractAxes', ax);
catch
end
local_arm_motion(fig);
local_clear_ptr(fig, clear_ptr);
consumed = true;

end

function local_clear_ptr(fig, yes)

if ~yes
    return
end
try
    if isappdata(fig, 'ZefInteractPointer')
        rmappdata(fig, 'ZefInteractPointer');
    end
catch
end

end

function consumed = local_move(fig, pt)

consumed = false;
if nargin < 2
    pt = [];
end
drag = [];
try
    drag = getappdata(fig, 'ZefInteractDrag');
catch
end
if isempty(drag) || ~isstruct(drag)
    return
end
if isfield(drag, 'delegate') && drag.delegate
    return
end
if numel(pt) < 2 || any(~isfinite(double(pt(1:2))))
    pt = local_fig_point(fig);
else
    pt = double(pt(1:2));
end
try
    setappdata(fig, 'ZefInteractLatestPt', pt);
catch
end
busy = false;
try
    busy = isequal(getappdata(fig, 'ZefInteractMoveBusy'), true);
catch
end
if busy
    try
        setappdata(fig, 'ZefInteractMovePending', true);
    catch
    end
    consumed = true;
    return
end
try
    setappdata(fig, 'ZefInteractMoveBusy', true);
catch
end
cleanup = onCleanup(@() local_clear_move_busy(fig));
n_paint = 0;
while true
    try
        setappdata(fig, 'ZefInteractMovePending', false);
    catch
    end
    drag = getappdata(fig, 'ZefInteractDrag');
    if isempty(drag) || ~isstruct(drag)
        break
    end
    ax = [];
    if isfield(drag, 'ax') && local_ok(drag.ax)
        ax = drag.ax;
    else
        ax = local_axes(fig);
    end
    if isempty(ax)
        break
    end
    try
        latest = getappdata(fig, 'ZefInteractLatestPt');
        if numel(latest) >= 2
            pt = double(latest(1:2));
        end
    catch
    end
    dx = pt(1) - drag.pt(1);
    dy = pt(2) - drag.pt(2);
    if abs(dx) < 0.5 && abs(dy) < 0.5
        consumed = true;
        pending = false;
        try
            pending = isequal(getappdata(fig, 'ZefInteractMovePending'), true);
        catch
        end
        if pending
            continue
        end
        if n_paint < 2 && local_drag_moved(drag)
            n_paint = n_paint + 1;
            if local_flush_motion(fig)
                continue
            end
        end
        break
    end
    if (~isfield(drag, 'moved') || ~drag.moved) && local_camera_changed(ax, drag)
        drag.delegate = true;
        drag.moved = true;
        setappdata(fig, 'ZefInteractDrag', drag);
        consumed = false;
        break
    end
    local_apply_delta(ax, drag.mode, drag.sel, dx, dy);
    drag.pt = pt;
    drag.moved = true;
    setappdata(fig, 'ZefInteractDrag', drag);
    consumed = true;
    pending = false;
    try
        pending = isequal(getappdata(fig, 'ZefInteractMovePending'), true);
    catch
    end
    if ~pending
        if n_paint < 2 && local_drag_moved(drag)
            n_paint = n_paint + 1;
            if local_flush_motion(fig)
                continue
            end
        end
        break
    end
end
clear cleanup;

end

function tf = local_drag_moved(drag)

tf = isstruct(drag) && isfield(drag, 'moved') && logical(drag.moved) ...
    && ~(isfield(drag, 'delegate') && drag.delegate);

end

function again = local_flush_motion(fig)

% The paint used to happen after local_move returned, when
% ZefInteractMoveBusy was already clear. Each queued motion event then
% redrew every patch. Painting here lets those events take the busy
% path (record the latest point and return).
again = false;
vis = 'off';
try
    vis = char(string(fig.Visible));
catch
end
if ~strcmpi(vis, 'on')
    return
end
try
    drawnow limitrate
catch
end
try
    again = isequal(getappdata(fig, 'ZefInteractMovePending'), true);
catch
    again = false;
end

end

function consumed = local_up(fig)

consumed = false;
drag = [];
try
    drag = getappdata(fig, 'ZefInteractDrag');
catch
end
if isempty(drag) || ~isstruct(drag)
    local_end_drag(fig);
    return
end
consumed = true;
ax = [];
if isfield(drag, 'ax') && local_ok(drag.ax)
    ax = drag.ax;
else
    ax = local_axes(fig);
end
moved = isfield(drag, 'moved') && drag.moved;
delegated = isfield(drag, 'delegate') && drag.delegate;
local_end_drag(fig);
if isempty(ax)
    return
end
if strcmp(drag.mode, 'zoom') && ~moved && ~delegated
    sel = 'normal';
    if isfield(drag, 'sel')
        sel = drag.sel;
    end
    local_cam_zoom(ax, local_zoom_click_factor(sel));
end
if any(strcmp(drag.mode, {'zoom', 'rotate', 'pan'}))
    local_sync_va(fig, ax);
end

end

function local_clear_move_busy(fig)

try
    setappdata(fig, 'ZefInteractMoveBusy', false);
catch
end

end

function local_end_drag(fig)

try
    setappdata(fig, 'ZefInteractDrag', []);
catch
end
try
    setappdata(fig, 'ZefInteractMoveBusy', false);
    setappdata(fig, 'ZefInteractMovePending', false);
    if isappdata(fig, 'ZefInteractLatestPt')
        rmappdata(fig, 'ZefInteractLatestPt');
    end
catch
end
local_disarm_motion(fig);

end

function consumed = local_wheel(fig, n)

consumed = false;
if isempty(n) || ~isfinite(double(n(1))) || double(n(1)) == 0
    return
end
vis = 'on';
try
    vis = char(fig.Visible);
catch
end
if strcmpi(vis, 'on') && ~local_pointer_in_axes(fig, local_axes(fig))
    return
end
ax = local_axes(fig);
if isempty(ax)
    return
end
n = double(n(1));
factor = 1.12 ^ (-n);
local_cam_zoom(ax, factor);
local_sync_va(fig, ax);
consumed = true;

end

function ok = local_nudge(fig, dx, dy)

ok = false;
ax = local_axes(fig);
if isempty(ax)
    return
end
mode = local_get_mode(fig);
if strcmp(mode, 'none')
    mode = 'rotate';
end
local_apply_delta(ax, mode, 'normal', dx, dy);
local_sync_va(fig, ax);
ok = true;

end

function ok = local_zoom_by(fig, factor)

ok = false;
ax = local_axes(fig);
if isempty(ax)
    return
end
local_cam_zoom(ax, factor);
local_sync_va(fig, ax);
ok = true;

end

function ok = local_drag(fig, x0, y0, x1, y1)

ok = false;
local_down(fig, [double(x0), double(y0)]);
local_move(fig, [double(x1), double(y1)]);
local_up(fig);
ok = true;

end

function tf = local_camera_changed(ax, drag)

tf = false;
if ~isstruct(drag)
    return
end
try
    if isfield(drag, 'cam0') && ~isempty(drag.cam0) ...
            && norm(ax.CameraPosition - drag.cam0) > 1e-6
        tf = true;
        return
    end
catch
end
try
    if isfield(drag, 'view0') && numel(drag.view0) >= 2 ...
            && norm(ax.View - drag.view0) > 1e-3
        tf = true;
    end
catch
end

end

function local_arm_motion(fig)

try
    if isappdata(fig, 'ZefNavHoverListener')
        lh = getappdata(fig, 'ZefNavHoverListener');
        if ~isempty(lh) && isvalid(lh)
            return
        end
    end
catch
end
try
    if isappdata(fig, 'ZefInteractArmed') && isequal(getappdata(fig, 'ZefInteractArmed'), true)
        return
    end
catch
end
prev = [];
try
    prev = fig.WindowButtonMotionFcn;
    setappdata(fig, 'ZefInteractPrevMotionCam', prev);
    fig.WindowButtonMotionFcn = @(src, evt) local_motion_armed(src, evt);
    setappdata(fig, 'ZefInteractArmed', true);
catch
end

end

function local_motion_armed(src, evt)

fig = ancestor(src, 'figure');
if isempty(fig)
    fig = src;
end
pt = [];
try
    if nargin >= 2 && ~isempty(evt) && isprop(evt, 'Point')
        pt = double(evt.Point);
    end
catch
end
try
    zef_figure_interact(fig, 'move', pt);
catch
end
prev = [];
try
    prev = getappdata(fig, 'ZefInteractPrevMotionCam');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    end
catch
end

end

function local_disarm_motion(fig)

armed = false;
try
    armed = isequal(getappdata(fig, 'ZefInteractArmed'), true);
catch
end
if ~armed
    return
end
prev = [];
try
    prev = getappdata(fig, 'ZefInteractPrevMotionCam');
catch
end
try
    fig.WindowButtonMotionFcn = prev;
catch
end
try
    setappdata(fig, 'ZefInteractArmed', false);
    if isappdata(fig, 'ZefInteractPrevMotionCam')
        rmappdata(fig, 'ZefInteractPrevMotionCam');
    end
catch
end

end

function local_apply_delta(ax, mode, sel, dx, dy)

if strcmp(mode, 'pan') || (strcmp(mode, 'rotate') && strcmp(sel, 'extend'))
    local_cam_pan(ax, dx, dy);
elseif strcmp(mode, 'zoom') || (strcmp(mode, 'rotate') && strcmp(sel, 'alt'))
    factor = 1 + max(-0.5, min(0.5, -dy * 0.01));
    local_cam_zoom(ax, factor);
elseif strcmp(mode, 'rotate')
    local_cam_orbit(ax, -dx * 0.35, -dy * 0.35);
end

end

function local_cam_orbit(ax, daz, del)

if ~isfinite(daz) || ~isfinite(del) || (daz == 0 && del == 0)
    return
end
if local_orbit_camera(ax, daz, del)
    return
end
try
    camorbit(ax, daz, del, 'camera');
    return
catch
end
try
    camorbit(ax, daz, del);
    return
catch
end
try
    v = ax.View;
    ax.View = [v(1) + daz, max(-90, min(90, v(2) + del))];
catch
end

end

function ok = local_orbit_camera(ax, daz, del)

ok = false;
try
    pos = get(ax, 'CameraPosition');
    targ = get(ax, 'CameraTarget');
    dar = get(ax, 'DataAspectRatio');
    up = get(ax, 'CameraUpVector');
    dirs = get(ax, {'XDir', 'YDir', 'ZDir'});
    num = length(find(lower(cat(2, dirs{:})) == 'n'));
    if mod(num, 2) == 0
        daz = -daz;
    end
    [new_pos, new_up] = camrotate(pos, targ, dar, up, daz, del, 'camera', [0 0 1]);
    if all(isfinite(new_pos)) && all(isfinite(new_up))
        set(ax, 'CameraPosition', new_pos, 'CameraUpVector', new_up);
        ok = true;
    end
catch
end

end

function local_cam_pan(ax, dx, dy)

% campan leaves CameraPosition where it is and swings CameraTarget, so the
% head orbits the camera instead of sliding with the pointer. Translate
% both by the same vector. One pixel matches the view on the shorter side
% of the axes (CameraViewAngle is that side's field of view).
if ~isfinite(dx) || ~isfinite(dy) || (dx == 0 && dy == 0)
    return
end
pos = get(ax, 'CameraPosition');
tgt = get(ax, 'CameraTarget');
up = get(ax, 'CameraUpVector');
va = local_view_angle(ax);
fwd = tgt - pos;
dist = norm(fwd);
un = norm(up);
if dist < eps || un < eps || ~isfinite(va) || va <= 0
    return
end
fwd = fwd / dist;
up = up / un;
right = cross(fwd, up);
rn = norm(right);
if rn < eps
    return
end
right = right / rn;
up = cross(right, fwd);
un = norm(up);
if un < eps
    return
end
up = up / un;
wh = local_axes_pixels(ax);
minor = max(1, min(wh(1), wh(2)));
scale = (2 * dist * tand(min(va, 179) / 2)) / minor;
delta = (-dx * scale) * right + (-dy * scale) * up;
if any(~isfinite(delta))
    return
end
set(ax, 'CameraPosition', pos + delta, 'CameraTarget', tgt + delta);

end

function wh = local_axes_pixels(ax)

wh = [1 1];
try
    p = getpixelposition(ax, false);
catch
    p = [];
end
if numel(p) >= 4 && all(isfinite(p(3:4)))
    wh = [max(1, p(3)), max(1, p(4))];
end

end

function local_cam_zoom(ax, factor)

if isempty(factor) || ~isfinite(factor) || factor <= 0
    return
end
factor = max(0.05, min(20, double(factor)));
try
    camzoom(ax, factor);
    return
catch
end
try
    va = local_view_angle(ax);
    ax.CameraViewAngle = min(90, max(0.1, va / factor));
catch
end

end

function factor = local_zoom_click_factor(sel)

factor = 1.6;
if any(strcmp(sel, {'extend', 'alt'}))
    factor = 1 / 1.6;
end

end

function consumed = local_click_overlay(fig, ax, mode, obj, pt)

if nargin < 4
    obj = []; %#ok<NASGU>
end
if nargin < 5
    pt = [];
end
consumed = true;
allow_center = isempty(pt);
ray = local_view_ray(fig, ax, pt);
[p, hit] = local_raycast(ax, ray);
if (numel(p) < 3 || any(~isfinite(p))) && allow_center
    [p, hit] = local_raycast(ax, local_view_ray(fig, ax, []));
end
if numel(p) < 3 || any(~isfinite(p))
    return
end
if strcmp(mode, 'measure')
    local_place_datatip(ax, hit, p);
else
    local_place_note(ax, p);
end

end

function ray = local_view_ray(fig, ax, pt)

pos = double(ax.CameraPosition);
tgt = double(ax.CameraTarget);
up = double(ax.CameraUpVector);
fwd = tgt - pos;
dist = norm(fwd);
fwd = fwd / dist;
up = up / norm(up);
right = cross(fwd, up);
right = right / norm(right);
up = cross(right, fwd);
up = up / norm(up);
va = local_view_angle(ax);
rect = local_axes_fig_rect(fig, ax);
if numel(rect) < 4
    rect = [0 0 1 1];
end
wh = [max(1, rect(3)), max(1, rect(4))];
if numel(pt) >= 2 && all(isfinite(double(pt(1:2))))
    ax_px = double(pt(1:2)) - rect(1:2);
else
    ax_px = wh / 2;
end
minor = max(1, min(wh));
scale = (2 * dist * tand(min(max(va, 0.1), 179) / 2)) / minor;
dx = (ax_px(1) - wh(1) / 2) * scale;
dy = (ax_px(2) - wh(2) / 2) * scale;
proj = 'orthographic';
try
    proj = char(string(ax.Projection));
catch
end
if strcmpi(proj, 'orthographic')
    o = pos + dx * right + dy * up;
    d = fwd;
else
    o = pos;
    d = tgt + dx * right + dy * up - pos;
    d = d / norm(d);
end
ray = struct('o', o, 'd', d);

end

function [p, hit] = local_raycast(ax, ray)

p = [NaN NaN NaN];
hit = gobjects(0);
if ~isstruct(ray) || ~isfield(ray, 'o') || ~isfield(ray, 'd')
    return
end
objs = findall(ax, 'Type', 'patch', '-or', 'Type', 'surface');
best = inf;
for i = 1:numel(objs)
    obj = objs(i);
    if ~local_ok(obj)
        continue
    end
    vis = 'on';
    try
        vis = char(string(obj.Visible));
    catch
    end
    if strcmpi(vis, 'off')
        continue
    end
    [hp, ht] = local_ray_object(obj, ray.o, ray.d);
    if ht < best
        best = ht;
        p = hp;
        hit = obj;
    end
end

end

function [p, t] = local_ray_object(obj, o, d)

p = [NaN NaN NaN];
t = inf;
kind = '';
try
    kind = lower(char(string(obj.Type)));
catch
end
if strcmp(kind, 'patch')
    [p, t] = local_ray_tris(obj.Vertices, obj.Faces, o, d);
    return
end
if ~strcmp(kind, 'surface')
    return
end
try
    X = double(obj.XData);
    Y = double(obj.YData);
    Z = double(obj.ZData);
catch
    return
end
if ~ismatrix(X) || ~isequal(size(X), size(Y)) || ~isequal(size(X), size(Z))
    return
end
[m, n] = size(X);
if m < 2 || n < 2
    return
end
V = [X(:), Y(:), Z(:)];
nf = (m - 1) * (n - 1);
F = zeros(nf * 2, 3);
base = 1:(m - 1);
row = 0;
for j = 1:(n - 1)
    i0 = base + (j - 1) * m;
    a = i0.';
    b = a + 1;
    c = a + m;
    e = b + m;
    k = row + (1:numel(a));
    F(k, :) = [a, c, b];
    F(nf + k, :) = [b, c, e];
    row = row + numel(a);
end
[p, t] = local_ray_tris(V, F, o, d);

end

function [p, t] = local_ray_tris(V, F, o, d)

p = [NaN NaN NaN];
t = inf;
if isempty(V) || isempty(F) || size(V, 2) < 3 || size(F, 2) < 3
    return
end
o = double(o(:).');
d = double(d(:).');
dn = norm(d);
if dn < eps
    return
end
d = d / dn;
if size(F, 2) > 3
    F = [F(:, 1:3); F(:, [1 3 4])];
end
F = F(all(F >= 1, 2) & F(:, 1) ~= F(:, 2) & F(:, 2) ~= F(:, 3), :);
if isempty(F)
    return
end
nv = size(V, 1);
if max(F(:)) > nv
    F = F(all(F <= nv, 2), :);
end
if isempty(F)
    return
end
V = double(V(:, 1:3));
v0 = V(F(:, 1), :);
v1 = V(F(:, 2), :);
v2 = V(F(:, 3), :);
e1 = v1 - v0;
e2 = v2 - v0;
pvec = [d(2) * e2(:, 3) - d(3) * e2(:, 2), ...
    d(3) * e2(:, 1) - d(1) * e2(:, 3), ...
    d(1) * e2(:, 2) - d(2) * e2(:, 1)];
det = e1(:, 1) .* pvec(:, 1) + e1(:, 2) .* pvec(:, 2) + e1(:, 3) .* pvec(:, 3);
ok = abs(det) > 1e-14;
if ~any(ok)
    return
end
invdet = zeros(size(det));
invdet(ok) = 1 ./ det(ok);
tvec = [o(1) - v0(:, 1), o(2) - v0(:, 2), o(3) - v0(:, 3)];
u = (tvec(:, 1) .* pvec(:, 1) + tvec(:, 2) .* pvec(:, 2) + tvec(:, 3) .* pvec(:, 3)) .* invdet;
qvec = [tvec(:, 2) .* e1(:, 3) - tvec(:, 3) .* e1(:, 2), ...
    tvec(:, 3) .* e1(:, 1) - tvec(:, 1) .* e1(:, 3), ...
    tvec(:, 1) .* e1(:, 2) - tvec(:, 2) .* e1(:, 1)];
v = (d(1) * qvec(:, 1) + d(2) * qvec(:, 2) + d(3) * qvec(:, 3)) .* invdet;
th = (e2(:, 1) .* qvec(:, 1) + e2(:, 2) .* qvec(:, 2) + e2(:, 3) .* qvec(:, 3)) .* invdet;
hit = ok & u >= 0 & v >= 0 & (u + v) <= 1 & th > 1e-5 & isfinite(th);
if ~any(hit)
    return
end
th(~hit) = inf;
t = min(th);
if ~isfinite(t)
    t = inf;
    return
end
p = o + t * d;

end

function local_place_datatip(ax, obj, p)

if local_tip_near(obj, p)
    return
end
lab = sprintf('x = %.4g\ny = %.4g\nz = %.4g', p(1), p(2), p(3));
try
    t = text(ax, p(1), p(2), p(3), lab, ...
        'BackgroundColor', [1 1 1], 'EdgeColor', [0.45 0.45 0.45], ...
        'Margin', 4, 'FontSize', 10, 'Interpreter', 'none', ...
        'Tag', 'zef_datatip_text', 'VerticalAlignment', 'bottom');
    try
        t.PickableParts = 'none';
    catch
    end
catch
end

end

function kept = local_tip_near(obj, p)

kept = false;
if ~local_ok(obj)
    return
end
meshish = isa(obj, 'matlab.graphics.primitive.Patch') ...
    || isa(obj, 'matlab.graphics.chart.primitive.Surface') ...
    || isa(obj, 'matlab.graphics.chart.primitive.Line') ...
    || isa(obj, 'matlab.graphics.chart.primitive.Scatter');
if ~meshish
    return
end
hdt = [];
try
    hdt = datatip(obj, p(1), p(2), p(3));
catch
    try
        hdt = datatip(obj, p(1), p(2));
    catch
        hdt = [];
    end
end
if ~local_ok(hdt)
    return
end
got = [];
try
    got = double(hdt.Position);
catch
end
tol = local_tip_tol(obj);
if numel(got) >= 3 && norm(got(1:3) - double(p(1:3))) <= tol
    kept = true;
    return
end
try
    delete(hdt);
catch
end

end

function tol = local_tip_tol(obj)

tol = 1e-3;
span = NaN;
try
    if isprop(obj, 'Vertices') && ~isempty(obj.Vertices)
        V = double(obj.Vertices(:, 1:3));
        span = max(max(V, [], 1) - min(V, [], 1));
    elseif isprop(obj, 'XData')
        span = max([range(double(obj.XData(:))), range(double(obj.YData(:))), range(double(obj.ZData(:)))]);
    end
catch
end
if isfinite(span) && span > 0
    tol = max(1e-4, 0.03 * span);
end

end

function local_place_note(ax, p)

try
    t = text(ax, p(1), p(2), p(3), 'Note', ...
        'BackgroundColor', [1 1 0.92], 'EdgeColor', [0.45 0.45 0.45], ...
        'Margin', 4, 'FontSize', 11, 'Interpreter', 'none', ...
        'Tag', 'zef_annotate_text', 'VerticalAlignment', 'bottom');
    try
        t.Editing = 'on';
    catch
    end
catch
end

end

function local_reset_view(fig)

ax = local_axes(fig);
if isempty(ax)
    return
end
home = [];
try
    home = getappdata(fig, 'ZefInteractHome');
catch
end
if isstruct(home) && isfield(home, 'CameraPosition')
    props = {'CameraPosition', 'CameraTarget', 'CameraUpVector', ...
        'CameraViewAngle', 'View'};
    for i = 1:numel(props)
        if isfield(home, props{i})
            try
                ax.(props{i}) = home.(props{i});
            catch
            end
        end
    end
    local_sync_va(fig, ax);
    return
end
az = [];
el = [];
va = [];
try
    zef = evalin('base', 'zef');
    if isfield(zef, 'azimuth')
        az = zef.azimuth;
    end
    if isfield(zef, 'elevation')
        el = zef.elevation;
    end
    if isfield(zef, 'cam_va')
        va = zef.cam_va;
    elseif isfield(zef, 'update_zoom')
        va = zef.update_zoom;
    end
catch
end
try
    if ~isempty(az) && ~isempty(el)
        view(ax, az, el);
    else
        view(ax, 3);
    end
    axis(ax, 'vis3d');
    if ~isempty(va) && isfinite(va)
        ax.CameraViewAngle = va;
    end
catch
end
local_sync_va(fig, ax);

end

function local_capture_home(fig, only_empty)

if only_empty
    try
        prev = getappdata(fig, 'ZefInteractHome');
        if isstruct(prev) && isfield(prev, 'CameraPosition')
            return
        end
    catch
    end
end
ax = local_axes(fig);
if isempty(ax)
    return
end
home = struct();
try
    home.CameraPosition = ax.CameraPosition;
    home.CameraTarget = ax.CameraTarget;
    home.CameraUpVector = ax.CameraUpVector;
    home.CameraViewAngle = ax.CameraViewAngle;
    home.View = ax.View;
catch
    return
end
try
    setappdata(fig, 'ZefInteractHome', home);
catch
end

end

function local_forget_home(fig)

try
    if isappdata(fig, 'ZefInteractHome')
        rmappdata(fig, 'ZefInteractHome');
    end
catch
end

end

function local_sync_toolbar(fig, mode)

keys = {'pan', 'rotate', 'zoom', 'measure', 'annotate'};
changed = false;
for i = 1:numel(keys)
    b = [];
    try
        b = zef_ui_find(fig, ['zef_tool_' keys{i}]);
    catch
    end
    if ~local_ok(b)
        continue
    end
    on = strcmp(keys{i}, mode);
    want = double(on);
    cur = [];
    try
        cur = b.UserData;
    catch
    end
    if isempty(cur)
        cur = 0;
    end
    if ~isequal(cur, want)
        changed = true;
        try
            b.UserData = want;
        catch
        end
        try
            b.Value = want;
        catch
        end
    end
end
if ~changed
    return
end
try
    zef_ui_shell('place_toolbar', fig);
catch
end

end

function local_disable_legacy(fig)

try
    brush(fig, 'off');
catch
end
try
    plotedit(fig, 'off');
catch
end

end

function local_sync_va(fig, ax)

va = local_view_angle(ax);
if ~isfinite(va)
    return
end
sl = [];
try
    sl = zef_ui_control(fig, 'update_zoom_slider');
catch
end
if local_ok(sl)
    try
        sl.Value = min(sl.Max, max(sl.Min, va));
    catch
    end
end
try
    zef = evalin('base', 'zef');
    if isstruct(zef)
        zef.update_zoom = va;
        zef.cam_va = va;
        assignin('base', 'zef', zef);
    end
catch
end

end

function va = local_view_angle(ax)

va = NaN;
try
    va = double(ax.CameraViewAngle);
catch
end

end

function mode = local_get_mode(fig)

mode = 'none';
try
    v = getappdata(fig, 'ZefInteractMode');
    if ~isempty(v)
        mode = local_norm_mode(v);
    end
catch
end

end

function mode = local_norm_mode(mode)

mode = lower(strtrim(char(string(mode))));
if any(strcmp(mode, {'zoomin', 'zoom_in', 'zoom+'}))
    mode = 'zoom';
end
if any(strcmp(mode, {'zoomout', 'zoom_out', 'zoom-'}))
    mode = 'zoom';
end
allowed = {'none', 'rotate', 'pan', 'zoom', 'measure', 'annotate'};
if ~any(strcmp(mode, allowed))
    mode = 'none';
end

end

function ptr = local_pointer(fig)

ptr = local_pointer_for(local_get_mode(fig));

end

function ptr = local_pointer_for(mode)

switch mode
    case 'pan'
        ptr = 'fleur';
    case 'rotate'
        ptr = 'circle';
    case {'zoom', 'measure', 'annotate'}
        ptr = 'crosshair';
    otherwise
        ptr = '';
end

end

function local_set_pointer(fig, ptr)

if isempty(ptr)
    ptr = 'arrow';
end
try
    fig.Pointer = ptr;
catch
end

end

function tf = local_recent(fig, key, dt)

tf = false;
if nargin < 3 || isempty(dt)
    dt = 0.05;
end
t = now * 86400;
try
    prev = getappdata(fig, key);
    if ~isempty(prev) && (t - prev) < dt
        tf = true;
        return
    end
catch
end
try
    setappdata(fig, key, t);
catch
end

end

function tf = local_over_plot(fig, obj)

tf = false;
ax = local_axes(fig);
if nargin < 2 || isempty(obj)
    try
        obj = hittest(fig);
    catch
        obj = [];
    end
end
h = obj;
for k = 1:10
    if ~local_ok(h)
        break
    end
    try
        typ = lower(char(h.Type));
        if any(strcmp(typ, {'axes', 'uiaxes'}))
            tag = '';
            try
                tag = char(h.Tag);
            catch
            end
            tf = strcmp(tag, 'axes1') || isempty(tag);
            if ~tf
                tf = local_ok(ax) && isequal(h, ax);
            end
            if tf
                return
            end
            break
        end
    catch
    end
    try
        h = h.Parent;
    catch
        break
    end
end
tf = local_pointer_in_axes(fig, ax);

end

function tf = local_pointer_in_axes(fig, ax)

tf = false;
if ~local_ok(fig) || ~local_ok(ax)
    return
end
pt = local_fig_point(fig);
if numel(pt) < 2
    return
end
r = local_axes_fig_rect(fig, ax);
if numel(r) < 4
    return
end
tf = pt(1) >= r(1) && pt(1) <= r(1) + r(3) ...
    && pt(2) >= r(2) && pt(2) <= r(2) + r(4);

end

function r = local_axes_fig_rect(fig, ax)

% getpixelposition(ax, true) is already in figure pixels, the same origin
% as CurrentPoint and WindowMouse Point. Subtracting the figure's screen
% position shifts the box by the window origin, so a press on the far
% side of the plot never starts a drag.
r = [];
if ~local_ok(fig) || ~local_ok(ax)
    return
end
try
    ap = double(getpixelposition(ax, true));
    if numel(ap) >= 4 && all(isfinite(ap(1:4))) && ap(3) > 0 && ap(4) > 0
        r = ap(1:4);
    end
catch
end

end


function tf = local_has_volume(h)

tf = false;
ax = h;
if local_is_fig(h)
    ax = local_axes(h);
end
if ~local_ok(ax)
    return
end
try
    tf = isappdata(ax, 'ZefHasVolumePlot') ...
        && isequal(getappdata(ax, 'ZefHasVolumePlot'), true);
catch
end
if tf
    return
end
try
    found = findall(ax, 'Type', 'patch', '-or', 'Type', 'surface', ...
        '-or', 'Type', 'line', '-or', 'Type', 'scatter');
    tf = ~isempty(found);
catch
end

end

function tf = local_is_3d(ax)

tf = false;
try
    v = ax.View;
    tf = numel(v) >= 2 && abs(v(2) - 90) > 0.5;
catch
end
if tf
    return
end
try
    tf = numel(axis(ax)) >= 6;
catch
end

end

function ax = local_axes(fig)

ax = [];
try
    cached = getappdata(fig, 'ZefInteractAxes');
    if local_ok(cached)
        ax = cached;
        return
    end
catch
end
try
    ax = zef_ui_axes(fig);
catch
    try
        found = findall(fig, 'Tag', 'axes1');
        if ~isempty(found) && isgraphics(found(1)) && isvalid(found(1))
            ax = found(1);
        end
    catch
    end
end
if ~local_ok(ax)
    ax = [];
    return
end
try
    setappdata(fig, 'ZefInteractAxes', ax);
catch
end

end

function pt = local_fig_point(fig)

pt = [0 0];
try
    ov = getappdata(fig, 'ZefInteractPointer');
    if numel(ov) >= 2 && all(isfinite(double(ov(1:2))))
        pt = double(ov(1:2));
        return
    end
catch
end
try
    scr = get(0, 'PointerLocation');
    fp = getpixelposition(fig, true);
    cand = [double(scr(1)) - double(fp(1)), double(scr(2)) - double(fp(2))];
    if numel(cand) >= 2 && all(isfinite(cand))
        pt = cand(1:2);
        return
    end
catch
end
try
    orig = fig.Units;
    fig.Units = 'pixels';
    pt = fig.CurrentPoint;
    fig.Units = orig;
catch
end
if numel(pt) < 2
    pt = [0 0];
end
pt = double(pt(1:2));

end

function fig = local_default_fig()

fig = [];
try
    zef = evalin('base', 'zef');
    if isstruct(zef) && isfield(zef, 'h_zeffiro') && local_is_fig(zef.h_zeffiro)
        fig = zef.h_zeffiro;
        return
    end
catch
end
try
    fig = gcf;
    if ~local_is_fig(fig)
        fig = [];
    end
catch
    fig = [];
end

end

function tf = local_is_fig(h)

tf = false;
try
    tf = ~isempty(h) && isgraphics(h) && isvalid(h) ...
        && any(strcmpi(char(h.Type), {'figure', 'uifigure'}));
catch
end

end

function tf = local_ok(h)

tf = false;
try
    tf = ~isempty(h) && isgraphics(h) && isvalid(h);
catch
end

end
