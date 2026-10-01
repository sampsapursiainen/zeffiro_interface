function varargout = zef_ui_shell(action, varargin)
%ZEF_UI_SHELL  Unified application chrome: header, nav, workspace, footer.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   The left nav is a live view of the Menu tool uimenu tree. Plugins
%   added by zef_plugin appear automatically because flyouts are built
%   from the actual menu children at click time. Callbacks, Tags, and
%   handles are not duplicated.
%
%   Nav hover is a figure-level WindowMouseMotion listener. Hit maps and
%   pointer events use figure-relative pixels so the full row container
%   (not only the icon or label) matches. Each menu row keeps a create-once
%   axes image from zef_ui_roundrect (same pattern as zef_ui_card). That
%   axes is the row's ONLY painted layer: the rounded fill, the composited
%   icon glyph, and a transparent text object for the label all live in
%   it. The label/icon/hit uicontrols are kept for tags, Strings, and
%   callbacks but are never shown, so no second square background can
%   stack over the chip (which used to read as two overlapping rectangles
%   with a stepped bottom edge). Toolbar icon/label pairs highlight together.
%
%   zef_ui_shell('build', h_fig)
%   zef_ui_shell('bind', zef)
%   zef_ui_shell('layout', h_fig)
%   zef_ui_shell('hide_menu', zef)
%   zef_ui_shell('hide_companions', zef)
%   zef_ui_shell('dismiss', h_fig)
%   zef_ui_shell('theme', h_fig)  % restyle chrome from canonical tokens
%   zef_ui_shell('raise_figure')
%
%   See also zef_figure_tool, zef_menu_tool, zef_ui_theme.

if nargin < 1 || isempty(action)
    action = 'build';
end
action = lower(char(string(action)));

switch action
    case 'build'
        local_build(varargin{:});
    case 'bind'
        local_bind(varargin{:});
    case 'layout'
        local_layout(varargin{:});
    case 'hide_menu'
        local_hide_menu(varargin{:});
    case 'hide_companions'
        local_hide_companions(varargin{:});
    case 'dismiss'
        local_dismiss(varargin{:});
    case 'theme'
        local_theme(varargin{:});
    case 'place_toolbar'
        local_refresh_toolbar(varargin{:});
    case 'raise_figure'
        local_raise_figure();
    case 'content_rect'
        [varargout{1:nargout}] = local_content_rect(varargin{:});
    case {'hits', 'hitmap', 'refresh_hits'}
        local_store_hit_maps(varargin{:});
    otherwise
        error('zef_ui_shell:UnknownAction', 'Unknown action: %s', action);
end

end

function local_build(h_fig)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
if ~isempty(zef_ui_find(h_fig, 'zef_shell_nav'))
    return
end

theme = zef_ui_theme();
h_fig.Color = theme.color.bg;
setappdata(h_fig, 'ZefUnifiedShell', true);

header = uipanel('Parent', h_fig, 'Units', 'pixels', 'BorderType', 'none', ...
    'HighlightColor', theme.color.headerBg, 'BackgroundColor', theme.color.headerBg, ...
    'ForegroundColor', theme.color.text, 'Title', '', 'Tag', 'zef_shell_header');
nav = uipanel('Parent', h_fig, 'Units', 'pixels', 'BorderType', 'none', ...
    'HighlightColor', theme.color.bg, 'BackgroundColor', theme.color.bg, ...
    'ForegroundColor', theme.color.text, 'Title', '', 'Tag', 'zef_shell_nav');
card = uipanel('Parent', h_fig, 'Units', 'pixels', 'BorderType', 'none', ...
    'BackgroundColor', theme.color.bg, 'ForegroundColor', theme.color.text, ...
    'Title', '', 'Tag', 'zef_shell_card');
tabs = uipanel('Parent', card, 'Units', 'pixels', 'BorderType', 'none', ...
    'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
    'Title', '', 'Tag', 'zef_shell_tabs');
tools = uipanel('Parent', card, 'Units', 'pixels', 'BorderType', 'none', ...
    'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
    'Title', '', 'Tag', 'zef_shell_toolbar');
footer = uipanel('Parent', h_fig, 'Units', 'pixels', 'BorderType', 'none', ...
    'HighlightColor', theme.color.footerBg, 'BackgroundColor', theme.color.footerBg, ...
    'ForegroundColor', theme.color.textMuted, 'Title', '', 'Tag', 'zef_shell_footer');

try
    header.AutoResizeChildren = 'off';
    nav.AutoResizeChildren = 'off';
    card.AutoResizeChildren = 'off';
    tabs.AutoResizeChildren = 'off';
    tools.AutoResizeChildren = 'off';
    footer.AutoResizeChildren = 'off';
catch
end

local_build_header(header, theme);
local_build_nav(nav, theme);
local_build_tabs(tabs, theme);
local_build_toolbar(tools, h_fig, theme);
local_build_footer(footer, theme);

try
    ax = zef_ui_find(h_fig, 'axes1');
    if ~isempty(ax) && isvalid(ax)
        ax.Color = theme.color.axesBg;
        try
            ax.Toolbar.Visible = 'off';
        catch
        end
    end
catch
end

prev = get(h_fig, 'WindowButtonDownFcn');
setappdata(h_fig, 'ZefShellPrevDownFcn', prev);
h_fig.WindowButtonDownFcn = @(src, evt) local_window_down(src, evt);
try
    prevu = get(h_fig, 'WindowButtonUpFcn');
    setappdata(h_fig, 'ZefShellPrevUpFcn', prevu);
    h_fig.WindowButtonUpFcn = @(src, evt) local_window_up(src, evt);
catch
end
try
    local_install_pointer_release(h_fig);
catch
end
try
    prevk = get(h_fig, 'WindowKeyPressFcn');
    setappdata(h_fig, 'ZefShellPrevKeyFcn', prevk);
    h_fig.WindowKeyPressFcn = @(src, evt) local_window_key(src, evt);
catch
end
try
    local_ensure_flyout_wheel(h_fig);
catch
end
local_install_nav_hover(h_fig);
local_restore_axes(h_fig);
try
    zef_ui_interact(h_fig);
catch
end

end

function local_build_header(header, theme)

logo = local_make_icon_btn(header, 'zef_shell_header_logo', theme.color.headerBg, false);
try
    logo.TooltipString = 'Zeffiro Interface';
catch
end

uicontrol('Style', 'pushbutton', 'Parent', header, 'Units', 'pixels', ...
    'String', '', 'Tag', 'zef_shell_help', ...
    'Callback', 'web(''https://github.com/sampsapursiainen/zeffiro_interface'');', ...
    'BackgroundColor', theme.color.headerBg, 'ForegroundColor', theme.color.text, ...
    'TooltipString', 'Help', 'FontName', theme.font.name, 'FontSize', theme.font.sizeSmall);
uicontrol('Style', 'pushbutton', 'Parent', header, 'Units', 'pixels', ...
    'String', '', 'Tag', 'zef_shell_bell', ...
    'Callback', @local_open_log, ...
    'BackgroundColor', theme.color.headerBg, 'ForegroundColor', theme.color.text, ...
    'TooltipString', 'Session log', 'FontName', theme.font.name, 'FontSize', theme.font.sizeSmall);
uicontrol('Style', 'pushbutton', 'Parent', header, 'Units', 'pixels', ...
    'String', '', 'Tag', 'zef_shell_profile', ...
    'Callback', @local_open_profile, ...
    'BackgroundColor', theme.color.headerBg, 'ForegroundColor', theme.color.text, ...
    'TooltipString', 'Init profile', 'FontName', theme.font.name, 'FontSize', theme.font.sizeSmall);
uicontrol('Style', 'text', 'Parent', header, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'Tag', 'zef_header_rule', ...
    'BackgroundColor', theme.color.border);
for tag = {'zef_shell_help', 'zef_shell_bell', 'zef_shell_profile'}
    b = findall(header, 'Tag', tag{1});
    if ~isempty(b)
        try
            b(1).BusyAction = 'cancel';
        catch
        end
    end
end

end

function local_build_nav(nav, theme)

local_make_icon_btn(nav, 'zef_shell_brand_mark', theme.color.navBg, false);
uicontrol('Style', 'text', 'Parent', nav, 'Units', 'pixels', ...
    'String', 'ZEFFIRO', 'HorizontalAlignment', 'left', 'FontWeight', 'bold', ...
    'ForegroundColor', theme.color.text, 'BackgroundColor', theme.color.navBg, ...
    'Tag', 'zef_shell_brand_title', 'FontName', theme.font.name, ...
    'FontUnits', 'pixels', 'FontSize', theme.font.sizeTitle);
uicontrol('Style', 'text', 'Parent', nav, 'Units', 'pixels', ...
    'String', 'INTERFACE', 'HorizontalAlignment', 'left', ...
    'ForegroundColor', theme.color.accent, 'BackgroundColor', theme.color.navBg, ...
    'Tag', 'zef_shell_brand_sub', 'FontName', theme.font.name, ...
    'FontUnits', 'pixels', 'FontSize', theme.font.sizeSmall);

items = local_nav_spec();
for i = 1:size(items, 1)
    key = items{i, 1};
    label = items{i, 2};
    field = items{i, 3};
    % Clicks are owned solely by the figure-level WindowButtonDownFcn
    % (hit maps in local_window_down). The row panel must NOT also wire
    % ButtonDownFcn: both fire for one press and the duplicate toggles
    % the flyout straight back closed.
    row = uipanel('Parent', nav, 'Units', 'pixels', 'BorderType', 'none', ...
        'Title', '', 'Tag', ['zef_nav_row_' key], 'UserData', field, ...
        'BackgroundColor', theme.color.panel, 'ForegroundColor', theme.color.text, ...
        'HighlightColor', theme.color.panel);
    try
        row.AutoResizeChildren = 'off';
        row.BorderWidth = 0;
        row.BorderColor = theme.color.panel;
    catch
    end
    hit = uicontrol('Style', 'text', 'Parent', row, 'Units', 'pixels', ...
        'String', '', 'Enable', 'inactive', 'Tag', ['zef_nav_hit_' key], 'UserData', field, ...
        'BackgroundColor', theme.color.panel, 'ForegroundColor', theme.color.panel, ...
        'Callback', @local_nav_click, 'ButtonDownFcn', @local_nav_click, ...
        'TooltipString', label);
    try
        hit.BusyAction = 'cancel';
    catch
    end
    ic = uicontrol('Style', 'text', 'Parent', row, 'Units', 'pixels', ...
        'String', '', 'Enable', 'inactive', 'Tag', ['zef_nav_icon_' key], ...
        'UserData', field, 'BackgroundColor', theme.color.panel, ...
        'ForegroundColor', theme.color.panel, 'Callback', @local_nav_click, ...
        'ButtonDownFcn', @local_nav_click, 'TooltipString', label);
    try
        ic.BusyAction = 'cancel';
        ic.CData = [];
    catch
    end
    btn = uicontrol('Style', 'text', 'Parent', row, 'Units', 'pixels', ...
        'String', label, 'HorizontalAlignment', 'left', 'Enable', 'inactive', ...
        'Tag', ['zef_nav_' key], 'UserData', field, ...
        'BackgroundColor', theme.color.panel, 'ForegroundColor', theme.color.text, ...
        'FontName', theme.font.name, 'FontUnits', 'pixels', ...
        'FontSize', theme.font.size, 'Callback', @local_nav_click, ...
        'ButtonDownFcn', @local_nav_click, 'TooltipString', label);
    try
        uistack(hit, 'bottom');
    catch
    end
end
uicontrol('Style', 'text', 'Parent', nav, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'Tag', 'zef_nav_sep', ...
    'BackgroundColor', theme.color.border);

end

function items = local_nav_spec()

items = { ...
    'project', 'Project', 'h_menu_project'; ...
    'export', 'Export', 'h_menu_export'; ...
    'import', 'Import', 'h_menu_import'; ...
    'edit', 'Edit', 'h_menu_edit'; ...
    'inverse', 'Inverse Tools', 'h_menu_inverse_tools'; ...
    'forward', 'Forward Tools', 'h_menu_forward_tools'; ...
    'multi', 'Multi-Tools', 'h_menu_multi_tools'; ...
    'settings', 'Settings', 'h_menu_settings'; ...
    'window', 'Window', 'h_menu_window'; ...
    'help', 'Help', 'h_menu_help'};

end

function local_build_tabs(tabs, theme)

uicontrol('Style', 'text', 'Parent', tabs, 'Units', 'pixels', ...
    'String', 'Figure', 'Tag', 'zef_tab_figure', 'UserData', 1, ...
    'Enable', 'inactive', 'HorizontalAlignment', 'center', ...
    'ForegroundColor', theme.color.accent, 'BackgroundColor', theme.color.workspace, ...
    'FontWeight', 'bold', 'FontName', theme.font.name, ...
    'FontSize', theme.font.size);
uicontrol('Style', 'text', 'Parent', tabs, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'BackgroundColor', theme.color.accent, ...
    'Tag', 'zef_tab_underline');
uicontrol('Style', 'text', 'Parent', tabs, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'BackgroundColor', theme.color.border, ...
    'Tag', 'zef_tab_rule');

end

function local_build_toolbar(tools, h_fig, theme)

spec = { ...
    'pan', 'Pan', @local_tool_pan, 'pushbutton'; ...
    'rotate', 'Rotate 3D', @local_tool_rotate, 'pushbutton'; ...
    'zoom', 'Zoom In', @local_tool_zoom, 'pushbutton'; ...
    'zoomout', 'Zoom Out', @local_tool_zoomout, 'pushbutton'; ...
    'reset', 'Reset View', @local_tool_reset, 'pushbutton'; ...
    'screenshot', 'Screenshot', @local_tool_screenshot, 'pushbutton'; ...
    'colormap', 'Colormap', @local_tool_colormap, 'pushbutton'; ...
    'measure', 'Data Cursor', @local_tool_measure, 'pushbutton'; ...
    'annotate', 'Annotate', @local_tool_annotate, 'pushbutton'; ...
    'edges', 'Toggle Edges', @local_tool_edges, 'pushbutton'};
for i = 1:size(spec, 1)
    btn = uicontrol('Style', spec{i, 4}, 'Parent', tools, 'Units', 'pixels', ...
        'String', '', 'Tag', ['zef_tool_' spec{i, 1}], ...
        'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
        'FontName', theme.font.name, 'FontSize', theme.font.sizeSmall, ...
        'Callback', spec{i, 3}, 'TooltipString', spec{i, 2});
    try
        btn.BusyAction = 'cancel';
    catch
    end
    btn.UserData = 0;
    lab = uicontrol('Style', 'text', 'Parent', tools, 'Units', 'pixels', ...
        'String', spec{i, 2}, 'Tag', ['zef_tool_lab_' spec{i, 1}], ...
        'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
        'FontName', theme.font.name, 'FontUnits', 'pixels', ...
        'FontSize', theme.font.sizeSmall, 'HorizontalAlignment', 'left', ...
        'Enable', 'inactive', 'ButtonDownFcn', @(s, e) local_tool_from_label(s, spec{i, 1}), ...
        'TooltipString', spec{i, 2});
    lab.UserData = spec{i, 1};
end
uicontrol('Style', 'text', 'Parent', tools, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'Tag', 'zef_tool_sep', ...
    'BackgroundColor', theme.color.border);
uicontrol('Style', 'text', 'Parent', tools, 'Units', 'pixels', ...
    'String', '', 'Enable', 'inactive', 'Tag', 'zef_tool_rule', ...
    'BackgroundColor', theme.color.border);
uicontrol('Style', 'pushbutton', 'Parent', tools, 'Units', 'pixels', ...
    'String', '', 'Tag', 'zef_tool_sliders', ...
    'Callback', 'zef_toggle_figure_controls;', ...
    'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
    'TooltipString', 'Toggle controls');
uicontrol('Style', 'pushbutton', 'Parent', tools, 'Units', 'pixels', ...
    'String', '', 'Tag', 'zef_tool_more', ...
    'Callback', @(src, ~) local_tool_more(src, h_fig), ...
    'BackgroundColor', theme.color.workspace, 'ForegroundColor', theme.color.text, ...
    'TooltipString', 'More');
for tag = {'zef_tool_sliders', 'zef_tool_more'}
    b = findall(tools, 'Tag', tag{1});
    if ~isempty(b)
        try
            b(1).BusyAction = 'cancel';
        catch
        end
    end
end

end

function local_build_footer(footer, theme)

uicontrol('Style', 'text', 'Parent', footer, 'Units', 'pixels', ...
    'String', 'Zeffiro Interface V2', 'HorizontalAlignment', 'left', ...
    'ForegroundColor', theme.color.textMuted, 'BackgroundColor', theme.color.footerBg, ...
    'Tag', 'zef_shell_version', 'FontName', theme.font.name, ...
    'FontUnits', 'pixels', 'FontSize', theme.font.sizeSmall);
uicontrol('Style', 'text', 'Parent', footer, 'Units', 'pixels', ...
    'String', '© 2018–2026 Sampsa Pursiainen & ZI Development Team', ...
    'HorizontalAlignment', 'center', 'ForegroundColor', theme.color.textMuted, ...
    'BackgroundColor', theme.color.footerBg, 'Tag', 'zef_shell_copy', ...
    'FontName', theme.font.name, 'FontUnits', 'pixels', ...
    'FontSize', theme.font.sizeSmall);

end

function local_bind(zef)

if nargin < 1 || isempty(zef)
    try
        zef = evalin('base', 'zef');
    catch
        return
    end
end
if ~isstruct(zef) || ~isfield(zef, 'h_zeffiro') || ~local_ok(zef.h_zeffiro)
    return
end
h_fig = zef.h_zeffiro;
items = local_nav_spec();
for i = 1:size(items, 1)
    for prefix = {'zef_nav_', 'zef_nav_icon_', 'zef_nav_hit_', 'zef_nav_row_'}
        btn = zef_ui_find(h_fig, [prefix{1} items{i, 1}]);
        if isempty(btn) || ~isvalid(btn)
            continue
        end
        field = items{i, 3};
        h_menu = [];
        if isfield(zef, field) && local_ok(zef.(field))
            h_menu = zef.(field);
        end
        try
            setappdata(btn, 'ZefMenuHandle', h_menu);
        catch
        end
        btn.UserData = field;
    end
end
local_hide_menu(zef);
local_hide_companions(zef);
try
    assignin('base', 'zef', zef);
catch
end

end

function local_hide_menu(zef)

if nargin < 1 || isempty(zef)
    try
        zef = evalin('base', 'zef');
    catch
        return
    end
end
if ~isstruct(zef) || ~isfield(zef, 'h_zeffiro_menu') || ~local_ok(zef.h_zeffiro_menu)
    return
end
h_menu = zef.h_zeffiro_menu;
try
    h_menu.Visible = 'off';
catch
end
try
    h_menu.HandleVisibility = 'off';
catch
end
try
    if isprop(h_menu, 'WindowState')
        h_menu.WindowState = 'normal';
    end
catch
end

end

function local_hide_companions(zef)

if nargin < 1 || isempty(zef)
    try
        zef = evalin('base', 'zef');
    catch
        return
    end
end
if ~isstruct(zef)
    return
end
fields = {'h_zeffiro_window_main', 'h_mesh_tool', 'h_mesh_visualization_tool'};
for i = 1:numel(fields)
    if ~isfield(zef, fields{i})
        continue
    end
    h = zef.(fields{i});
    if ~local_ok(h)
        continue
    end
    try
        h.Visible = 'off';
    catch
    end
end
local_hide_menu(zef);

end

function local_layout(h_fig)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
if ~zef_ui_is_unified(h_fig)
    return
end
try
    orig_chk = h_fig.Units;
    h_fig.Units = 'pixels';
    sz = round(h_fig.Position(3:4));
    h_fig.Units = orig_chk;
    prev = getappdata(h_fig, 'ZefShellLayoutSize');
    if ~isempty(prev) && isequal(prev, sz)
        % Same size: keep flyouts (creating a panel can re-enter layout).
    else
        fly = getappdata(h_fig, 'ZefFlyoutPanel');
        if local_ok(fly)
            local_dismiss(h_fig);
        end
        setappdata(h_fig, 'ZefShellLayoutSize', sz);
    end
catch
end

theme = zef_ui_theme();
orig = h_fig.Units;
h_fig.Units = 'pixels';
pos = h_fig.Position;
W = max(pos(3), 1);
H = max(pos(4), 1);

header_h = local_header_height(theme, W);
footer_h = theme.space.footerH;
nav_w = theme.space.navW;
show_labels = W >= 860;
if W < 860
    nav_w = theme.space.navWCompact;
    show_labels = false;
end

header = zef_ui_find(h_fig, 'zef_shell_header');
nav = zef_ui_find(h_fig, 'zef_shell_nav');
work = zef_ui_find(h_fig, 'zef_shell_card');
tabs = zef_ui_find(h_fig, 'zef_shell_tabs');
tools = zef_ui_find(h_fig, 'zef_shell_toolbar');
footer = zef_ui_find(h_fig, 'zef_shell_footer');
right_inset = local_right_inset(h_fig);
gap = 12;
try
    gap = theme.space.cardGap;
    rad = theme.space.cardRadius;
catch
    rad = 10;
end
top_gap = local_header_gap(theme, W, H);
try
    setappdata(h_fig, 'ZefShellHeaderGap', top_gap);
    setappdata(h_fig, 'ZefShellHeaderH', header_h);
catch
end

if local_ok(header)
    header.Units = 'pixels';
    header.Position = [0, H - header_h, W, header_h];
    local_place_header(header, theme);
end
if local_ok(nav)
    nav.Units = 'pixels';
    nav.Position = [gap, footer_h + gap, nav_w, max(40, H - header_h - footer_h - gap - top_gap)];
    try
        zef_ui_card(nav, theme);
    catch
    end
    local_place_nav(nav, theme, show_labels);
    local_install_nav_hover(h_fig);
end
if local_ok(footer)
    footer.Units = 'pixels';
    footer.Position = [0, 0, W, footer_h];
    local_place_footer(footer, theme);
end

content_x = nav_w + 2 * gap;
content_w = max(120, W - nav_w - right_inset - 2 * gap);
status_h = theme.space.statusH;
figure_y = footer_h + 2 * gap + status_h;
figure_h = max(80, H - header_h - top_gap - figure_y);
if local_ok(work)
    work.Units = 'pixels';
    work.Position = [content_x, figure_y, content_w, figure_h];
    try
        work.Visible = 'on';
        work.BackgroundColor = theme.color.bg;
        work.BorderType = 'none';
    catch
    end
    local_adopt(tabs, work);
    local_adopt(tools, work);
    view = zef_ui_find(h_fig, 'figure_view');
    local_adopt(view, work);
    try
        zef_ui_card(work, theme);
    catch
    end
    local_place_workspace(work, tabs, tools, view, theme);
end
try
    if ~(isappdata(h_fig, 'ZefChromeRaised') ...
            && isequal(getappdata(h_fig, 'ZefChromeRaised'), true))
        local_raise_chrome(h_fig);
        setappdata(h_fig, 'ZefChromeRaised', true);
    end
catch
    local_raise_chrome(h_fig);
end
try
    zef_ui_card_corners(h_fig, [content_x, figure_y, content_w, figure_h], theme, rad);
catch
end

h_fig.Units = orig;
local_restore_axes(h_fig);
try
    local_store_hit_maps(h_fig);
catch
end

end

function local_place_workspace(work, tabs, tools, view, theme)

if ~local_ok(work)
    return
end
work.Units = 'pixels';
wp = double(work.Position);
w = max(1, round(wp(3)));
h = max(1, round(wp(4)));
rad = 12;
tabH = 28;
toolH = 36;
try
    rad = theme.space.cardRadius;
    tabH = theme.space.tabH;
    toolH = theme.space.toolbarH;
catch
end
inner_x = rad;
inner_y = rad;
inner_w = max(40, w - 2 * rad);
inner_h = max(40, h - 2 * rad);
if local_ok(tabs)
    tabs.Units = 'pixels';
    tabs.Position = [inner_x, inner_y + inner_h - tabH, inner_w, tabH];
    local_place_tabs(tabs, theme);
end
if local_ok(tools)
    tools.Units = 'pixels';
    tools.Position = [inner_x, inner_y + inner_h - tabH - toolH, inner_w, toolH];
    local_place_toolbar(tools, theme, inner_w);
end
if local_ok(view)
    view.Units = 'pixels';
    view_h = max(40, inner_h - tabH - toolH);
    view.Position = [inner_x, inner_y, inner_w, view_h];
end
bg = zef_ui_find(work, 'zef_card_bg');
if local_ok(bg)
    try
        uistack(bg, 'bottom');
    catch
    end
end

end

function local_adopt(h, parent)

if ~local_ok(h) || ~local_ok(parent)
    return
end
try
    if isequal(h.Parent, parent)
        return
    end
catch
end
try
    h.Parent = parent;
catch
end

end

function [x, y, w, h] = local_content_rect(h_fig, theme)

if nargin < 2 || isempty(theme)
    theme = zef_ui_theme();
end
orig = h_fig.Units;
h_fig.Units = 'pixels';
p = h_fig.Position;
W = max(p(3), 1);
H = max(p(4), 1);
h_fig.Units = orig;
x = 0;
y = 0;
w = W;
h = H;
if ~zef_ui_is_unified(h_fig)
    return
end
nav_w = theme.space.navW;
if W < 860
    nav_w = theme.space.navWCompact;
end
gap = theme.space.cardGap;
x = nav_w + 2 * gap;
y = theme.space.footerH + 2 * gap + theme.space.statusH;
w = max(80, W - nav_w - local_right_inset(h_fig) - 2 * gap);
header_h = local_header_height(theme, W);
top_gap = local_header_gap(theme, W, H);
h = max(80, H - header_h - theme.space.footerH - theme.space.statusH ...
    - top_gap - 2 * gap - theme.space.tabH - theme.space.toolbarH);

end

function local_place_header(header, theme)

p = header.Position;
inner_h = p(4);
logo = zef_ui_find(header, 'zef_shell_header_logo');
mark = zef_ui_find(header, 'zef_shell_header_mark');
title = zef_ui_find(header, 'zef_shell_title');
sub = zef_ui_find(header, 'zef_shell_header_sub');
local_delete_legacy_theme_controls(header);
helpb = zef_ui_find(header, 'zef_shell_help');
bellb = zef_ui_find(header, 'zef_shell_bell');
profb = zef_ui_find(header, 'zef_shell_profile');
y = max(8, round((inner_h - 24) / 2) + 1);
x_right = p(3) - 12;
right_icons = {profb, 'profile'; bellb, 'bell'; helpb, 'help'};
for i = 1:size(right_icons, 1)
    hb = right_icons{i, 1};
    if local_ok(hb)
        hb.Position = [x_right - 24, y, 24, 24];
        hb.String = '';
        hb.Enable = 'on';
        hb.BackgroundColor = theme.color.headerBg;
        local_show_icon(hb, right_icons{i, 2}, 22, theme.color.text, theme.color.headerBg);
        x_right = x_right - 30;
    end
end
if local_ok(mark)
    mark.Visible = 'off';
end
if local_ok(title)
    title.Visible = 'off';
end
if local_ok(sub)
    sub.Visible = 'off';
end
if ~local_ok(logo)
    logo = local_make_icon_btn(header, 'zef_shell_header_logo', theme.color.headerBg, false);
    try
        logo.TooltipString = 'Zeffiro Interface';
    catch
    end
end
x0 = 12;
if local_ok(logo)
    header.Units = 'pixels';
    max_w = max(64, x_right - x0 - 12);
    lh = max(20, inner_h - 8);
    [lw, lh] = local_header_logo_size(max_w, lh);
    ly = max(1, round((inner_h - lh) / 2));
    logo.Position = [x0, ly, lw, lh];
    local_show_header_logo(logo, theme);
end
rule = zef_ui_find(header, 'zef_header_rule');
if local_ok(rule)
    show_rule = true;
    try
        show_rule = theme.space.headerGap >= 1;
    catch
    end
    rule.Visible = onoff(show_rule);
    rule.Position = [0, 0, max(1, p(3)), 1];
    rule.BackgroundColor = theme.color.border;
end

end

function local_place_nav(nav, theme, show_labels)

p = nav.Position;
pad = 10;
item_h = theme.space.navItemH;
inner_w = max(36, p(3) - 2 * pad);
mark = zef_ui_find(nav, 'zef_shell_brand_mark');
title = zef_ui_find(nav, 'zef_shell_brand_title');
sub = zef_ui_find(nav, 'zef_shell_brand_sub');
if local_ok(mark)
    mark.Visible = 'off';
end
if local_ok(title)
    title.Visible = 'off';
end
if local_ok(sub)
    sub.Visible = 'off';
end

items = local_nav_spec();
n = size(items, 1);
top_n = 7;
icon_s = 24;
avail = max(40, p(4) - 2 * pad);
top_gap = 5;
group_extra = 16;
needed = n * item_h + (n - 1) * top_gap + group_extra + 2 * pad;
if needed > p(4)
    slack = avail - n * item_h - group_extra;
    if slack >= 0
        top_gap = slack / max(1, n - 1);
    else
        item_h = max(icon_s + 4, floor((avail - group_extra) / n));
        top_gap = 0;
    end
end
ys = zeros(n, 1);
y_top = p(4) - pad - item_h;
for i = 1:n
    ys(i) = y_top;
    y_top = y_top - item_h - top_gap;
    if i == top_n
        y_top = y_top - group_extra;
    end
end
bot_n = n - top_n;
if bot_n > 0
    bot_gap = 5;
    y_bot = pad;
    ys_bot = zeros(bot_n, 1);
    for k = bot_n:-1:1
        ys_bot(k) = y_bot;
        y_bot = y_bot + item_h + bot_gap;
    end
    top_limit = ys(top_n) - group_extra - item_h;
    if ys_bot(1) <= top_limit
        ys(top_n + 1:n) = ys_bot;
    end
end
paint_key = {char(theme.mode), logical(show_labels)};
do_paint = true;
try
    do_paint = ~isequal(getappdata(nav, 'ZefNavPaintKey'), paint_key);
catch
end
for i = 1:n
    key = items{i, 1};
    row = zef_ui_find(nav, ['zef_nav_row_' key]);
    if ~local_ok(row)
        continue
    end
    row.Units = 'pixels';
    row.Position = [pad, max(4, ys(i)), inner_w, item_h];
    try
        row.AutoResizeChildren = 'off';
        row.BorderType = 'none';
        row.BorderWidth = 0;
        row.BorderColor = theme.color.panel;
    catch
    end
    row.UserData = items{i, 3};
    local_nav_layout_row(row, theme, show_labels, key, items{i, 2}, items{i, 3});
    if do_paint
        local_nav_paint_row(row, theme, key, items{i, 2});
    end
end
sep = zef_ui_find(nav, 'zef_nav_sep');
if local_ok(sep) && (top_n + 1) <= n
    sep.Visible = 'on';
    sep.BackgroundColor = theme.color.border;
    sep_y = ys(top_n + 1) + item_h + max(6, round((ys(top_n) - ys(top_n + 1) - item_h) / 2));
    sep.Position = [pad + 4, sep_y, max(16, inner_w - 8), 1];
end
try
    if do_paint
        setappdata(nav, 'ZefNavPaintKey', paint_key);
        local_prefetch_nav_icons(theme);
    end
catch
end

end

function local_nav_layout_row(row, theme, show_labels, key, label, field)

hit = zef_ui_find(row, ['zef_nav_hit_' key]);
ic = zef_ui_find(row, ['zef_nav_icon_' key]);
btn = zef_ui_find(row, ['zef_nav_' key]);
row.Units = 'pixels';
rp = row.Position;
rw = max(1, rp(3));
rh = max(1, rp(4));
icon_s = 24;
pad_x = 8;
gap = 8;
icon_y = 0;
icon_h = rh;
glyph_y = max(0, round((rh - icon_s) / 2));
if show_labels
    icon_x = pad_x;
else
    icon_x = max(0, round((rw - icon_s) / 2));
end
ready = false;
try
    ready = isappdata(row, 'ZefNavRowReady') && isequal(getappdata(row, 'ZefNavRowReady'), true);
catch
end
if local_ok(hit)
    hit.Units = 'pixels';
    hit.Position = [0, 0, rw, rh];
    try
        hit.CData = [];
    catch
    end
    try
        if isappdata(hit, 'ZefNavHitKey')
            rmappdata(hit, 'ZefNavHitKey');
        end
    catch
    end
    if ~ready
        hit.UserData = field;
        hit.Enable = 'inactive';
        hit.Callback = @local_nav_click;
        hit.ButtonDownFcn = @local_nav_click;
        hit.TooltipString = label;
        try
            if ~isappdata(hit, 'ZefHitStacked')
                uistack(hit, 'bottom');
                setappdata(hit, 'ZefHitStacked', true);
            end
        catch
        end
    end
end
if local_ok(ic)
    ic.Units = 'pixels';
    ic_w = icon_s;
    if show_labels
        ic_w = icon_s + gap;
    end
    ic.Position = [icon_x, icon_y, ic_w, icon_h];
    try
        ic.Style = 'text';
        ic.String = '';
        ic.CData = [];
    catch
    end
    if ~ready
        ic.UserData = field;
        ic.Callback = @local_nav_click;
        ic.ButtonDownFcn = @local_nav_click;
        ic.Enable = 'inactive';
        ic.TooltipString = label;
    end
end
lab_x = icon_x + icon_s + gap;
if local_ok(btn)
    btn.Units = 'pixels';
    if ~ready
        btn.String = label;
        btn.UserData = field;
        btn.HorizontalAlignment = 'left';
        btn.Enable = 'inactive';
        btn.Callback = @local_nav_click;
        btn.ButtonDownFcn = @local_nav_click;
        try
            btn.FontUnits = 'pixels';
            btn.FontSize = theme.font.size;
            btn.FontWeight = 'normal';
        catch
        end
    end
    if show_labels
        lab_w = max(24, rw - lab_x - pad_x);
        btn.Position = [lab_x, 0, lab_w, rh];
    end
    % The chip axes is the row's only painted layer (fill + icon + text).
    % A visible label uicontrol would stack a second, square background
    % over the rounded chip, so the uicontrol is never shown; it is kept
    % only for its tag, String, and callback identity.
    btn.Visible = 'off';
end
fillc = theme.color.panel;
icon_fg = theme.color.navIcon;
try
    prev_fill = getappdata(row, 'ZefChipFill');
    if ~isempty(prev_fill)
        fillc = prev_fill;
        if isequal(round(fillc * 1000), round(theme.color.navHover * 1000)) ...
                || isequal(round(fillc * 1000), round(theme.color.navActive * 1000))
            icon_fg = theme.color.accent;
        end
    end
catch
end
r = local_menu_chip_radius(theme, rh);
local_menu_chip(row, ['zef_nav_bg_' key], fillc, theme.color.panel, r);
local_nav_blit_icon(row, key, icon_x, glyph_y, icon_s, icon_fg, fillc);
local_chip_text(row, ['zef_nav_text_' key], label, show_labels, lab_x, rh, theme);
try
    ax = getappdata(row, 'ZefChipAx');
    if local_ok(ax)
        uistack(ax, 'bottom');
    end
    if local_ok(hit)
        uistack(hit, 'bottom');
        hit.Visible = 'off';
    end
    if local_ok(ic)
        ic.Visible = 'off';
        uistack(ic, 'top');
    end
    local_nav_delete_glyph(row);
catch
end
try
    setappdata(row, 'ZefNavRowReady', true);
catch
end

end

function local_nav_paint_row(row, theme, key, label)

if ~local_ok(row)
    return
end
hit = zef_ui_find(row, ['zef_nav_hit_' key]);
ic = zef_ui_find(row, ['zef_nav_icon_' key]);
btn = zef_ui_find(row, ['zef_nav_' key]);
h_fig = ancestor(row, 'figure');
fillc = theme.color.panel;
icon_fg = theme.color.navIcon;
hovered = '';
try
    hovered = char(getappdata(h_fig, 'ZefNavHoverKey'));
catch
end
if isempty(hovered)
    try
        nav = ancestor(row, 'figure');
        navp = zef_ui_find(nav, 'zef_shell_nav');
        if local_ok(navp)
            hovered = char(getappdata(navp, 'ZefNavHoverKey'));
        end
    catch
    end
end
is_hover = strcmp(hovered, key);
is_active = false;
try
    src = getappdata(h_fig, 'ZefFlyoutSource');
    is_active = local_ok(src) && isequal(src, row);
catch
end
if is_active
    fillc = theme.color.navActive;
    icon_fg = theme.color.accent;
elseif is_hover
    fillc = theme.color.navHover;
    icon_fg = theme.color.accent;
end
outer = theme.color.panel;
row.BackgroundColor = outer;
try
    row.HighlightColor = outer;
    row.BorderColor = outer;
    row.BorderType = 'none';
    row.BorderWidth = 0;
catch
end
try
    setappdata(row, 'ZefChipFill', fillc);
catch
end
rp = row.Position;
r = local_menu_chip_radius(theme, rp(4));
local_menu_chip(row, ['zef_nav_bg_' key], fillc, outer, r);
if local_ok(hit)
    try
        hit.CData = [];
    catch
    end
    try
        if isappdata(hit, 'ZefNavHitKey')
            rmappdata(hit, 'ZefNavHitKey');
        end
    catch
    end
    hit.BackgroundColor = outer;
    hit.ForegroundColor = outer;
    hit.TooltipString = label;
    try
        hit.Visible = 'off';
    catch
    end
end
if local_ok(ic)
    try
        ic.Style = 'text';
        ic.String = '';
        ic.CData = [];
        ic.Visible = 'off';
    catch
    end
    try
        ip = ic.Position;
        glyph_s = 24;
        gx = ip(1);
        gy = max(0, round((rp(4) - glyph_s) / 2));
        local_nav_blit_icon(row, key, gx, gy, glyph_s, icon_fg, fillc);
    catch
        local_nav_blit_icon(row, key, 8, 4, 24, icon_fg, fillc);
    end
end
if local_ok(btn)
    % Never paint the label uicontrol: the chip axes is the single
    % rendered layer, so the row cannot show a square rectangle over
    % the rounded chip. The uicontrol only carries tag/String/callback.
    btn.Visible = 'off';
end
try
    local_nav_delete_glyph(row);
catch
end

end

function local_install_pointer_release(h_fig)

if ~local_ok(h_fig)
    return
end
try
    if isappdata(h_fig, 'ZefShellReleaseListener')
        lh = getappdata(h_fig, 'ZefShellReleaseListener');
        if ~isempty(lh) && isvalid(lh)
            return
        end
    end
catch
end
try
    lh = addlistener(h_fig, 'WindowMouseRelease', @(s, e) local_window_up(s, e));
    setappdata(h_fig, 'ZefShellReleaseListener', lh);
catch
end

end

function local_install_nav_hover(h_fig)

if ~local_ok(h_fig)
    return
end
try
    if isappdata(h_fig, 'ZefNavHoverListener')
        lh = getappdata(h_fig, 'ZefNavHoverListener');
        if ~isempty(lh) && isvalid(lh)
            return
        end
    end
catch
end
try
    lh = addlistener(h_fig, 'WindowMouseMotion', @(s, e) local_nav_hover(s, e));
    setappdata(h_fig, 'ZefNavHoverListener', lh);
    return
catch
end
try
    if isappdata(h_fig, 'ZefShellPrevMotionFcn')
        return
    end
    prev = get(h_fig, 'WindowButtonMotionFcn');
    setappdata(h_fig, 'ZefShellPrevMotionFcn', prev);
    h_fig.WindowButtonMotionFcn = @(src, evt) local_nav_motion_wrap(src, evt);
catch
end

end

function local_nav_motion_wrap(src, evt)

local_nav_hover(src, evt);
prev = [];
try
    prev = getappdata(src, 'ZefShellPrevMotionFcn');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    elseif (ischar(prev) || isstring(prev)) && strlength(prev) > 0
        evalin('base', char(prev));
    end
catch
end

end

function local_nav_hover(src, evt)

if nargin < 2
    evt = [];
end
h_fig = ancestor(src, 'figure');
if ~local_ok(h_fig)
    h_fig = src;
end
if ~local_ok(h_fig)
    return
end
dragging = false;
try
    drag = getappdata(h_fig, 'ZefInteractDrag');
    dragging = ~isempty(drag) && isstruct(drag);
catch
end
if dragging
    try
        pt = local_pointer_pt(h_fig, evt);
        zef_figure_interact(h_fig, 'move', pt);
    catch
        try
            zef_figure_interact(h_fig, 'move');
        catch
        end
    end
    return
end

hit = [];
try
    if ~isempty(evt)
        hit = evt.HitObject;
    end
catch
end

fly = local_fly_from_hit(hit);
if ~local_ok(fly)
    pt = local_pointer_pt(h_fig, evt);
    if numel(pt) >= 2
        fly = local_fly_at(h_fig, pt);
    end
end
if local_ok(fly)
    local_nav_set_hover(h_fig, '');
    local_set_chrome_hover(h_fig, []);
    local_set_fly_hover(h_fig, fly);
    local_set_pointer(h_fig, 'hand');
    return
end
local_set_fly_hover(h_fig, []);

key = local_nav_key_of(hit);
if isempty(key)
    pt = local_pointer_pt(h_fig, evt);
    if numel(pt) >= 2
        key = local_nav_key_at(h_fig, pt);
    end
end
local_nav_set_hover(h_fig, key);
if ~isempty(key)
    local_set_chrome_hover(h_fig, []);
    local_set_pointer(h_fig, 'hand');
    return
end

ch = local_chrome_from_hit(hit);
if ~local_ok(ch)
    pt = local_pointer_pt(h_fig, evt);
    if numel(pt) >= 2
        ch = local_chrome_at(h_fig, pt);
    end
end
local_set_chrome_hover(h_fig, ch);
if local_ok(ch)
    local_set_pointer(h_fig, 'hand');
    return
end

pt = local_pointer_pt(h_fig, evt);
vr = [];
try
    vr = getappdata(h_fig, 'ZefViewRect');
catch
end
if numel(pt) >= 2 && local_in_rect(pt, vr)
    p = 'arrow';
    try
        p = zef_figure_interact(h_fig, 'pointer');
        if isempty(p)
            p = 'arrow';
        end
    catch
    end
    local_set_pointer(h_fig, p);
    return
end
if local_is_edit_hit(hit)
    local_set_pointer(h_fig, 'ibeam');
    return
end
if local_is_clickable_hit(hit)
    local_set_pointer(h_fig, 'hand');
    return
end
local_set_pointer(h_fig, 'arrow');

end

function key = local_nav_key_of(obj)

key = '';
h = obj;
spec = local_nav_spec();
names = spec(:, 1);
prefixes = {'zef_nav_row_', 'zef_nav_hit_', 'zef_nav_icon_', ...
    'zef_nav_glyph_', 'zef_nav_bg_', 'zef_nav_'};
for i = 1:10
    if ~local_ok(h)
        return
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    for p = 1:numel(prefixes)
        pref = prefixes{p};
        if strncmp(tag, pref, numel(pref))
            rest = tag((numel(pref) + 1):end);
            if any(strcmp(names, rest))
                key = rest;
                return
            end
        end
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function pt = local_pointer_pt(fig, evt)

pt = [];
if nargin >= 2 && ~isempty(evt)
    try
        pt = double(evt.Point);
    catch
    end
end
if numel(pt) < 2 && local_ok(fig)
    try
        if strcmpi(char(fig.Units), 'pixels')
            pt = double(fig.CurrentPoint);
        else
            orig = fig.Units;
            fig.Units = 'pixels';
            pt = double(fig.CurrentPoint);
            fig.Units = orig;
        end
    catch
        pt = [];
    end
end
if numel(pt) >= 2
    pt = pt(1:2);
end

end

function tf = local_in_rect(pt, r)

tf = numel(pt) >= 2 && numel(r) >= 4 && r(3) > 0 && r(4) > 0 ...
    && pt(1) >= r(1) && pt(1) < r(1) + r(3) ...
    && pt(2) >= r(2) && pt(2) < r(2) + r(4);

end

function r = local_fig_rect(h)

%LOCAL_FIG_RECT  Figure-relative pixel rect, matching CurrentPoint.
%   getpixelposition(h, true) already returns figure-relative pixels on
%   supported MATLAB versions; subtracting the figure's screen position
%   (its own getpixelposition) would double-count the window offset and
%   break every pointer hit map once the window is not at the origin.

r = [0 0 0 0];
if ~local_ok(h)
    return
end
try
    ap = double(getpixelposition(h, true));
    if numel(ap) >= 4
        r = ap;
    end
catch
end

end

function key = local_nav_key_at(h_fig, pt)

key = '';
keys = {};
rects = zeros(0, 4);
try
    keys = getappdata(h_fig, 'ZefNavHitKeys');
    rects = getappdata(h_fig, 'ZefNavHitRects');
catch
end
stale = false;
try
    stored = getappdata(h_fig, 'ZefHitMapFigPos');
    cur = [];
    try
        orig = h_fig.Units;
        h_fig.Units = 'pixels';
        cur = round(double(h_fig.Position));
        h_fig.Units = orig;
    catch
    end
    stale = isempty(stored) || (~isempty(cur) && ~isequal(stored, cur));
catch
end
if stale || ~iscell(keys) || isempty(keys) || size(rects, 1) ~= numel(keys)
    try
        local_store_hit_maps(h_fig);
        keys = getappdata(h_fig, 'ZefNavHitKeys');
        rects = getappdata(h_fig, 'ZefNavHitRects');
    catch
        return
    end
end
if ~iscell(keys)
    return
end
for i = 1:numel(keys)
    if local_in_rect(pt, rects(i, :))
        key = keys{i};
        return
    end
end

end

function fly = local_fly_at(h_fig, pt)

fly = [];
hs = gobjects(0);
rects = zeros(0, 4);
try
    hs = getappdata(h_fig, 'ZefFlyHitH');
    rects = getappdata(h_fig, 'ZefFlyHitR');
catch
end
for i = 1:numel(hs)
    if local_ok(hs(i)) && local_in_rect(pt, rects(i, :))
        fly = hs(i);
        return
    end
end

end

function h = local_chrome_at(h_fig, pt)

h = [];
hs = gobjects(0);
rects = zeros(0, 4);
try
    hs = getappdata(h_fig, 'ZefChromeHitH');
    rects = getappdata(h_fig, 'ZefChromeHitR');
catch
end
for i = 1:numel(hs)
    if local_ok(hs(i)) && i <= size(rects, 1) && local_in_rect(pt, rects(i, :))
        h = hs(i);
        return
    end
end

end

function h = local_chrome_from_hit(obj)

h = [];
x = obj;
tags = {'zef_shell_help', 'zef_shell_bell', 'zef_shell_profile', ...
    'zef_tool_more', 'zef_tool_sliders'};
for i = 1:8
    if ~local_ok(x)
        return
    end
    tag = '';
    try
        tag = char(x.Tag);
    catch
    end
    if any(strcmp(tag, tags)) || strncmp(tag, 'zef_tool_', 9) ...
            || strncmp(tag, 'zef_tab_', 8)
        try
            if isprop(x, 'Enable') && strcmpi(char(x.Enable), 'off')
                return
            end
        catch
        end
        h = x;
        return
    end
    try
        if isappdata(x, 'ZefRoundKey')
            h = x;
            return
        end
    catch
    end
    try
        x = x.Parent;
    catch
        return
    end
end

end

function fly = local_fly_from_hit(obj)

fly = [];
h = obj;
for i = 1:8
    if ~local_ok(h)
        return
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    if strcmp(tag, 'zef_fly_item')
        fly = h;
        return
    end
    if contains(tag, 'zef_shell_flyout') && ~strcmpi(char(h.Type), 'uicontrol')
        return
    end
    try
        par = h.Parent;
        ptag = '';
        try
            ptag = char(par.Tag);
        catch
        end
        if strcmp(ptag, 'zef_fly_item')
            fly = par;
            return
        end
        if strcmpi(char(h.Type), 'uicontrol') && contains(ptag, 'zef_shell_flyout')
            style = lower(char(h.Style));
            if any(strcmp(style, {'text', 'pushbutton'}))
                fly = h;
                return
            end
        end
    catch
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function tf = local_is_edit_hit(obj)

tf = false;
if ~local_ok(obj)
    return
end
try
    if strcmpi(char(obj.Type), 'uicontrol') && strcmpi(char(obj.Style), 'edit')
        tf = true;
        return
    end
catch
end
cls = class(obj);
tf = contains(cls, 'EditField') || contains(cls, 'TextArea') ...
    || contains(cls, 'Spinner');

end

function tf = local_is_clickable_hit(obj)

tf = false;
if ~local_ok(obj)
    return
end
try
    if isprop(obj, 'Enable') && strcmpi(char(obj.Enable), 'off')
        return
    end
catch
end
try
    if strcmpi(char(obj.Type), 'uicontrol')
        style = lower(char(obj.Style));
        tf = any(strcmp(style, {'pushbutton', 'togglebutton', 'checkbox', ...
            'radiobutton', 'slider', 'listbox', 'popupmenu'}));
        return
    end
catch
end
cls = class(obj);
tf = contains(cls, 'Button') || contains(cls, 'CheckBox') ...
    || contains(cls, 'DropDown') || contains(cls, 'ListBox') ...
    || contains(cls, 'Slider');

end

function tf = local_chrome_hand_at(h_fig, pt)

tf = local_ok(local_chrome_at(h_fig, pt));

end

function local_set_chrome_hover(h_fig, h)

prev = [];
try
    prev = getappdata(h_fig, 'ZefChromeHover');
catch
end
if isequal(prev, h)
    return
end
prev_grp = local_chrome_mates(h_fig, prev);
next_grp = local_chrome_mates(h_fig, h);
for i = 1:numel(prev_grp)
    if local_ok(prev_grp(i)) && ~local_in_handles(prev_grp(i), next_grp)
        try
            zef_ui_interact(prev_grp(i), 'paint', 'idle');
        catch
        end
    end
end
for i = 1:numel(next_grp)
    if local_ok(next_grp(i)) && ~local_in_handles(next_grp(i), prev_grp)
        try
            zef_ui_interact(next_grp(i), 'paint', 'hover');
        catch
        end
    end
end
try
    setappdata(h_fig, 'ZefChromeHover', h);
catch
end
local_exit_guard_refresh(h_fig);

end

function tf = local_in_handles(h, grp)

tf = false;
for i = 1:numel(grp)
    if local_ok(grp(i)) && isequal(grp(i), h)
        tf = true;
        return
    end
end

end

function hs = local_chrome_mates(h_fig, h)

hs = gobjects(0);
if ~local_ok(h)
    return
end
hs = h;
tag = '';
try
    tag = char(h.Tag);
catch
end
mate = [];
if strncmp(tag, 'zef_tool_lab_', 13)
    mate = zef_ui_find(h_fig, ['zef_tool_' tag(14:end)]);
elseif strncmp(tag, 'zef_tool_', 9) && ~contains(tag, '_lab_') ...
        && ~any(strcmp(tag, {'zef_tool_more', 'zef_tool_sliders', 'zef_tool_sep', 'zef_tool_rule'}))
    mate = zef_ui_find(h_fig, ['zef_tool_lab_' tag(10:end)]);
end
if local_ok(mate)
    hs(end + 1) = mate; %#ok<AGROW>
end

end

function local_nav_set_hover(h_fig, key)

nav = zef_ui_find(h_fig, 'zef_shell_nav');
if ~local_ok(nav)
    return
end
if isempty(key)
    key = '';
end
prev = '';
try
    prev = char(getappdata(nav, 'ZefNavHoverKey'));
catch
end
if strcmp(prev, key)
    return
end
try
    setappdata(nav, 'ZefNavHoverKey', key);
    setappdata(h_fig, 'ZefNavHoverKey', key);
catch
end
theme = zef_ui_theme();
items = local_nav_spec();
if ~isempty(prev)
    local_nav_paint_named(nav, theme, items, prev);
end
if ~isempty(key)
    local_nav_paint_named(nav, theme, items, key);
end
local_exit_guard_refresh(h_fig);

end

function local_nav_paint_named(nav, theme, items, key)

row = zef_ui_find(nav, ['zef_nav_row_' key]);
if ~local_ok(row)
    return
end
label = key;
for i = 1:size(items, 1)
    if strcmp(items{i, 1}, key)
        label = items{i, 2};
        break
    end
end
local_nav_paint_row(row, theme, key, label);

end

function local_set_fly_hover(h_fig, fly)

prev = [];
try
    prev = getappdata(h_fig, 'ZefFlyoutHover');
catch
end
if isequal(prev, fly)
    return
end
if local_ok(prev) && ~local_is_open_fly_item(h_fig, prev)
    local_flyout_paint(prev, false);
end
if local_ok(fly)
    local_flyout_paint(fly, true);
end
try
    setappdata(h_fig, 'ZefFlyoutHover', fly);
catch
end
local_exit_guard_refresh(h_fig);

end

function local_flyout_paint(item, on)

item = local_fly_item_of(item);
if ~local_ok(item)
    return
end
tag = '';
try
    tag = char(item.Tag);
catch
end
if ~strcmp(tag, 'zef_fly_item')
    return
end
theme = zef_ui_theme();
outer = theme.color.panel;
fillc = outer;
if on
    fillc = theme.color.navHover;
end
try
    item.BackgroundColor = outer;
    item.HighlightColor = outer;
    item.BorderType = 'none';
catch
end
try
    item.ForegroundColor = theme.color.text;
catch
end
ht = 28;
try
    item.Units = 'pixels';
    ht = item.Position(4);
catch
end
r = local_menu_chip_radius(theme, ht);
local_menu_chip(item, 'zef_fly_bg', fillc, outer, r);
% Child uicontrols stay hidden and unpainted: the chip axes (fill +
% text object) is the item's only rendered layer, so hover can never
% stack a second rectangle over the rounded chip.

end

function local_exit_guard_refresh(h_fig)

%LOCAL_EXIT_GUARD_REFRESH  Arm/disarm the pointer-outside-window poller.
%   Traditional figures fire no mouse-exit event, so without this the
%   last hovered row would stay highlighted when the pointer leaves the
%   window (e.g. exiting through the left edge of the nav panel).

if ~local_ok(h_fig)
    return
end
active = false;
try
    % Only a visible window can be pointer-hovered; synthetic hovers on
    % hidden figures (tests) must not be polled against the OS pointer.
    if strcmpi(char(h_fig.Visible), 'on')
        active = strlength(char(getappdata(h_fig, 'ZefNavHoverKey'))) > 0;
        if ~active
            active = local_ok(getappdata(h_fig, 'ZefFlyoutHover'));
        end
        if ~active
            active = local_ok(getappdata(h_fig, 'ZefChromeHover'));
        end
    end
catch
end
tm = [];
try
    tm = getappdata(h_fig, 'ZefExitGuardTimer');
catch
end
if ~active
    if ~isempty(tm) && isvalid(tm)
        try
            if strcmpi(char(tm.Running), 'on')
                stop(tm);   % StopFcn deletes (safe inside its own callback)
            else
                delete(tm);
            end
        catch
        end
    end
    try, rmappdata(h_fig, 'ZefExitGuardTimer'); catch, end
    return
end
if ~isempty(tm) && isvalid(tm)
    try
        if strcmpi(char(tm.Running), 'on')
            return
        end
    catch
    end
else
    tm = timer('ExecutionMode', 'fixedSpacing', 'Period', 0.12, ...
        'BusyMode', 'drop', 'Tag', 'ZefExitGuardTimer', ...
        'TimerFcn', @(s, ~) local_exit_guard_check(s, h_fig), ...
        'StopFcn', @(s, ~) local_exit_guard_delete(s));
    try
        setappdata(h_fig, 'ZefExitGuardTimer', tm);
    catch
    end
end
try
    start(tm);
catch
end

end

function local_exit_guard_check(tm, h_fig)

if ~local_ok(tm)
    return
end
if ~local_ok(h_fig)
    % Figure is gone: stop self; StopFcn deletes the timer object.
    try, stop(tm); catch, end
    return
end
inside = false;
pl = [];
fpos = [];
try
    pl = get(0, 'PointerLocation');
    orig = h_fig.Units;
    h_fig.Units = 'pixels';
    fpos = h_fig.Position;
    h_fig.Units = orig;
    inside = numel(pl) >= 2 && numel(fpos) >= 4 ...
        && pl(1) >= fpos(1) && pl(1) < fpos(1) + fpos(3) ...
        && pl(2) >= fpos(2) && pl(2) < fpos(2) + fpos(4);
catch
end
if inside
    % Reconcile the hover target with the actual pointer position. OS
    % mouse-motion events can be coalesced or dropped, so while a hover
    % is active the guard re-derives it from the pointer at ~8 Hz; the
    % setters early-exit when nothing changed, so this is cheap.
    try
        pt = pl(1:2) - fpos(1:2);
        fly = local_fly_at(h_fig, pt);
        if local_ok(fly)
            local_nav_set_hover(h_fig, '');
            local_set_chrome_hover(h_fig, []);
            local_set_fly_hover(h_fig, fly);
        else
            key = local_nav_key_at(h_fig, pt);
            local_set_fly_hover(h_fig, []);
            local_nav_set_hover(h_fig, key);
            if isempty(key)
                local_set_chrome_hover(h_fig, local_chrome_at(h_fig, pt));
            else
                local_set_chrome_hover(h_fig, []);
            end
        end
    catch
    end
    return
end
% Pointer left the window: drop every hover state. The setters refresh
% the guard, which stops this timer (StopFcn deletes it).
try
    local_nav_set_hover(h_fig, '');
    local_set_chrome_hover(h_fig, []);
    local_set_fly_hover(h_fig, []);
catch
end
try
    if isvalid(tm) && strcmpi(char(tm.Running), 'on')
        stop(tm);
    end
catch
end

end

function local_exit_guard_delete(tm)

try
    if ~isempty(tm) && isvalid(tm)
        delete(tm);
    end
catch
end

end

function item = local_fly_item_of(src)

item = src;
h = src;
for i = 1:8
    if ~local_ok(h)
        return
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    if strcmp(tag, 'zef_fly_item')
        item = h;
        return
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function local_set_pointer(h_fig, want)

if ~local_ok(h_fig) || nargin < 2 || isempty(want)
    return
end
cur = '';
try
    cur = char(h_fig.Pointer);
catch
end
if ~strcmpi(cur, want)
    try
        h_fig.Pointer = want;
    catch
    end
end

end

function local_prefetch_nav_icons(theme)

items = local_nav_spec();
try
    for i = 1:size(items, 1)
        zef_ui_icons(items{i, 1}, 24, theme.color.navIcon, theme.color.panel);
        zef_ui_icons(items{i, 1}, 24, theme.color.accent, theme.color.navHover);
    end
catch
end

end

function local_store_hit_maps(h_fig)

if ~local_ok(h_fig)
    return
end
items = local_nav_spec();
nav = zef_ui_find(h_fig, 'zef_shell_nav');
keys = {};
rects = zeros(0, 4);
if local_ok(nav)
    for i = 1:size(items, 1)
        row = zef_ui_find(nav, ['zef_nav_row_' items{i, 1}]);
        if local_ok(row)
            keys{end + 1} = items{i, 1}; %#ok<AGROW>
            rects(end + 1, :) = local_fig_rect(row); %#ok<AGROW>
        end
    end
end
try
    setappdata(h_fig, 'ZefNavHitKeys', keys);
    setappdata(h_fig, 'ZefNavHitRects', rects);
catch
end

fly_h = gobjects(0);
fly_r = zeros(0, 4);
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
for i = 1:numel(found)
    if ~local_ok(found(i))
        continue
    end
    kids = [];
    try
        kids = getappdata(found(i), 'ZefFlyoutItems');
    catch
    end
    for j = 1:numel(kids)
        if local_ok(kids(j))
            fly_h(end + 1) = kids(j); %#ok<AGROW>
            fly_r(end + 1, :) = local_fig_rect(kids(j)); %#ok<AGROW>
        end
    end
end
try
    setappdata(h_fig, 'ZefFlyHitH', fly_h);
    setappdata(h_fig, 'ZefFlyHitR', fly_r);
catch
end

ch_h = gobjects(0);
ch_r = zeros(0, 4);
tags = {'zef_shell_help', 'zef_shell_bell', 'zef_shell_profile', ...
    'zef_tool_more', 'zef_tool_sliders'};
tool_keys = {'pan', 'rotate', 'zoom', 'zoomout', 'reset', 'screenshot', ...
    'colormap', 'measure', 'annotate', 'edges'};
for i = 1:numel(tool_keys)
    tags{end + 1} = ['zef_tool_' tool_keys{i}]; %#ok<AGROW>
    tags{end + 1} = ['zef_tool_lab_' tool_keys{i}]; %#ok<AGROW>
end
for i = 1:numel(tags)
    h = zef_ui_find(h_fig, tags{i});
    if local_ok(h)
        vis = 'on';
        try
            vis = char(h.Visible);
        catch
        end
        if strcmpi(vis, 'on')
            ch_h(end + 1) = h; %#ok<AGROW>
            ch_r(end + 1, :) = local_fig_rect(h); %#ok<AGROW>
        end
    end
end
try
    setappdata(h_fig, 'ZefChromeHitH', ch_h);
    setappdata(h_fig, 'ZefChromeHitR', ch_r);
catch
end
try
    orig = h_fig.Units;
    h_fig.Units = 'pixels';
    setappdata(h_fig, 'ZefHitMapFigPos', round(double(h_fig.Position)));
    h_fig.Units = orig;
catch
end
view = zef_ui_find(h_fig, 'figure_view');
try
    if local_ok(view)
        setappdata(h_fig, 'ZefViewRect', local_fig_rect(view));
    end
catch
end

end

function row = local_nav_row_of(src)

row = [];
h = src;
for i = 1:10
    if ~local_ok(h)
        return
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    if strncmp(tag, 'zef_nav_row_', 12)
        row = h;
        return
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function local_place_tabs(tabs, theme)

p = tabs.Position;
h = max(22, p(4) - 4);
fig_tab = zef_ui_find(tabs, 'zef_tab_figure');
und = zef_ui_find(tabs, 'zef_tab_underline');
x = 12;
if local_ok(fig_tab)
    fig_tab.Position = [x, 6, 64, h - 8];
end
if local_ok(und) && local_ok(fig_tab)
    und.Position = [fig_tab.Position(1) + 10, 2, max(28, fig_tab.Position(3) - 20), 3];
    und.BackgroundColor = theme.color.accent;
end
rule = zef_ui_find(tabs, 'zef_tab_rule');
if local_ok(rule)
    rule.Position = [0, 0, max(1, p(3)), 1];
    rule.BackgroundColor = theme.color.border;
end

end

function local_place_toolbar(tools, theme, content_w)

p = tools.Position;
pad = 4;
icon_w = 22;
lab_h = 16;
top_pad = 8;
y_icon = max(2, round((p(4) - icon_w) / 2));
y_lab = max(1, round((p(4) - lab_h) / 2) - 1);
keys = {'pan', 'rotate', 'zoom', 'zoomout', 'reset', 'screenshot', 'colormap', ...
    'measure', 'annotate', 'edges'};
more = zef_ui_find(tools, 'zef_tool_more');
sl = zef_ui_find(tools, 'zef_tool_sliders');
ink = theme.color.text;
surface = theme.color.workspace;
right = p(3) - 6;
icon_hit = 24;
if local_ok(more)
    more.Position = [right - icon_hit, y_icon, icon_hit, icon_hit];
    more.String = '';
    more.Enable = 'on';
    more.BackgroundColor = surface;
    local_show_icon(more, 'ellipsis', 22, ink, surface);
    right = right - icon_hit - 4;
end
if local_ok(sl)
    sl.Position = [right - icon_hit, y_icon, icon_hit, icon_hit];
    sl.TooltipString = 'Toggle controls';
    sl.Enable = 'on';
    fill_sl = surface;
    try
        hf = ancestor(tools, 'figure');
        hidden = false;
        if isappdata(hf, 'ZefFigureControlsVisible')
            hidden = ~logical(getappdata(hf, 'ZefFigureControlsVisible'));
        elseif isequal(sl.UserData, 1)
            hidden = true;
        else
            tgb = zef_ui_find(hf, 'togglecontrolsbutton');
            hidden = ~isempty(tgb) && isvalid(tgb) && isequal(tgb.UserData, 2);
        end
        if hidden
            fill_sl = theme.color.hover;
            sl.UserData = 1;
        else
            sl.UserData = 0;
        end
    catch
    end
    sl.BackgroundColor = fill_sl;
    local_show_icon(sl, 'sliders', 22, ink, fill_sl);
    right = right - icon_hit - 4;
end
x_limit = right - 2;
x0 = pad;
n = numel(keys);
tw = zeros(1, n);
show = true(1, n);
lab_fs = 10;
tw_ok = false;
try
    if isequal(getappdata(tools, 'ZefToolLabFs'), lab_fs)
        tw_cached = getappdata(tools, 'ZefToolLabW');
        tw_ok = isequal(size(tw_cached), [1, n]);
        if tw_ok
            tw = tw_cached;
        end
    end
catch
end
for i = 1:n
    lab = zef_ui_find(tools, ['zef_tool_lab_' keys{i}]);
    if local_ok(lab)
        lab.String = local_tool_label(keys{i});
        try
            lab.FontUnits = 'pixels';
            lab.FontSize = lab_fs;
            lab.FontName = theme.font.name;
        catch
        end
        if tw_ok
            continue
        end
        tw(i) = 32;
        try
            lab.Position = [0, 0, 280, lab_h];
            tw(i) = max(14, ceil(lab.Extent(3)) + 4);
        catch
            txt = '';
            try
                txt = char(string(lab.String));
            catch
            end
            tw(i) = max(14, ceil((numel(txt) + 1) * lab_fs * 0.58) + 4);
        end
    end
end
if ~tw_ok
    try
        setappdata(tools, 'ZefToolLabW', tw);
        setappdata(tools, 'ZefToolLabFs', lab_fs);
    catch
    end
end
sep_w = 10;
gap_icon_lab = 2;
gap_after = 6;
    function tot = total_w()
        tot = 0;
        for k = 1:n
            tot = tot + icon_w + gap_icon_lab;
            if show(k)
                tot = tot + tw(k);
            else
                tot = tot - gap_icon_lab;
            end
            tot = tot + gap_after;
            if strcmp(keys{k}, 'reset')
                tot = tot + sep_w;
            end
        end
    end
avail = max(40, x_limit - x0);
while total_w() > avail && gap_after > 2
    gap_after = gap_after - 1;
end
while total_w() > avail && lab_fs > 8
    lab_fs = lab_fs - 1;
    for i = 1:n
        lab = zef_ui_find(tools, ['zef_tool_lab_' keys{i}]);
        if local_ok(lab)
            try
                lab.FontSize = lab_fs;
                lab.Position = [0, 0, 240, lab_h];
                tw(i) = max(14, ceil(lab.Extent(3)) + 4);
            catch
                txt = char(string(lab.String));
                tw(i) = max(14, ceil((numel(txt) + 1) * lab_fs * 0.58) + 4);
            end
        end
    end
end
hide_order = n:-1:1;
hi = 1;
while total_w() > avail && hi <= numel(hide_order)
    show(hide_order(hi)) = false;
    hi = hi + 1;
end
x = x0;
for i = 1:n
    btn = zef_ui_find(tools, ['zef_tool_' keys{i}]);
    lab = zef_ui_find(tools, ['zef_tool_lab_' keys{i}]);
    if ~local_ok(btn)
        continue
    end
    btn.Visible = 'on';
    btn.Enable = 'on';
    try
        btn.ButtonDownFcn = '';
    catch
    end
    btn.Position = [x, y_icon, icon_w, icon_w];
    fill = surface;
    try
        if isequal(btn.UserData, 1) && any(strcmp(keys{i}, ...
                {'pan', 'rotate', 'zoom', 'measure', 'annotate'}))
            fill = theme.color.hover;
        end
    catch
    end
    btn.BackgroundColor = fill;
    btn.String = '';
    local_show_icon(btn, keys{i}, 22, ink, fill);
    room = x_limit - x - 4;
    need = icon_w + gap_icon_lab + tw(i);
    if show(i) && tw(i) > 0 && local_ok(lab) && room >= need
        x = x + icon_w + gap_icon_lab;
        lab.Visible = 'on';
        lab.String = local_tool_label(keys{i});
        lab.Enable = 'inactive';
        lab.ButtonDownFcn = @(s, e) local_tool_from_label(s, keys{i});
        lab.Position = [x, y_lab, tw(i), lab_h];
        lab.BackgroundColor = fill;
        lab.ForegroundColor = ink;
        lab.HorizontalAlignment = 'left';
        try
            lab.FontUnits = 'pixels';
            lab.FontSize = lab_fs;
            lab.FontName = theme.font.name;
        catch
        end
        x = x + tw(i) + gap_after;
    else
        if local_ok(lab)
            lab.Visible = 'off';
        end
        x = x + icon_w + gap_after;
    end
    if strcmp(keys{i}, 'reset')
        sep = zef_ui_find(tools, 'zef_tool_sep');
        if local_ok(sep)
            sep.Position = [x, y_icon + 2, 1, max(12, icon_w - 4)];
            sep.BackgroundColor = theme.color.border;
            x = x + sep_w;
        end
    end
end
rule = zef_ui_find(tools, 'zef_tool_rule');
if local_ok(rule)
    rule.Position = [0, 0, max(1, p(3)), 1];
    rule.BackgroundColor = theme.color.border;
end

end

function local_refresh_toolbar(h_fig)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
theme = zef_ui_theme();
tools = zef_ui_find(h_fig, 'zef_shell_toolbar');
if local_ok(tools)
    tools.Units = 'pixels';
    local_place_toolbar(tools, theme, tools.Position(3));
end
try
    local_store_hit_maps(h_fig);
catch
end

end

function local_place_footer(footer, theme)

p = footer.Position;
ver = zef_ui_find(footer, 'zef_shell_version');
copy = zef_ui_find(footer, 'zef_shell_copy');
if local_ok(ver)
    ver.Position = [14, 4, min(260, p(3) * 0.32), max(16, p(4) - 8)];
    ver.ForegroundColor = theme.color.textMuted;
end
if local_ok(copy)
    copy.HorizontalAlignment = 'center';
    copy.Position = [round(p(3) * 0.22), 4, round(p(3) * 0.56), max(16, p(4) - 8)];
    copy.ForegroundColor = theme.color.textMuted;
end

end

function local_nav_click(src, ~)

src = local_hit_src(src);
h_fig = ancestor(src, 'figure');
if local_dup_click(h_fig, src)
    return
end
open_src = [];
try
    open_src = getappdata(h_fig, 'ZefFlyoutSource');
catch
end
anchor = local_nav_row_of(src);
if ~local_ok(anchor)
    anchor = src;
end
if ~isempty(open_src) && isequal(open_src, anchor)
    local_dismiss(h_fig);
    return
end
% Switching menus: drop the old flyout but keep overlapping toolbar
% chrome hidden so those buttons do not flash between the two clicks.
local_dismiss(h_fig, false);

h_menu = [];
try
    h_menu = getappdata(src, 'ZefMenuHandle');
catch
end
if ~local_ok(h_menu) && local_ok(anchor)
    try
        h_menu = getappdata(anchor, 'ZefMenuHandle');
    catch
    end
end
if ~local_ok(h_menu) && local_ok(anchor)
    % The row's tagged children (label/hit/icon) can carry the handle
    % too; any hit path inside the row must resolve the same menu.
    try
        kids = allchild(anchor);
        for i = 1:numel(kids)
            if isappdata(kids(i), 'ZefMenuHandle')
                cand = getappdata(kids(i), 'ZefMenuHandle');
                if local_ok(cand)
                    h_menu = cand;
                    break
                end
            end
        end
    catch
    end
end
if ~local_ok(h_menu)
    h_menu = local_lookup_menu(src);
end
if ~local_ok(h_menu) && local_ok(anchor)
    h_menu = local_lookup_menu(anchor);
end
if ~local_ok(h_menu)
    local_restore_toolbar_after_flyout(h_fig);
    return
end
kids = local_menu_children(h_menu);
if isempty(kids)
    local_restore_toolbar_after_flyout(h_fig);
    local_invoke_menu(h_menu);
    return
end
local_open_flyout(h_fig, anchor, kids, 1);

end

function h_menu = local_lookup_menu(src)

h_menu = [];
field = '';
try
    field = char(src.UserData);
catch
end
if isempty(field)
    return
end
try
    zef = evalin('base', 'zef');
    if isfield(zef, field) && local_ok(zef.(field))
        h_menu = zef.(field);
        setappdata(src, 'ZefMenuHandle', h_menu);
    end
catch
end

end

function kids = local_menu_children(h_menu)

kids = gobjects(0);
ch = [];
try
    ch = h_menu.Children;
catch
    try
        ch = allchild(h_menu);
    catch
        return
    end
end
if isempty(ch)
    return
end
keep = false(size(ch));
for i = 1:numel(ch)
    try
        typ = '';
        try
            typ = lower(char(ch(i).Type));
        catch
        end
        if ~strcmp(typ, 'uimenu') && ~isa(ch(i), 'matlab.ui.container.Menu')
            continue
        end
        vis = 'on';
        if isprop(ch(i), 'Visible')
            vis = char(ch(i).Visible);
        end
        if strcmpi(vis, 'off')
            continue
        end
        txt = strtrim(char(string(ch(i).Text)));
        if isempty(txt)
            continue
        end
        keep(i) = true;
    catch
    end
end
kids = ch(keep);
kids = flipud(kids(:));

end

function local_open_flyout(h_fig, src, kids, level)

theme = zef_ui_theme();
nav = zef_ui_find(h_fig, 'zef_shell_nav');
src_fig = getpixelposition(src, true);
nav_fig = [0 0 0 0];
if local_ok(nav)
    nav_fig = getpixelposition(nav, true);
end
in_nav = local_ok(nav) && src_fig(1) <= nav_fig(1) + nav_fig(3) + 24;
x = src_fig(1);
if level > 1 && isappdata(h_fig, 'ZefFlyoutPanel')
    prev = getappdata(h_fig, 'ZefFlyoutPanel');
    if local_ok(prev)
        prev.Units = 'pixels';
        x = prev.Position(1) + prev.Position(3) - 1;
        in_nav = true;
    end
elseif in_nav
    x = nav_fig(1) + nav_fig(3) - 1;
end
row_h = 28;
n = numel(kids);
pad = 8;
need = n * row_h + 2 * pad;
avail = max(120, h_fig.Position(4) - theme.space.headerH - theme.space.footerH - 8);
h = min(max(need, 48), avail);
overflow = need > h;
slider_w = 0;
if overflow
    slider_w = 14;
end
labels = cell(n, 1);
for i = 1:n
    labels{i} = local_menu_label(kids(i));
    sub = local_menu_children(kids(i));
    if ~isempty(sub)
        labels{i} = [labels{i} '   ▸']; %#ok<AGROW>
    end
end
w = local_flyout_width(labels, theme);
if in_nav
    y = src_fig(2) + src_fig(4) - h;
else
    y = src_fig(2) - h;
    if y < theme.space.footerH + 4
        y = src_fig(2) + src_fig(4);
    end
end
y = min(max(theme.space.footerH + 4, y), ...
    h_fig.Position(4) - theme.space.headerH - h - 4);
max_x = h_fig.Position(3) - w - 8;
if x > max_x
    if level > 1 && isappdata(h_fig, 'ZefFlyoutPanel')
        prev = getappdata(h_fig, 'ZefFlyoutPanel');
        if local_ok(prev)
            try
                prev.Units = 'pixels';
                left_x = prev.Position(1) - w + 1;
                if left_x >= 8
                    x = left_x;
                else
                    x = max(8, max_x);
                end
            catch
                x = max(8, max_x);
            end
        else
            x = max(8, max_x);
        end
    else
        x = max(8, max_x);
    end
end
x = max(8, min(x, max(8, h_fig.Position(3) - w - 4)));
tag = 'zef_shell_flyout';
if level > 1
    tag = sprintf('zef_shell_flyout_%d', level);
end
local_dismiss_from(h_fig, level);
panel = uipanel('Parent', h_fig, 'Units', 'pixels', 'BorderType', 'none', ...
    'HighlightColor', theme.color.bg, 'BackgroundColor', theme.color.bg, ...
    'Title', '', 'Tag', tag, 'Position', [x, y, w, h]);
try
    panel.AutoResizeChildren = 'off';
catch
end
try
    zef_ui_card(panel, theme, theme.space.cardRadius);
catch
end
item_w = max(48, w - 2 * pad - slider_w);
items = gobjects(n, 1);
yy = h - pad - row_h;
chip_r = local_menu_chip_radius(theme, row_h);
for i = 1:n
    label = labels{i};
    sub = local_menu_children(kids(i));
    if isempty(sub)
        cb = @(s, ~) local_leaf_click(s, h_fig);
    else
        cb = @(s, ~) local_sub_click(s, h_fig, level + 1);
    end
    % The item panel carries its callback as appdata, not ButtonDownFcn:
    % local_window_down invokes it via the hit map, and a panel
    % ButtonDownFcn would fire a second time for the same press.
    row = uipanel('Parent', panel, 'Units', 'pixels', 'BorderType', 'none', ...
        'Title', '', 'Tag', 'zef_fly_item', 'Position', [pad, yy, item_w, row_h], ...
        'BackgroundColor', theme.color.panel, 'HighlightColor', theme.color.panel, ...
        'ForegroundColor', theme.color.text);
    setappdata(row, 'ZefFlyCb', cb);
    try
        row.AutoResizeChildren = 'off';
        row.BorderWidth = 0;
        row.BorderColor = theme.color.panel;
    catch
    end
    inset = chip_r;
    lab_w = max(8, item_w - 2 * inset);
    b = uicontrol('Style', 'text', 'Parent', row, 'Units', 'pixels', ...
        'String', ['  ' label], 'HorizontalAlignment', 'left', ...
        'Enable', 'inactive', 'Position', [inset, 0, lab_w, row_h], ...
        'BackgroundColor', theme.color.panel, 'ForegroundColor', theme.color.text, ...
        'FontName', theme.font.name, 'FontSize', theme.font.size, ...
        'FontUnits', 'pixels', 'Visible', 'off');
    setappdata(b, 'ZefMenuHandle', kids(i));
    setappdata(row, 'ZefMenuHandle', kids(i));
    b.Callback = cb;
    b.ButtonDownFcn = cb;
    try
        b.BusyAction = 'cancel';
    catch
    end
    local_menu_chip(row, 'zef_fly_bg', theme.color.panel, theme.color.panel, chip_r);
    try
        ax = getappdata(row, 'ZefChipAx');
        if local_ok(ax)
            uistack(ax, 'bottom');
        end
    catch
    end
    % The chip axes is the item's only painted layer; the hidden label
    % uicontrol above keeps String/callback identity, the visible text
    % lives inside the chip (7 px approximates the legacy 2-space pad).
    local_chip_text(row, 'zef_fly_text', label, true, inset + 7, row_h, theme);
    items(i) = row;
    yy = yy - row_h;
end
max_off = max(0, need - h);
setappdata(panel, 'ZefFlyoutItems', items);
setappdata(panel, 'ZefFlyoutRowH', row_h);
setappdata(panel, 'ZefFlyoutPad', pad);
setappdata(panel, 'ZefFlyoutMaxOff', max_off);
if overflow && max_off > 0
    sl = uicontrol('Style', 'slider', 'Parent', panel, 'Units', 'pixels', ...
        'Min', 0, 'Max', max_off, 'Value', max_off, ...
        'SliderStep', [min(1, row_h / max_off), min(1, max(row_h, h - 2 * pad) / max_off)], ...
        'Position', [w - pad - slider_w, pad, slider_w, max(24, h - 2 * pad)], ...
        'BackgroundColor', theme.color.panel, 'ForegroundColor', theme.color.text, ...
        'Tag', 'zef_shell_flyout_slider', ...
        'Callback', @(s, ~) local_flyout_slider(s, panel));
    try
        sl.BusyAction = 'cancel';
    catch
    end
end
setappdata(h_fig, 'ZefFlyoutPanel', panel);
setappdata(h_fig, 'ZefFlyoutSource', src);
local_remember_source(h_fig, src, level);
if level > 1
    try
        local_mark_open_item(h_fig, src);
    catch
    end
end
uistack(panel, 'top');
try
    local_hide_toolbar_for_flyout(h_fig);
catch
end
try
    setappdata(h_fig, 'ZefFlyoutTic', tic);
catch
end
try
    local_ensure_flyout_wheel(h_fig);
catch
end
try
    local_store_hit_maps(h_fig);
catch
end
try
    local_restore_axes(h_fig);
catch
end

end

function w = local_flyout_width(labels, theme)

w = theme.space.flyoutW;
nch = 0;
for i = 1:numel(labels)
    try
        nch = max(nch, numel(char(string(labels{i}))));
    catch
    end
end
fs = 12;
try
    fs = theme.font.size;
catch
end
need = 52 + round(nch * fs * 0.72);
w = max(w, min(480, need));

end

function label = local_menu_label(h_menu)

label = '';
try
    label = strtrim(char(string(h_menu.Text)));
catch
end
if isempty(label)
    try
        label = strtrim(char(string(h_menu.Label)));
    catch
    end
end
if startsWith(label, 'ZEFFIRO Interface:')
    label = zef_ui_window_label(label);
end

end

function local_leaf_click(src, h_fig)

src = local_fly_item_of(src);
if local_dup_click(h_fig, src)
    return
end
h_menu = [];
try
    h_menu = getappdata(src, 'ZefMenuHandle');
catch
end
local_dismiss(h_fig);
local_invoke_menu(h_menu);

end

function local_sub_click(src, h_fig, level)

src = local_fly_item_of(src);
if local_dup_click(h_fig, src)
    return
end
open_src = [];
try
    open_src = getappdata(h_fig, 'ZefFlyoutSource');
catch
end
if local_ok(open_src) && isequal(open_src, src)
    local_dismiss_from(h_fig, level);
    return
end
try
    open_items = getappdata(h_fig, 'ZefFlyoutOpenItems');
    if iscell(open_items)
        for i = 1:numel(open_items)
            if isequal(open_items{i}, src)
                local_dismiss_from(h_fig, level);
                return
            end
        end
    end
catch
end
h_menu = getappdata(src, 'ZefMenuHandle');
kids = local_menu_children(h_menu);
if isempty(kids)
    local_dismiss(h_fig);
    local_invoke_menu(h_menu);
    return
end
local_open_flyout(h_fig, src, kids, level);

end

function local_flyout_slider(src, panel)

max_off = [];
try
    max_off = getappdata(panel, 'ZefFlyoutMaxOff');
catch
end
if isempty(max_off)
    try
        max_off = src.Max;
    catch
        max_off = 0;
    end
end
offset = 0;
try
    offset = max_off - src.Value;
catch
end
local_flyout_apply_offset(panel, offset);

end

function local_flyout_apply_offset(panel, offset)

if ~local_ok(panel)
    return
end
items = [];
try
    items = getappdata(panel, 'ZefFlyoutItems');
catch
end
row_h = 28;
pad = 8;
try
    rh = getappdata(panel, 'ZefFlyoutRowH');
    if ~isempty(rh)
        row_h = rh;
    end
    pd = getappdata(panel, 'ZefFlyoutPad');
    if ~isempty(pd)
        pad = pd;
    end
catch
end
ht = [];
try
    panel.Units = 'pixels';
    ht = panel.Position(4);
catch
    return
end
yy = ht - pad - row_h + offset;
for i = 1:numel(items)
    if local_ok(items(i))
        try
            items(i).Position(2) = yy;
        catch
        end
    end
    yy = yy - row_h;
end
try
    local_store_hit_maps(ancestor(panel, 'figure'));
catch
end

end

function local_flyout_nudge(panel, scroll_count)

if ~local_ok(panel) || isempty(scroll_count) || scroll_count == 0
    return
end
sl = findall(panel, 'Tag', 'zef_shell_flyout_slider');
if isempty(sl)
    return
end
sl = sl(1);
row_h = 28;
try
    rh = getappdata(panel, 'ZefFlyoutRowH');
    if ~isempty(rh)
        row_h = rh;
    end
catch
end
try
    newv = sl.Value - double(scroll_count) * row_h;
    sl.Value = min(sl.Max, max(sl.Min, newv));
    local_flyout_slider(sl, panel);
catch
end

end

function local_invoke_menu(h_menu)

if ~local_ok(h_menu)
    return
end
before = [];
try
    before = findall(groot, 'Type', 'figure');
catch
end
fcn = [];
try
    fcn = get(h_menu, 'MenuSelectedFcn');
catch
end
if isempty(fcn)
    try
        fcn = get(h_menu, 'Callback');
    catch
    end
end
try
    if isa(fcn, 'function_handle')
        fcn(h_menu, []);
    elseif iscell(fcn) && ~isempty(fcn) && isa(fcn{1}, 'function_handle')
        fcn{1}(h_menu, [], fcn{2:end});
    elseif (ischar(fcn) || isstring(fcn)) && strlength(strtrim(string(fcn))) > 0
        evalin('base', char(fcn));
    end
catch err
    warning('zef_ui_shell:MenuCallback', '%s', err.message);
end
try
    zef_live = evalin('base', 'zef');
    local_hide_menu(zef_live);
catch
end
try
    drawnow nocallbacks;
catch
end
try
    zef_ui_ready_new_windows();
catch
end
try
    after = findall(groot, 'Type', 'figure');
    spawned = setdiff(after, before);
    for i = 1:numel(spawned)
        try
            vis = 'on';
            if isprop(spawned(i), 'Visible')
                vis = char(spawned(i).Visible);
            end
            if strcmpi(vis, 'on')
                zef_window_manager('raise', spawned(i));
            end
        catch
        end
    end
catch
end

end

function local_dismiss(h_fig, restore_chrome)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
if nargin < 2 || isempty(restore_chrome)
    restore_chrome = true;
end
src = [];
try
    src = getappdata(h_fig, 'ZefFlyoutSource');
catch
end
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
for i = 1:numel(found)
    try
        if isvalid(found(i))
            delete(found(i));
        end
    catch
    end
end
try
    setappdata(h_fig, 'ZefFlyoutSource', []);
    setappdata(h_fig, 'ZefFlyoutPanel', []);
    setappdata(h_fig, 'ZefFlyoutSources', {});
    local_clear_open_items(h_fig);
catch
end
if local_ok(src)
    try
        theme = zef_ui_theme();
        key = local_nav_key_of(src);
        if ~isempty(key)
            local_nav_paint_named(zef_ui_find(h_fig, 'zef_shell_nav'), ...
                theme, local_nav_spec(), key);
        end
    catch
    end
end
if restore_chrome
    try
        local_restore_toolbar_after_flyout(h_fig);
    catch
    end
end

end

function local_dismiss_from(h_fig, min_level)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
if nargin < 2 || isempty(min_level)
    min_level = 1;
end
if min_level <= 1
    local_dismiss(h_fig);
    return
end
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
for i = 1:numel(found)
    if ~isvalid(found(i))
        continue
    end
    if local_flyout_level(found(i)) >= min_level
        try
            delete(found(i));
        catch
        end
    end
end
local_trim_open_items(h_fig, max(0, min_level - 2));
local_sync_flyout_state(h_fig);
try
    local_restore_toolbar_after_flyout(h_fig);
catch
end

end

function lv = local_flyout_level(panel)

lv = 1;
try
    tag = char(panel.Tag);
    tok = regexp(tag, 'zef_shell_flyout_(\d+)', 'tokens', 'once');
    if ~isempty(tok)
        lv = str2double(tok{1});
    end
catch
end
if isempty(lv) || isnan(lv)
    lv = 1;
end

end

function local_hide_toolbar_for_flyout(h_fig)

% Hide only toolbar buttons / gizmo that overlap a flyout so they cannot
% paint through the menu. Never hide figure_view, axes1, the logo, or the
% toolbar strip as a whole: that blanks visualization or chrome the
% flyout does not cover.

if ~local_ok(h_fig)
    return
end
saved = struct('h', gobjects(0), 'vis', {{}});
try
    prev = getappdata(h_fig, 'ZefFlyoutHidChrome');
    if isstruct(prev) && isfield(prev, 'h')
        saved = prev;
    end
catch
end
frs = local_flyout_rects(h_fig);
if isempty(frs)
    return
end
tools = findall(h_fig, '-regexp', 'Tag', '^zef_tool_');
giz = findall(h_fig, 'Tag', 'zef_axes_gizmo_img');
hosts = [tools(:); giz(:)];
for i = 1:numel(hosts)
    h = hosts(i);
    if ~local_ok(h)
        continue
    end
    if ~local_overlaps_any(local_fig_rect(h), frs)
        continue
    end
    pack = local_chrome_mates(h_fig, h);
    for k = 1:numel(pack)
        hk = pack(k);
        if ~local_ok(hk)
            continue
        end
        already = false;
        for j = 1:numel(saved.h)
            if saved.h(j) == hk
                already = true;
                break
            end
        end
        if already
            continue
        end
        vis = 'on';
        try
            vis = char(hk.Visible);
        catch
        end
        saved.h(end+1, 1) = hk; %#ok<AGROW>
        saved.vis{end+1, 1} = vis; %#ok<AGROW>
        try
            hk.Visible = 'off';
        catch
        end
    end
end
try
    setappdata(h_fig, 'ZefFlyoutHidChrome', saved);
catch
end

end

function frs = local_flyout_rects(h_fig)

frs = zeros(0, 4);
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
for i = 1:numel(found)
    if ~local_ok(found(i))
        continue
    end
    try
        if ~strcmpi(char(found(i).Type), 'uipanel')
            continue
        end
    catch
        continue
    end
    r = local_fig_rect(found(i));
    if numel(r) >= 4 && r(3) > 0 && r(4) > 0
        frs(end + 1, :) = r; %#ok<AGROW>
    end
end

end

function tf = local_overlaps_any(r, frs)

tf = false;
for i = 1:size(frs, 1)
    if local_rects_overlap(r, frs(i, :))
        tf = true;
        return
    end
end

end

function tf = local_rects_overlap(a, b)

tf = numel(a) >= 4 && numel(b) >= 4 ...
    && a(3) > 0 && a(4) > 0 && b(3) > 0 && b(4) > 0 ...
    && a(1) < b(1) + b(3) && b(1) < a(1) + a(3) ...
    && a(2) < b(2) + b(4) && b(2) < a(2) + a(4);

end

function local_restore_toolbar_after_flyout(h_fig)

if ~local_ok(h_fig)
    return
end
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
alive = false;
for i = 1:numel(found)
    if isvalid(found(i))
        alive = true;
        break
    end
end
if alive
    return
end
saved = [];
try
    saved = getappdata(h_fig, 'ZefFlyoutHidChrome');
catch
end
if isempty(saved) || ~isstruct(saved) || ~isfield(saved, 'h')
    return
end
for i = 1:numel(saved.h)
    h = saved.h(i);
    if ~local_ok(h)
        continue
    end
    vis = 'on';
    if i <= numel(saved.vis)
        vis = saved.vis{i};
    end
    try
        h.Visible = vis;
    catch
    end
end
try
    rmappdata(h_fig, 'ZefFlyoutHidChrome');
catch
end

end

function tf = local_dup_click(h_fig, src)

tf = false;
if ~local_ok(h_fig)
    return
end
id = local_click_id(src);
last_id = [];
last_t = [];
try
    last_id = getappdata(h_fig, 'ZefClickSrc');
    last_t = getappdata(h_fig, 'ZefClickTic');
catch
end
try
    setappdata(h_fig, 'ZefClickSrc', id);
    setappdata(h_fig, 'ZefClickTic', tic);
catch
end
if ~isempty(last_t) && ~isempty(last_id) && isequal(last_id, id)
    try
        tf = toc(last_t) < 0.12;
    catch
        tf = false;
    end
end

end

function id = local_click_id(src)

key = local_nav_key_of(src);
if ~isempty(key)
    id = ['nav:' key];
    return
end
fly = local_fly_item_of(src);
if local_ok(fly)
    id = fly;
    return
end
id = src;

end

function local_remember_source(h_fig, src, level)

stack = {};
try
    stack = getappdata(h_fig, 'ZefFlyoutSources');
catch
end
if ~iscell(stack)
    stack = {};
end
if level < 1
    level = 1;
end
if numel(stack) >= level
    stack = stack(1:level);
end
stack{level} = src; %#ok<AGROW>
try
    setappdata(h_fig, 'ZefFlyoutSources', stack);
catch
end

end

function local_sync_flyout_state(h_fig)

found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
if isempty(found)
    try
        setappdata(h_fig, 'ZefFlyoutSource', []);
        setappdata(h_fig, 'ZefFlyoutPanel', []);
        setappdata(h_fig, 'ZefFlyoutSources', {});
    catch
    end
    local_clear_open_items(h_fig);
    return
end
keep = gobjects(0);
keep_lv = 0;
for i = 1:numel(found)
    if ~local_ok(found(i))
        continue
    end
    try
        if ~strcmpi(char(found(i).Type), 'uipanel')
            continue
        end
    catch
        continue
    end
    lv = local_flyout_level(found(i));
    if lv >= keep_lv
        keep_lv = lv;
        keep = found(i);
    end
end
try
    setappdata(h_fig, 'ZefFlyoutPanel', keep);
catch
end
stack = {};
try
    stack = getappdata(h_fig, 'ZefFlyoutSources');
catch
end
src = [];
if iscell(stack) && keep_lv >= 1 && keep_lv <= numel(stack)
    src = stack{keep_lv};
end
try
    setappdata(h_fig, 'ZefFlyoutSource', src);
    if iscell(stack) && numel(stack) > keep_lv
        setappdata(h_fig, 'ZefFlyoutSources', stack(1:keep_lv));
    end
catch
end

end

function local_mark_open_item(h_fig, src)

src = local_fly_item_of(src);
if ~local_ok(src)
    return
end
open = {};
try
    open = getappdata(h_fig, 'ZefFlyoutOpenItems');
catch
end
if ~iscell(open)
    open = {};
end
keep = {};
for i = 1:numel(open)
    if local_ok(open{i}) && ~isequal(open{i}, src)
        keep{end+1} = open{i}; %#ok<AGROW>
    end
end
keep{end+1} = src; %#ok<AGROW>
try
    setappdata(h_fig, 'ZefFlyoutOpenItems', keep);
catch
end
try
    local_flyout_paint(src, true);
catch
end

end

function tf = local_is_open_fly_item(h_fig, item)

tf = false;
open = {};
try
    open = getappdata(h_fig, 'ZefFlyoutOpenItems');
catch
end
if ~iscell(open)
    return
end
for i = 1:numel(open)
    if isequal(open{i}, item)
        tf = true;
        return
    end
end

end

function local_trim_open_items(h_fig, keep_n)

open = {};
try
    open = getappdata(h_fig, 'ZefFlyoutOpenItems');
catch
end
if ~iscell(open)
    open = {};
end
if nargin < 2 || isempty(keep_n)
    keep_n = 0;
end
keep_n = max(0, keep_n);
keep = {};
for i = 1:numel(open)
    if i > keep_n
        try
            if local_ok(open{i})
                local_flyout_paint(open{i}, false);
            end
        catch
        end
    elseif local_ok(open{i})
        keep{end+1} = open{i}; %#ok<AGROW>
    end
end
try
    setappdata(h_fig, 'ZefFlyoutOpenItems', keep);
catch
end

end

function local_clear_open_items(h_fig)

open = {};
try
    open = getappdata(h_fig, 'ZefFlyoutOpenItems');
catch
end
if iscell(open)
    for i = 1:numel(open)
        try
            if local_ok(open{i})
                local_flyout_paint(open{i}, false);
            end
        catch
        end
    end
end
try
    setappdata(h_fig, 'ZefFlyoutOpenItems', {});
catch
end

end

function local_dismiss_top(h_fig)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
if isempty(found)
    local_dismiss(h_fig);
    return
end
max_lv = 1;
for i = 1:numel(found)
    max_lv = max(max_lv, local_flyout_level(found(i)));
end
local_dismiss_from(h_fig, max_lv);

end

function local_window_down(src, evt)

h_fig = ancestor(src, 'figure');
if isempty(h_fig)
    h_fig = src;
end
pt = local_pointer_pt(h_fig, evt);
keep = false;
if local_ok(local_fly_at(h_fig, pt)) || ~isempty(local_nav_key_at(h_fig, pt)) ...
        || local_ok(local_chrome_at(h_fig, pt))
    keep = true;
end
try
    fly = getappdata(h_fig, 'ZefFlyoutPanel');
    if local_ok(fly) && local_in_rect(pt, local_fig_rect(fly))
        keep = true;
    end
catch
end
if ~keep
    fresh = false;
    try
        t0 = getappdata(h_fig, 'ZefFlyoutTic');
        fresh = ~isempty(t0) && toc(t0) < 0.4;
    catch
    end
    if ~fresh
        local_dismiss(h_fig);
    end
end
try
    fly_hit = local_fly_at(h_fig, pt);
    if local_ok(fly_hit)
        cb = [];
        try
            cb = getappdata(fly_hit, 'ZefFlyCb');
        catch
        end
        if isa(cb, 'function_handle')
            cb(fly_hit, evt);
            return
        end
    end
catch
end
try
    nkey = local_nav_key_at(h_fig, pt);
    if ~isempty(nkey)
        nrow = zef_ui_find(h_fig, ['zef_nav_row_' nkey]);
        if local_ok(nrow)
            local_nav_click(nrow, evt);
            return
        end
    end
catch
end
used = false;
try
    used = zef_figure_interact(h_fig, 'down', pt);
catch
    used = false;
end
if used
    return
end
prev = [];
try
    prev = getappdata(h_fig, 'ZefShellPrevDownFcn');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    elseif (ischar(prev) || isstring(prev)) && strlength(prev) > 0
        evalin('base', char(prev));
    end
catch
end

end

function local_window_up(src, evt)

h_fig = ancestor(src, 'figure');
if isempty(h_fig)
    h_fig = src;
end
used = false;
try
    used = zef_figure_interact(h_fig, 'up');
catch
    used = false;
end
if used
    return
end
prev = [];
try
    prev = getappdata(h_fig, 'ZefShellPrevUpFcn');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    elseif (ischar(prev) || isstring(prev)) && strlength(prev) > 0
        evalin('base', char(prev));
    end
catch
end

end

function local_window_key(src, evt)

h_fig = ancestor(src, 'figure');
if isempty(h_fig)
    h_fig = src;
end
consumed = false;
try
    key = '';
    if isstruct(evt) && isfield(evt, 'Key')
        key = char(evt.Key);
    end
    if strcmpi(key, 'escape')
        fly = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
        if ~isempty(fly)
            local_dismiss_top(h_fig);
            consumed = true;
        end
    end
catch
end
if consumed
    return
end
prev = [];
try
    prev = getappdata(h_fig, 'ZefShellPrevKeyFcn');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    elseif (ischar(prev) || isstring(prev)) && strlength(prev) > 0
        evalin('base', char(prev));
    end
catch
end

end

function local_ensure_flyout_wheel(h_fig)

if ~local_ok(h_fig)
    return
end
cur = [];
try
    cur = get(h_fig, 'WindowScrollWheelFcn');
catch
end
our = [];
try
    our = getappdata(h_fig, 'ZefFlyoutWheelFcn');
catch
end
if ~isempty(our) && isequal(cur, our)
    return
end
try
    setappdata(h_fig, 'ZefShellPrevWheelFcn', cur);
catch
end
wrapper = @(src, evt) local_flyout_wheel(src, evt);
try
    setappdata(h_fig, 'ZefFlyoutWheelFcn', wrapper);
    h_fig.WindowScrollWheelFcn = wrapper;
catch
end

end

function local_flyout_wheel(src, evt)

h_fig = ancestor(src, 'figure');
if isempty(h_fig)
    h_fig = src;
end
consumed = false;
obj = [];
try
    obj = hittest(h_fig);
catch
end
n = 0;
try
    n = evt.VerticalScrollCount;
catch
end
try
    fly = [];
    if isappdata(h_fig, 'ZefFlyoutPanel')
        fly = getappdata(h_fig, 'ZefFlyoutPanel');
    end
    if local_ok(fly)
        hit_panel = local_flyout_panel_of(obj);
        if ~local_ok(hit_panel)
            hit_panel = fly;
            if ~local_over_flyout(obj)
                hit_panel = [];
            end
        end
        if local_ok(hit_panel)
            if ~isempty(n) && n ~= 0
                local_flyout_nudge(hit_panel, n);
            end
            consumed = true;
        end
    end
catch
end
if ~consumed
    try
        consumed = local_chrome_wheel(obj, n);
    catch
        consumed = false;
    end
end
if ~consumed
    try
        consumed = zef_figure_interact(h_fig, 'wheel', n);
    catch
        consumed = false;
    end
end
if consumed
    return
end
prev = [];
try
    prev = getappdata(h_fig, 'ZefShellPrevWheelFcn');
catch
end
try
    if isa(prev, 'function_handle')
        prev(src, evt);
    elseif iscell(prev) && ~isempty(prev) && isa(prev{1}, 'function_handle')
        prev{1}(src, evt, prev{2:end});
    elseif (ischar(prev) || isstring(prev)) && strlength(prev) > 0
        evalin('base', char(prev));
    end
catch
end

end

function tf = local_chrome_wheel(obj, scroll_count)

tf = false;
if ~local_ok(obj) || local_is_plot_hit(obj) || ~local_is_chrome_hit(obj)
    return
end
tf = true;
if isempty(scroll_count) || scroll_count == 0
    return
end
style = '';
try
    if strcmpi(char(obj.Type), 'uicontrol')
        style = lower(char(obj.Style));
    end
catch
end
if strcmp(style, 'slider')
    local_nudge_uicontrol_slider(obj, scroll_count);
elseif strcmp(style, 'listbox')
    local_nudge_listbox(obj, scroll_count);
end

end

function tf = local_is_plot_hit(obj)

tf = false;
h = obj;
for k = 1:8
    if ~local_ok(h)
        return
    end
    typ = '';
    try
        typ = lower(char(h.Type));
    catch
    end
    if any(strcmp(typ, {'axes', 'uiaxes'}))
        tag = '';
        try
            tag = char(h.Tag);
        catch
        end
        if ~(strcmp(tag, 'zef_card_bg') || strncmp(tag, 'zef_card_', 9))
            tf = true;
            return
        end
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function tf = local_is_chrome_hit(obj)

tf = false;
h = obj;
chrome = {'figure_sidebar', 'figure_lists', 'zef_shell_nav', 'zef_shell_header', ...
    'zef_shell_toolbar', 'zef_shell_tabs', 'zef_shell_footer', 'zef_shell_flyout', ...
    'zef_shell_card'};
for k = 1:10
    if ~local_ok(h)
        return
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    for i = 1:numel(chrome)
        if strcmp(tag, chrome{i}) || strncmp(tag, [chrome{i} '_'], numel(chrome{i}) + 1)
            tf = true;
            return
        end
    end
    if contains(tag, 'zef_shell_flyout') || strncmp(tag, 'zef_flyout_', 11)
        tf = true;
        return
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function local_nudge_uicontrol_slider(sl, scroll_count)

if ~local_ok(sl)
    return
end
tag = '';
try
    tag = char(sl.Tag);
catch
end
% Time slider Callback visualizes reconstructions; only block camera zoom.
if strcmp(tag, 'slider')
    return
end
mn = 0;
mx = 1;
v = 0;
try
    mn = sl.Min;
    mx = sl.Max;
    v = sl.Value;
catch
    return
end
range = mx - mn;
if ~isfinite(range) || range <= 0
    return
end
step = range * 0.02;
try
    ss = sl.SliderStep;
    if ~isempty(ss)
        step = max(step, ss(1) * range);
    end
catch
end
try
    sl.Value = min(mx, max(mn, v - double(scroll_count) * step));
catch
    return
end
cb = [];
try
    cb = sl.Callback;
catch
end
try
    if isa(cb, 'function_handle')
        cb(sl, []);
    elseif (ischar(cb) || isstring(cb)) && strlength(cb) > 0
        evalin('base', char(cb));
    end
catch
end

end

function local_nudge_listbox(lb, scroll_count)

if ~local_ok(lb)
    return
end
n = 0;
try
    n = numel(lb.String);
catch
end
if n < 2
    return
end
top = 1;
try
    top = lb.ListboxTop;
catch
end
try
    lb.ListboxTop = min(n, max(1, top + double(scroll_count)));
catch
end

end

function tf = local_over_flyout(obj)

tf = local_ok(local_flyout_panel_of(obj));

end

function p = local_flyout_panel_of(obj)

p = [];
h = obj;
for k = 1:10
    if ~local_ok(h)
        return
    end
    try
        tag = char(h.Tag);
        if contains(tag, 'zef_shell_flyout')
            if strcmpi(char(h.Type), 'uipanel')
                p = h;
                return
            end
            fig = ancestor(h, 'figure');
            if local_ok(fig) && isappdata(fig, 'ZefFlyoutPanel')
                cand = getappdata(fig, 'ZefFlyoutPanel');
                if local_ok(cand)
                    p = cand;
                    return
                end
            end
        end
    catch
    end
    try
        h = h.Parent;
    catch
        return
    end
end

end

function local_theme(h_fig)

if nargin < 1 || isempty(h_fig) || ~isgraphics(h_fig) || ~isvalid(h_fig)
    return
end
theme = zef_ui_theme();
try
    local_delete_legacy_theme_controls(h_fig);
catch
end
try
    h_fig.Color = theme.color.bg;
catch
end
tags = {'zef_shell_header', 'zef_shell_nav', 'zef_shell_tabs', ...
    'zef_shell_toolbar', 'zef_shell_footer'};
bgs = {theme.color.headerBg, theme.color.bg, theme.color.workspace, ...
    theme.color.workspace, theme.color.footerBg};
for i = 1:numel(tags)
    p = zef_ui_find(h_fig, tags{i});
    if local_ok(p)
        try
            p.BackgroundColor = bgs{i};
            p.HighlightColor = theme.color.border;
        catch
        end
    end
end
zef_ui_apply_theme(h_fig, theme);
try
    rmappdata(h_fig, 'ZefCardRect');
catch
end
try
    zef_figure_tool_layout(h_fig);
catch
    local_layout(h_fig);
end

end

function local_delete_legacy_theme_controls(host)

if nargin < 1 || ~local_ok(host)
    return
end
tags = {'zef_shell_theme_sun', 'zef_shell_theme_label', ...
    'zef_shell_theme', 'zef_shell_theme_pill'};
for i = 1:numel(tags)
    h = zef_ui_find(host, tags{i});
    if local_ok(h)
        try
            delete(h);
        catch
        end
    end
end
try
    h_fig = ancestor(host, 'figure');
    if local_ok(h_fig) && isappdata(h_fig, 'ZefThemeMenu')
        cm = getappdata(h_fig, 'ZefThemeMenu');
        if local_ok(cm)
            delete(cm);
        end
        rmappdata(h_fig, 'ZefThemeMenu');
    end
catch
end

end

function local_clear_tools(h_fig)

try
    zef_figure_interact(h_fig, 'set', 'none');
catch
end

end

function local_tool_pan(src, ~)

src = local_tool_src(src, 'pan');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'toggle', 'pan');

end

function local_tool_rotate(src, ~)

src = local_tool_src(src, 'rotate');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'toggle', 'rotate');

end

function local_tool_zoom(src, ~)

src = local_tool_src(src, 'zoom');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'zoom_by', 1.6);

end

function local_tool_zoomout(src, ~)

src = local_tool_src(src, 'zoomout');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'zoom_by', 1 / 1.6);

end

function local_tool_reset(src, ~)

h_fig = [];
try
    h_fig = ancestor(src, 'figure');
catch
end
if isempty(h_fig) || ~isvalid(h_fig)
    h_fig = gcbf;
end
if isempty(h_fig) || ~isvalid(h_fig)
    try
        h_fig = evalin('base', 'zef.h_zeffiro');
    catch
        h_fig = [];
    end
end
zef_figure_interact(h_fig, 'reset');

end

function local_tool_screenshot(src, ~)

h_fig = [];
try
    h_fig = ancestor(src, 'figure');
catch
end
if ~local_ok(h_fig)
    try
        h_fig = evalin('base', 'zef.h_zeffiro');
    catch
        h_fig = [];
    end
end
ax = [];
try
    ax = zef_ui_axes(h_fig);
catch
end
try
    figure(h_fig);
catch
end
start = pwd;
try
    zef = evalin('base', 'zef');
    if isstruct(zef) && isfield(zef, 'save_file_path') && ~isempty(zef.save_file_path)
        start = zef.save_file_path;
    end
    if isstruct(zef) && isfield(zef, 'use_display') && ~zef.use_display
        return
    end
catch
end
[file, path, idx] = uiputfile( ...
    {'*.png', 'PNG'; '*.jpg', 'JPEG'; '*.tiff', 'TIFF'}, ...
    'Print figure to file as...', start);
if isequal(file, 0)
    return
end
out = fullfile(path, file);
if ~isempty(ax) && isvalid(ax)
    exportgraphics(ax, out, 'Resolution', 200);
    return
end
if idx == 1
    print(h_fig, '-dpng', '-r200', out);
elseif idx == 2
    print(h_fig, '-djpeg', '-r200', out);
else
    print(h_fig, '-dtiff', '-r200', out);
end

end

function local_tool_colormap(src, ~)

h_fig = ancestor(src, 'figure');
open_src = [];
try
    open_src = getappdata(h_fig, 'ZefFlyoutSource');
catch
end
if local_ok(open_src) && isequal(open_src, src)
    local_dismiss(h_fig);
    return
end
pop = zef_ui_find(h_fig, 'colormapselection');
if ~local_ok(pop)
    return
end
items = {};
try
    items = cellstr(string(pop.String));
catch
end
if isempty(items)
    return
end
cm = uicontextmenu(h_fig);
for i = 1:numel(items)
    uimenu(cm, 'Text', items{i}, 'Callback', @(~, ~) local_set_colormap(pop, i, h_fig));
end
local_open_flyout(h_fig, src, local_menu_children(cm), 1);

end

function local_set_colormap(pop, idx, h_fig)

local_dismiss(h_fig);
pop.Value = idx;
cb = pop.Callback;
if isa(cb, 'function_handle')
    cb(pop, []);
elseif (ischar(cb) || isstring(cb)) && strlength(cb) > 0
    evalin('base', char(cb));
end
evalin('base', 'zef.update_colormap = zef.h_update_colormap.Value; zef_update_contrast_and_brightness(zef.h_zeffiro);');

end

function local_tool_edges(~, ~)

zef_toggle_edges;

end

function local_tool_measure(src, ~)

src = local_tool_src(src, 'measure');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'toggle', 'measure');

end

function local_tool_annotate(src, ~)

src = local_tool_src(src, 'annotate');
h_fig = ancestor(src, 'figure');
zef_figure_interact(h_fig, 'toggle', 'annotate');

end

function local_open_log(~, ~)

p = '';
try
    zef = evalin('base', 'zef');
    if isstruct(zef) && isfield(zef, 'program_path')
        p = fullfile(zef.program_path, 'data', 'log');
    end
catch
end
if isempty(p) || ~isfolder(p)
    p = fullfile(pwd, 'data', 'log');
end
try
    if ismac
        system(sprintf('open "%s"', p));
    elseif ispc
        winopen(p);
    else
        system(sprintf('xdg-open "%s"', p));
    end
catch
end

end

function local_open_profile(~, ~)

try
    evalin('base', 'zef_open_init_profile;');
catch
end

end

function local_tool_more(~, h_fig)

ax = zef_ui_axes(h_fig);
if isempty(ax) || ~isvalid(ax)
    return
end
try
    figure(h_fig);
catch
end
zef_axes_popup;

end

function local_raise_figure()

zef = [];
try
    zef = evalin('base', 'zef');
catch
end
if isstruct(zef) && isfield(zef, 'h_zeffiro') && local_ok(zef.h_zeffiro)
    zef_window_manager('raise', zef.h_zeffiro);
    return
end
try
    zef_figure_tool;
catch
end

end

function local_tool_from_label(src, key)

h_fig = ancestor(src, 'figure');
if isempty(h_fig) || ~isvalid(h_fig)
    return
end
btn = zef_ui_find(h_fig, ['zef_tool_' key]);
if ~local_ok(btn)
    return
end
cb = btn.Callback;
if isa(cb, 'function_handle')
    cb(btn, []);
end

end

function src = local_tool_src(src, key)

src = local_hit_src(src);
if ~local_ok(src)
    return
end
try
    tag = char(src.Tag);
    if startsWith(tag, 'zef_tool_lab_')
        h_fig = ancestor(src, 'figure');
        btn = zef_ui_find(h_fig, ['zef_tool_' key]);
        if local_ok(btn)
            src = btn;
        end
    end
catch
end

end

function inset = local_right_inset(h_fig)

inset = 0;
try
    v = getappdata(h_fig, 'ZefShellRightInset');
    if ~isempty(v)
        inset = max(0, double(v(1)));
    end
catch
end

end

function local_raise_chrome(h_fig)

work = zef_ui_find(h_fig, 'zef_shell_card');
view = zef_ui_find(h_fig, 'figure_view');
if local_ok(view)
    try
        uistack(view, 'top');
    catch
    end
else
    ax = zef_ui_find(h_fig, 'axes1');
    if local_ok(ax)
        try
            uistack(ax, 'top');
        catch
        end
    end
end
tt = zef_ui_find(h_fig, 'time_text');
if local_ok(tt)
    try
        uistack(tt, 'top');
    catch
    end
end
inner = {'zef_shell_tabs', 'zef_shell_toolbar'};
for i = 1:numel(inner)
    h = zef_ui_find(h_fig, inner{i});
    if local_ok(h)
        try
            uistack(h, 'top');
        catch
        end
    end
end
if local_ok(work)
    bg = zef_ui_find(work, 'zef_card_bg');
    if local_ok(bg)
        try
            uistack(bg, 'bottom');
        catch
        end
    end
end
order = {'figure_lists', 'figure_sidebar', 'zef_shell_card', ...
    'zef_shell_header', 'zef_shell_nav', 'zef_shell_footer', ...
    'figure_toggle_host'};
for i = 1:numel(order)
    h = zef_ui_find(h_fig, order{i});
    if local_ok(h)
        try
            uistack(h, 'top');
        catch
        end
    end
end
found = findall(h_fig, '-regexp', 'Tag', '^zef_shell_flyout');
for i = 1:numel(found)
    if local_ok(found(i))
        try
            uistack(found(i), 'top');
        catch
        end
    end
end

end

function label = local_tool_label(key)

labels = struct('pan', 'Pan', 'rotate', 'Rotate', 'zoom', 'Zoom +', ...
    'zoomout', 'Zoom −', 'reset', 'Reset', 'screenshot', 'Screenshot', ...
    'colormap', 'Colormap', 'measure', 'Measure', 'annotate', 'Annotate', ...
    'edges', 'Edges');
label = key;
try
    label = labels.(key);
catch
end

end

function h = local_make_icon_btn(parent, tag, bg, hittable)

h = uicontrol('Style', 'pushbutton', 'Parent', parent, 'Units', 'pixels', ...
    'String', '', 'Tag', tag, 'BackgroundColor', bg, 'ForegroundColor', bg);
if hittable
    h.Callback = @local_nav_click;
    try
        h.BusyAction = 'cancel';
    catch
    end
else
    h.Enable = 'inactive';
end

end

function local_nav_blit_icon(row, key, x, y, side, fg, bg)

if ~local_ok(row)
    return
end
ax = [];
try
    ax = getappdata(row, 'ZefChipAx');
catch
end
if ~local_ok(ax)
    return
end
im = [];
try
    found = findall(ax, 'Type', 'image');
    if ~isempty(found)
        im = found(1);
    end
catch
end
if ~local_ok(im)
    return
end
base = [];
try
    base = getappdata(ax, 'ZefChipBase');
catch
end
if isempty(base)
    try
        base = im.CData;
        setappdata(ax, 'ZefChipBase', base);
    catch
        return
    end
end
if isempty(base)
    return
end
rgb = base;
side = max(8, round(double(side(1))));
glyph = [];
try
    glyph = zef_ui_icons(key, side, fg, bg);
catch
end
if isempty(glyph)
    im.CData = rgb;
    return
end
[hh, ww, ~] = size(rgb);
[gh, gw, ~] = size(glyph);
x0 = max(1, round(double(x(1))) + 1);
y_panel = round(double(y(1)));
r0 = hh - (y_panel + gh) + 1;
r0 = max(1, r0);
c1 = min(ww, x0 + gw - 1);
r1 = min(hh, r0 + gh - 1);
if c1 < x0 || r1 < r0
    im.CData = rgb;
    return
end
rgb(r0:r1, x0:c1, :) = glyph(1:(r1 - r0 + 1), 1:(c1 - x0 + 1), :);
im.CData = rgb;

end

function local_chip_text(row, tag, label, show, x, h, theme)

%LOCAL_CHIP_TEXT  Label text drawn inside the row's chip axes.
%
%   The chip axes (rounded-rect image) is the only painted layer of a
%   menu row, so the label is a transparent text object in that same
%   axes rather than a uicontrol with its own BackgroundColor. x/h are
%   the label's left edge and the row height in panel pixels.

if ~local_ok(row)
    return
end
ax = [];
try
    ax = getappdata(row, 'ZefChipAx');
catch
end
if ~local_ok(ax)
    return
end
txt = [];
try
    found = findall(ax, 'Tag', tag);
    for i = 1:numel(found)
        if strcmpi(char(found(i).Type), 'text')
            txt = found(i);
            break
        end
    end
catch
end
if ~local_ok(txt)
    try
        txt = text(ax, 0, 0, '', 'Tag', tag, ...
            'HitTest', 'off', 'PickableParts', 'none', ...
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
            'Clipping', 'on', 'Interpreter', 'none');
    catch
        return
    end
end
try
    txt.FontName = theme.font.name;
    txt.FontUnits = 'pixels';
    txt.FontSize = theme.font.size;
    txt.Color = theme.color.text;
catch
end
try
    if show
        txt.String = label;
        txt.Position = [double(x) + 0.5, double(h(1)) / 2 + 0.5, 1];
        txt.Visible = 'on';
    else
        txt.String = '';
        txt.Visible = 'off';
    end
catch
end

end

function local_nav_delete_glyph(row)

ax = [];
try
    if isappdata(row, 'ZefGlyphAx')
        ax = getappdata(row, 'ZefGlyphAx');
        rmappdata(row, 'ZefGlyphAx');
    end
catch
end
if local_ok(ax)
    try
        delete(ax);
    catch
    end
end
try
    extra = findall(row, '-regexp', 'Tag', '^zef_nav_glyph_');
    for i = 1:numel(extra)
        if local_ok(extra(i))
            delete(extra(i));
        end
    end
catch
end

end

function local_show_icon(h, name, sz, fg, bg)

if ~local_ok(h)
    return
end
bw = sz;
bh = sz;
try
    u = h.Units;
    h.Units = 'pixels';
    bw = max(1, round(h.Position(3)));
    bh = max(1, round(h.Position(4)));
    h.Units = u;
catch
end
side = min(bw, bh);
if side < 8
    side = max(8, sz);
end
key = {char(name), side, bw, bh, round(double(fg(1:min(3, numel(fg)))) * 1000), ...
    round(double(bg(1:min(3, numel(bg)))) * 1000)};
try
    prev = getappdata(h, 'ZefIconKey');
    if isequal(prev, key) && ~isempty(h.CData)
        return
    end
catch
end
cdata = [];
try
    cdata = zef_ui_icons(name, side, fg, bg);
catch
end
try
    h.String = '';
    h.BackgroundColor = bg;
    if ~isempty(cdata)
        try
            full = repmat(reshape(double(bg(1:3)), 1, 1, 3), bh, bw);
            ih = size(cdata, 1);
            iw = size(cdata, 2);
            r0 = max(1, floor((bh - ih) / 2) + 1);
            c0 = max(1, floor((bw - iw) / 2) + 1);
            r1 = min(bh, r0 + ih - 1);
            c1 = min(bw, c0 + iw - 1);
            full(r0:r1, c0:c1, :) = cdata(1:(r1 - r0 + 1), 1:(c1 - c0 + 1), :);
            h.CData = full;
        catch
            h.CData = cdata;
        end
    end
    setappdata(h, 'ZefIconKey', key);
catch
end

end

function [lw, lh] = local_header_logo_size(max_w, max_h)

lw = max(48, round(max_w));
lh = max(18, round(max_h));
[rgb, ~] = local_header_logo_src();
if isempty(rgb)
    return
end
ih = size(rgb, 1);
iw = size(rgb, 2);
if ih < 1 || iw < 1
    return
end
s = min(max_w / iw, max_h / ih);
lh = max(18, round(ih * s));
lw = max(36, round(iw * s));

end

function h = local_header_height(theme, W)

h = theme.space.headerH;
try
    h = max(h, min(56, round(h * double(W) / 1200)));
catch
end

end

function g = local_header_gap(theme, W, H)

g = theme.space.headerGap;
try
    ref_h = max(1, double(theme.space.shellDefH));
    ref_w = max(1, double(theme.space.shellDefW));
    scale = 0.65 * (double(H) / ref_h) + 0.35 * (double(W) / ref_w);
    g = round(double(g) * max(0.7, min(1.45, scale)));
    g = max(8, min(18, g));
catch
end

end

function local_show_header_logo(h, theme)

if ~local_ok(h)
    return
end
bg = theme.color.headerBg;
fg = theme.color.text;
bw = 120;
bh = 28;
try
    h.Units = 'pixels';
    bw = max(1, round(h.Position(3)));
    bh = max(1, round(h.Position(4)));
catch
end
key = [bw, bh, round(double(bg(1:3)) * 1000), round(double(fg(1:3)) * 1000)];
try
    prev = getappdata(h, 'ZefLogoKey');
    cdata = h.CData;
    if isequal(prev, key) && ~isempty(cdata) ...
            && size(cdata, 1) == bh && size(cdata, 2) == bw
        return
    end
catch
end
cdata = local_header_logo_cdata(bw, bh, bg, fg);
try
    h.String = '';
    h.Enable = 'inactive';
    h.BackgroundColor = bg;
    h.ForegroundColor = bg;
    if ~isempty(cdata)
        h.CData = cdata;
    end
    setappdata(h, 'ZefLogoKey', key);
catch
end

end

function cdata = local_header_logo_cdata(bw, bh, bg, fg)

cdata = [];
[rgb, alpha] = local_header_logo_src();
if isempty(rgb)
    return
end
bw = max(1, round(bw));
bh = max(1, round(bh));
bg = reshape(double(bg(1:3)), 1, 1, 3);
fg = reshape(double(fg(1:3)), 1, 1, 3);
ih = size(rgb, 1);
iw = size(rgb, 2);
s = min(bw / iw, bh / ih);
nw = max(1, round(iw * s));
nh = max(1, round(ih * s));
tile = local_imscale(rgb, nh, nw);
a = local_imscale(alpha, nh, nw);
if size(a, 3) > 1
    a = a(:, :, 1);
end
mx = max(tile, [], 3);
mn = min(tile, [], 3);
sat = mx - mn;
lum = mean(tile, 3);
gray = a > 0.05 & sat < 0.11 & lum >= 0.12 & lum <= 0.82;
for k = 1:3
    ch = tile(:, :, k);
    ch(gray) = fg(k);
    tile(:, :, k) = ch;
end
canvas = repmat(bg, bh, bw);
r0 = max(1, floor((bh - nh) / 2) + 1);
c0 = max(1, floor((bw - nw) / 2) + 1);
r1 = min(bh, r0 + nh - 1);
c1 = min(bw, c0 + nw - 1);
sh = r1 - r0 + 1;
sw = c1 - c0 + 1;
am = a(1:sh, 1:sw);
am3 = repmat(am, 1, 1, 3);
src = tile(1:sh, 1:sw, :);
canvas(r0:r1, c0:c1, :) = src .* am3 + canvas(r0:r1, c0:c1, :) .* (1 - am3);
cdata = max(0, min(1, canvas));

end

function [rgb, alpha] = local_header_logo_src()

persistent src_rgb src_a src_file
rgb = [];
alpha = [];
file = local_header_logo_file();
if isempty(file)
    return
end
if ~isempty(src_rgb) && strcmp(src_file, file)
    rgb = src_rgb;
    alpha = src_a;
    return
end
img = [];
a = [];
try
    [img, ~, a] = imread(file);
catch
    try
        img = imread(file);
    catch
        return
    end
end
if isempty(img)
    return
end
try
    img = im2double(img);
catch
    img = double(img);
    if max(img(:)) > 1.5
        img = img / 255;
    end
end
if size(img, 3) >= 4
    a = img(:, :, 4);
    img = img(:, :, 1:3);
elseif size(img, 3) == 1
    img = repmat(img, 1, 1, 3);
end
if isempty(a)
    lum = mean(img, 3);
    mx = max(img, [], 3);
    mn = min(img, [], 3);
    sat = mx - mn;
    a = double(~((lum < 0.09 & sat < 0.11) | (lum > 0.95 & sat < 0.07)));
else
    try
        a = im2double(a);
    catch
        a = double(a);
        if max(a(:)) > 1.5
            a = a / 255;
        end
    end
    if size(a, 3) > 1
        a = a(:, :, 1);
    end
end
mask = a > 0.05;
if any(mask(:))
    [r, c] = find(mask);
    pad = max(2, round(0.015 * max(size(a, 1), size(a, 2))));
    r1 = max(1, min(r) - pad);
    r2 = min(size(img, 1), max(r) + pad);
    c1 = max(1, min(c) - pad);
    c2 = min(size(img, 2), max(c) + pad);
    img = img(r1:r2, c1:c2, :);
    a = a(r1:r2, c1:c2);
end
src_rgb = img;
src_a = a;
src_file = file;
rgb = img;
alpha = a;

end

function file = local_header_logo_file()

file = '';
cands = {};
try
    hit = which('zeffiro_logo_compass.png');
    if ~isempty(hit)
        cands{end+1} = hit; %#ok<AGROW>
    end
catch
end
try
    root = fileparts(which('zeffiro_interface'));
    if ~isempty(root)
        cands{end+1} = fullfile(root, 'assets', 'fig', 'zeffiro_logo_compass.png'); %#ok<AGROW>
    end
catch
end
try
    here = fileparts(mfilename('fullpath'));
    root = fileparts(fileparts(fileparts(here)));
    cands{end+1} = fullfile(root, 'assets', 'fig', 'zeffiro_logo_compass.png'); %#ok<AGROW>
catch
end
for i = 1:numel(cands)
    if exist(cands{i}, 'file') == 2
        file = cands{i};
        return
    end
end

end

function out = local_imscale(in, nh, nw)

out = in;
if isempty(in)
    return
end
nh = max(1, round(nh));
nw = max(1, round(nw));
try
    out = imresize(in, [nh nw], 'bilinear');
    return
catch
end
ih = size(in, 1);
iw = size(in, 2);
yr = max(1, min(ih, round(linspace(1, ih, nh))));
xr = max(1, min(iw, round(linspace(1, iw, nw))));
out = in(yr, xr, :);

end

function src = local_hit_src(src)

try
    if strcmpi(char(src.Type), 'image') && ~isempty(src.Parent)
        src = src.Parent;
    end
catch
end

end

function r = local_menu_chip_radius(theme, h)

% Menu rows read as one rounded container; 8 px keeps the chip clearly
% rounded (the legacy 6 px button radius looked almost rectangular).
r = 8;
try
    r = max(8, round(double(theme.space.btnRadius)));
catch
end
ht = 32;
try
    ht = max(8, round(double(h(1))));
catch
end
r = max(3, min(round(double(r)), max(3, floor(ht / 2) - 1)));

end

function local_menu_chip(parent, tag, fillc, outerc, radius)

if ~local_ok(parent)
    return
end
try
    typ = lower(char(parent.Type));
    if ~any(strcmp(typ, {'uipanel', 'panel', 'figure'}))
        return
    end
catch
    return
end
parent.Units = 'pixels';
p = parent.Position;
w = max(8, round(double(p(3))));
h = max(8, round(double(p(4))));
if nargin < 5 || isempty(radius)
    radius = 6;
end
r = max(3, min(round(double(radius(1))), max(3, floor(min(w, h) / 2) - 1)));
fillc = reshape(double(fillc(1:3)), 1, 3);
outerc = reshape(double(outerc(1:3)), 1, 3);
key = [w, h, r, round(fillc * 1000), round(outerc * 1000)];
prev = [];
try
    prev = getappdata(parent, 'ZefChipKey');
catch
end
fig = ancestor(parent, 'figure');
prev_ax = [];
try
    prev_ax = get(fig, 'CurrentAxes');
catch
end
[ax, created] = local_menu_chip_axes(parent, tag, outerc);
same = isequal(prev, key);
has_im = false;
if same
    try
        has_im = ~isempty(findall(ax, 'Type', 'image'));
    catch
    end
end
if same && has_im
    local_menu_chip_place(ax, [0, 0, w, h], [], outerc);
    local_menu_chip_restore(fig, prev_ax);
    return
end
rgb = [];
try
    rgb = zef_ui_roundrect(w, h, r, fillc, fillc, outerc);
catch
end
local_menu_chip_place(ax, [0, 0, w, h], rgb, outerc);
try
    setappdata(parent, 'ZefChipKey', key);
    setappdata(parent, 'ZefChipAx', ax);
    if ~isempty(rgb)
        setappdata(ax, 'ZefChipBase', rgb);
    end
catch
end
if created
    try
        uistack(ax, 'bottom');
        kids = allchild(parent);
        for i = 1:numel(kids)
            ktag = '';
            try
                ktag = char(kids(i).Tag);
            catch
            end
            if strncmp(ktag, 'zef_nav_hit_', 12)
                uistack(kids(i), 'bottom');
                break
            end
        end
    catch
    end
end
local_menu_chip_restore(fig, prev_ax);

end

function [ax, created] = local_menu_chip_axes(parent, tag, outerc)

created = false;
ax = [];
try
    if isappdata(parent, 'ZefChipAx')
        ax = getappdata(parent, 'ZefChipAx');
    end
catch
end
if ~isempty(ax) && isvalid(ax) && strcmpi(char(ax.Type), 'axes')
    return
end
found = gobjects(0);
try
    found = findall(parent, 'Tag', tag);
catch
end
for i = 1:numel(found)
    if isvalid(found(i)) && strcmpi(char(found(i).Type), 'axes')
        ax = found(i);
        try
            setappdata(parent, 'ZefChipAx', ax);
        catch
        end
        return
    end
end
created = true;
ax = axes('Parent', parent, 'Units', 'pixels', 'Tag', tag, ...
    'HitTest', 'off', 'HandleVisibility', 'off', 'Box', 'off', ...
    'XTick', [], 'YTick', [], 'Color', outerc, ...
    'Toolbar', [], 'Interactions', []);
try
    ax.PickableParts = 'none';
catch
end
try
    ax.XColor = 'none';
    ax.YColor = 'none';
catch
end
try
    ax.Title.String = '';
    ax.Title.Visible = 'off';
catch
end
try
    ax.PositionConstraint = 'innerposition';
catch
end
try
    setappdata(parent, 'ZefChipAx', ax);
catch
end

end

function local_menu_chip_place(ax, pos, rgb, outer)

if isempty(ax) || ~isvalid(ax)
    return
end
ax.Units = 'pixels';
try
    ax.PositionConstraint = 'innerposition';
catch
end
try
    ax.LooseInset = [0 0 0 0];
catch
end
try
    ax.Title.String = '';
    ax.Title.Visible = 'off';
    ax.XLabel.String = '';
    ax.YLabel.String = '';
    ax.XLabel.Visible = 'off';
    ax.YLabel.Visible = 'off';
catch
end
try
    ax.XAxis.Visible = 'off';
    ax.YAxis.Visible = 'off';
catch
end
try
    ax.Box = 'off';
    ax.XTick = [];
    ax.YTick = [];
catch
end
try
    ax.Position = pos;
catch
end
try
    ax.InnerPosition = pos;
catch
end
try
    ip = double(ax.InnerPosition);
    want = double(pos);
    pc = '';
    try
        pc = lower(char(ax.PositionConstraint));
    catch
    end
    if ~strcmp(pc, 'innerposition') && numel(ip) >= 4 && numel(want) >= 4
        dl = ip(1) - want(1);
        db = ip(2) - want(2);
        dr = (want(1) + want(3)) - (ip(1) + ip(3));
        dt = (want(2) + want(4)) - (ip(2) + ip(4));
        if any(abs([dl, db, dr, dt]) > 0.51)
            ax.Position = [want(1) - dl, want(2) - db, ...
                want(3) + dl + dr, want(4) + db + dt];
        end
    end
catch
end
try
    ax.Color = outer;
catch
end
try
    ax.HitTest = 'off';
    ax.PickableParts = 'none';
catch
end
if isempty(rgb)
    return
end
[hh, ww, ~] = size(rgb);
try
    ax.XLim = [0.5, ww + 0.5];
    ax.YLim = [0.5, hh + 0.5];
    % YDir stays normal: the image flips via decreasing YData instead.
    % (YDir 'reverse' misplaces vertically-centered text objects, which
    %  these chip axes host for menu labels.)
    ax.YDir = 'normal';
    ax.XTick = [];
    ax.YTick = [];
    ax.PlotBoxAspectRatioMode = 'auto';
    ax.DataAspectRatioMode = 'auto';
catch
end
im = [];
try
    im = findall(ax, 'Type', 'image');
    if ~isempty(im)
        im = im(1);
    end
catch
end
if isempty(im) || ~isvalid(im)
    imh = image('Parent', ax, 'CData', rgb, 'HitTest', 'off', ...
        'XData', [1 ww], 'YData', [hh 1]);
    try
        imh.HitTest = 'off';
        imh.PickableParts = 'none';
    catch
    end
else
    im.CData = rgb;
    im.XData = [1 ww];
    im.YData = [hh 1];
    try
        im.HitTest = 'off';
        im.PickableParts = 'none';
    catch
    end
end

end

function local_menu_chip_restore(fig, prev)

if nargin >= 2 && ~isempty(prev)
    try
        if isvalid(prev)
            set(fig, 'CurrentAxes', prev);
            return
        end
    catch
    end
end
local_restore_axes(fig);

end

function local_restore_axes(h_fig)

ax = zef_ui_find(h_fig, 'axes1');
if local_ok(ax)
    try
        set(h_fig, 'CurrentAxes', ax);
    catch
    end
end

end

function tf = local_ok(h)

tf = false;
try
    tf = ~isempty(h) && isvalid(h);
catch
end

end

function s = onoff(tf)

if tf
    s = 'on';
else
    s = 'off';
end

end
